---
title: Statistical Inference in Casual Settings
author: ''
date: '2020-12-13'
slug: statistical-inference-in-casual-settings
categories:
  - Fun
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2020-12-13T16:13:21-06:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []

output:
  blogdown::html_page:
    toc: true
    toc_depth: 4
---


### Introduction


There are particularly two concerns regarding the statistical inferences on causal effects: correlations within groups, and serial correlation. The first concern fits the group data, whereas the second concern matches the panel data settings. Here for group data, I mean data observed within treatment groups (of course), for instance, test scores of students within the same class, wages of individuals within the same state, etc. In other words, there is no time dimension in the data. For the panel data, in contrast, we observe each student/worker multiple times and construct a panel (months, years, etc.). Both cases are common in casual studies, however, the latter one is more privileged, thanks for the development of Difference in Difference (DiD). 

In this note, I will address the statistical inference concerns on casual effect studies, such as the bias in robust standard error, correlations within groups, and serial correlations. In practice, some of these concerns are well stressed, however, the rest of them are largely ignored. This will lend practitioners to over-reject the null hypothesis of no effects and conclude a casual effect that does not exist. 

Numerous approaches are available to fix these concerns, yet, they are confusing for beginners (at least for me), who may find it difficult to choose the **_correct_** one to fix their specific problem. This post attempts to provide a guide for beginners. 

Below, I firstly introduce some background information on robust standard errors. Following that, I discuss the clustering problem in group data. Thirdly, we focus on the serial correlation in panel data. Finally, I close the note.

You are highly recommended to consult the seminal work by Angrist and Pischke: Mostly Harmless Econometrics for technical details.

### Robust standard errors

Before we move to the clustering and serial correlation, I’d like to pave the road by talking about the _robust_ standard errors first. Robust standard errors are in opposition to the _conventional_ standard errors which assumes homoskedasticity. This is a strong assumption and frequently fails in practice. The robust standard errors, on other hand, relax this restriction and are preferable in empirical studies.

One thing that should be mentioned is that for finite samples, both variance estimators are also _biased_. In practice, the bias should be corrected which can be easily done in modern statistical software. The last thing you need to do is to do it right. 

One can fix the bias of conventional estimators via a simple degree-of-freedom correction. This is also the _default_ setting in most statistical software. If you are pursuing standard errors under homoskedasticity, you are happy with the default estimates. Things get a little bit complicated in the heteroskedasticity world, yet simple remedies are handy. There are several alternative correction approaches such as _HC1, HC2, and HC3_. In application, the estimated standard errors tend to get larger as we go down the list from _HC1 to HC3_ (Angrist and Pischke 2008). Note that all these corrections aim to fix the bias induced by finite samples. Also, note that heteroskedasticity rarely leads to dramatic changes in inferences if the sample size is large.

One largely ignored concern is the _robust_ estimators are more biased than the conventional ones when we have homoskedasticity or the heteroskedasticity is moderate (Angrist and Pischke 2008). In these cases, we may end up with robust standard errors even lower than the conventional standard error and consequently over-reject the null hypothesis of no effect. That says if you are confident that you have homoskedasticity or you have reasons to believe the heteroskedasticity is moderate, you should go after a conventional standard error framework. 

There are no golden rules to determine whether the heteroskedasticity is moderate or not. In practices, the heteroskedasticity setting way dominates the homoskedasticity counterpart. In such cases, I think the _HC2_ correction should do the job in most cases. 


### Clustering in group data

I just discussed the robust standard errors in the cross-sectional regressions. For group data, things get complicated. Recall that the group data here has no time dimension to distinguish with the panel data which I will talk about shortly. A simple example is the test scores of students from different classes and schools. 

You can of course think about this type of estimate as a regular cross-sectional regression. However, the statistical inference you draw from this simple cross-sectional setting will be problematic even though with corrected robust standard errors. That is because you missed the potential correlations within the group, for instance, test scores of students from the same class tend to correlate with each other. This omission of correction within group will bias the standard errors downward and lead you to mistakenly over-reject the null hypothesis. 

The bias is largely guided by the Moulton factor (Angrist and Pischke 2008) which increases with group size (the overall sample size is fixed). Intuitively, larger group size indicates fewer groups (clusters), in which case there is less independent information in the sample (because we assume there is no correlation across clusters).

To fix the bias stemmed from within-group correlations, we can either

- inflate the conventional standard errors by the Moulton factor. For technical notes please refer to (Angrist and Pischke 2008). The factor is supplied as descriptive statistics in some software packages (_loneway_ command in Stata).

- cluster at the group level, like clusters in panel data which we will cover shortly. The concern here is cluster errors are unlikely to be reliable with few clusters. Recall that the clustered variance-covariance matrix is derived by averaging across clusters. With few clusters, this moment estimate tends to be inconsistent. 

- average the individual level data to group level and perform a regular WLS regression with group sizes as weights. The _premise_ for this approach is the treatment variable only varies at the group level. In practices, we always have covariates that vary at the individual level. In such cases, we need to transform the individual-level covariates to covariate-adjusted group effects. Specifically, first run a regression of the outcome on a full set of group dummies and the covariates (note that the treatment variable is absent from the regression). Then run the WLS regression of estimated group effects (the group dummies from the first regression) on the treatment variables. The group-level estimates are preferable to the clustering approach in the context of few clusters. 


### Serial correlation in panel data

Unlike the group data, panel data has a time dimension in it, for instance, wages varying across years. In many cases, we expect these observations are correlated over time. Serial correlations are well documented in general panel data settings, i.e. fixed effect and random effect panel data models. In those general settings, there are no treatment variables (i.e. binary treatment variable), nor are treated groups and control groups. A simple example for such setting is the regression of crop yields on weather variables using county-level data. To address serial correlations in counties, you can cluster at the county level. To further address the spatial correlation across counties within states, we can cluster at a higher level, say state level (this is the nonparametric way, you can also choose the parametric approach by assuming that the spatial correlation follows some parametric function forms). 

Panel data in the causal effect settings, particularly the Two-Way Fixed Effects DiD, is different from the general panel data settings. In these cases, we have treatment groups, control groups, treatment variables that vary at group (state) level, and covariates that are observed at the individual (county) level. The error terms in such settings could be correlated within/across counties, as well as within/across states. In practice, correlations within/across counties are commonly fixed by clustering at the state-year level under the assumption that there are no correlations across states and years. 

However, this assumption could be easily violated in empirical studies. For instance, if a state experienced an economic shock in one year, we expect the shock to persist to next year. The ignored serial correlations can seriously bias the standard error estimates (Bertrand, Duflo, and Mullainathan 2004). Fortunately, we have alternative ways to fix the problem. 

- The simplest and most widely applied approach is to pass the clustering cell one level higher. Say, we cluster at the state level rather than the state-year level. The problem here is the number of clusters is reduced and consequently leads the standard error estimates less precise. The empirical question is what is the minimum number of clusters that will render us reliable inference. The short answer is 42. I recommend you to refer to Angrist and Pischke (2008) for more details.


- An alternative approach is to introduce a state-specific trend into the model to account for serial correlation. Angrist and Pischke (2008) did not talk about this approach in their book, however, I think it makes sense. If the state trend is controlled, we are at least partly free from the serial correlation problems.


### Conclusion

In this post, I discussed the statistical inference in regression analysis with a focus on causal inference. For a simple cross-sectional regression, you may need to take care of the heterogeneity by constructing robust standard errors. Besides, you can also go further by performing finite-sample corrections to mitigate biases in standard errors. Most modern statistical software allows you to do it very easily.

In the grouped data, you need to take care of the potential correlations within groups. To do so, you can either cluster standard errors at the group level, which is appealing if you have a reasonable number of clusters; alternatively, you can also average the individual level data to group level and perform a regular WLS regression with group sizes as weights. This approach is promising if you have limited clusters. You are always recommended to do a sensitivity analysis to compare the standard errors estimated from these two approaches.

Lastly, for the panel data in causal inference setting, clustering at the group-year level has still dominated the literature though the estimated standard errors could be significantly biased downward because of ignoring the serial correlation, which leads to the practitioners to over-reject the null hypothesis. To mitigate the bias, you can cluster at the group-level instead. The downside is we will have fewer clusters and experience computational burdens. 


### Reference

Angrist, J.D., and J.-S. Pischke. 2008. Mostly Harmless Econometrics: An Empiricist’s Companion. Princeton University Press.

Bertrand, M., E. Duflo, and S. Mullainathan. 2004. “How Much Should We Trust Differences-In-Differences Estimates?” The Quarterly Journal of Economics 119(1):249–275.




