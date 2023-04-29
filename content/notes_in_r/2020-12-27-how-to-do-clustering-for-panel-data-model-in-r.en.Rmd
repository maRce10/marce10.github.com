---
title: How to do clustering for panel data model in R
author: Yabin Da
date: '2020-12-27'
slug: how-to-do-clustering-for-panel-data-model-in-r
categories:
  - Data
tags:
  - Panel data
  - Clustering standard errors
subtitle: 'Clustering standard errors in R'
summary: ''
authors: []
lastmod: '2020-12-27T23:17:39-06:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
draft: false
math: true

output:
  blogdown::html_page:
    toc: true
    toc_depth: 4

---



### An introduction of clustering in panel data models

In my last post, I briefly introduced standard error clustering in panel data settings. In this post, I will continue the topic and present how to do the clustering in `R`. 

Before we move to the coding part, I'd like to clarify several things. First, the panel model I focus on in this post refers to the fixed effect panel data model, which is distinct from the random effect model. These two models differ from each other in terms of the assumption of the unobserved individual effects. The random effect model assumes the individual effects are unrelated to the independent variables, whereas the fixed effect model allows the presence of arbitrary correlations. You are encouraged to go over the textbook by Wooldridge (2010) if you want to learn more. 

In practice, the fixed effect model is much more privileged than the random effect model. Because we suspect there exist unobserved individual effects that are correlated with the covariates and we use the fixed effect model to control for the unobservables to alleviate omitted variable bias.

Back to our topic, clustering in the fixed effect model is straightforward. We can either cluster at $i$ (individual level) or $t$ (time level). The former case is robust to heterogeneity and serial correlation within the individual, whereas the latter one allows correlations across individuals yet is unable to take account of the serial correlations. 

You may ask how to determine which level to cluster at? The rule of thumb is that in panels where you have a large number of individuals and a short period, you should cluster at the individual level. Analogously, if you have a few individuals that were observed during a long time slot, you should cluster at the time level. 

Alternatively, you can also "cluster" at both individual and time levels (also known as two-way clustering). See [here](https://cran.r-project.org/web/packages/multiwayvcov/multiwayvcov.pdf) for more details. 

Clustering in the random effect model is slightly different than that in the fixed effect counterpart. With a few more assumptions (again refer to Wooldridge (2010) for more details), we can use GLS to estimate standard errors. In such cases, we gain efficiency (because we have a smaller number of unknowns to estimate in the variance and covariance matrix), however, the payoff is the standard errors are less robust because we imposed additional assumptions in the first place. Thus, in some circumstances, regular clustering is also recommended in random effect model settings.


### Clustering in R

Before we perform clustering, we need to run the panel data model first. You can either use the `lm` function or the `plm` function from the `plm` package. I personally prefer the latter over the former. Thus, in this post, I am going to stick with the `plm` package.


#### Importing the data

I am going to run a panel data model to examine the effects of weather conditions on crop yields. The data can be downloaded from [here](https://drive.google.com/file/d/1DFU30lRmoVEbjJpYtEMIFP29f3K1PV8A/view?usp=sharing).


```{r library, message=FALSE, warning=FALSE}
library(tidyverse) 
library(plm)
library(lmtest)
library(clubSandwich)
library(sandwich)

df <- read_csv('dataforclustering.csv',
               col_types = cols(new_code = col_character()))

head(df)

```

As you can see, 

- `new_code` represents the counties (individuals).
- `Year` indicates the time index.
- `wheat` refers to winter wheat yield in tons/hectare.
- `tavg` stands for the average temperature over the growing season (October to May).
- `pc` is the accumulation of precipitation over the growing season.


#### Running the fixed effect model


```{r plm, echo=TRUE}

# Note I only included the county fixed effect in the model.
reg <- df %>%
  pdata.frame(index = c('new_code','Year')) %>% # specify the inidivual and year index
  plm(formula = log(wheat) ~ tavg + I(tavg^2) + pc + I(pc^2), 
      data = ., effect = 'individual', model = 'within')

summary(reg)


```

As can be been, with raw (no clustering) standard errors, we got statistically significant coefficients on temperature and precipitation. We then move forward to clustering. 


#### Clustering the standard erros

There are three functions available to do the clustering. 

- You can use the `vcovHC` function in the `plm` package to construct the variance-covariance matrix. 
- Alternatively, you can use the `vcovHC` function from the `sandwich` package to do the task.
- Or `vcovCR` function from the `clubSandwich` package to do the task.


```{r plm vcov, echo=TRUE, warning=F, message=FALSE}

# The first approach: vcovHC from the plm package
# 'arellano' is the recommanded method as it does not 
# impose restrictions on the structure of the variance-covariance matrix.
# cluster = 'group' indicates we cluster at county level
# type = 'HC3' is for small-sample adjustment.
method1 <- coeftest(reg, vcov = function(x) 
  plm::vcovHC(x, method = 'arellano', cluster = 'group', type = 'HC3'))

# The second approach: vcovHC from the sandwich package
# You may have noticed that there does not exist a parameter for us 
# to specify the clustering level.
method2 <- coeftest(reg, vcov = function(x) 
  sandwich::vcovHC(x, type = 'HC3'))

# The third approach: vcovHC from the clubSandwich package
# type = 'CR2' is recommanded for small-sample adjustment.
# cluster = df$new_code indicates we cluster at the individual level.
method3 <- coeftest(reg, vcov = function(x) 
  clubSandwich::vcovCR(x, type = 'CR2', cluster = df$new_code))

# Compare the estimated standard errors

comse <- bind_cols(method1[,2], method2[,2], method3[,2]) %>% 
  rename('plm' = '...1',
         'sandwich' = '...2',
         'clubsandwich' = '...3') %>% print(.)



```

As we can see, `plm` and `sandwich` gave us identical clustered standard errors, whereas `clubsanwich` returned slightly larger standard errors. Note that in the analysis above, we clustered at the county (individual) level. 

Things are different if we clustered at the year (time) level. Simply change the `cluster = 'group'` to `cluster = 'time'` in method one, and adjust `cluster = df$new_code` to `cluster = df$Year` in method three. See below.  The `vcovHC` function from the `sandwich` package does not allow us to choose which level to cluster the standard errors at. 


```{r plm vcov1, echo=TRUE, warning=F, message=FALSE}
method1_time <- coeftest(reg, vcov = function(x) 
  plm::vcovHC(x, method = 'arellano', cluster = 'time', type = 'HC3'))

method3_time <- coeftest(reg, vcov = function(x) 
  clubSandwich::vcovCR(x, type = 'CR2', cluster = df$Year))

comse_time <- bind_cols(method1_time[,2], method2[,2], method3_time[,2]) %>% 
  rename('plm' = '...1',
         'sandwich' = '...2',
         'clubsandwich' = '...3') %>% print(.)



```

### Takeaways

In applications where you cluster standard errors at the individual level, all three methods should work just fine. However, if you want to cluster at the time level (or other alternative levels), you may refer to the embedded `vcovHC` function in the `plm` package or the `vcovCR` function from the `clubSandwich` package. 

Well, actually I would say it's better to just stick with the `plm` and/or `clubSandwich`approaches regardless of what level your standard errors were clustered at. The `sandwich` package is sort of particularly designed for clustering in `lm` or `glm` regressions. 


### Reference

Jeffrey M Wooldridge, 2010. "Econometric Analysis of Cross Section and Panel Data," MIT Press Books, The MIT Press, edition 2.
