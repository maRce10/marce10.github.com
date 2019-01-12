---
layout: post
title: "Compare signals in a selection table to a set of templates using cross-correlation"
date: 11-01-2019
---



I got the following question about cross-correlation:

> "We would like to compare every call within a selection table to a template of each owl, and get peak correlation coefficients on each call separately. However, currently R compares the entire recording to the template as a unit. Is there a way to separate that? We can copy-paste the sound files, and rename it, and separate the calls that way but I wonder if you know an easier method"

The easiest way to do this is by running a loop that compares each row in a selection table to the set of template calls and then put the results back into the selection table.

First set up the example data and global options:


{% highlight r %}
# load warbleR
library(warbleR)

#load data and save sound files
data("Phae.long.est")

# set warbleR global options
# this options can also be set within the function call
warbleR_options(wl = 300, pb = FALSE, ovlp = 90, flim = c(1, 12), 
                pal = reverse.heat.colors)
{% endhighlight %}

We'll use the example data set from the [NatureSounds](https://cran.r-project.org/package=NatureSounds) package. Check out the full description of the data [here](https://marce10.github.io/NatureSounds/reference/Phae.long.est.html).

So the first step is to create an example selection table for "calls" to be compared and another one for the template "calls". In the following code we get 3 examples for each song type in the (extended) selection table (calls) and 1 of each song type in a template set (tempts):


{% highlight r %}
# get calls to identify
calls <- Phae.long.est[c(1:3, 11:13, 21:23), ]

# get 3 candidate calls to compare against
tempts <- Phae.long.est[c(10, 20, 30), ]
{% endhighlight %}

We can look at the spectrograms for the 2 sets as follows:


{% highlight r %}
# catalog for calls
catalog(calls, nrow = 3, ncol = 3, rm.axes = T, width = 11, 
        labels = "lek.song.type")
{% endhighlight %}

![catalog1](/img/calls_catalog.png)



{% highlight r %}
# catalog for templates
catalog(tempts, nrow = 2, ncol = 3, rm.axes = T, width = 11, 
        labels = "lek.song.type")
{% endhighlight %}
![catalog2](/img/templt_catalog.png)

As you can see the templates have an single example of each of the 3 song types in the 'calls' selection table.

Now we have to create a routine that will compare each row in the "calls" selection table to each template and put the results in a data frame: 


{% highlight r %}
# loop for each row
out <- lapply(1:nrow(calls), function(x) {
  
  # extract each row at the time
  X <- calls[x, , drop = FALSE]
  
  # bind the call and the candidate calls in a single extended selection table
  Y <- rbind(X, tempts)
  
  # run cross correlation
  xc <- xcorr(Y, pb = FALSE)

  # put results into a data frame
  Z <- data.frame(X, t(round(xc[ -1, 1], 3)))
  
  # rename columns with xc values
  names(Z)[9:11] <- tempts$lek.song.type
  
  return(Z)
  })

# put results back into a single data frame
do.call(rbind, out)
{% endhighlight %}



{% highlight text %}
##                        sound.files selec start       end bottom.freq
## 31    0.BR1.2012.7.27.5.55.wav_3-4     1   0.1 0.2577134    2.322680
## 32      0.BR1.2012.7.27.5.55.wav_1     1   0.1 0.2547964    2.367977
## 33    0.BR1.2012.7.27.5.55.wav_3-3     1   0.1 0.2555617    2.549166
## 410    0.CCL.2008.4.1.8.27.wav_2-8     1   0.1 0.2286106    1.370448
## 411   0.CCL.2008.4.1.8.27.wav_1-10     1   0.1 0.2255827    1.717743
## 412    0.CCL.2008.4.1.8.27.wav_2-6     1   0.1 0.2345561    1.775625
## 430    43.CCL.2011.6.16.8.19.wav_2     1   0.1 0.2391177    2.199320
## 431    43.CCL.2011.6.16.8.19.wav_4     1   0.1 0.2380658    2.243740
## 432 31.CCL.2011.6.17.8.45.wav_1-13     1   0.1 0.2347949    2.110482
##     top.freq lek lek.song.type BR1-D1 CCL-G1 CCL-K2
## 31  11.67318 BR1        BR1-D1  0.696  0.253  0.424
## 32  11.71848 BR1        BR1-D1  0.704  0.264  0.417
## 33  11.89967 BR1        BR1-D1  0.700  0.235  0.418
## 410 10.72095 CCL        CCL-G1  0.312  0.752  0.488
## 411 11.06824 CCL        CCL-G1  0.294  0.746  0.454
## 412 11.12612 CCL        CCL-G1  0.313  0.754  0.491
## 430 11.54982 CCL        CCL-K2  0.474  0.377  0.671
## 431 11.59424 CCL        CCL-K2  0.443  0.435  0.723
## 432 11.46098 CCL        CCL-K2  0.407  0.455  0.690
{% endhighlight %}

Note the last 3 columns with the cross-correlation scores for each of the 3 templates respectively.

The code can go faster by using parallel computing. This can be done using the pblapply function (instead of lapply) from the [pbapply](https://cran.r-project.org/package=NatureSounds) package with the argument `cl`. 

Hope that helps!


<font size="4">Session information</font>


{% highlight text %}
## R version 3.5.1 (2018-07-02)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 18.10
## 
## Matrix products: default
## BLAS: /usr/lib/x86_64-linux-gnu/openblas/libblas.so.3
## LAPACK: /usr/lib/x86_64-linux-gnu/libopenblasp-r0.3.3.so
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] warbleR_1.1.16     NatureSounds_1.0.1 seewave_2.1.0     
## [4] tuneR_1.3.3        maps_3.3.0        
## 
## loaded via a namespace (and not attached):
##  [1] knitr_1.20       magrittr_1.5     Sim.DiffProc_4.3 MASS_7.3-50     
##  [5] Deriv_3.8.5      rjson_0.2.20     jpeg_0.1-8       pbapply_1.3-4   
##  [9] stringr_1.3.1    highr_0.7        tools_3.5.1      parallel_3.5.1  
## [13] dtw_1.20-1       iterators_1.0.10 yaml_2.2.0       soundgen_1.3.2  
## [17] bitops_1.0-6     RCurl_1.95-4.11  signal_0.7-6     evaluate_0.12   
## [21] proxy_0.4-22     stringi_1.2.4    pracma_2.2.2     compiler_3.5.1  
## [25] fftw_1.0-4
{% endhighlight %}

