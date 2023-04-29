---
title: A RUC (Renmin University of China) LaTex beamer template in R Markdown
author: Yabin Da
date: '2023-04-23'
slug: a-latex-template-for-RUC-in-r-markdown
categories:
  - RUC
tags:
  - Beamer
  - LaTex
subtitle: ''
summary: 'Note that this template was derived from the template for TAMU which I posted in 2021.'
authors: []
lastmod: '2023-04-23T09:30:00-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
draft: false

output:
  blogdown::html_page:
    toc: true
    toc_depth: 4

---

### Introduction

In 2021, I created a post introducing a beamer template for TAMU. Nowadays, I am working at the Renmin University of China. Thus I adjusted that TAMU template to match RUC (most of the changes are color-related).

Again, all the beamer templates are originally from [Dr. Steven V. Miller](http://svmiller.com/blog/2019/08/r-markdown-template-beamer-presentations/).

### Download the RUC template

Here from my [Github](https://github.com/dayabin/RUCBeamer), you can directly download the RUC template with the RUC color and logo (`RUCTemplate.tex`). You can also find an example of RUC beamer presentation there (`RUCBeamer.pdf`). 

Below I will briefly introduce the changes I made to Dr. Miller's original template. Before you start your editing, you are recommended to quickly go over the template to have a basic idea of what's going on there. 

### Include RUC LOGO

You may want to include RUC logo in your title page of your slide. I obtained the logo from Google images. 

To include, go to the `RUCTemplate.tex` template and navigate to the code section like below. Here I use an absolute path. You just need to replace with paths on your local machine. 

```

\titlegraphic{\includegraphics[width=0.4\paperwidth]{C:/work/RUCBeamer/RUCBeamer/ruc/Renmin-University-of-China-logo_3.png}} 

```

### RUC color

To customize colors in the `RUCTemplate.tex` template, you can go to the code section below. I define two colors, `rucmaroon` and `rucwhite`. In the second part of the code section, you can customize colors for frame title, title, block title, etc. 


```
% Some optional colors. Change or add as you see fit.
%---------------------------------------------------
\definecolor{rucmaroon}{HTML}{AE0B2A}
\definecolor{rucwhite}{HTML}{FFFFFF}


% Some optional color adjustments to Beamer. Change as you see fit.
%------------------------------------------------------------------
\setbeamercolor{frametitle}{fg=rucwhite,bg=rucmaroon}
\setbeamercolor{title}{fg=rucwhite,bg=rucmaroon}
\setbeamercolor{local structure}{fg=rucmaroon}
\setbeamercolor{section in toc}{fg=rucwhite,bg=rucmaroon}
\setbeamercolor{subsection in toc}{fg=rucwhite,bg=rucmaroon}
\setbeamercolor{footline}{fg=rucmaroon, bg=rucwhite}
\setbeamercolor{block title}{fg=rucwhite, bg=rucmaroon}


```

### Other changes I made to the template

I also slightly edited the original template based on suggestions by a contributor at Stackoverflow. See the post [here](https://stackoverflow.com/questions/64374791/page-number-not-showing-in-r-markdown-beamer-while-using-a-latex-template/64375699?noredirect=1#comment113835188_64375699). 





### Using the template in R Markdown

The YAML header in R Markdown (`RUCBeamer.Rmd`) would like something below. You need to specify the path where you store the template. Here I created a folder particularly for the template. Here again I use an absolute path. 

```

---
title: "RUCBeamer"
subtitle: ""
author: Yabin Da
date: "`r Sys.Date()`"
institute: \normalsize School of Agricultural Economics and Rural Development
fontsize: 10pt
output:
 beamer_presentation:
    template: C:/work/RUCBeamer/RUCBeamer/RUCTemplate.tex
    keep_tex: true
    slide_level: 3
make149: true

---

```

You should set `keep_tex:true`, which will retain the LaTex file that actually creates your beamer slides. I found it's very useful for troubleshooting.


### How to include LaTex tables in R Markdown

At the end of this post, I want say something about how to include LaTex tables in beamer presentation in R Markdown. 

There are two different types of tables: user-defined tables and regression result tables. 

For the first scenario, it can be a data frame containing data or other important information that you want to present as a table in your presentation. In this case, you'd better refer to the `kbl` function from the `kableExtra` package. It has numerous features and is easy to customize based on your needs. You are highly recommended to check out this [website](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html#Overview) for more detailed information. 

Below I show a code example and the created table in beamer slide. 



```{r cutoff, echo=TRUE, eval=FALSE, results='hide'}

df <- read_csv('cutoff.csv')

df %>%
  kbl(booktabs = T,caption = 'Estimated temperature thresholds for each of the seasons', linesep = "") %>%
  kable_styling(full_width = F, font_size = 7) %>% 
  footnote(general = "\\\\tiny{Note: The lower threshold is restricted to be at least 5 °C above zero and 10 °C below the maximum temperature. The upper threshold is set to be at least 5 °C above the lower threshold and 5 °C below the maximum temperature. Relaxing those restrictions do not significantly change the results.}",footnote_as_chunk = T,
           threeparttable = T, escape = F,
           general_title = "")


```

![](/post/2020-10-17-a-latex-template-for-beamer-presentation-in-r-markdown.en_files/table1.png)


Here I'd like to emphasize two more things. Firstly, the default font for table note is `footnote`. If you have a very long note, you may need change to `tiny` (see the `footnote` in the code chunk). But do REMEMBER to set the `escape = F`, otherwise the `\\\\tiny` command won't be rendered by R Markdown.

Secondly, by default the footnote will be a list below the table. That means the word `Note:` will be in the row of the note. The content of the note starts at the second row. You can set `footnote_as_chunk = T` to fix this problem. 

However, the appearance of the footnote is still wired (see the image below). Therefore, I set the `general_title = ""` to remove the default `Note:` and directly start my note with `Note:`.

![](/post/2020-10-17-a-latex-template-for-beamer-presentation-in-r-markdown.en_files/table2.png)


