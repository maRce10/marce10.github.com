---
layout: post
title: "Creating dynamic spectrograms (videos)"
date: 12-12-2016
---



<div class="alert alert-info">

<center>Note that the code below is now available in the new R package <a href="https://marce10.github.io/dynaSpec/">dynaSpec</a></center>

</div>

This code creates a video with a spectrogram scrolling from right to left. The spectrogram is synchronized with the audio. This is done by creating single image files for each of the movie frames and then putting them together in .mp4 video format. You will need  the ffmpeg UNIX application to be able to run the code (only works for OSX and Linux).  

First load the [warbleR](https://cran.r-project.org/package=warbleR) package 


{% highlight r %}
require("warbleR")
{% endhighlight %}

Download and read the example sound file ([long-billed hermit](http://neotropical.birds.cornell.edu/portal/species/overview?p_p_spp=231771) song)


{% highlight r %}
download.file(url = "http://marceloarayasalas.weebly.com/uploads/2/5/5/2/25524573/0.sur.2014.7.3.8.31.wav", 
    destfile = "example.wav")

wav1 <- readWave("example.wav", from = 0, to = 19, units = "seconds")
{% endhighlight %}

Set the frequency limit, frames per second (video) and a margin of silence to add at the start and end of the sound file (so the sound starts playing at 0)


{% highlight r %}
tlimsize <- 1.5


# frames per second
fps <- 50

#margin
marg <- tlimsize / 2

#add silence
wav <-pastew(wave2 = silence(duration = marg, samp.rate = wav1@samp.rate, 
            xunit = "time"), wave1 = wav1, f = wav1@samp.rate, 
            output = "Wave")

wav <-pastew(wave1 = silence(duration = marg, samp.rate = wav@samp.rate, 
            xunit = "time"), wave2 = wav, f = wav@samp.rate,
            output = "Wave")
{% endhighlight %}

 and create the individual images that will be put together in a video (this might take a while...)
 

{% highlight r %}
#start graphic device to create image files
tiff("fee%04d.tiff",res = 120, width = 1100, height = 700)

x <- 0

#loop to create image files 
repeat{

  tlim <- c(x, x + tlimsize)

  spectro(wave = wav, f = wav@samp.rate, wl = 300, ovlp = 90, 
          flim = c(2, 10.5), tlim = tlim, scale = F, grid = F, 
          palette = gray.colors,  norm = F, dBref = 2*10e-5, 
          osc = T, colgrid="white", colwave="chocolate2", 
          colaxis="white", collab="white", colbg="black")
  
  abline(v = tlim[1]+marg, lty = 2, col = "skyblue", lwd = 2)
  
  x <- x + 1/fps
  
  # stop when the end is reached
  if(x >= (length(wav@left)/wav@samp.rate) - tlimsize) break
  
  }

dev.off()
{% endhighlight %}

The last step is to run the ffmeg application in UNIX (only works for OSX and Linux, ffmpeg needs to be installed)


{% highlight r %}
#Make video
system("ffmpeg -framerate 50 -i fee%04d.tiff -c:v libx264 -profile:v high -crf 2 -pix_fmt yuv420p spectro_movie.mp4")

# save audio file
savewav(wave = wav1,filename =  "audio1.wav")

#Add audio
system("ffmpeg -i spectro_movie.mp4 -i audio1.wav -vcodec libx264 -acodec libmp3lame -shortest spectro_movie_audio.mp4")
{% endhighlight %}

At the end you should get something like this:

<center><iframe allowtransparency="true" style="background: #FFFFFF;" style="border:0px solid lightgrey;"  width="854/2" height="480/2"
src="https://www.youtube.com/embed/McAQaIXeuUQ" 
frameborder="0" 
allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe></center>

