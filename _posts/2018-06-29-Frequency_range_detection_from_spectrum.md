---
layout: post
title: "Frequency range detection from spectrum"
date: 29-06-2018
---

We are often interested in getting the frequency range of acoustic signals, either because we have specific predictions about its variation or simply because we want to measure other stuff within that range. Measuring frequency range is typically done by drawing boxes in *Raven/Avisoft/Syrinx*. An alternative way, and potentially less subjective, is to infer the range from the energy distribution in the frequency domain applying amplitude thresholds on spectrums. I have added two new functions to [warbleR](https://cran.r-project.org/package=warbleR) that do exactly that:

* `freq_range_detec`: detects the frequency range of signals in wave objects (like a [seewave](https://cran.r-project.org/package=seewave) function). Can produce images n the graphic device if `plot = TRUE`.

* `freq_range`: applies `freq_range_detec` iteratively on signals listed in a selection table (like most [warbleR](https://cran.r-project.org/package=warbleR) functions). If `img = TRUE` image files including a spectrogram and a frequency spectrum are produced for each selection. 

This post shows how these functions work.

 Let's first Load/install [warbleR](https://cran.r-project.org/package=warbleR):
 

{% highlight r %}
if(!require(githubinstall)) install.packages("githubinstall")

githubinstall("warbleR", ask = FALSE)

library("warbleR")
{% endhighlight %}



We will run the functions on signals detected on a recording from a male [Striped-throated Hermit (*Phaethornis striigularis*)](https://neotropical.birds.cornell.edu/Species-Account/nb/species/stther2/overview) from [Xeno-Canto](http://xeno-canto.org). We can download the sound file and convert it into wave format as follows:


{% highlight r %}
# set temporary working directory
 setwd(tempdir())

# Query and download  Xeno-Canto for metadata using genus and species as keywords
Phae.stri <- quer_xc(qword = "nr:154074", download = TRUE, pb = FALSE)

# Convert mp3 to wav format
# Simultaneously lower sampling rate to speed up down stream analyses
mp32wav(samp.rate = 22.05, pb = FALSE)
{% endhighlight %}

Now, we need to detect the time "coordinates" of the signals in the sound file using `auto_detec`:


{% highlight r %}
ad <- auto_detec(wl = 200, threshold = 3.5, ssmooth = 1200, bp = c(4, 9.6), 
                 pb = FALSE,  mindur = 0.1, maxdur = 0.25, img = FALSE)
{% endhighlight %}

And selec the highest signal-to-noise ratio signals (just for the sake of the example):


{% highlight r %}
snr <- sig2noise(ad, pb = FALSE, mar = 0.05)

ad <- snr[rank(-snr$SNR) < 60, ]
{% endhighlight %}

Let's take a look at the subset of signals that we will analyze (the output of `catalog` will be found in your working directory):


{% highlight r %}
catalog(ad, nrow = 5, ncol = 4, mar = 0.01, flim = c(3.5, 10.5), 
        labels = "selec", pal = reverse.heat.colors, pb = FALSE)

open_wd()
{% endhighlight %}



![frange1](/img/frange_catalog.png)

### freq_range_detec

Now we are ready to run the new functions. `freq_range_detec` works on wave objects. In this example we use it to detect the frequency range of the first selection in "ad". But first the selection has to be read as a wave object into *R*: 


{% highlight r %}
w2 <- readWave(as.character(ad$sound.files[2]), from = ad$start[2], 
               to = ad$end[2], units = "seconds")

freq_range_detec(w2, bp = c(2, 9.6), fsmooth = 1, ovlp = 95, 
                 wl = 200, threshold = 8)
{% endhighlight %}

![frange2](/img/frange_freq_range_detec.png)

We can look at the detection for each selection in the 'ad' data frame using a loop as follows:


{% highlight r %}
for(i in 1:nrow(ad))
{
  wv <- readWave(as.character(ad$sound.files[i]), from = ad$start[i], 
                 to = ad$end[i], units = "seconds")

freq_range_detec(wv, bp = c(2, 12), fsmooth = 1, ovlp = 95, wl = 200, 
                 threshold = 8, flim = c(0, 13), 
                 main = paste("selection", i))

Sys.sleep(0.8)
}
{% endhighlight %}




![frange_gif](/img/frange_2.gif)

In most cases the detection is good. However, there are some issues with highly amplitude-modulated signals (e.g. high variation in amplitude across the signal). Some parameter tweeking will be required to improve those detections. 


### freq_range

As mentioned above, the frequency range can be calculated for all selection in a selection table using `freq_range`:


{% highlight r %}
fr_ad <- freq_range(X = ad, bp = c(2, 12), fsmooth = 0.001, ovlp = 95, 
                          wl = 200, threshold = 10, img = FALSE)

View(fr_ad)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-y: scroll; height:600px; overflow-x: scroll; width:740px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> SNR </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.489751 </td>
   <td style="text-align:center;"> 4.638935 </td>
   <td style="text-align:center;"> 20.90457 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 5.008890 </td>
   <td style="text-align:center;"> 5.173992 </td>
   <td style="text-align:center;"> 18.34097 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 5.515987 </td>
   <td style="text-align:center;"> 5.648255 </td>
   <td style="text-align:center;"> 20.36164 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 6.026758 </td>
   <td style="text-align:center;"> 6.148005 </td>
   <td style="text-align:center;"> 19.19053 </td>
   <td style="text-align:center;"> 5.84325 </td>
   <td style="text-align:center;"> 8.26875 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 6.465987 </td>
   <td style="text-align:center;"> 6.688504 </td>
   <td style="text-align:center;"> 20.75168 </td>
   <td style="text-align:center;"> 4.96125 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> 6.751951 </td>
   <td style="text-align:center;"> 6.921702 </td>
   <td style="text-align:center;"> 24.45381 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 7.232495 </td>
   <td style="text-align:center;"> 7.362042 </td>
   <td style="text-align:center;"> 22.34749 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> 7.733947 </td>
   <td style="text-align:center;"> 7.902042 </td>
   <td style="text-align:center;"> 21.29256 </td>
   <td style="text-align:center;"> 4.52025 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 8.260749 </td>
   <td style="text-align:center;"> 8.381226 </td>
   <td style="text-align:center;"> 22.84151 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> 8.831634 </td>
   <td style="text-align:center;"> 8.993493 </td>
   <td style="text-align:center;"> 20.23309 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:center;"> 9.436532 </td>
   <td style="text-align:center;"> 9.559366 </td>
   <td style="text-align:center;"> 24.22708 </td>
   <td style="text-align:center;"> 6.28425 </td>
   <td style="text-align:center;"> 8.26875 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> 10.009502 </td>
   <td style="text-align:center;"> 10.171838 </td>
   <td style="text-align:center;"> 21.27714 </td>
   <td style="text-align:center;"> 4.52025 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:center;"> 10.634196 </td>
   <td style="text-align:center;"> 10.756079 </td>
   <td style="text-align:center;"> 21.71106 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:center;"> 11.125671 </td>
   <td style="text-align:center;"> 11.245172 </td>
   <td style="text-align:center;"> 20.07081 </td>
   <td style="text-align:center;"> 5.84325 </td>
   <td style="text-align:center;"> 7.82775 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 16 </td>
   <td style="text-align:center;"> 11.658051 </td>
   <td style="text-align:center;"> 11.780795 </td>
   <td style="text-align:center;"> 21.47064 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:center;"> 12.033539 </td>
   <td style="text-align:center;"> 12.257553 </td>
   <td style="text-align:center;"> 20.78009 </td>
   <td style="text-align:center;"> 5.18175 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 18 </td>
   <td style="text-align:center;"> 12.306600 </td>
   <td style="text-align:center;"> 12.505330 </td>
   <td style="text-align:center;"> 18.45269 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 19 </td>
   <td style="text-align:center;"> 12.648097 </td>
   <td style="text-align:center;"> 12.783539 </td>
   <td style="text-align:center;"> 22.10976 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> 12.952428 </td>
   <td style="text-align:center;"> 13.122383 </td>
   <td style="text-align:center;"> 18.94679 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 21 </td>
   <td style="text-align:center;"> 13.421272 </td>
   <td style="text-align:center;"> 13.588845 </td>
   <td style="text-align:center;"> 19.06837 </td>
   <td style="text-align:center;"> 4.07925 </td>
   <td style="text-align:center;"> 7.82775 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:center;"> 13.820070 </td>
   <td style="text-align:center;"> 13.942904 </td>
   <td style="text-align:center;"> 25.49960 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 9.15075 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 23 </td>
   <td style="text-align:center;"> 14.245467 </td>
   <td style="text-align:center;"> 14.402179 </td>
   <td style="text-align:center;"> 21.68081 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 9.81225 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:center;"> 14.681113 </td>
   <td style="text-align:center;"> 14.892746 </td>
   <td style="text-align:center;"> 22.28803 </td>
   <td style="text-align:center;"> 4.96125 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 25 </td>
   <td style="text-align:center;"> 14.952995 </td>
   <td style="text-align:center;"> 15.108936 </td>
   <td style="text-align:center;"> 25.53068 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 26 </td>
   <td style="text-align:center;"> 15.367939 </td>
   <td style="text-align:center;"> 15.479209 </td>
   <td style="text-align:center;"> 26.28637 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 27 </td>
   <td style="text-align:center;"> 15.759118 </td>
   <td style="text-align:center;"> 15.911431 </td>
   <td style="text-align:center;"> 23.86172 </td>
   <td style="text-align:center;"> 4.52025 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:center;"> 16.321249 </td>
   <td style="text-align:center;"> 16.428211 </td>
   <td style="text-align:center;"> 25.17833 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 29 </td>
   <td style="text-align:center;"> 17.303608 </td>
   <td style="text-align:center;"> 17.412905 </td>
   <td style="text-align:center;"> 25.80084 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:center;"> 18.262293 </td>
   <td style="text-align:center;"> 18.368415 </td>
   <td style="text-align:center;"> 27.95617 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:center;"> 20.295694 </td>
   <td style="text-align:center;"> 20.400161 </td>
   <td style="text-align:center;"> 24.66168 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 32 </td>
   <td style="text-align:center;"> 21.410978 </td>
   <td style="text-align:center;"> 21.519051 </td>
   <td style="text-align:center;"> 23.77559 </td>
   <td style="text-align:center;"> 5.62275 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 33 </td>
   <td style="text-align:center;"> 21.833019 </td>
   <td style="text-align:center;"> 22.039572 </td>
   <td style="text-align:center;"> 20.78263 </td>
   <td style="text-align:center;"> 4.74075 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:center;"> 22.103654 </td>
   <td style="text-align:center;"> 22.258121 </td>
   <td style="text-align:center;"> 24.28746 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 35 </td>
   <td style="text-align:center;"> 22.463654 </td>
   <td style="text-align:center;"> 22.572906 </td>
   <td style="text-align:center;"> 19.35437 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 36 </td>
   <td style="text-align:center;"> 23.326307 </td>
   <td style="text-align:center;"> 23.433563 </td>
   <td style="text-align:center;"> 16.89860 </td>
   <td style="text-align:center;"> 5.18175 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 37 </td>
   <td style="text-align:center;"> 23.732679 </td>
   <td style="text-align:center;"> 23.846375 </td>
   <td style="text-align:center;"> 21.67463 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 38 </td>
   <td style="text-align:center;"> 25.414629 </td>
   <td style="text-align:center;"> 25.534357 </td>
   <td style="text-align:center;"> 14.28221 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 39 </td>
   <td style="text-align:center;"> 27.724970 </td>
   <td style="text-align:center;"> 27.836784 </td>
   <td style="text-align:center;"> 22.53570 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 40 </td>
   <td style="text-align:center;"> 29.991206 </td>
   <td style="text-align:center;"> 30.140140 </td>
   <td style="text-align:center;"> 16.33969 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 41 </td>
   <td style="text-align:center;"> 36.950889 </td>
   <td style="text-align:center;"> 37.054041 </td>
   <td style="text-align:center;"> 15.93673 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:center;"> 42.691548 </td>
   <td style="text-align:center;"> 42.792818 </td>
   <td style="text-align:center;"> 23.03548 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:center;"> 44.947807 </td>
   <td style="text-align:center;"> 45.055176 </td>
   <td style="text-align:center;"> 14.97918 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 47 </td>
   <td style="text-align:center;"> 55.080257 </td>
   <td style="text-align:center;"> 55.197989 </td>
   <td style="text-align:center;"> 14.60428 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 48 </td>
   <td style="text-align:center;"> 57.503908 </td>
   <td style="text-align:center;"> 57.607672 </td>
   <td style="text-align:center;"> 16.81580 </td>
   <td style="text-align:center;"> 3.85875 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> 58.645473 </td>
   <td style="text-align:center;"> 58.760031 </td>
   <td style="text-align:center;"> 15.19377 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 51 </td>
   <td style="text-align:center;"> 61.539351 </td>
   <td style="text-align:center;"> 61.650349 </td>
   <td style="text-align:center;"> 15.68119 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 54 </td>
   <td style="text-align:center;"> 66.936200 </td>
   <td style="text-align:center;"> 67.039170 </td>
   <td style="text-align:center;"> 17.64989 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 75 </td>
   <td style="text-align:center;"> 80.315567 </td>
   <td style="text-align:center;"> 80.475068 </td>
   <td style="text-align:center;"> 13.71808 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 77 </td>
   <td style="text-align:center;"> 81.066723 </td>
   <td style="text-align:center;"> 81.179580 </td>
   <td style="text-align:center;"> 13.69326 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 86 </td>
   <td style="text-align:center;"> 84.856429 </td>
   <td style="text-align:center;"> 84.967336 </td>
   <td style="text-align:center;"> 14.32599 </td>
   <td style="text-align:center;"> 3.85875 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 88 </td>
   <td style="text-align:center;"> 85.438107 </td>
   <td style="text-align:center;"> 85.552211 </td>
   <td style="text-align:center;"> 13.87818 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 90 </td>
   <td style="text-align:center;"> 86.451735 </td>
   <td style="text-align:center;"> 86.559264 </td>
   <td style="text-align:center;"> 14.22499 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 92 </td>
   <td style="text-align:center;"> 87.433572 </td>
   <td style="text-align:center;"> 87.545341 </td>
   <td style="text-align:center;"> 13.07171 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 88.701803 </td>
   <td style="text-align:center;"> 88.856792 </td>
   <td style="text-align:center;"> 13.27620 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 9.15075 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 97 </td>
   <td style="text-align:center;"> 89.906566 </td>
   <td style="text-align:center;"> 90.013414 </td>
   <td style="text-align:center;"> 13.40520 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 8.26875 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 100 </td>
   <td style="text-align:center;"> 91.123459 </td>
   <td style="text-align:center;"> 91.281441 </td>
   <td style="text-align:center;"> 13.01602 </td>
   <td style="text-align:center;"> 3.63825 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 106 </td>
   <td style="text-align:center;"> 93.240942 </td>
   <td style="text-align:center;"> 93.404752 </td>
   <td style="text-align:center;"> 14.42909 </td>
   <td style="text-align:center;"> 4.29975 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 110 </td>
   <td style="text-align:center;"> 94.960058 </td>
   <td style="text-align:center;"> 95.075546 </td>
   <td style="text-align:center;"> 14.95041 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 111 </td>
   <td style="text-align:center;"> 95.955614 </td>
   <td style="text-align:center;"> 96.172258 </td>
   <td style="text-align:center;"> 13.14609 </td>
   <td style="text-align:center;"> 3.19725 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
</tbody>
</table></div>

The range can then be used as a band pass filter in other [warbleR](https://cran.r-project.org/package=warbleR) functions like `trackfreqs`, `dfts` or `specan`:


{% highlight r %}
sp <- specan(X = fr_ad, wl = 200, bp = "frange", ovlp = 90, pb = FALSE, 
             threshold = 15)

View(sp)
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 1px; overflow-y: scroll; height:600px; overflow-x: scroll; width:740px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> duration </th>
   <th style="text-align:center;"> meanfreq </th>
   <th style="text-align:center;"> sd </th>
   <th style="text-align:center;"> freq.median </th>
   <th style="text-align:center;"> freq.Q25 </th>
   <th style="text-align:center;"> freq.Q75 </th>
   <th style="text-align:center;"> freq.IQR </th>
   <th style="text-align:center;"> time.median </th>
   <th style="text-align:center;"> time.Q25 </th>
   <th style="text-align:center;"> time.Q75 </th>
   <th style="text-align:center;"> time.IQR </th>
   <th style="text-align:center;"> skew </th>
   <th style="text-align:center;"> kurt </th>
   <th style="text-align:center;"> sp.ent </th>
   <th style="text-align:center;"> time.ent </th>
   <th style="text-align:center;"> entropy </th>
   <th style="text-align:center;"> sfm </th>
   <th style="text-align:center;"> meanfun </th>
   <th style="text-align:center;"> minfun </th>
   <th style="text-align:center;"> maxfun </th>
   <th style="text-align:center;"> meandom </th>
   <th style="text-align:center;"> mindom </th>
   <th style="text-align:center;"> maxdom </th>
   <th style="text-align:center;"> dfrange </th>
   <th style="text-align:center;"> modindx </th>
   <th style="text-align:center;"> startdom </th>
   <th style="text-align:center;"> enddom </th>
   <th style="text-align:center;"> dfslope </th>
   <th style="text-align:center;"> meanpeakf </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1491837 </td>
   <td style="text-align:center;"> 7.595923 </td>
   <td style="text-align:center;"> 0.5151054 </td>
   <td style="text-align:center;"> 7.731654 </td>
   <td style="text-align:center;"> 7.161780 </td>
   <td style="text-align:center;"> 8.019943 </td>
   <td style="text-align:center;"> 0.8581622 </td>
   <td style="text-align:center;"> 0.0680240 </td>
   <td style="text-align:center;"> 0.0389379 </td>
   <td style="text-align:center;"> 0.0905423 </td>
   <td style="text-align:center;"> 0.0516044 </td>
   <td style="text-align:center;"> 0.5476544 </td>
   <td style="text-align:center;"> 2.704384 </td>
   <td style="text-align:center;"> 0.9597727 </td>
   <td style="text-align:center;"> 0.8880751 </td>
   <td style="text-align:center;"> 0.8523502 </td>
   <td style="text-align:center;"> 0.6989461 </td>
   <td style="text-align:center;"> 5.951745 </td>
   <td style="text-align:center;"> 1.3781250 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.444951 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 1.5435 </td>
   <td style="text-align:center;"> 3.428571 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 5.912174 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.1651021 </td>
   <td style="text-align:center;"> 7.392857 </td>
   <td style="text-align:center;"> 1.4663635 </td>
   <td style="text-align:center;"> 7.816846 </td>
   <td style="text-align:center;"> 6.417519 </td>
   <td style="text-align:center;"> 8.495308 </td>
   <td style="text-align:center;"> 2.0777885 </td>
   <td style="text-align:center;"> 0.0624963 </td>
   <td style="text-align:center;"> 0.0391768 </td>
   <td style="text-align:center;"> 0.1035386 </td>
   <td style="text-align:center;"> 0.0643618 </td>
   <td style="text-align:center;"> 1.6768368 </td>
   <td style="text-align:center;"> 5.677156 </td>
   <td style="text-align:center;"> 0.9366713 </td>
   <td style="text-align:center;"> 0.8868538 </td>
   <td style="text-align:center;"> 0.8306906 </td>
   <td style="text-align:center;"> 0.5640262 </td>
   <td style="text-align:center;"> 5.247411 </td>
   <td style="text-align:center;"> 0.1743083 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.865568 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 9.4815 </td>
   <td style="text-align:center;"> 6.3945 </td>
   <td style="text-align:center;"> 8.931035 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> -1.335538 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 0.1322676 </td>
   <td style="text-align:center;"> 7.892218 </td>
   <td style="text-align:center;"> 0.3212360 </td>
   <td style="text-align:center;"> 7.862338 </td>
   <td style="text-align:center;"> 7.597522 </td>
   <td style="text-align:center;"> 8.157419 </td>
   <td style="text-align:center;"> 0.5598971 </td>
   <td style="text-align:center;"> 0.0597793 </td>
   <td style="text-align:center;"> 0.0395391 </td>
   <td style="text-align:center;"> 0.0828437 </td>
   <td style="text-align:center;"> 0.0433047 </td>
   <td style="text-align:center;"> 0.5337817 </td>
   <td style="text-align:center;"> 2.517482 </td>
   <td style="text-align:center;"> 0.9283590 </td>
   <td style="text-align:center;"> 0.8907942 </td>
   <td style="text-align:center;"> 0.8269768 </td>
   <td style="text-align:center;"> 0.4810346 </td>
   <td style="text-align:center;"> 5.032002 </td>
   <td style="text-align:center;"> 0.3150000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.948601 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 1.3230 </td>
   <td style="text-align:center;"> 6.666667 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 6.668300 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 0.1212472 </td>
   <td style="text-align:center;"> 7.108289 </td>
   <td style="text-align:center;"> 0.4080179 </td>
   <td style="text-align:center;"> 7.196250 </td>
   <td style="text-align:center;"> 6.891000 </td>
   <td style="text-align:center;"> 7.386000 </td>
   <td style="text-align:center;"> 0.4950000 </td>
   <td style="text-align:center;"> 0.0580288 </td>
   <td style="text-align:center;"> 0.0410448 </td>
   <td style="text-align:center;"> 0.0745411 </td>
   <td style="text-align:center;"> 0.0334963 </td>
   <td style="text-align:center;"> 1.5882154 </td>
   <td style="text-align:center;"> 4.702673 </td>
   <td style="text-align:center;"> 0.8871230 </td>
   <td style="text-align:center;"> 0.8932471 </td>
   <td style="text-align:center;"> 0.7924201 </td>
   <td style="text-align:center;"> 0.4093291 </td>
   <td style="text-align:center;"> 5.486558 </td>
   <td style="text-align:center;"> 0.1743083 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.971113 </td>
   <td style="text-align:center;"> 5.9535 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 1.9845 </td>
   <td style="text-align:center;"> 5.222222 </td>
   <td style="text-align:center;"> 6.1740 </td>
   <td style="text-align:center;"> 7.7175 </td>
   <td style="text-align:center;"> 12.730193 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 5.84325 </td>
   <td style="text-align:center;"> 8.26875 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 0.2225170 </td>
   <td style="text-align:center;"> 7.080586 </td>
   <td style="text-align:center;"> 0.8983189 </td>
   <td style="text-align:center;"> 7.337250 </td>
   <td style="text-align:center;"> 6.387750 </td>
   <td style="text-align:center;"> 7.895250 </td>
   <td style="text-align:center;"> 1.5075000 </td>
   <td style="text-align:center;"> 0.0941062 </td>
   <td style="text-align:center;"> 0.0695366 </td>
   <td style="text-align:center;"> 0.1543712 </td>
   <td style="text-align:center;"> 0.0848346 </td>
   <td style="text-align:center;"> 2.3159439 </td>
   <td style="text-align:center;"> 9.899743 </td>
   <td style="text-align:center;"> 0.9512709 </td>
   <td style="text-align:center;"> 0.8842104 </td>
   <td style="text-align:center;"> 0.8411236 </td>
   <td style="text-align:center;"> 0.6635994 </td>
   <td style="text-align:center;"> 5.642261 </td>
   <td style="text-align:center;"> 0.1743083 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.689686 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 4.571429 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 0.000000 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 4.96125 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> 0.1697506 </td>
   <td style="text-align:center;"> 7.871154 </td>
   <td style="text-align:center;"> 0.3172318 </td>
   <td style="text-align:center;"> 7.941366 </td>
   <td style="text-align:center;"> 7.705718 </td>
   <td style="text-align:center;"> 8.129886 </td>
   <td style="text-align:center;"> 0.4241679 </td>
   <td style="text-align:center;"> 0.0708849 </td>
   <td style="text-align:center;"> 0.0452357 </td>
   <td style="text-align:center;"> 0.0983994 </td>
   <td style="text-align:center;"> 0.0531636 </td>
   <td style="text-align:center;"> 1.6622037 </td>
   <td style="text-align:center;"> 5.545733 </td>
   <td style="text-align:center;"> 0.9229465 </td>
   <td style="text-align:center;"> 0.8861465 </td>
   <td style="text-align:center;"> 0.8178659 </td>
   <td style="text-align:center;"> 0.5776405 </td>
   <td style="text-align:center;"> 5.143396 </td>
   <td style="text-align:center;"> 0.1743083 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.816544 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 1.1025 </td>
   <td style="text-align:center;"> 5.800000 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> -1.298965 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 0.1295465 </td>
   <td style="text-align:center;"> 7.662273 </td>
   <td style="text-align:center;"> 0.5731449 </td>
   <td style="text-align:center;"> 7.742645 </td>
   <td style="text-align:center;"> 7.185592 </td>
   <td style="text-align:center;"> 8.168171 </td>
   <td style="text-align:center;"> 0.9825789 </td>
   <td style="text-align:center;"> 0.0701906 </td>
   <td style="text-align:center;"> 0.0395706 </td>
   <td style="text-align:center;"> 0.0895048 </td>
   <td style="text-align:center;"> 0.0499343 </td>
   <td style="text-align:center;"> 0.4835166 </td>
   <td style="text-align:center;"> 2.427618 </td>
   <td style="text-align:center;"> 0.9612345 </td>
   <td style="text-align:center;"> 0.8918360 </td>
   <td style="text-align:center;"> 0.8572635 </td>
   <td style="text-align:center;"> 0.7310556 </td>
   <td style="text-align:center;"> 6.045615 </td>
   <td style="text-align:center;"> 1.6961538 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.460250 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 1.7640 </td>
   <td style="text-align:center;"> 3.250000 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 0.000000 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> 0.1680953 </td>
   <td style="text-align:center;"> 7.508169 </td>
   <td style="text-align:center;"> 1.1319577 </td>
   <td style="text-align:center;"> 7.900655 </td>
   <td style="text-align:center;"> 6.877011 </td>
   <td style="text-align:center;"> 8.436282 </td>
   <td style="text-align:center;"> 1.5592713 </td>
   <td style="text-align:center;"> 0.0578995 </td>
   <td style="text-align:center;"> 0.0378214 </td>
   <td style="text-align:center;"> 0.0882500 </td>
   <td style="text-align:center;"> 0.0504286 </td>
   <td style="text-align:center;"> 2.6782343 </td>
   <td style="text-align:center;"> 11.774223 </td>
   <td style="text-align:center;"> 0.9311766 </td>
   <td style="text-align:center;"> 0.8861346 </td>
   <td style="text-align:center;"> 0.8251479 </td>
   <td style="text-align:center;"> 0.5943380 </td>
   <td style="text-align:center;"> 5.157648 </td>
   <td style="text-align:center;"> 0.1743083 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.776193 </td>
   <td style="text-align:center;"> 4.6305 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 3.9690 </td>
   <td style="text-align:center;"> 7.111111 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 2.623512 </td>
   <td style="text-align:center;"> 8.48925 </td>
   <td style="text-align:center;"> 4.52025 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 0.1204762 </td>
   <td style="text-align:center;"> 7.775408 </td>
   <td style="text-align:center;"> 0.3414647 </td>
   <td style="text-align:center;"> 7.752863 </td>
   <td style="text-align:center;"> 7.503241 </td>
   <td style="text-align:center;"> 8.035769 </td>
   <td style="text-align:center;"> 0.5325283 </td>
   <td style="text-align:center;"> 0.0585845 </td>
   <td style="text-align:center;"> 0.0373240 </td>
   <td style="text-align:center;"> 0.0831522 </td>
   <td style="text-align:center;"> 0.0458282 </td>
   <td style="text-align:center;"> 0.4209429 </td>
   <td style="text-align:center;"> 1.985766 </td>
   <td style="text-align:center;"> 0.9214282 </td>
   <td style="text-align:center;"> 0.8943691 </td>
   <td style="text-align:center;"> 0.8240969 </td>
   <td style="text-align:center;"> 0.4235481 </td>
   <td style="text-align:center;"> 5.129286 </td>
   <td style="text-align:center;"> 0.2505682 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.849388 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 1.3230 </td>
   <td style="text-align:center;"> 5.166667 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 9.151184 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> 0.1618594 </td>
   <td style="text-align:center;"> 7.566993 </td>
   <td style="text-align:center;"> 1.3964559 </td>
   <td style="text-align:center;"> 7.923101 </td>
   <td style="text-align:center;"> 6.742687 </td>
   <td style="text-align:center;"> 8.627642 </td>
   <td style="text-align:center;"> 1.8849550 </td>
   <td style="text-align:center;"> 0.0561362 </td>
   <td style="text-align:center;"> 0.0355529 </td>
   <td style="text-align:center;"> 0.0916891 </td>
   <td style="text-align:center;"> 0.0561362 </td>
   <td style="text-align:center;"> 1.5298547 </td>
   <td style="text-align:center;"> 5.331965 </td>
   <td style="text-align:center;"> 0.9437879 </td>
   <td style="text-align:center;"> 0.8868838 </td>
   <td style="text-align:center;"> 0.8370302 </td>
   <td style="text-align:center;"> 0.6037433 </td>
   <td style="text-align:center;"> 5.602845 </td>
   <td style="text-align:center;"> 0.2383784 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.896937 </td>
   <td style="text-align:center;"> 3.5280 </td>
   <td style="text-align:center;"> 9.2610 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> 4.500000 </td>
   <td style="text-align:center;"> 4.1895 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 17.709811 </td>
   <td style="text-align:center;"> 8.48925 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:center;"> 0.1228345 </td>
   <td style="text-align:center;"> 7.444825 </td>
   <td style="text-align:center;"> 0.4232132 </td>
   <td style="text-align:center;"> 7.492917 </td>
   <td style="text-align:center;"> 7.133583 </td>
   <td style="text-align:center;"> 7.819583 </td>
   <td style="text-align:center;"> 0.6860000 </td>
   <td style="text-align:center;"> 0.0477165 </td>
   <td style="text-align:center;"> 0.0321259 </td>
   <td style="text-align:center;"> 0.0680314 </td>
   <td style="text-align:center;"> 0.0359055 </td>
   <td style="text-align:center;"> 0.3452488 </td>
   <td style="text-align:center;"> 2.400311 </td>
   <td style="text-align:center;"> 0.9426623 </td>
   <td style="text-align:center;"> 0.8926454 </td>
   <td style="text-align:center;"> 0.8414632 </td>
   <td style="text-align:center;"> 0.5437088 </td>
   <td style="text-align:center;"> 5.971276 </td>
   <td style="text-align:center;"> 2.3210526 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.360500 </td>
   <td style="text-align:center;"> 6.3945 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 1.5435 </td>
   <td style="text-align:center;"> 3.571429 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> -5.385296 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 6.28425 </td>
   <td style="text-align:center;"> 8.26875 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> 0.1623356 </td>
   <td style="text-align:center;"> 7.494048 </td>
   <td style="text-align:center;"> 1.1762380 </td>
   <td style="text-align:center;"> 7.943397 </td>
   <td style="text-align:center;"> 6.820851 </td>
   <td style="text-align:center;"> 8.467663 </td>
   <td style="text-align:center;"> 1.6468112 </td>
   <td style="text-align:center;"> 0.0552035 </td>
   <td style="text-align:center;"> 0.0374261 </td>
   <td style="text-align:center;"> 0.0837408 </td>
   <td style="text-align:center;"> 0.0463148 </td>
   <td style="text-align:center;"> 3.2779647 </td>
   <td style="text-align:center;"> 15.376351 </td>
   <td style="text-align:center;"> 0.9269290 </td>
   <td style="text-align:center;"> 0.8866527 </td>
   <td style="text-align:center;"> 0.8218641 </td>
   <td style="text-align:center;"> 0.6108722 </td>
   <td style="text-align:center;"> 5.852994 </td>
   <td style="text-align:center;"> 0.2090047 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.901476 </td>
   <td style="text-align:center;"> 4.6305 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 3.9690 </td>
   <td style="text-align:center;"> 3.166667 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> -1.358297 </td>
   <td style="text-align:center;"> 8.48925 </td>
   <td style="text-align:center;"> 4.52025 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:center;"> 0.1218821 </td>
   <td style="text-align:center;"> 7.812830 </td>
   <td style="text-align:center;"> 0.3321780 </td>
   <td style="text-align:center;"> 7.737077 </td>
   <td style="text-align:center;"> 7.539245 </td>
   <td style="text-align:center;"> 8.083283 </td>
   <td style="text-align:center;"> 0.5440374 </td>
   <td style="text-align:center;"> 0.0557445 </td>
   <td style="text-align:center;"> 0.0359033 </td>
   <td style="text-align:center;"> 0.0784203 </td>
   <td style="text-align:center;"> 0.0425170 </td>
   <td style="text-align:center;"> 0.8583218 </td>
   <td style="text-align:center;"> 2.881642 </td>
   <td style="text-align:center;"> 0.9110010 </td>
   <td style="text-align:center;"> 0.8936527 </td>
   <td style="text-align:center;"> 0.8141185 </td>
   <td style="text-align:center;"> 0.4017141 </td>
   <td style="text-align:center;"> 6.299054 </td>
   <td style="text-align:center;"> 2.3210526 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.874087 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 1.3230 </td>
   <td style="text-align:center;"> 5.166667 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 1.809125 </td>
   <td style="text-align:center;"> 7.60725 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:center;"> 0.1195012 </td>
   <td style="text-align:center;"> 7.216396 </td>
   <td style="text-align:center;"> 0.4136238 </td>
   <td style="text-align:center;"> 7.367212 </td>
   <td style="text-align:center;"> 7.074142 </td>
   <td style="text-align:center;"> 7.484440 </td>
   <td style="text-align:center;"> 0.4102975 </td>
   <td style="text-align:center;"> 0.0585697 </td>
   <td style="text-align:center;"> 0.0401486 </td>
   <td style="text-align:center;"> 0.0736845 </td>
   <td style="text-align:center;"> 0.0335359 </td>
   <td style="text-align:center;"> 1.9959573 </td>
   <td style="text-align:center;"> 6.841179 </td>
   <td style="text-align:center;"> 0.8995461 </td>
   <td style="text-align:center;"> 0.8938433 </td>
   <td style="text-align:center;"> 0.8040533 </td>
   <td style="text-align:center;"> 0.5380238 </td>
   <td style="text-align:center;"> 5.642966 </td>
   <td style="text-align:center;"> 0.1968750 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.028437 </td>
   <td style="text-align:center;"> 5.9535 </td>
   <td style="text-align:center;"> 7.7175 </td>
   <td style="text-align:center;"> 1.7640 </td>
   <td style="text-align:center;"> 7.625000 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 7.7175 </td>
   <td style="text-align:center;"> 9.225853 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 5.84325 </td>
   <td style="text-align:center;"> 7.82775 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 16 </td>
   <td style="text-align:center;"> 0.1227438 </td>
   <td style="text-align:center;"> 7.257579 </td>
   <td style="text-align:center;"> 0.8433624 </td>
   <td style="text-align:center;"> 7.380634 </td>
   <td style="text-align:center;"> 6.956622 </td>
   <td style="text-align:center;"> 7.845417 </td>
   <td style="text-align:center;"> 0.8887951 </td>
   <td style="text-align:center;"> 0.0552347 </td>
   <td style="text-align:center;"> 0.0354069 </td>
   <td style="text-align:center;"> 0.0788393 </td>
   <td style="text-align:center;"> 0.0434324 </td>
   <td style="text-align:center;"> 1.5948595 </td>
   <td style="text-align:center;"> 4.893569 </td>
   <td style="text-align:center;"> 0.8877460 </td>
   <td style="text-align:center;"> 0.8943907 </td>
   <td style="text-align:center;"> 0.7939918 </td>
   <td style="text-align:center;"> 0.3489413 </td>
   <td style="text-align:center;"> 5.833513 </td>
   <td style="text-align:center;"> 1.1307692 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.150500 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 2.8665 </td>
   <td style="text-align:center;"> 1.846154 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 6.1740 </td>
   <td style="text-align:center;"> -7.185700 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:center;"> 0.2240136 </td>
   <td style="text-align:center;"> 7.108398 </td>
   <td style="text-align:center;"> 0.8781753 </td>
   <td style="text-align:center;"> 7.295868 </td>
   <td style="text-align:center;"> 6.406419 </td>
   <td style="text-align:center;"> 7.854568 </td>
   <td style="text-align:center;"> 1.4481486 </td>
   <td style="text-align:center;"> 0.0992524 </td>
   <td style="text-align:center;"> 0.0695694 </td>
   <td style="text-align:center;"> 0.1614011 </td>
   <td style="text-align:center;"> 0.0918317 </td>
   <td style="text-align:center;"> 1.2984662 </td>
   <td style="text-align:center;"> 4.511395 </td>
   <td style="text-align:center;"> 0.9691188 </td>
   <td style="text-align:center;"> 0.8842695 </td>
   <td style="text-align:center;"> 0.8569622 </td>
   <td style="text-align:center;"> 0.7977846 </td>
   <td style="text-align:center;"> 5.871156 </td>
   <td style="text-align:center;"> 0.2238579 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.791400 </td>
   <td style="text-align:center;"> 5.2920 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 2.8665 </td>
   <td style="text-align:center;"> 7.384615 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> 0.000000 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 5.18175 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 18 </td>
   <td style="text-align:center;"> 0.1987302 </td>
   <td style="text-align:center;"> 7.827960 </td>
   <td style="text-align:center;"> 0.3525358 </td>
   <td style="text-align:center;"> 7.919265 </td>
   <td style="text-align:center;"> 7.626706 </td>
   <td style="text-align:center;"> 8.110941 </td>
   <td style="text-align:center;"> 0.4842353 </td>
   <td style="text-align:center;"> 0.0719700 </td>
   <td style="text-align:center;"> 0.0390031 </td>
   <td style="text-align:center;"> 0.1002937 </td>
   <td style="text-align:center;"> 0.0612906 </td>
   <td style="text-align:center;"> 1.1679792 </td>
   <td style="text-align:center;"> 3.866666 </td>
   <td style="text-align:center;"> 0.9496155 </td>
   <td style="text-align:center;"> 0.8843358 </td>
   <td style="text-align:center;"> 0.8397789 </td>
   <td style="text-align:center;"> 0.6853308 </td>
   <td style="text-align:center;"> 4.488501 </td>
   <td style="text-align:center;"> 0.1837500 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.849941 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 1.1025 </td>
   <td style="text-align:center;"> 11.400000 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> -1.109545 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 19 </td>
   <td style="text-align:center;"> 0.1354422 </td>
   <td style="text-align:center;"> 7.710930 </td>
   <td style="text-align:center;"> 0.5897865 </td>
   <td style="text-align:center;"> 7.821830 </td>
   <td style="text-align:center;"> 7.200287 </td>
   <td style="text-align:center;"> 8.250992 </td>
   <td style="text-align:center;"> 1.0507047 </td>
   <td style="text-align:center;"> 0.0710131 </td>
   <td style="text-align:center;"> 0.0413851 </td>
   <td style="text-align:center;"> 0.0912354 </td>
   <td style="text-align:center;"> 0.0498502 </td>
   <td style="text-align:center;"> 0.8279834 </td>
   <td style="text-align:center;"> 3.538390 </td>
   <td style="text-align:center;"> 0.9597460 </td>
   <td style="text-align:center;"> 0.8905087 </td>
   <td style="text-align:center;"> 0.8546622 </td>
   <td style="text-align:center;"> 0.7176440 </td>
   <td style="text-align:center;"> 5.994420 </td>
   <td style="text-align:center;"> 0.5582278 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.512542 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 1.7640 </td>
   <td style="text-align:center;"> 5.000000 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 3.256002 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> 0.1699547 </td>
   <td style="text-align:center;"> 7.516221 </td>
   <td style="text-align:center;"> 1.4896162 </td>
   <td style="text-align:center;"> 7.849722 </td>
   <td style="text-align:center;"> 6.643249 </td>
   <td style="text-align:center;"> 8.779588 </td>
   <td style="text-align:center;"> 2.1363390 </td>
   <td style="text-align:center;"> 0.0658341 </td>
   <td style="text-align:center;"> 0.0424887 </td>
   <td style="text-align:center;"> 0.1064551 </td>
   <td style="text-align:center;"> 0.0639664 </td>
   <td style="text-align:center;"> 1.9586169 </td>
   <td style="text-align:center;"> 7.203510 </td>
   <td style="text-align:center;"> 0.9333614 </td>
   <td style="text-align:center;"> 0.8863482 </td>
   <td style="text-align:center;"> 0.8272832 </td>
   <td style="text-align:center;"> 0.5531507 </td>
   <td style="text-align:center;"> 4.964476 </td>
   <td style="text-align:center;"> 0.2358289 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.622022 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 9.4815 </td>
   <td style="text-align:center;"> 6.3945 </td>
   <td style="text-align:center;"> 7.551724 </td>
   <td style="text-align:center;"> 4.8510 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 14.271452 </td>
   <td style="text-align:center;"> 9.15075 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 21 </td>
   <td style="text-align:center;"> 0.1675737 </td>
   <td style="text-align:center;"> 6.766446 </td>
   <td style="text-align:center;"> 0.8353039 </td>
   <td style="text-align:center;"> 7.093569 </td>
   <td style="text-align:center;"> 6.448923 </td>
   <td style="text-align:center;"> 7.368141 </td>
   <td style="text-align:center;"> 0.9192182 </td>
   <td style="text-align:center;"> 0.0658159 </td>
   <td style="text-align:center;"> 0.0457444 </td>
   <td style="text-align:center;"> 0.0840202 </td>
   <td style="text-align:center;"> 0.0382759 </td>
   <td style="text-align:center;"> 2.8274179 </td>
   <td style="text-align:center;"> 11.427846 </td>
   <td style="text-align:center;"> 0.8989784 </td>
   <td style="text-align:center;"> 0.8859372 </td>
   <td style="text-align:center;"> 0.7964384 </td>
   <td style="text-align:center;"> 0.5357117 </td>
   <td style="text-align:center;"> 5.360415 </td>
   <td style="text-align:center;"> 0.2773585 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.481514 </td>
   <td style="text-align:center;"> 4.1895 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> 5.866667 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 4.1895 </td>
   <td style="text-align:center;"> -7.895033 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 4.07925 </td>
   <td style="text-align:center;"> 7.82775 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:center;"> 0.1228345 </td>
   <td style="text-align:center;"> 7.471732 </td>
   <td style="text-align:center;"> 0.6665490 </td>
   <td style="text-align:center;"> 7.455776 </td>
   <td style="text-align:center;"> 7.072777 </td>
   <td style="text-align:center;"> 7.846924 </td>
   <td style="text-align:center;"> 0.7741467 </td>
   <td style="text-align:center;"> 0.0496062 </td>
   <td style="text-align:center;"> 0.0330708 </td>
   <td style="text-align:center;"> 0.0732282 </td>
   <td style="text-align:center;"> 0.0401574 </td>
   <td style="text-align:center;"> 1.0881315 </td>
   <td style="text-align:center;"> 3.069921 </td>
   <td style="text-align:center;"> 0.9350795 </td>
   <td style="text-align:center;"> 0.8934965 </td>
   <td style="text-align:center;"> 0.8354902 </td>
   <td style="text-align:center;"> 0.5993202 </td>
   <td style="text-align:center;"> 6.576213 </td>
   <td style="text-align:center;"> 2.3210526 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 7.104109 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 8.8200 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> 1.800000 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> -8.975493 </td>
   <td style="text-align:center;"> 7.82775 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 9.15075 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 23 </td>
   <td style="text-align:center;"> 0.1567120 </td>
   <td style="text-align:center;"> 7.691524 </td>
   <td style="text-align:center;"> 1.4693448 </td>
   <td style="text-align:center;"> 8.025191 </td>
   <td style="text-align:center;"> 6.914662 </td>
   <td style="text-align:center;"> 8.925103 </td>
   <td style="text-align:center;"> 2.0104412 </td>
   <td style="text-align:center;"> 0.0533289 </td>
   <td style="text-align:center;"> 0.0322780 </td>
   <td style="text-align:center;"> 0.0870103 </td>
   <td style="text-align:center;"> 0.0547323 </td>
   <td style="text-align:center;"> 1.6620349 </td>
   <td style="text-align:center;"> 5.941476 </td>
   <td style="text-align:center;"> 0.9332716 </td>
   <td style="text-align:center;"> 0.8876544 </td>
   <td style="text-align:center;"> 0.8284226 </td>
   <td style="text-align:center;"> 0.5326246 </td>
   <td style="text-align:center;"> 5.620870 </td>
   <td style="text-align:center;"> 0.1771084 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 7.002048 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 9.4815 </td>
   <td style="text-align:center;"> 6.3945 </td>
   <td style="text-align:center;"> 7.793103 </td>
   <td style="text-align:center;"> 4.6305 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 16.884472 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 9.81225 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:center;"> 0.2116327 </td>
   <td style="text-align:center;"> 7.057101 </td>
   <td style="text-align:center;"> 0.9391337 </td>
   <td style="text-align:center;"> 7.221818 </td>
   <td style="text-align:center;"> 6.285432 </td>
   <td style="text-align:center;"> 7.917014 </td>
   <td style="text-align:center;"> 1.6315818 </td>
   <td style="text-align:center;"> 0.0844674 </td>
   <td style="text-align:center;"> 0.0570851 </td>
   <td style="text-align:center;"> 0.1429449 </td>
   <td style="text-align:center;"> 0.0858597 </td>
   <td style="text-align:center;"> 1.6674539 </td>
   <td style="text-align:center;"> 7.015124 </td>
   <td style="text-align:center;"> 0.9664641 </td>
   <td style="text-align:center;"> 0.8846288 </td>
   <td style="text-align:center;"> 0.8549619 </td>
   <td style="text-align:center;"> 0.7426098 </td>
   <td style="text-align:center;"> 5.855529 </td>
   <td style="text-align:center;"> 1.4225806 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.738036 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 3.214286 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> -3.125699 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 4.96125 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 25 </td>
   <td style="text-align:center;"> 0.1559411 </td>
   <td style="text-align:center;"> 7.900825 </td>
   <td style="text-align:center;"> 0.2360337 </td>
   <td style="text-align:center;"> 7.962619 </td>
   <td style="text-align:center;"> 7.776371 </td>
   <td style="text-align:center;"> 8.084643 </td>
   <td style="text-align:center;"> 0.3082718 </td>
   <td style="text-align:center;"> 0.0627511 </td>
   <td style="text-align:center;"> 0.0351219 </td>
   <td style="text-align:center;"> 0.0875705 </td>
   <td style="text-align:center;"> 0.0524486 </td>
   <td style="text-align:center;"> 2.5004748 </td>
   <td style="text-align:center;"> 11.100437 </td>
   <td style="text-align:center;"> 0.8942239 </td>
   <td style="text-align:center;"> 0.8874681 </td>
   <td style="text-align:center;"> 0.7935952 </td>
   <td style="text-align:center;"> 0.4647881 </td>
   <td style="text-align:center;"> 5.930598 </td>
   <td style="text-align:center;"> 1.8375000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.891297 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 0.8820 </td>
   <td style="text-align:center;"> 5.750000 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 1.413996 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 26 </td>
   <td style="text-align:center;"> 0.1112699 </td>
   <td style="text-align:center;"> 7.536154 </td>
   <td style="text-align:center;"> 0.5574551 </td>
   <td style="text-align:center;"> 7.431750 </td>
   <td style="text-align:center;"> 7.035750 </td>
   <td style="text-align:center;"> 8.061750 </td>
   <td style="text-align:center;"> 1.0260000 </td>
   <td style="text-align:center;"> 0.0629740 </td>
   <td style="text-align:center;"> 0.0340912 </td>
   <td style="text-align:center;"> 0.0833340 </td>
   <td style="text-align:center;"> 0.0492428 </td>
   <td style="text-align:center;"> 0.6504043 </td>
   <td style="text-align:center;"> 2.947743 </td>
   <td style="text-align:center;"> 0.9514919 </td>
   <td style="text-align:center;"> 0.8978629 </td>
   <td style="text-align:center;"> 0.8543093 </td>
   <td style="text-align:center;"> 0.6058308 </td>
   <td style="text-align:center;"> 6.289384 </td>
   <td style="text-align:center;"> 1.7640000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.422813 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 1.7640 </td>
   <td style="text-align:center;"> 2.500000 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 3.963338 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 27 </td>
   <td style="text-align:center;"> 0.1523129 </td>
   <td style="text-align:center;"> 7.779584 </td>
   <td style="text-align:center;"> 1.2150367 </td>
   <td style="text-align:center;"> 8.054534 </td>
   <td style="text-align:center;"> 7.226802 </td>
   <td style="text-align:center;"> 8.639201 </td>
   <td style="text-align:center;"> 1.4123996 </td>
   <td style="text-align:center;"> 0.0482715 </td>
   <td style="text-align:center;"> 0.0313999 </td>
   <td style="text-align:center;"> 0.0688923 </td>
   <td style="text-align:center;"> 0.0374924 </td>
   <td style="text-align:center;"> 1.4186114 </td>
   <td style="text-align:center;"> 4.246877 </td>
   <td style="text-align:center;"> 0.9479720 </td>
   <td style="text-align:center;"> 0.8876944 </td>
   <td style="text-align:center;"> 0.8415094 </td>
   <td style="text-align:center;"> 0.6808825 </td>
   <td style="text-align:center;"> 6.205878 </td>
   <td style="text-align:center;"> 0.3445312 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.949767 </td>
   <td style="text-align:center;"> 4.6305 </td>
   <td style="text-align:center;"> 9.4815 </td>
   <td style="text-align:center;"> 4.8510 </td>
   <td style="text-align:center;"> 6.409091 </td>
   <td style="text-align:center;"> 5.2920 </td>
   <td style="text-align:center;"> 4.6305 </td>
   <td style="text-align:center;"> -4.343032 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 4.52025 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:center;"> 0.1069615 </td>
   <td style="text-align:center;"> 7.840953 </td>
   <td style="text-align:center;"> 0.3323427 </td>
   <td style="text-align:center;"> 7.818367 </td>
   <td style="text-align:center;"> 7.565027 </td>
   <td style="text-align:center;"> 8.090473 </td>
   <td style="text-align:center;"> 0.5254468 </td>
   <td style="text-align:center;"> 0.0518169 </td>
   <td style="text-align:center;"> 0.0318507 </td>
   <td style="text-align:center;"> 0.0760615 </td>
   <td style="text-align:center;"> 0.0442107 </td>
   <td style="text-align:center;"> 0.4869248 </td>
   <td style="text-align:center;"> 2.101008 </td>
   <td style="text-align:center;"> 0.9175678 </td>
   <td style="text-align:center;"> 0.8995854 </td>
   <td style="text-align:center;"> 0.8254306 </td>
   <td style="text-align:center;"> 0.4448678 </td>
   <td style="text-align:center;"> 6.733071 </td>
   <td style="text-align:center;"> 2.7562500 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.907436 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 1.5435 </td>
   <td style="text-align:center;"> 3.714286 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 0.000000 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 29 </td>
   <td style="text-align:center;"> 0.1092971 </td>
   <td style="text-align:center;"> 7.448623 </td>
   <td style="text-align:center;"> 0.5581248 </td>
   <td style="text-align:center;"> 7.454549 </td>
   <td style="text-align:center;"> 7.078905 </td>
   <td style="text-align:center;"> 7.866841 </td>
   <td style="text-align:center;"> 0.7879363 </td>
   <td style="text-align:center;"> 0.0458953 </td>
   <td style="text-align:center;"> 0.0288620 </td>
   <td style="text-align:center;"> 0.0676601 </td>
   <td style="text-align:center;"> 0.0387981 </td>
   <td style="text-align:center;"> 0.5496909 </td>
   <td style="text-align:center;"> 1.949159 </td>
   <td style="text-align:center;"> 0.9285015 </td>
   <td style="text-align:center;"> 0.8985947 </td>
   <td style="text-align:center;"> 0.8343465 </td>
   <td style="text-align:center;"> 0.5001344 </td>
   <td style="text-align:center;"> 6.383949 </td>
   <td style="text-align:center;"> 3.3923077 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.158558 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 2.8665 </td>
   <td style="text-align:center;"> 1.615385 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> -10.087187 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:center;"> 0.1061225 </td>
   <td style="text-align:center;"> 7.813291 </td>
   <td style="text-align:center;"> 0.3022992 </td>
   <td style="text-align:center;"> 7.781756 </td>
   <td style="text-align:center;"> 7.563962 </td>
   <td style="text-align:center;"> 8.018489 </td>
   <td style="text-align:center;"> 0.4545276 </td>
   <td style="text-align:center;"> 0.0521137 </td>
   <td style="text-align:center;"> 0.0326895 </td>
   <td style="text-align:center;"> 0.0772230 </td>
   <td style="text-align:center;"> 0.0445335 </td>
   <td style="text-align:center;"> 0.5239407 </td>
   <td style="text-align:center;"> 2.130740 </td>
   <td style="text-align:center;"> 0.9243037 </td>
   <td style="text-align:center;"> 0.8996835 </td>
   <td style="text-align:center;"> 0.8315808 </td>
   <td style="text-align:center;"> 0.4651990 </td>
   <td style="text-align:center;"> 6.222326 </td>
   <td style="text-align:center;"> 1.6961538 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.859015 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 1.1025 </td>
   <td style="text-align:center;"> 2.800000 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 8.311153 </td>
   <td style="text-align:center;"> 7.82775 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:center;"> 0.1044671 </td>
   <td style="text-align:center;"> 7.973733 </td>
   <td style="text-align:center;"> 0.4380074 </td>
   <td style="text-align:center;"> 7.846924 </td>
   <td style="text-align:center;"> 7.607250 </td>
   <td style="text-align:center;"> 8.345446 </td>
   <td style="text-align:center;"> 0.7381957 </td>
   <td style="text-align:center;"> 0.0498593 </td>
   <td style="text-align:center;"> 0.0308653 </td>
   <td style="text-align:center;"> 0.0745515 </td>
   <td style="text-align:center;"> 0.0436863 </td>
   <td style="text-align:center;"> 0.8227078 </td>
   <td style="text-align:center;"> 3.054491 </td>
   <td style="text-align:center;"> 0.9296066 </td>
   <td style="text-align:center;"> 0.9006579 </td>
   <td style="text-align:center;"> 0.8372575 </td>
   <td style="text-align:center;"> 0.4874988 </td>
   <td style="text-align:center;"> 7.459773 </td>
   <td style="text-align:center;"> 2.1000000 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 7.948916 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 1.5435 </td>
   <td style="text-align:center;"> 3.000000 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 14.774982 </td>
   <td style="text-align:center;"> 8.48925 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 32 </td>
   <td style="text-align:center;"> 0.1080726 </td>
   <td style="text-align:center;"> 7.418956 </td>
   <td style="text-align:center;"> 0.4860361 </td>
   <td style="text-align:center;"> 7.450260 </td>
   <td style="text-align:center;"> 7.134852 </td>
   <td style="text-align:center;"> 7.774944 </td>
   <td style="text-align:center;"> 0.6400922 </td>
   <td style="text-align:center;"> 0.0450302 </td>
   <td style="text-align:center;"> 0.0289142 </td>
   <td style="text-align:center;"> 0.0668343 </td>
   <td style="text-align:center;"> 0.0379202 </td>
   <td style="text-align:center;"> 0.5842725 </td>
   <td style="text-align:center;"> 2.103971 </td>
   <td style="text-align:center;"> 0.9252034 </td>
   <td style="text-align:center;"> 0.8989984 </td>
   <td style="text-align:center;"> 0.8317564 </td>
   <td style="text-align:center;"> 0.5181574 </td>
   <td style="text-align:center;"> 6.144466 </td>
   <td style="text-align:center;"> 2.3210526 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.173043 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 2.4255 </td>
   <td style="text-align:center;"> 2.454546 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 10.201478 </td>
   <td style="text-align:center;"> 7.82775 </td>
   <td style="text-align:center;"> 5.62275 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 33 </td>
   <td style="text-align:center;"> 0.2065533 </td>
   <td style="text-align:center;"> 6.989601 </td>
   <td style="text-align:center;"> 0.8965136 </td>
   <td style="text-align:center;"> 7.215535 </td>
   <td style="text-align:center;"> 6.290517 </td>
   <td style="text-align:center;"> 7.743424 </td>
   <td style="text-align:center;"> 1.4529070 </td>
   <td style="text-align:center;"> 0.0863346 </td>
   <td style="text-align:center;"> 0.0603414 </td>
   <td style="text-align:center;"> 0.1476044 </td>
   <td style="text-align:center;"> 0.0872630 </td>
   <td style="text-align:center;"> 1.0602537 </td>
   <td style="text-align:center;"> 3.275186 </td>
   <td style="text-align:center;"> 0.9527018 </td>
   <td style="text-align:center;"> 0.8847962 </td>
   <td style="text-align:center;"> 0.8429470 </td>
   <td style="text-align:center;"> 0.6598350 </td>
   <td style="text-align:center;"> 5.554157 </td>
   <td style="text-align:center;"> 0.3340909 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.761830 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 6.857143 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 0.000000 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 4.74075 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:center;"> 0.1544671 </td>
   <td style="text-align:center;"> 7.876533 </td>
   <td style="text-align:center;"> 0.3275844 </td>
   <td style="text-align:center;"> 7.970427 </td>
   <td style="text-align:center;"> 7.691559 </td>
   <td style="text-align:center;"> 8.132559 </td>
   <td style="text-align:center;"> 0.4410000 </td>
   <td style="text-align:center;"> 0.0636592 </td>
   <td style="text-align:center;"> 0.0360423 </td>
   <td style="text-align:center;"> 0.0908079 </td>
   <td style="text-align:center;"> 0.0547656 </td>
   <td style="text-align:center;"> 1.1869352 </td>
   <td style="text-align:center;"> 3.511807 </td>
   <td style="text-align:center;"> 0.9352351 </td>
   <td style="text-align:center;"> 0.8878864 </td>
   <td style="text-align:center;"> 0.8303825 </td>
   <td style="text-align:center;"> 0.6324812 </td>
   <td style="text-align:center;"> 5.283639 </td>
   <td style="text-align:center;"> 1.3363636 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.801898 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 1.1025 </td>
   <td style="text-align:center;"> 8.200000 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> -1.427488 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 35 </td>
   <td style="text-align:center;"> 0.1092517 </td>
   <td style="text-align:center;"> 7.618119 </td>
   <td style="text-align:center;"> 0.6160403 </td>
   <td style="text-align:center;"> 7.570500 </td>
   <td style="text-align:center;"> 7.046812 </td>
   <td style="text-align:center;"> 8.213625 </td>
   <td style="text-align:center;"> 1.1668125 </td>
   <td style="text-align:center;"> 0.0612760 </td>
   <td style="text-align:center;"> 0.0327755 </td>
   <td style="text-align:center;"> 0.0807513 </td>
   <td style="text-align:center;"> 0.0479757 </td>
   <td style="text-align:center;"> 0.5732209 </td>
   <td style="text-align:center;"> 2.656538 </td>
   <td style="text-align:center;"> 0.9619220 </td>
   <td style="text-align:center;"> 0.8988786 </td>
   <td style="text-align:center;"> 0.8646512 </td>
   <td style="text-align:center;"> 0.7392058 </td>
   <td style="text-align:center;"> 6.507000 </td>
   <td style="text-align:center;"> 2.3210526 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.503921 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 1.9845 </td>
   <td style="text-align:center;"> 3.111111 </td>
   <td style="text-align:center;"> 6.8355 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 16.146200 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 6.50475 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 36 </td>
   <td style="text-align:center;"> 0.1072563 </td>
   <td style="text-align:center;"> 7.040539 </td>
   <td style="text-align:center;"> 0.5812961 </td>
   <td style="text-align:center;"> 7.209229 </td>
   <td style="text-align:center;"> 6.835500 </td>
   <td style="text-align:center;"> 7.405436 </td>
   <td style="text-align:center;"> 0.5699364 </td>
   <td style="text-align:center;"> 0.0526789 </td>
   <td style="text-align:center;"> 0.0336955 </td>
   <td style="text-align:center;"> 0.0707132 </td>
   <td style="text-align:center;"> 0.0370176 </td>
   <td style="text-align:center;"> 2.4917466 </td>
   <td style="text-align:center;"> 9.174941 </td>
   <td style="text-align:center;"> 0.8797049 </td>
   <td style="text-align:center;"> 0.8997678 </td>
   <td style="text-align:center;"> 0.7915301 </td>
   <td style="text-align:center;"> 0.4779642 </td>
   <td style="text-align:center;"> 5.305866 </td>
   <td style="text-align:center;"> 0.2594118 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.643170 </td>
   <td style="text-align:center;"> 5.2920 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 2.2050 </td>
   <td style="text-align:center;"> 5.800000 </td>
   <td style="text-align:center;"> 6.1740 </td>
   <td style="text-align:center;"> 5.2920 </td>
   <td style="text-align:center;"> -8.223297 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 5.18175 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 37 </td>
   <td style="text-align:center;"> 0.1136962 </td>
   <td style="text-align:center;"> 7.347424 </td>
   <td style="text-align:center;"> 0.5425752 </td>
   <td style="text-align:center;"> 7.404390 </td>
   <td style="text-align:center;"> 6.998670 </td>
   <td style="text-align:center;"> 7.774830 </td>
   <td style="text-align:center;"> 0.7761600 </td>
   <td style="text-align:center;"> 0.0459522 </td>
   <td style="text-align:center;"> 0.0288978 </td>
   <td style="text-align:center;"> 0.0696389 </td>
   <td style="text-align:center;"> 0.0407411 </td>
   <td style="text-align:center;"> 0.4859870 </td>
   <td style="text-align:center;"> 1.813369 </td>
   <td style="text-align:center;"> 0.9317571 </td>
   <td style="text-align:center;"> 0.8969820 </td>
   <td style="text-align:center;"> 0.8357693 </td>
   <td style="text-align:center;"> 0.5411775 </td>
   <td style="text-align:center;"> 6.099127 </td>
   <td style="text-align:center;"> 2.2050000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.086652 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 2.6460 </td>
   <td style="text-align:center;"> 2.416667 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> -5.818138 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 38 </td>
   <td style="text-align:center;"> 0.1197279 </td>
   <td style="text-align:center;"> 8.049722 </td>
   <td style="text-align:center;"> 0.1868510 </td>
   <td style="text-align:center;"> 8.088341 </td>
   <td style="text-align:center;"> 7.938000 </td>
   <td style="text-align:center;"> 8.188568 </td>
   <td style="text-align:center;"> 0.2505682 </td>
   <td style="text-align:center;"> 0.0551502 </td>
   <td style="text-align:center;"> 0.0301677 </td>
   <td style="text-align:center;"> 0.0810756 </td>
   <td style="text-align:center;"> 0.0509079 </td>
   <td style="text-align:center;"> 2.0721461 </td>
   <td style="text-align:center;"> 7.254991 </td>
   <td style="text-align:center;"> 0.8867147 </td>
   <td style="text-align:center;"> 0.8954805 </td>
   <td style="text-align:center;"> 0.7940357 </td>
   <td style="text-align:center;"> 0.4899042 </td>
   <td style="text-align:center;"> 4.751029 </td>
   <td style="text-align:center;"> 1.6333333 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.946234 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 0.6615 </td>
   <td style="text-align:center;"> 4.000000 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> -3.683352 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 39 </td>
   <td style="text-align:center;"> 0.1118141 </td>
   <td style="text-align:center;"> 7.466535 </td>
   <td style="text-align:center;"> 0.6144868 </td>
   <td style="text-align:center;"> 7.508652 </td>
   <td style="text-align:center;"> 7.105299 </td>
   <td style="text-align:center;"> 7.894079 </td>
   <td style="text-align:center;"> 0.7887805 </td>
   <td style="text-align:center;"> 0.0435885 </td>
   <td style="text-align:center;"> 0.0260584 </td>
   <td style="text-align:center;"> 0.0696469 </td>
   <td style="text-align:center;"> 0.0435885 </td>
   <td style="text-align:center;"> 0.9074793 </td>
   <td style="text-align:center;"> 2.974528 </td>
   <td style="text-align:center;"> 0.9375210 </td>
   <td style="text-align:center;"> 0.8979364 </td>
   <td style="text-align:center;"> 0.8418342 </td>
   <td style="text-align:center;"> 0.6002134 </td>
   <td style="text-align:center;"> 5.982616 </td>
   <td style="text-align:center;"> 1.8375000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.105540 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 1.714286 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> -15.776189 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 40 </td>
   <td style="text-align:center;"> 0.1489343 </td>
   <td style="text-align:center;"> 7.724909 </td>
   <td style="text-align:center;"> 0.5600309 </td>
   <td style="text-align:center;"> 7.924309 </td>
   <td style="text-align:center;"> 7.614936 </td>
   <td style="text-align:center;"> 8.099172 </td>
   <td style="text-align:center;"> 0.4842353 </td>
   <td style="text-align:center;"> 0.0646318 </td>
   <td style="text-align:center;"> 0.0407462 </td>
   <td style="text-align:center;"> 0.1002262 </td>
   <td style="text-align:center;"> 0.0594800 </td>
   <td style="text-align:center;"> 4.2522815 </td>
   <td style="text-align:center;"> 26.206933 </td>
   <td style="text-align:center;"> 0.8395776 </td>
   <td style="text-align:center;"> 0.8895270 </td>
   <td style="text-align:center;"> 0.7468270 </td>
   <td style="text-align:center;"> 0.3677393 </td>
   <td style="text-align:center;"> 4.368324 </td>
   <td style="text-align:center;"> 2.7562500 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.535164 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 2.6460 </td>
   <td style="text-align:center;"> 2.166667 </td>
   <td style="text-align:center;"> 7.7175 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> -14.805190 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 5.40225 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 41 </td>
   <td style="text-align:center;"> 0.1031519 </td>
   <td style="text-align:center;"> 6.826143 </td>
   <td style="text-align:center;"> 1.2312714 </td>
   <td style="text-align:center;"> 7.078122 </td>
   <td style="text-align:center;"> 6.592518 </td>
   <td style="text-align:center;"> 7.621998 </td>
   <td style="text-align:center;"> 1.0294796 </td>
   <td style="text-align:center;"> 0.0546658 </td>
   <td style="text-align:center;"> 0.0251938 </td>
   <td style="text-align:center;"> 0.0770074 </td>
   <td style="text-align:center;"> 0.0518136 </td>
   <td style="text-align:center;"> 1.6087499 </td>
   <td style="text-align:center;"> 4.929829 </td>
   <td style="text-align:center;"> 0.9082611 </td>
   <td style="text-align:center;"> 0.9025621 </td>
   <td style="text-align:center;"> 0.8197620 </td>
   <td style="text-align:center;"> 0.4770687 </td>
   <td style="text-align:center;"> 4.493279 </td>
   <td style="text-align:center;"> 2.9400000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.123768 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 2.8665 </td>
   <td style="text-align:center;"> 1.692308 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> -12.825740 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:center;"> 0.1012699 </td>
   <td style="text-align:center;"> 7.785658 </td>
   <td style="text-align:center;"> 0.2957464 </td>
   <td style="text-align:center;"> 7.758379 </td>
   <td style="text-align:center;"> 7.530447 </td>
   <td style="text-align:center;"> 7.976402 </td>
   <td style="text-align:center;"> 0.4459551 </td>
   <td style="text-align:center;"> 0.0494463 </td>
   <td style="text-align:center;"> 0.0304285 </td>
   <td style="text-align:center;"> 0.0717922 </td>
   <td style="text-align:center;"> 0.0413637 </td>
   <td style="text-align:center;"> 0.8258022 </td>
   <td style="text-align:center;"> 2.616164 </td>
   <td style="text-align:center;"> 0.8990315 </td>
   <td style="text-align:center;"> 0.9022495 </td>
   <td style="text-align:center;"> 0.8111507 </td>
   <td style="text-align:center;"> 0.3666234 </td>
   <td style="text-align:center;"> 6.137258 </td>
   <td style="text-align:center;"> 2.1000000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.835978 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 1.3230 </td>
   <td style="text-align:center;"> 3.000000 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 13.064105 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:center;"> 0.1073696 </td>
   <td style="text-align:center;"> 8.066479 </td>
   <td style="text-align:center;"> 0.1375977 </td>
   <td style="text-align:center;"> 8.115521 </td>
   <td style="text-align:center;"> 8.040775 </td>
   <td style="text-align:center;"> 8.134208 </td>
   <td style="text-align:center;"> 0.0934322 </td>
   <td style="text-align:center;"> 0.0532097 </td>
   <td style="text-align:center;"> 0.0342062 </td>
   <td style="text-align:center;"> 0.0717381 </td>
   <td style="text-align:center;"> 0.0375319 </td>
   <td style="text-align:center;"> 3.5800485 </td>
   <td style="text-align:center;"> 17.002291 </td>
   <td style="text-align:center;"> 0.7574503 </td>
   <td style="text-align:center;"> 0.8999124 </td>
   <td style="text-align:center;"> 0.6816389 </td>
   <td style="text-align:center;"> 0.2219228 </td>
   <td style="text-align:center;"> 4.155321 </td>
   <td style="text-align:center;"> 0.4500000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.978797 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 0.6615 </td>
   <td style="text-align:center;"> 3.000000 </td>
   <td style="text-align:center;"> 7.7175 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 2.053653 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 47 </td>
   <td style="text-align:center;"> 0.1177324 </td>
   <td style="text-align:center;"> 8.043234 </td>
   <td style="text-align:center;"> 0.1564398 </td>
   <td style="text-align:center;"> 8.070471 </td>
   <td style="text-align:center;"> 7.967913 </td>
   <td style="text-align:center;"> 8.155936 </td>
   <td style="text-align:center;"> 0.1880233 </td>
   <td style="text-align:center;"> 0.0553201 </td>
   <td style="text-align:center;"> 0.0321518 </td>
   <td style="text-align:center;"> 0.0817980 </td>
   <td style="text-align:center;"> 0.0496462 </td>
   <td style="text-align:center;"> 1.9455786 </td>
   <td style="text-align:center;"> 6.004741 </td>
   <td style="text-align:center;"> 0.8388406 </td>
   <td style="text-align:center;"> 0.8961669 </td>
   <td style="text-align:center;"> 0.7517412 </td>
   <td style="text-align:center;"> 0.3233027 </td>
   <td style="text-align:center;"> 3.922482 </td>
   <td style="text-align:center;"> 2.5941176 </td>
   <td style="text-align:center;"> 4.41 </td>
   <td style="text-align:center;"> 7.927373 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 0.6615 </td>
   <td style="text-align:center;"> 5.666667 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> -5.618672 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 48 </td>
   <td style="text-align:center;"> 0.1037642 </td>
   <td style="text-align:center;"> 7.184132 </td>
   <td style="text-align:center;"> 0.8172140 </td>
   <td style="text-align:center;"> 7.331625 </td>
   <td style="text-align:center;"> 6.945750 </td>
   <td style="text-align:center;"> 7.746441 </td>
   <td style="text-align:center;"> 0.8006906 </td>
   <td style="text-align:center;"> 0.0447423 </td>
   <td style="text-align:center;"> 0.0233231 </td>
   <td style="text-align:center;"> 0.0723493 </td>
   <td style="text-align:center;"> 0.0490262 </td>
   <td style="text-align:center;"> 1.5548883 </td>
   <td style="text-align:center;"> 4.664722 </td>
   <td style="text-align:center;"> 0.8897997 </td>
   <td style="text-align:center;"> 0.9019613 </td>
   <td style="text-align:center;"> 0.8025649 </td>
   <td style="text-align:center;"> 0.3876180 </td>
   <td style="text-align:center;"> 6.169937 </td>
   <td style="text-align:center;"> 3.3923077 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.073116 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 2.571429 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 4.250021 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 3.85875 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 50 </td>
   <td style="text-align:center;"> 0.1145578 </td>
   <td style="text-align:center;"> 8.051210 </td>
   <td style="text-align:center;"> 0.1495574 </td>
   <td style="text-align:center;"> 8.095500 </td>
   <td style="text-align:center;"> 7.990500 </td>
   <td style="text-align:center;"> 8.148000 </td>
   <td style="text-align:center;"> 0.1575000 </td>
   <td style="text-align:center;"> 0.0553854 </td>
   <td style="text-align:center;"> 0.0317164 </td>
   <td style="text-align:center;"> 0.0790544 </td>
   <td style="text-align:center;"> 0.0473379 </td>
   <td style="text-align:center;"> 2.8202832 </td>
   <td style="text-align:center;"> 11.269627 </td>
   <td style="text-align:center;"> 0.7987632 </td>
   <td style="text-align:center;"> 0.8974231 </td>
   <td style="text-align:center;"> 0.7168285 </td>
   <td style="text-align:center;"> 0.2970491 </td>
   <td style="text-align:center;"> 4.619671 </td>
   <td style="text-align:center;"> 3.6750000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.965222 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 0.6615 </td>
   <td style="text-align:center;"> 4.000000 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 0.000000 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 51 </td>
   <td style="text-align:center;"> 0.1109977 </td>
   <td style="text-align:center;"> 8.020465 </td>
   <td style="text-align:center;"> 0.1407433 </td>
   <td style="text-align:center;"> 8.073553 </td>
   <td style="text-align:center;"> 7.956074 </td>
   <td style="text-align:center;"> 8.118738 </td>
   <td style="text-align:center;"> 0.1626639 </td>
   <td style="text-align:center;"> 0.0564476 </td>
   <td style="text-align:center;"> 0.0322558 </td>
   <td style="text-align:center;"> 0.0782676 </td>
   <td style="text-align:center;"> 0.0460119 </td>
   <td style="text-align:center;"> 3.6521383 </td>
   <td style="text-align:center;"> 18.156197 </td>
   <td style="text-align:center;"> 0.7751034 </td>
   <td style="text-align:center;"> 0.8984754 </td>
   <td style="text-align:center;"> 0.6964114 </td>
   <td style="text-align:center;"> 0.2422633 </td>
   <td style="text-align:center;"> 4.621712 </td>
   <td style="text-align:center;"> 2.5941176 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.943752 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 0.6615 </td>
   <td style="text-align:center;"> 3.333333 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 3.973054 </td>
   <td style="text-align:center;"> 8.04825 </td>
   <td style="text-align:center;"> 7.38675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 54 </td>
   <td style="text-align:center;"> 0.1029705 </td>
   <td style="text-align:center;"> 8.020916 </td>
   <td style="text-align:center;"> 0.3973644 </td>
   <td style="text-align:center;"> 7.945919 </td>
   <td style="text-align:center;"> 7.653543 </td>
   <td style="text-align:center;"> 8.403974 </td>
   <td style="text-align:center;"> 0.7504309 </td>
   <td style="text-align:center;"> 0.0521970 </td>
   <td style="text-align:center;"> 0.0303692 </td>
   <td style="text-align:center;"> 0.0787701 </td>
   <td style="text-align:center;"> 0.0484009 </td>
   <td style="text-align:center;"> 0.9540461 </td>
   <td style="text-align:center;"> 3.135347 </td>
   <td style="text-align:center;"> 0.9178458 </td>
   <td style="text-align:center;"> 0.9019789 </td>
   <td style="text-align:center;"> 0.8278776 </td>
   <td style="text-align:center;"> 0.4910032 </td>
   <td style="text-align:center;"> 7.427330 </td>
   <td style="text-align:center;"> 2.1000000 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 8.079896 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 1.3230 </td>
   <td style="text-align:center;"> 5.500000 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 10.706946 </td>
   <td style="text-align:center;"> 8.48925 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 75 </td>
   <td style="text-align:center;"> 0.1595012 </td>
   <td style="text-align:center;"> 7.065751 </td>
   <td style="text-align:center;"> 1.6436715 </td>
   <td style="text-align:center;"> 7.440762 </td>
   <td style="text-align:center;"> 5.597059 </td>
   <td style="text-align:center;"> 8.412783 </td>
   <td style="text-align:center;"> 2.8157243 </td>
   <td style="text-align:center;"> 0.0636134 </td>
   <td style="text-align:center;"> 0.0388229 </td>
   <td style="text-align:center;"> 0.1108556 </td>
   <td style="text-align:center;"> 0.0720328 </td>
   <td style="text-align:center;"> 1.1670412 </td>
   <td style="text-align:center;"> 4.150994 </td>
   <td style="text-align:center;"> 0.9538373 </td>
   <td style="text-align:center;"> 0.8878723 </td>
   <td style="text-align:center;"> 0.8468858 </td>
   <td style="text-align:center;"> 0.6595506 </td>
   <td style="text-align:center;"> 5.574022 </td>
   <td style="text-align:center;"> 0.2345745 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.493725 </td>
   <td style="text-align:center;"> 2.8665 </td>
   <td style="text-align:center;"> 9.4815 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 9.866667 </td>
   <td style="text-align:center;"> 4.4100 </td>
   <td style="text-align:center;"> 9.2610 </td>
   <td style="text-align:center;"> 30.413573 </td>
   <td style="text-align:center;"> 7.60725 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 9.59175 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 77 </td>
   <td style="text-align:center;"> 0.1128572 </td>
   <td style="text-align:center;"> 8.092408 </td>
   <td style="text-align:center;"> 0.3911275 </td>
   <td style="text-align:center;"> 8.194511 </td>
   <td style="text-align:center;"> 7.742431 </td>
   <td style="text-align:center;"> 8.407255 </td>
   <td style="text-align:center;"> 0.6648241 </td>
   <td style="text-align:center;"> 0.0507383 </td>
   <td style="text-align:center;"> 0.0289256 </td>
   <td style="text-align:center;"> 0.0825090 </td>
   <td style="text-align:center;"> 0.0535834 </td>
   <td style="text-align:center;"> 0.9848136 </td>
   <td style="text-align:center;"> 3.617225 </td>
   <td style="text-align:center;"> 0.9232390 </td>
   <td style="text-align:center;"> 0.8969041 </td>
   <td style="text-align:center;"> 0.8280568 </td>
   <td style="text-align:center;"> 0.5160761 </td>
   <td style="text-align:center;"> 5.482887 </td>
   <td style="text-align:center;"> 3.6750000 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 8.054564 </td>
   <td style="text-align:center;"> 7.2765 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 1.3230 </td>
   <td style="text-align:center;"> 8.333333 </td>
   <td style="text-align:center;"> 7.4970 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 7.815189 </td>
   <td style="text-align:center;"> 8.48925 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 8.93025 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 86 </td>
   <td style="text-align:center;"> 0.1109070 </td>
   <td style="text-align:center;"> 7.458594 </td>
   <td style="text-align:center;"> 1.0950200 </td>
   <td style="text-align:center;"> 7.788331 </td>
   <td style="text-align:center;"> 7.426990 </td>
   <td style="text-align:center;"> 8.113538 </td>
   <td style="text-align:center;"> 0.6865475 </td>
   <td style="text-align:center;"> 0.0545056 </td>
   <td style="text-align:center;"> 0.0289117 </td>
   <td style="text-align:center;"> 0.0800995 </td>
   <td style="text-align:center;"> 0.0511879 </td>
   <td style="text-align:center;"> 2.8356268 </td>
   <td style="text-align:center;"> 11.473037 </td>
   <td style="text-align:center;"> 0.8343574 </td>
   <td style="text-align:center;"> 0.8984572 </td>
   <td style="text-align:center;"> 0.7496344 </td>
   <td style="text-align:center;"> 0.3215752 </td>
   <td style="text-align:center;"> 4.664753 </td>
   <td style="text-align:center;"> 2.5941176 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.825322 </td>
   <td style="text-align:center;"> 3.9690 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 4.4100 </td>
   <td style="text-align:center;"> 3.100000 </td>
   <td style="text-align:center;"> 7.0560 </td>
   <td style="text-align:center;"> 3.9690 </td>
   <td style="text-align:center;"> -27.834120 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 3.85875 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 88 </td>
   <td style="text-align:center;"> 0.1141043 </td>
   <td style="text-align:center;"> 6.840009 </td>
   <td style="text-align:center;"> 1.0960154 </td>
   <td style="text-align:center;"> 7.043205 </td>
   <td style="text-align:center;"> 6.753996 </td>
   <td style="text-align:center;"> 7.481400 </td>
   <td style="text-align:center;"> 0.7274046 </td>
   <td style="text-align:center;"> 0.0563420 </td>
   <td style="text-align:center;"> 0.0298281 </td>
   <td style="text-align:center;"> 0.0752804 </td>
   <td style="text-align:center;"> 0.0454523 </td>
   <td style="text-align:center;"> 2.9954876 </td>
   <td style="text-align:center;"> 14.112290 </td>
   <td style="text-align:center;"> 0.8787531 </td>
   <td style="text-align:center;"> 0.8976223 </td>
   <td style="text-align:center;"> 0.7887884 </td>
   <td style="text-align:center;"> 0.4153712 </td>
   <td style="text-align:center;"> 5.680680 </td>
   <td style="text-align:center;"> 3.3923077 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.953039 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 4.8510 </td>
   <td style="text-align:center;"> 4.090909 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> -19.324421 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 90 </td>
   <td style="text-align:center;"> 0.1075284 </td>
   <td style="text-align:center;"> 7.339658 </td>
   <td style="text-align:center;"> 1.2281583 </td>
   <td style="text-align:center;"> 7.621588 </td>
   <td style="text-align:center;"> 7.407676 </td>
   <td style="text-align:center;"> 8.049413 </td>
   <td style="text-align:center;"> 0.6417364 </td>
   <td style="text-align:center;"> 0.0573169 </td>
   <td style="text-align:center;"> 0.0312637 </td>
   <td style="text-align:center;"> 0.0800541 </td>
   <td style="text-align:center;"> 0.0487904 </td>
   <td style="text-align:center;"> 3.5545197 </td>
   <td style="text-align:center;"> 17.830003 </td>
   <td style="text-align:center;"> 0.8231944 </td>
   <td style="text-align:center;"> 0.9000475 </td>
   <td style="text-align:center;"> 0.7409140 </td>
   <td style="text-align:center;"> 0.2994317 </td>
   <td style="text-align:center;"> 4.737770 </td>
   <td style="text-align:center;"> 3.6750000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.777816 </td>
   <td style="text-align:center;"> 4.1895 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 4.1895 </td>
   <td style="text-align:center;"> 4.368421 </td>
   <td style="text-align:center;"> 5.2920 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 26.658084 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 92 </td>
   <td style="text-align:center;"> 0.1117687 </td>
   <td style="text-align:center;"> 6.890319 </td>
   <td style="text-align:center;"> 1.1748029 </td>
   <td style="text-align:center;"> 7.100789 </td>
   <td style="text-align:center;"> 6.760392 </td>
   <td style="text-align:center;"> 7.611384 </td>
   <td style="text-align:center;"> 0.8509922 </td>
   <td style="text-align:center;"> 0.0520956 </td>
   <td style="text-align:center;"> 0.0298366 </td>
   <td style="text-align:center;"> 0.0762490 </td>
   <td style="text-align:center;"> 0.0464124 </td>
   <td style="text-align:center;"> 2.2637685 </td>
   <td style="text-align:center;"> 8.173521 </td>
   <td style="text-align:center;"> 0.8875657 </td>
   <td style="text-align:center;"> 0.8984813 </td>
   <td style="text-align:center;"> 0.7974612 </td>
   <td style="text-align:center;"> 0.4300430 </td>
   <td style="text-align:center;"> 4.921333 </td>
   <td style="text-align:center;"> 2.5941176 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.024500 </td>
   <td style="text-align:center;"> 3.7485 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 4.4100 </td>
   <td style="text-align:center;"> 3.900000 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> -3.945648 </td>
   <td style="text-align:center;"> 7.82775 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 95 </td>
   <td style="text-align:center;"> 0.1549887 </td>
   <td style="text-align:center;"> 7.026924 </td>
   <td style="text-align:center;"> 1.5491318 </td>
   <td style="text-align:center;"> 7.574732 </td>
   <td style="text-align:center;"> 6.257077 </td>
   <td style="text-align:center;"> 8.162509 </td>
   <td style="text-align:center;"> 1.9054318 </td>
   <td style="text-align:center;"> 0.0674271 </td>
   <td style="text-align:center;"> 0.0374595 </td>
   <td style="text-align:center;"> 0.0983312 </td>
   <td style="text-align:center;"> 0.0608717 </td>
   <td style="text-align:center;"> 2.9171992 </td>
   <td style="text-align:center;"> 12.459929 </td>
   <td style="text-align:center;"> 0.9174345 </td>
   <td style="text-align:center;"> 0.8886631 </td>
   <td style="text-align:center;"> 0.8152901 </td>
   <td style="text-align:center;"> 0.5795760 </td>
   <td style="text-align:center;"> 4.734838 </td>
   <td style="text-align:center;"> 0.1852941 </td>
   <td style="text-align:center;"> 8.82 </td>
   <td style="text-align:center;"> 6.840862 </td>
   <td style="text-align:center;"> 3.9690 </td>
   <td style="text-align:center;"> 8.5995 </td>
   <td style="text-align:center;"> 4.6305 </td>
   <td style="text-align:center;"> 5.809524 </td>
   <td style="text-align:center;"> 6.6150 </td>
   <td style="text-align:center;"> 5.2920 </td>
   <td style="text-align:center;"> -8.536107 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 2.75625 </td>
   <td style="text-align:center;"> 9.15075 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 97 </td>
   <td style="text-align:center;"> 0.1068481 </td>
   <td style="text-align:center;"> 6.891009 </td>
   <td style="text-align:center;"> 1.1490578 </td>
   <td style="text-align:center;"> 7.266548 </td>
   <td style="text-align:center;"> 6.788863 </td>
   <td style="text-align:center;"> 7.594371 </td>
   <td style="text-align:center;"> 0.8055080 </td>
   <td style="text-align:center;"> 0.0489127 </td>
   <td style="text-align:center;"> 0.0299175 </td>
   <td style="text-align:center;"> 0.0726567 </td>
   <td style="text-align:center;"> 0.0427392 </td>
   <td style="text-align:center;"> 1.9370341 </td>
   <td style="text-align:center;"> 6.032807 </td>
   <td style="text-align:center;"> 0.8823887 </td>
   <td style="text-align:center;"> 0.9003777 </td>
   <td style="text-align:center;"> 0.7944831 </td>
   <td style="text-align:center;"> 0.4161263 </td>
   <td style="text-align:center;"> 5.007294 </td>
   <td style="text-align:center;"> 3.3923077 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.920760 </td>
   <td style="text-align:center;"> 3.0870 </td>
   <td style="text-align:center;"> 7.9380 </td>
   <td style="text-align:center;"> 4.8510 </td>
   <td style="text-align:center;"> 7.500000 </td>
   <td style="text-align:center;"> 5.2920 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> -18.573098 </td>
   <td style="text-align:center;"> 7.82775 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 8.26875 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 100 </td>
   <td style="text-align:center;"> 0.1579819 </td>
   <td style="text-align:center;"> 7.337346 </td>
   <td style="text-align:center;"> 1.3359707 </td>
   <td style="text-align:center;"> 7.987964 </td>
   <td style="text-align:center;"> 7.031913 </td>
   <td style="text-align:center;"> 8.203233 </td>
   <td style="text-align:center;"> 1.1713202 </td>
   <td style="text-align:center;"> 0.0668385 </td>
   <td style="text-align:center;"> 0.0397292 </td>
   <td style="text-align:center;"> 0.1098395 </td>
   <td style="text-align:center;"> 0.0701103 </td>
   <td style="text-align:center;"> 4.6292584 </td>
   <td style="text-align:center;"> 31.097986 </td>
   <td style="text-align:center;"> 0.8735748 </td>
   <td style="text-align:center;"> 0.8882608 </td>
   <td style="text-align:center;"> 0.7759623 </td>
   <td style="text-align:center;"> 0.4630612 </td>
   <td style="text-align:center;"> 4.580775 </td>
   <td style="text-align:center;"> 0.4323529 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.474234 </td>
   <td style="text-align:center;"> 3.7485 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 4.6305 </td>
   <td style="text-align:center;"> 4.809524 </td>
   <td style="text-align:center;"> 3.7485 </td>
   <td style="text-align:center;"> 5.7330 </td>
   <td style="text-align:center;"> 12.561567 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 3.63825 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 106 </td>
   <td style="text-align:center;"> 0.1638095 </td>
   <td style="text-align:center;"> 7.412379 </td>
   <td style="text-align:center;"> 1.0225347 </td>
   <td style="text-align:center;"> 7.829679 </td>
   <td style="text-align:center;"> 7.054071 </td>
   <td style="text-align:center;"> 8.135036 </td>
   <td style="text-align:center;"> 1.0809643 </td>
   <td style="text-align:center;"> 0.0718708 </td>
   <td style="text-align:center;"> 0.0471361 </td>
   <td style="text-align:center;"> 0.1124732 </td>
   <td style="text-align:center;"> 0.0653371 </td>
   <td style="text-align:center;"> 6.6307654 </td>
   <td style="text-align:center;"> 60.635431 </td>
   <td style="text-align:center;"> 0.8690471 </td>
   <td style="text-align:center;"> 0.8875375 </td>
   <td style="text-align:center;"> 0.7713119 </td>
   <td style="text-align:center;"> 0.4655538 </td>
   <td style="text-align:center;"> 4.329805 </td>
   <td style="text-align:center;"> 1.0255814 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 7.401408 </td>
   <td style="text-align:center;"> 4.4100 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 3.7485 </td>
   <td style="text-align:center;"> 4.647059 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 4.4100 </td>
   <td style="text-align:center;"> -6.730377 </td>
   <td style="text-align:center;"> 8.26875 </td>
   <td style="text-align:center;"> 4.29975 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 110 </td>
   <td style="text-align:center;"> 0.1154875 </td>
   <td style="text-align:center;"> 6.916342 </td>
   <td style="text-align:center;"> 1.1792276 </td>
   <td style="text-align:center;"> 7.261322 </td>
   <td style="text-align:center;"> 6.801641 </td>
   <td style="text-align:center;"> 7.616924 </td>
   <td style="text-align:center;"> 0.8152829 </td>
   <td style="text-align:center;"> 0.0520640 </td>
   <td style="text-align:center;"> 0.0317117 </td>
   <td style="text-align:center;"> 0.0785694 </td>
   <td style="text-align:center;"> 0.0468576 </td>
   <td style="text-align:center;"> 1.8720695 </td>
   <td style="text-align:center;"> 5.615305 </td>
   <td style="text-align:center;"> 0.8922102 </td>
   <td style="text-align:center;"> 0.8970969 </td>
   <td style="text-align:center;"> 0.8003990 </td>
   <td style="text-align:center;"> 0.4421294 </td>
   <td style="text-align:center;"> 4.873987 </td>
   <td style="text-align:center;"> 1.1025000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.984635 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> 8.3790 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> 3.434783 </td>
   <td style="text-align:center;"> 3.5280 </td>
   <td style="text-align:center;"> 3.3075 </td>
   <td style="text-align:center;"> -1.909297 </td>
   <td style="text-align:center;"> 7.82775 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-striigularis-154074.wav </td>
   <td style="text-align:center;"> 111 </td>
   <td style="text-align:center;"> 0.2166440 </td>
   <td style="text-align:center;"> 6.608996 </td>
   <td style="text-align:center;"> 1.1425440 </td>
   <td style="text-align:center;"> 6.946904 </td>
   <td style="text-align:center;"> 5.755512 </td>
   <td style="text-align:center;"> 7.561072 </td>
   <td style="text-align:center;"> 1.8055602 </td>
   <td style="text-align:center;"> 0.1090179 </td>
   <td style="text-align:center;"> 0.0626273 </td>
   <td style="text-align:center;"> 0.1563362 </td>
   <td style="text-align:center;"> 0.0937090 </td>
   <td style="text-align:center;"> 1.6137805 </td>
   <td style="text-align:center;"> 5.650432 </td>
   <td style="text-align:center;"> 0.9324493 </td>
   <td style="text-align:center;"> 0.8846462 </td>
   <td style="text-align:center;"> 0.8248877 </td>
   <td style="text-align:center;"> 0.5429038 </td>
   <td style="text-align:center;"> 5.953291 </td>
   <td style="text-align:center;"> 1.1025000 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 6.815240 </td>
   <td style="text-align:center;"> 3.7485 </td>
   <td style="text-align:center;"> 8.1585 </td>
   <td style="text-align:center;"> 4.4100 </td>
   <td style="text-align:center;"> 4.400000 </td>
   <td style="text-align:center;"> 5.0715 </td>
   <td style="text-align:center;"> 3.7485 </td>
   <td style="text-align:center;"> -6.106792 </td>
   <td style="text-align:center;"> 7.16625 </td>
   <td style="text-align:center;"> 3.19725 </td>
   <td style="text-align:center;"> 8.48925 </td>
  </tr>
</tbody>
</table></div>

That's it!
