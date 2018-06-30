---
layout: post
title: "Frequency range detection from spectrum"
date: 29-06-2018
---

We are often interested in getting the frequency range of acoustic signals, either because we have specific predictions about its variation or simply because we want to measure other stuff within that range. Measuring frequency range is typically done by drawing boxes in *Raven/Avisoft/Syrinx*. An alternative way, and potentially less subjective, is to infer the range from the energy distribution in the frequency domain applying amplitude thresholds on spectrums. I have added two new functions to [warbleR](https://cran.r-project.org/package=warbleR) that do exactly that:

* `freq_range_detec`: detects the frequency range of signals in wave objects (like a [seewave](https://cran.r-project.org/package=seewave) function). Can produce image files in the working directory if `plot = TRUE`.

* `freq_range`: applies `freq_range_detec` iteratively on signals listed in a selection table (like most [warbleR](https://cran.r-project.org/package=warbleR) functions). If `img = TRUE` a graph including a spectrogram and a frequency spectrum is produced. And this post shows how they work.

 Let's first Load/install [warbleR](https://cran.r-project.org/package=warbleR):
 

{% highlight r %}
if(!require(githubinstall)) install.packages("githubinstall")

githubinstall("warbleR", ask = FALSE)

library("warbleR")
{% endhighlight %}



We will run the functions on signals detected on a recording from a male [Striped-throated Hermit (*Phaethornis striigularis*)](https://neotropical.birds.cornell.edu/Species-Account/nb/species/stther2/overview) from [Xeno-Canto](http://xeno-canto.org). We can download the sound file and convert it into wave format as follows:


{% highlight r %}
# set temporary working directory
# setwd(tempdir())

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

ad <- snr[rank(-snr$SNR) < 21, ]
{% endhighlight %}

Let's take a look at the subset of signals that we will analyze (the output of `catalog` will be found in your working directory):


{% highlight r %}
catalog(ad, nrow = 5, ncol = 4, mar = 0.01, flim = c(3.5, 10.5), 
        labels = "selec", pal = reverse.heat.colors, pb = FALSE)

open_wd()
{% endhighlight %}



![frange1](frange_catalog.png)

### freq_range_detec

Now we are ready to run the new functions. `freq_range_detec` works on wave objects. In this example we use it to detect the frequency range of the first selection in "ad". But first the selection has to be read as a wave object into *R*: 


{% highlight r %}
w2 <- readWave(as.character(ad$sound.files[2]), from = ad$start[2], 
               to = ad$end[2], units = "seconds")

freq_range_detec(w4, bp = c(2, 9.6), fsmooth = 1, ovlp = 95, 
                 wl = 200, threshold = 8)
{% endhighlight %}

![frange2](frange_freq_range_detec.png)

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




![frange_gif](frange_2.gif)

In most cases the detection is good. However, there are some issues with highly amplitude-modulated signals (e.g. high variation in amplitude across the signal). Some parameter tweeking will be required to improve those detections. 


### freq_range

As mentioned above, the frequency range can be calculated for all selection in a selection table using `freq_range`:


{% highlight r %}
fr.ad <- freq_range_detec(X = ad, bp = c(2, 12), fsmooth = 0.001, ovlp = 95, 
                          wl = 200, threshold = 10, img = FALSE)

View(fr.ad)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-y: scroll; height:600px; overflow-x: scroll; width:740px; "><table>
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
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 8.260749 </td>
   <td style="text-align:center;"> 8.381226 </td>
   <td style="text-align:center;"> 22.84151 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
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
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:center;"> 10.634196 </td>
   <td style="text-align:center;"> 10.756079 </td>
   <td style="text-align:center;"> 21.71106 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
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
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:center;"> 22.103654 </td>
   <td style="text-align:center;"> 22.258121 </td>
   <td style="text-align:center;"> 24.28746 </td>
   <td style="text-align:center;"> 6.94575 </td>
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
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:center;"> 42.691548 </td>
   <td style="text-align:center;"> 42.792818 </td>
   <td style="text-align:center;"> 23.03548 </td>
   <td style="text-align:center;"> 6.94575 </td>
   <td style="text-align:center;"> 8.70975 </td>
  </tr>
</tbody>
</table></div>

The range can then be used as a band pass filter in other [warbleR](https://cran.r-project.org/package=warbleR) functions like `trackfreqs`, `dfts` or `specan`:


{% highlight r %}
sp <- specan(X = fr.ad, wl = 200, bp = "frange", ovlp = 90, pb = FALSE, 
             threshold = 15)

View(sp)
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 1px; overflow-y: scroll; height:600px; overflow-x: scroll; width:740px; "><table>
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
</tbody>
</table></div>

That's it!
