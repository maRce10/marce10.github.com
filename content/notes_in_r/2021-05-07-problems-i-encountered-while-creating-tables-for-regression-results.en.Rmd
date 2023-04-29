---
title: Problems I encountered while creating tables for regression results in R
author: Yabin Da
date: '2021-05-07'
slug: problems-i-encountered-while-creating-tables-for-regression-results in R
categories:
  - Data
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2021-06-27T23:05:59-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
math: true

output:
  blogdown::html_page:
    toc: true
    toc_depth: 4

---



In many circumstances, we need to create nice tables from regression results and present the table in beamers. As an R user, I primarily use the `stargazer` package to do the job. I think it is powerful enough and can accommodate most of the cases. An alternative package is `kableExtra`, which I find is particularly useful when you are trying to create tables for data frames. 

In this post, I will take notes on the problems I encountered while using the `stargazer` to provide a reference for myself and hopefully can also help others. 

Below is an example of the code. `reg`, `rpenalty.1`, and `rpenalty.2` are the three regressions I report. 

```
stargazer(reg5, rpenalty.1, rpenalty.2, 
no.space = T, font.size = 'footnotesize', single.row = F,
type = 'latex', header = F,
column.labels = c('Baseline panel','Partial penalty', 'Full penalty'),
keep = c('dfallhigh','frez_spring','penalty_dfallhigh','penalty_frez_spring'),
covariate.labels = c('DDhigh\\_fall','Frez\\_spring','DDhigh\\_fall\\_penalty',
                               'Frez\\_spring\\_penalty'),
coef = list(mreg5[,1][c(4,8)], mrpenalty.1[,1][c(4,8,20,21)], mrpenalty.2[,1][c(4,8,23,27)]),
se = list(mreg5[,2][c(4,8)], mrpenalty.1[,2][c(4,8,20,21)], mrpenalty.2[,2][c(4,8,23,27)]),
t = list(mreg5[,3][c(4,8)], mrpenalty.1[,3][c(4,8,20,21)], mrpenalty.2[,3][c(4,8,23,27)]),
p = list(mreg5[,4][c(4,8)], mrpenalty.1[,4][c(4,8,20,21)], mrpenalty.2[,4][c(4,8,23,27)]),
model.names = F,dep.var.caption = 'Winter wheat yields',
dep.var.labels.include = F,omit.stat = c("rsq", "f",'ser'),
ci = F, digits = 3, model.numbers = T,
add.lines = list(c('County fixed effect','Yes','Yes','Yes'),
                           c('Linear time trend','Yes','Yes','Yes'),
                           c('Quadratic time trend','Yes','Yes','Yes')))

```

The created table looks like below. 

![](/notes_in_r/2021-05-07-problems-i-encountered-while-creating-tables-for-regression-results.en_files/reg_table.png)


#### Select variables to be reported in the table

This can be done by using the `keep` or `omit` parameter in `stargazer`. My feeling is that `keep` is more convenient. You just need to specify the names of variables (in the regression) you want to present in the final table.  See an example below.

```
keep = c('dfallhigh','frez_spring','penalty_dfallhigh','penalty_frez_spring')

```
**You need to pay particular attention here**. The variable names should be specified carefully to make sure that `keep` and `omit` work. Try to aviod variable names like `log(x)`, `I(x^2)`, etc. In contrast to using variable names, you can also use a numeric vector to indicate the positions of variables in the regression with full varaibles, i.e. `keep = c(1:5)`. 

Following that, you can further specify the names\lables to be presented in the table. 

```
covariate.labels = c('DDhigh\\_fall','Frez\\_spring','DDhigh\\_fall\\_penalty',
                               'Frez\\_spring\\_penalty')
```

#### Present underscores as text

Underscores won't be printed in the final table because it is recognized as a special character in R and Latex. To print underscore as text, use `\` to skip. See an example below. This also applies to other special characters (i.e. dollar sign). The code below will print `DDhigh_fall` in the table.

```

covariate.labels = c('DDhigh\\_fall','Frez\\_spring','DDhigh\\_fall\\_penalty',
                               'Frez\\_spring\\_penalty')
```

#### Customize the t statistics and p values
`stargazer` allows users to manually specify the coefficients, t statistics, and p values. This could be extremely helpful when it comes to robust errors which are not reported in original regression results.  

To do this in `stargazer`, use `coef`, `se`, `t`, and `p` parameters. See the example below. I first specify the coefficients I want to report in the table (which should be consistent with the `keep` parameter). `mreg5`, `mrpenalty.1`, and `mrpenalty.1` are objects that resulted from the `coeftest` function. Similarly, `se` parameter corresponds to the robust standard errors in those objects.   

```
coef = list(mreg5[,1][c(4,8)], mrpenalty.1[,1][c(4,8,20,21)], mrpenalty.2[,1][c(4,8,23,27)])
se = list(mreg5[,2][c(4,8)], mrpenalty.1[,2][c(4,8,20,21)], mrpenalty.2[,2][c(4,8,23,27)])

````

#### Add lines in the table

In addition to the main regression results, you can manually add lines to report the fixed effects. The number of elements in each line should be consistent with the column numbers. 

```
add.lines = list(c('County fixed effect','Yes','Yes','Yes'),
                           c('Linear time trend','Yes','Yes','Yes'),
                           c('Quadratic time trend','Yes','Yes','Yes'))

```






