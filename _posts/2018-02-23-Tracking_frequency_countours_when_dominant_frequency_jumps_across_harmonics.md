---
layout: post
title: Tracking frequency contours when dominant frequency jumps across harmonics
date: 23-02-2018
---

When tracking dominant frequency in order to obtain a frequency contour most algorithms rely on getting the highest amplitude frequency (i.e. dominant frequency) at each time window. This method, however, can be problematic when the highest amplitude is found at different harmonics in different time windows. Here, I demonstrate how this issue can be overcome using the new [warbleR](https://cran.r-project.org/package=warbleR) function `track_harm`.

First install and/or load [warbleR](https://cran.r-project.org/package=warbleR) developmental version (if there is an older [warbleR](https://cran.r-project.org/package=warbleR) version installed it has to be removed first):


{% highlight r %}
# remove warbleR
remove.packages("warbleR")

# install devtools if not installed
if (!"devtools" %in% installed.packages()[,"Package"])  
  install.packages("devtools")

# and install warbleR from github
devtools::install_github("maRce10/warbleR")

# load warbleR
library(warbleR)
{% endhighlight %}




Now let's simulate a song with "jumping" dominant frequency using the (also new) `sim_songs` function (the `sim_songs` function was fully explained in [a previous post](https://marce10.github.io/2018/02/22/Simulating_animal_vocalizations.html)). To accomplish this we simulate 2 songs that both start and end at the same frequency (4 kHz). We skip the gap (i.e. silence) at the end of the first song and at the beginning of the second one, so when with paste them together the sound looks like a continuous frequency trace (a single song): 

But first let's define some parameters needed for simulations and spectrograms: 


{% highlight r %}
# number of harmonics
hrms <- 4

# amplitude values for each harmonic
amps <- c(0.2, 0.1, 0.1, 1)

# sampling rate
sr <- 22.05

##### spectrogram parameters #####
# color palette
pal <- reverse.topo.colors

# set collevels
cl <- seq(-80, 0, 1)

# windows length
wl <- 600

# time window overlap 
ovlp <- 90

# frequency limits
flm <- c(1, 11)
{% endhighlight %}

Now simulate the two song segments independently:


{% highlight r %}
#song 1
sm_sng_p1 <- sim_songs(steps = 4, durs = 0.25, gaps = c(0.1, 0), 
                       samp.rate = sr, bgn = 0.25, fout = 0,
                       freq = 4, harms = hrms, amps = amps, seed = 4, 
                       diff_fun = "BB")

# plot spectrogram
spectro(sm_sng_p1, grid = F, scale = F, ovlp = ovlp, palette = pal, 
        collevels = cl, wl = wl, osc = F,  
        flim = flm, main = "song segment 1")
{% endhighlight %}

<img src="/assets/Rfig/track_harm_4-1.png" title="plot of chunk track_harm_4" alt="plot of chunk track_harm_4" width="750" />

{% highlight r %}
# song 2
sm_sng_p2 <- sim_songs(steps = 4, durs = 0.25, gaps = c(0, 0.1), 
                       samp.rate = sr, bgn = 0.9, fin = 0, 
                       freq = 4, harms = hrms, amps = rev(amps), 
                       seed = 4, diff_fun = "BB")

# plot spectrogram
spectro(sm_sng_p2, grid = F, scale = F,  ovlp = ovlp, palette = pal, 
        collevels = cl, wl = wl, osc = F,  main = "song segment 2", 
        flim = flm)
{% endhighlight %}

<img src="/assets/Rfig/track_harm_4-2.png" title="plot of chunk track_harm_4" alt="plot of chunk track_harm_4" width="750" />

Note that the amplitude values were flipped (`amps = rev(amps)`) in the second simulation so the highest amplitude is in the last harmonic. Also, the fade-out was set to 0 (`fout`) in the first simulation while the fade-in (`fin`) was 0 in the second. A seed is used so the same song will be generated every time. If `seed = NULL` (as by default) then a different song will produced each time.


We can put together this 2 song segments in a single wave object using [seewave's](https://cran.r-project.org/package=seewave) `pastew` function:


{% highlight r %}
# paste the 2 songs
sm_sng <- pastew(sm_sng_p2, sm_sng_p1, output = "Wave")

# plot spectrogram
spectro(sm_sng, grid = F, scale = F, f = f, ovlp = ovlp, palette = pal, 
        collevels = cl, wl = wl, osc = F, flim = flm, 
        main = "'Jumping' dominant frequency song")
{% endhighlight %}

<img src="/assets/Rfig/track_harm_5-1.png" title="plot of chunk track_harm_5" alt="plot of chunk track_harm_5" width="750" />

There it is. A song in which the dominant frequency jumps from the first harmonic to the fourth one.

If we used [seewave's](https://cran.r-project.org/package=seewave) `dfreq` function to get the frequency contour we will see that the contour will also jump from the first to the fourth harmonic:


{% highlight r %}
#band pass
bp <- c(2000, 9000)

# threshold for amplitude detection
thrshld <- 10

# seewave's dominant frequency tracking
dm_frq <- dfreq(wave = sm_sng, tlim = c(0.1, 0.6), wl = wl, ovlp = ovlp, 
                threshold = thrshld, plot = F, bandpass = bp)

# plot spectrogram
spectro(sm_sng, grid = F, scale = F, f = f, ovlp = ovlp, palette = pal, 
        collevels = cl, wl = wl, osc = F, flim = c(0,10), 
        main = "seewave's 'dfreq'")

# plot detected frequency contour
points(x = dm_frq[ , 1] + 0.1, y =  dm_frq[ , 2], cex = 1, col = "red2", 
       pch = 20)
{% endhighlight %}

<img src="/assets/Rfig/track_harm_6-1.png" title="plot of chunk track_harm_6" alt="plot of chunk track_harm_6" width="750" />

the red dots highlight the resulting frequency contour.

Now let's try with `track_harms`:


{% highlight r %}
# track harmonic frequencu contour
trck_hrm <- track_harm(wave = sm_sng, tlim = c(0.1, 0.6), wl = wl, 
                       ovlp = ovlp, threshold = thrshld, plot = F, 
                       bandpass = bp)

# plot spectrogram
spectro(sm_sng, grid = F, scale = F, f = f, ovlp = ovlp, palette = pal, 
        collevels = cl, wl = wl, osc = F, flim = flm, 
        main = "warbleR's 'track_harm'")

# plot detected frequency contour
points(x = trck_hrm[ , 1] + 0.1, y =  trck_hrm[ , 2], cex = 1, 
       col = "red2", pch = 20)
{% endhighlight %}

<img src="/assets/Rfig/track_harm_7-1.png" title="plot of chunk track_harm_7" alt="plot of chunk track_harm_7" width="750" />

The frequency contour is now accurately tracked despite the dominant frequency jumping across harmonics. `trac_harms` takes exactly the same arguments than [seewave's](https://cran.r-project.org/package=seewave) `dfreq` function, so it can be simply replaced in existing code. 
 
Now we can try it on a real song. This is an element from a fairy-wren song:

<img src="/assets/Rfig/track_harm_8-1.png" title="plot of chunk track_harm_8" alt="plot of chunk track_harm_8" width="750" />

This is the frequency contour using the regular `dfreq` function:

<img src="/assets/Rfig/track_harm_9-1.png" title="plot of chunk track_harm_9" alt="plot of chunk track_harm_9" width="750" />

And this is using the `track_harm` function:

<img src="/assets/Rfig/track_harm_10-1.png" title="plot of chunk track_harm_10" alt="plot of chunk track_harm_10" width="750" />

 
Please report any bugs [here](https://github.com/maRce10/warbleR/issues).
