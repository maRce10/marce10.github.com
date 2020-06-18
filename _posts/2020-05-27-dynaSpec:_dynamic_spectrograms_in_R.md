---
layout: post
title: "dynaSpec: dynamic spectrograms in R"
date: 27-05-2020
editor_options: 
  chunk_output_type: console
---




The R package [dynaSpec](https://marce10.github.io/dynaSpec) can now be installed from github. This is a set of tools to generate dynamic spectrogram visualizations in video format. It is still on the making and new visualizations will be available soon. [FFMPEG](https://ffmpeg.org/download.html) **must be installed** in order for this package to work. 

To install [dynaSpec](https://marce10.github.io/dynaSpec) from [github](http://github.com/) you will need the R package [devtools](https://cran.r-project.org/package=devtools):


{% highlight r %}

# From github
devtools::install_github("maRce10/dynaSpec")

#load package
library(dynaSpec)

{% endhighlight %}


## Examples

To run the following examples you will also need to load a few more packages as well as  [warbleR](https://cran.r-project.org/package=warbleR) 1.1.24 (currently as the developmental version on github). It can be installed as follows:


{% highlight r %}

# From github
devtools::install_github("maRce10/warbleR")

#load package
library(warbleR)
library(viridis)
library(tuneR)
library(seewave)
{% endhighlight %}

The function `scrolling_spectro()` (the only function so far) creates '.mp4' video files of the spectrogram of an input 'wave' object that moves from right to left. For instance, this is a dynamic spectrogram of a canyon wren song with a viridis color palette:

{% highlight r %}

data("canyon_wren")

scrolling_spectro(wave = canyon_wren, wl = 300, 
              t.display = 1.7, pal = viridis, 
              grid = FALSE, flim = c(1, 9), 
              width = 1000, height = 500, 
              res = 120, file.name = "default.mp4")

{% endhighlight %}



<center><iframe allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="600" height="240"
src="https://www.youtube.com/embed/TOiukDxaNbI" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;

This is the same clip but with a black and white spectrogram:

{% highlight r %}

scrolling_spectro(wave = canyon_wren, wl = 300, 
          t.display = 1.7, pal = reverse.gray.colors.1, 
          grid = FALSE, flim = c(1, 9), 
          width = 1000, height = 500, 
          res = 120, file.name = "black_and_white.mp4",
          collevels = seq(-100, 0, 5))

{% endhighlight %}




<center><iframe allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="600" height="240"
src="https://www.youtube.com/embed/5gQjgzijHOs" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;
A spectrogram with black background (colbg = "black"):

{% highlight r %}

scrolling_spectro(wave = canyon_wren, wl = 300, 
              t.display = 1.7, pal = viridis, 
              grid = FALSE, flim = c(1, 9), 
              width = 1000, height = 500, res = 120, 
              file.name = "black.mp4", colbg = "black")

{% endhighlight %}




<center><iframe allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="600" height="240"
src="https://www.youtube.com/embed/n_GNDn2VH-U" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;

Slow down to 1/2 speed (speed = 0.5) with a oscillogram at the bottom (osc = TRUE):

{% highlight r %}

scrolling_spectro(wave = canyon_wren, wl = 300, 
              t.display = 1.7, pal = viridis, 
              grid = FALSE, flim = c(1, 9), 
              width = 1000, height = 500, res = 120, 
              file.name = "slow.mp4", colbg = "black",
              speed = 0.5, osc = TRUE, 
              colwave = "#31688E99")

{% endhighlight %}




<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="600" height="240"
src="https://www.youtube.com/embed/r25TSKSklLo" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;

&nbsp;

Long-billed hermit song at 1/5 speed (speed = 0.5), removing axes and looping 3 times (loop = 3:

{% highlight r %}

data("Phae.long4")

scrolling_spectro(wave = Phae.long4, wl = 300, 
    t.display = 1.7, ovlp = 90, pal = magma, 
    grid = FALSE, flim = c(1, 10), width = 1000, 
    height = 500, res = 120, collevels = seq(-50, 0, 5), 
    file.name = "no_axis.mp4", colbg = "black", 
    speed = 0.2, axis.type = "none", loop = 3)

{% endhighlight %}



<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="600" height="360"
src="https://www.youtube.com/embed/7AAoaZUkA3k" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;


Visualizing a northern nightingale wren recording from [xeno-canto](https://www.xeno-canto.org) using a custom color palette:


{% highlight r %}

ngh_wren <- read_wave("https://www.xeno-canto.org/518334/download")

custom_pal <- colorRampPalette( c("#2d2d86", "#2d2d86", reverse.terrain.colors(10)[5:10]))

scrolling_spectro(wave = ngh_wren, wl = 600, 
    t.display = 3, ovlp = 95, pal = custom_pal, 
    grid = FALSE, flim = c(2, 8), width = 700, 
    height = 250, res = 100, collevels = seq(-40, 0, 5),
    file.name = "../nightingale_wren.mp4", colbg = "#2d2d86", lcol = "#FFFFFFE6")

{% endhighlight %}



<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="700" height="250"
src="https://www.youtube.com/embed/OxvKoPyX-4o" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;
 
Spix's disc-winged bat inquiry call slow down (speed = 0.05):


{% highlight r %}

data("thyroptera.est")

# extract one call
thy_wav <- attributes(thyroptera.est)$wave.objects[[12]]

# add silence at both "sides""
thy_wav <- pastew(tuneR::silence(duration = 0.05, 
            samp.rate = thy_wav@samp.rate, xunit = "time"),
            thy_wav, output = "Wave")

thy_wav <- pastew(thy_wav, tuneR::silence(duration = 0.04, 
            samp.rate = thy_wav@samp.rate, xunit = "time"),
            output = "Wave")

scrolling_spectro(wave = thy_wav, wl = 400, 
    t.display = 0.08, ovlp = 95, pal = inferno, 
    grid = FALSE, flim = c(12, 37), width = 700, 
    height = 250, res = 100, collevels = seq(-40, 0, 5),
    file.name = "thyroptera_osc.mp4", colbg = "black", lcol = "#FFFFFFE6", 
    speed = 0.05, fps = 200, buffer = 0, loop = 4, lty = 1, 
    osc = TRUE, colwave = inferno(10, alpha = 0.9)[3])

{% endhighlight %}
  


<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="700" height="250"
src="https://www.youtube.com/embed/mFiYPzOe9Nw" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;


### Further customization

The argument 'spectro.call' allows to insert customized spectrogram visualizations. For instance, the following code makes use of the `color_spectro()` function from [warbleR](https://cran.r-project.org/package=warbleR) to highlight vocalizations from male and female house wrens with different colors (after downloading the selection table and sound file from figshare):
 

{% highlight r %}

# get house wren male female duet recording
hs_wren <- read_wave("https://ndownloader.figshare.com/files/22722101")

# and extended selection table
st <- read.csv("https://ndownloader.figshare.com/files/22722404")

# create color column
st$colors <- c("green", "yellow")

# highlight selections
color.spectro(wave = hs_wren, wl = 200, ovlp = 95, flim = c(1, 13), 
              collevels = seq(-55, 0, 5), dB = "B", X = st, col.clm = "colors", 
              base.col = "black",  t.mar = 0.07, f.mar = 0.1, strength = 3, 
              interactive = NULL, bg.col = "black")

{% endhighlight %}
 
<img src="https://github.com/maRce10/dynaSpec/raw/master/inst/colored_spectro_house_wren_duet.png" alt="house wren duet">
 
The male part is shown in green and the female part in yellow. 

We can wrap the `color_spectro()` call using the `call()` function form base R and input that into `scrolling_spectro()` using the argument 'spectro.call':


{% highlight r %}
# save call
sp_cl <- call("color.spectro", wave = hs_wren, wl = 200, ovlp = 95, 
              flim = c(1, 13), collevels = seq(-55, 0, 5), strength = 3,
              dB = "B", X = st, col.clm = "colors", base.col = "black",  
              t.mar = 0.07, f.mar = 0.1, interactive = NULL, bg.col = "black")

# create dynamic spectrogram
scrolling_spectro(wave = hs_wren, wl = 512,  
                  t.display = 1.2, pal = reverse.gray.colors.1, 
                  grid = FALSE, flim = c(1, 13), loop = 3,
                  width = 1000, height = 500, res = 120,
                  collevels = seq(-100, 0, 1), spectro.call = sp_cl, fps = 60,
                  file.name = "yellow_and_green.mp4")
{% endhighlight %}

<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="700" height="350"
src="https://www.youtube.com/embed/9qMPxYuGUJE" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;

This option can be mixed with any of the other customizations in the function, as adding an oscillogram: 

{% highlight r %}

# create dynamic spectrogram
scrolling_spectro(wave = hs_wren, wl = 512, osc = TRUE,
                  t.display = 1.2, pal = reverse.gray.colors.1, 
                  grid = FALSE, flim = c(1, 13), loop = 3, 
                  width = 1000, height = 500, res = 120, 
                  collevels = seq(-100, 0, 1), 
                  spectro.call = sp_cl, fps = 60,
                  file.name = "yellow_and_green_oscillo.mp4")

{% endhighlight %}

<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="700" height="350"
src="https://www.youtube.com/embed/k6OumiKsRWw" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;

A viridis color palette:


{% highlight r %}

st$colors <- viridis(10)[c(3, 8)]

sp_cl <- call("color.spectro", wave = hs_wren, wl = 200, 
              ovlp = 95, flim = c(1, 13), collevels = seq(-55, 0, 5),
              dB = "B", X = st, col.clm = "colors", 
              base.col = "white", t.mar = 0.07, f.mar = 0.1,
              strength = 3, interactive = NULL)

# create dynamic spectrogram
scrolling_spectro(wave = hs_wren, wl = 200, osc = TRUE,
                  t.display = 1.2, pal = reverse.gray.colors.1, 
                  grid = FALSE, flim = c(1, 13), loop = 3, 
                  width = 1000, height = 500, res = 120, 
                  collevels = seq(-100, 0, 1), colwave = viridis(10)[c(9)],
                  spectro.call = sp_cl, fps = 60,
                  file.name = "viridis.mp4")

{% endhighlight %}

<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="700" height="350"
src="https://www.youtube.com/embed/HvV2NFuJeIU" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;


Or simply a gray scale:


{% highlight r %}

st$colors <- c("gray", "gray49")

sp_cl <- call("color.spectro", wave = hs_wren, wl = 200, ovlp = 95, flim = c(1, 13), 
              collevels = seq(-55, 0, 5), dB = "B", X = st, col.clm = "colors", 
              base.col = "white", t.mar = 0.07, f.mar = 0.1, strength = 3, 
              interactive = NULL)

# create dynamic spectrogram
scrolling_spectro(wave = hs_wren, wl = 512, osc = TRUE,
                  t.display = 1.2, pal = reverse.gray.colors.1, 
                  grid = FALSE, flim = c(1, 13), loop = 3, 
                  width = 1000, height = 500, res = 120, 
                  collevels = seq(-100, 0, 1), 
                  spectro.call = sp_cl, fps = 60,
                  file.name = "gray.mp4")
{% endhighlight %}

<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="700" height="350"
src="https://www.youtube.com/embed/gd096zAG5NE" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;

The 'spectro.call' argument can also be used to add annotations. To do this we need to wrap up both the spectrogram function and the annotation functions (i.e. `text()`, `lines()`) in a single function and then save the call to that function:


{% highlight r %}

# create color column
st$colors <- viridis(10)[c(3, 8)]

# create label column
st$labels <- c("male", "female")

# shrink end of second selection (purely aesthetics)
st$end[2] <- 3.87

  # function to highlight selections
ann_fun <- function(wave, X){
  
  # print spectrogram
  color.spectro(wave = wave,  wl = 200, 
              ovlp = 95, flim = c(1, 18.6), collevels = seq(-55, 0, 5),
              dB = "B", X = X, col.clm = "colors", 
              base.col = "white", t.mar = 0.07, f.mar = 0.1,
              strength = 3, interactive = NULL)
  
  # annotate each selection in X 
  for(e in 1:nrow(X)){  
    # label
    text(x = X$start[e] + ((X$end[e] - X$start[e]) / 2), 
         y = 16.5, labels = X$labels[e], cex = 3.3, 
         col = adjustcolor(X$colors[e], 0.6))
    
    # line
    lines(x = c(X$start[e], X$end[e]), y = c(14.5, 14.5), 
          lwd = 6, col = adjustcolor("gray50", 0.3))
  }
  
}

# save call
ann_cl <- call("ann_fun", wave = hs_wren, X = st)

# create annotated dynamic spectrogram
scrolling_spectro(wave = hs_wren, wl = 200, t.display = 1.2, 
                  grid = FALSE, flim = c(1, 18.6), loop = 3, 
                  width = 1000, height = 500, res = 200, 
                  collevels = seq(-100, 0, 1), speed = 0.5,
                  spectro.call = ann_cl, fps = 120,
                  file.name = "../viridis_annotated.mp4")

{% endhighlight %}

<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="700" height="350"
src="https://www.youtube.com/embed/wbpjKfZUUIw" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;


Finally, the argument 'annotation.call' can be used to add static labels (i.e. non-scrolling). It works similar to 'spectro.call', but requires a call from `text()`. This let users customize things as size, color, position, font, and additional arguments taken by `text()`. The call should also include the argmuents 'start' and 'end' to indicate the time at which the labels are displayed (in s). 'fading' is optional and allows fade-in and fade-out effects on labels (in s as well). The following code downloads a recording containing several frog species recorded in Costa Rica from figshare, cuts a clip including two species and labels it with a single label:


{% highlight r %}

# read data from figshare
frogs <- read_wave("https://ndownloader.figshare.com/files/22829075")

# cut a couple of species
shrt_frgs <- cutw(frogs, from = 35.3, to = 50.5, output = "Wave")

# make annotation call
ann_cll <- call("text", x = 0.25, y = 0.87, 
                labels = "Frog calls", cex = 1, start = 0.2, end = 14, 
                col = "#FFEA46CC", font = 3, fading = 0.6)

# create dynamic spectro
scrolling_spectro(wave = shrt_frgs, wl = 512, ovlp = 95,  
                  t.display = 1.1, pal = cividis,
                  grid = FALSE, flim = c(0, 5.5), loop = 3,
                  width = 1200, height = 550, res = 200,
                  collevels = seq(-40, 0, 5), lcol =  "#FFFFFFCC", 
                  colbg = "black", fps = 60, file.name = "../frogs.mp4",
                  osc = TRUE, height.prop = c(3, 1), colwave = "#31688E", 
                  lty = 3, annotation.call = ann_cll)


{% endhighlight %}

<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="763.63" height="350"
src="https://www.youtube.com/embed/Ux71aMVa_oU" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;

The argument accepts more than one labels as in a regular `text()` call. In that case 'start' and 'end' values should be supplied for each label:


{% highlight r %}

# make annotation call for 2 annotations
ann_cll <- call("text", x = 0.25, y = 0.87, 
                labels = c("Dendropsophus ebraccatus", "Eleutherodactylus coqui"), 
                cex = 1, start = c(0.4, 7), 
                end = c(5.5, 14.8), col = "#FFEA46CC", font = 3, fading = 0.6)

# create dynamic spectro
scrolling_spectro(wave = shrt_frgs, wl = 512, ovlp = 95,  
                  t.display = 1.1, pal = cividis,
                  grid = FALSE, flim = c(0, 5.5), loop = 3,
                  width = 1200, height = 550, res = 200,
                  collevels = seq(-40, 0, 5), lcol =  "#FFFFFFCC", colbg = "black", 
                  fps = 60, file.name = "../frogs_sp_labels.mp4", osc = TRUE, 
                  height.prop = c(3, 1),colwave = "#31688E", lty = 3, 
                  annotation.call = ann_cll)

{% endhighlight %}

<center><iframe  allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="763.63" height="350"
src="https://www.youtube.com/embed/nFfYr8Tc53Q" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

&nbsp;
 

---


Please cite [dynaSpec](https://marce10.github.io/dynaSpec) as follows:

Araya-Salas M. (2020), *dynaSpec: dynamic spectrogram visualizations in R*. R package version 1.0.0.

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
##  [1] LC_CTYPE=es_ES.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=es_CR.UTF-8        LC_COLLATE=es_ES.UTF-8    
##  [5] LC_MONETARY=es_CR.UTF-8    LC_MESSAGES=es_ES.UTF-8   
##  [7] LC_PAPER=es_CR.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=es_CR.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets 
## [6] methods   base     
## 
## other attached packages:
## [1] kableExtra_1.1.0   warbleR_1.1.24     NatureSounds_1.0.3
## [4] seewave_2.1.6      tuneR_1.3.3        knitr_1.28        
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.4.6      highr_0.8         compiler_3.6.1   
##  [4] pillar_1.4.4      bitops_1.0-6      tools_3.6.1      
##  [7] digest_0.6.25     viridisLite_0.3.0 evaluate_0.14    
## [10] tibble_3.0.1      lifecycle_0.2.0   fftw_1.0-6       
## [13] pkgconfig_2.0.3   rlang_0.4.6       rstudioapi_0.11  
## [16] yaml_2.2.1        parallel_3.6.1    xfun_0.14        
## [19] xml2_1.3.2        stringr_1.4.0     httr_1.4.1       
## [22] vctrs_0.3.1       hms_0.5.3         webshot_0.5.2    
## [25] glue_1.4.1        R6_2.4.1          dtw_1.21-3       
## [28] pbapply_1.4-2     rmarkdown_2.2     readr_1.3.1      
## [31] magrittr_1.5      scales_1.1.1      htmltools_0.4.0  
## [34] ellipsis_0.3.1    MASS_7.3-51.4     rvest_0.3.5      
## [37] colorspace_1.4-1  stringi_1.4.6     proxy_0.4-24     
## [40] munsell_0.5.0     signal_0.7-6      RCurl_1.98-1.2   
## [43] crayon_1.3.4      rjson_0.2.20
{% endhighlight %}
