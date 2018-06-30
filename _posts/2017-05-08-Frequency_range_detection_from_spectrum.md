---
layout: post
title: "Frequency range detection from spectrum"
date: 08-05-2017
---

We are often interested in getting the frequency range of acoustic signals, either because we have specific predictions about its variation or simply because we want to measure other stuff within the frequency range of the signals. Measuring frequency range is typically done by drawing boxes in Raven/Avisoft/Syrinx. An alternative way, and potentially less subjective, is to infer the range from the energy distribution in the frequency domain applying amplitude thresholds on spectrums. 

I have added two new functions to [warbleR]((https://cran.r-project.org/package=warbleR) that do exactly that:

* `freq_range_detec`: detects the frequency range of signals in wave objects (like a [seewave]((https://cran.r-project.org/package=seewave) function). Can produce image files in the working directory if `plot = TRUE`.

* `freq_range`: applies 'freq_range_detec' iteratively on signals listed in a selection table.  If `img = TRUE` a graph including a spectrogram and a frequency spectrum is produced. And this post shows how they work.

 But first Load/install [warbleR]((https://cran.r-project.org/package=warbleR):
 

{% highlight r %}
if(!require(githubinstall)) install.packages("githubinstall")

githubinstall("warbleR", ask = FALSE)

library(warbleR)
{% endhighlight %}





Now download an example recording from a male [Striped-throated Hermit (**Phaethornis striigularis**)](https://neotropical.birds.cornell.edu/Species-Account/nb/species/stther2/overview) and convert it into wave format:


{% highlight r %}
# set temporary working directory
setwd(tempdir())

# Query and download  Xeno-Canto for metadata using genus and species as keywords
Phae.stri <- querxc(qword = "nr:154074", download = TRUE, pb = FALSE)

# Convert mp3 to wav format
# Simultaneously lower sampling rate for more speed in following analyses
mp32wav(samp.rate = 22.05, pb = FALSE)
{% endhighlight %}


{% highlight r %}
ad <- autodetec(wl = 200, threshold = 3.5, ssmooth = 1200, bp = c(4, 9.6), pb = FALSE,  mindur = 0.1, maxdur = 0.25, img = FALSE)

snr <- sig2noise(ad, pb = FALSE, mar = 0.05)

ad <- snr[rank(-snr$SNR) < 21, ]

catalog(ad, nrow = 5, ncol = 4, mar = 0.01, flim = c(3.5, 10.5), labels = "selec", pal = reverse.heat.colors, pb = FALSE)
{% endhighlight %}



![frange1](img/frange_1.png)

`frange.detec` works on wave objects. In this example we use it to detect the frequency range of the first selection in "ad". But first the selection was to be read as a wave object into R: 


{% highlight r %}
w1 <- readWave(as.character(ad$sound.files[1]), from = ad$start[1], to = ad$end[1], units = "seconds")
{% endhighlight %}



{% highlight text %}
## Error in readWave(as.character(ad$sound.files[1]), from = ad$start[1], : File 'Phaethornis-striigularis-154074.wav' does not exist.
{% endhighlight %}



{% highlight r %}
freq_range_detec(w1, bp = c(2, 9.6), fsmooth = 0.5, fast.spec = T, pal = monitoR::gray.3, ovlp = 90, wl = 200, threshold = 5)
{% endhighlight %}



{% highlight text %}
## Error in frd_wrblr_int(wave = wave, wl = wl, fsmooth = fsmooth, threshold = threshold, : object 'w1' not found
{% endhighlight %}


We can look at the detection for each selection in the 'ad' data frame using a loop as follows:


{% highlight r %}
for(i in 1:nrow(ad))
{
  wv <- readWave(as.character(ad$sound.files[i]), from = ad$start[i], to = ad$end[i], units = "seconds")

freq_range_detec(wv, bp = c(2, 12), fsmooth = 1, ovlp = 95, wl = 200, threshold = 8, flim = c(0, 13), main = paste("selection", i))

Sys.sleep(0.8)
}
{% endhighlight %}




![frange1](img/frange_2.gif)

In most cases the detection is good. However, there are some issues with signals with a lot of amplitude modulation (variation in amplitude across the signal). Some parameter tweeking will be required to improve the detections. 


As mentioned above, the frequency range can be calculated for all selection in a selection table using `freq_range`:


{% highlight r %}
fr.ad <- freq_range_detec(X = ad, bp = c(2, 12), fsmooth = 0.001, ovlp = 95, wl = 200, threshold = 10, img = FALSE)

View(fr.ad)
{% endhighlight %}


{% highlight text %}
## Error in freq_range_detec(X = ad, bp = c(2, 12), fsmooth = 0.001, ovlp = 95, : unused arguments (X = ad, img = FALSE)
{% endhighlight %}



{% highlight text %}
## Error in inherits(x, "list"): object 'fr.ad' not found
{% endhighlight %}



{% highlight text %}
## Error in scroll_box(kbl, width = "740px", box_css = "border: 1px solid #ddd; padding: 1px; ", : could not find function "scroll_box"
{% endhighlight %}

The range can then be used as a band pass in further analysis that required frequency detection as in `trackfreqs`, `dfts` or `specan`:


{% highlight r %}
sp <- specan(X = fr.ad, wl = 200, flim = c(2, 12), bp = "frange", ovlp = 90, pb = FALSE, threshold = 15)

View(sp)
{% endhighlight %}



{% highlight text %}
## Error in specan(X = fr.ad, wl = 200, flim = c(2, 12), bp = "frange", ovlp = 90, : unused argument (flim = c(2, 12))
{% endhighlight %}



{% highlight text %}
## Error in kable(sp, align = "c", row.names = F, format = "html"): object 'sp' not found
{% endhighlight %}



{% highlight text %}
## Error in scroll_box(kbl, width = "740px", box_css = "border: 1px solid #ddd; padding: 1px; ", : could not find function "scroll_box"
{% endhighlight %}

That's it!
