---
layout: post
title: "Signal detection with cross-correlation using warbleR"
date: 10-04-2020
editor_options: 
  chunk_output_type: console
---



[warbleR](https://cran.r-project.org/package=warbleR) (v1.1.24) now includes functions to detect signals using cross-correlation similar to those in the package [monitoR](https://cran.r-project.org/package=monitoR). There is already a [blog post on cross-correlation detection using monitoR](https://marce10.github.io/2016/12/15/Detecting_signals_with_monitoR.html). In this post I show how to do that with [warbleR](https://cran.r-project.org/package=warbleR) and compare its performance against that from  [monitoR](https://cran.r-project.org/package=monitoR).

First install the latest developmental version of [warbleR](https://cran.r-project.org/package=warbleR) and load other packages (the code will install the packages if missing):


{% highlight r %}
devtools::install_github("maRce10/warbleR")

x <- c("warbleR", "monitoR", "microbenchmark", "ggplot2")

out <- lapply(x, function(y) {
  if(!y %in% installed.packages()[,"Package"])  install.packages(y)
require(y, character.only = T)
  })
{% endhighlight %}

and  load the long-billed hermit sound that comes with [warbleR](https://cran.r-project.org/package=warbleR):


{% highlight r %}
#write files in temporal directory
setwd(tempdir()))

# load sound files and data
data(list = c("Phae.long1", "Phae.long2", 
              "Phae.long3", "Phae.long4", "selec.table"))

#write files to disk
writeWave(Phae.long1,"Phae.long1.wav")
{% endhighlight %}

Before getting into the functions let's recall how detection works with [monitoR](https://cran.r-project.org/package=monitoR):

1. Create template
1. Run cross-correlation
1. Find peaks (detections above a trheshold)


{% highlight r %}
# Create template
phae1T1 <- makeCorTemplate("Phae.long1.wav", 
      t.lim = c(lbh_selec_table$start[2], lbh_selec_table$end[2]), 
      wl = 300, ovlp = 90, frq.lim = c(1, 11), dens = 1, 
      name = "phae1T1", score.cutoff = 0.4, write.wav = FALSE)

#  Run cross-correlation
cscoresPhae1 <- corMatch(survey = "Phae.long1.wav",
                 templates = phae1T1, parallel = TRUE, 
                 show.prog = FALSE, time.source = "fileinfo")

# Find peaks
cdetectsPhae1 <- findPeaks(cscoresPhae1, parallel = TRUE)
{% endhighlight %}

This graph shows the detections:


{% highlight r %}
# View results
plot(cdetectsPhae1, hit.marker="points")
{% endhighlight %}

<img src="/./img/phae1-1_monitor_detection.png" title="plot of chunk wblrVSmntr4.5" alt="plot of chunk wblrVSmntr4.5" width="900px" style="display: block; margin: auto;" />

Below is the exact same process using [warbleR](https://cran.r-project.org/package=warbleR). Note that the template(s) and sound files to be used in the detections are indicated in the "compare.matrix" input. This is simply a matrix
with the templates in the first column ("Phae.long1.wav-1" means selection "1" from sound file "Phae.long1.wav") and the sound files in which to look for in the second column. The object 'lbh_selec_table' is a selection table with all the annotation data needed to find templates:


{% highlight r %}
# make matrix with templates and sound files
cm <- matrix(c("Phae.long1.wav-1", "Phae.long1.wav"), ncol = 2)

# Run cross correlation
xc.output <- xcorr(X = lbh_selec_table[1, ], output = "list", 
compare.matrix = cm, path = tempdir())

# find peaks
pks <- find_peaks(xc.output = xc.output, path = tempdir())

# add frequency range (not required but used for plot)
pks$bottom.freq <- lbh_selec_table$bottom.freq[1]
pks$top.freq <- lbh_selec_table$top.freq[1]
{% endhighlight %}

And plot the detections:


{% highlight r %}
spectrograms(X = pks, wl = 200, by.song = "sound.files",
             collevels = seq(-80, 0, 5), xl = 3, pb = FALSE)
{% endhighlight %}

<img src="/./img/Phae.long1.wav.jpeg" title="plot of chunk wblrVSmntr6" alt="plot of chunk wblrVSmntr6" width="900px" style="display: block; margin: auto;" />


# Compare warbleR and monitoR

We will use the function `microbenchmark()` from the package of the same name to test performance (i.e. how long it takes to run). To do this we first need to save both processes as individual functions:


{% highlight r %}
# monitoR detection
detec_monitor <- function(x){
 
  # Create template
phae1T1 <- makeCorTemplate("Phae.long1.wav", 
      t.lim = c(lbh_selec_table$start[2], lbh_selec_table$end[2]), 
      wl = 300, ovlp = 90, frq.lim = c(1, 11), dens = 1, 
      name = "phae1T1", score.cutoff = 0.4, write.wav = FALSE)

#  Run cross-correlation
cscoresPhae1 <- corMatch(survey = "Phae.long1.wav",
                 templates = phae1T1, parallel = TRUE, 
                 show.prog = FALSE, time.source = "fileinfo")

  
  # find peaks
  cdetectsPhae1 <- findPeaks(cscoresPhae1)
}

# warbleR detection
detec_warbleR <- function(x){
 
  xc.output <- x_corr(X = lbh_selec_table[1, ], output = "list",
    compare.matrix = matrix(c("Phae.long1.wav-1", "Phae.long1.wav"), ncol = 2), 
    path = tempdir(), pb = FALSE)

# find peaks
pks <- find_peaks(xc.output = xc.output, path = tempdir(), 
                  pb = FALSE)

pks$bottom.freq <- lbh_selec_table$bottom.freq[1]
pks$top.freq <- lbh_selec_table$top.freq[1]
  
}
{% endhighlight %}


And now test performance (this can take a few minutes):


{% highlight r %}
mb <- microbenchmark(detec_warbleR(), detec_monitor(), times = 10)

autoplot(mb)
{% endhighlight %}




<img src="/./img/mb_plot.jpeg" title="plot of chunk wblrVSmntr7.2" alt="plot of chunk wblrVSmntr7.2" width="900px" style="display: block; margin: auto;" />


{% highlight r %}
# print results
mb
{% endhighlight %}



{% highlight text %}
## Unit: milliseconds
##             expr       min       lq      mean
##  detec_warbleR()  76.35316 100.0231  136.2479
##  detec_monitor() 687.64700 879.5293 1009.3005
##    median        uq       max neval cld
##  119.6610  140.7929  416.8854   100  a 
##  927.2823 1031.3535 2224.5691   100   b
{% endhighlight %}



{% highlight r %}
# mean time per function
mean_times <- tapply(mb$time, mb$expr, mean)

# how monitoR compares to warbleR
round(mean_times[2] / mean_times[1], 2)
{% endhighlight %}



{% highlight text %}
## detec_monitor() 
##            7.41
{% endhighlight %}

Detection with [monitoR](https://cran.r-project.org/package=monitoR) takes ~7 times longer. So a long process that may take a week in monitoR would take about a day using [warbleR](https://cran.r-project.org/package=warbleR). Note that parallelization could further improve performance. This can be set with the argument 'parallel' in both `x_corr()` and `find_peaks()`.

---

<font size="4">Session information</font>


{% highlight text %}
## R version 3.6.1 (2019-07-05)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 18.04.4 LTS
## 
## Matrix products: default
## BLAS:   /usr/lib/x86_64-linux-gnu/atlas/libblas.so.3.10.3
## LAPACK: /usr/lib/x86_64-linux-gnu/atlas/liblapack.so.3.10.3
## 
## locale:
##  [1] LC_CTYPE=es_ES.UTF-8      
##  [2] LC_NUMERIC=C              
##  [3] LC_TIME=es_CR.UTF-8       
##  [4] LC_COLLATE=es_ES.UTF-8    
##  [5] LC_MONETARY=es_CR.UTF-8   
##  [6] LC_MESSAGES=es_ES.UTF-8   
##  [7] LC_PAPER=es_CR.UTF-8      
##  [8] LC_NAME=C                 
##  [9] LC_ADDRESS=C              
## [10] LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=es_CR.UTF-8
## [12] LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils    
## [5] datasets  methods   base     
## 
## other attached packages:
## [1] ggplot2_3.3.0        microbenchmark_1.4-7
## [3] monitoR_1.0.7        warbleR_1.1.23      
## [5] NatureSounds_1.0.2   knitr_1.28          
## [7] seewave_2.1.5        tuneR_1.3.3         
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.3        mvtnorm_1.0-11   
##  [3] lattice_0.20-40   prettyunits_1.0.2
##  [5] ps_1.3.0          fftw_1.0-6       
##  [7] zoo_1.8-6         assertthat_0.2.1 
##  [9] rprojroot_1.3-2   digest_0.6.22    
## [11] R6_2.4.1          backports_1.1.5  
## [13] signal_0.7-6      evaluate_0.14    
## [15] highr_0.8         pillar_1.4.2     
## [17] rlang_0.4.1       curl_4.2         
## [19] multcomp_1.4-12   rstudioapi_0.10  
## [21] callr_3.3.2       Matrix_1.2-18    
## [23] desc_1.2.0        devtools_2.2.1   
## [25] splines_3.6.1     stringr_1.4.0    
## [27] RCurl_1.98-1.1    munsell_0.5.0    
## [29] proxy_0.4-23      compiler_3.6.1   
## [31] xfun_0.12         pkgconfig_2.0.3  
## [33] pkgbuild_1.0.6    tidyselect_0.2.5 
## [35] tibble_2.1.3      dtw_1.21-3       
## [37] codetools_0.2-16  crayon_1.3.4     
## [39] dplyr_0.8.3       withr_2.1.2      
## [41] MASS_7.3-51.4     bitops_1.0-6     
## [43] grid_3.6.1        gtable_0.3.0     
## [45] magrittr_1.5      scales_1.0.0     
## [47] cli_1.1.0         stringi_1.4.6    
## [49] pbapply_1.4-2     fs_1.3.1         
## [51] remotes_2.1.0     testthat_2.3.0   
## [53] ellipsis_0.3.0    sandwich_2.5-1   
## [55] TH.data_1.0-10    rjson_0.2.20     
## [57] tools_3.6.1       glue_1.3.1       
## [59] purrr_0.3.3       processx_3.4.1   
## [61] pkgload_1.0.2     parallel_3.6.1   
## [63] survival_3.1-11   yaml_2.2.1       
## [65] colorspace_1.4-1  sessioninfo_1.1.1
## [67] memoise_1.1.0     usethis_1.5.1
{% endhighlight %}
