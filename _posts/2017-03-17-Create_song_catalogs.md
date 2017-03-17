---
layout: post
title: "Create song catalogs"
date: 17-03-2017
---



The analysis of geographic variation of animal vocalizations typically depends on the visual assessment of acoustic similarities within and between sites. This can be particularly challenging when dealing with many individuals from many sites. The new [warbleR](https://cran.r-project.org/package=warbleR) function `catalog` aims to simplify the visual exploration of multiple vocalizations. 

The function plots a matrix of spectrograms from signals listed in a selection table (a data frame similar to the example data frame `selec.table` in [warbleR](https://cran.r-project.org/package=warbleR)). All spectrograms have the same duration so they can be compared more easily. Spectrograms can be labeled or color tagged to facilitate exploring variation related to the parameter of interest (e.g. location, song type). A legend can be added to help match colors with tag levels. Different color palettes can be used for each tag. Users can also control the number of rows and columns as well as The width and height of the output image. The function generates graphs saved as image files in the working directory (or path provided). Several images are generated if the number of signals don't fit in a single file.   

This is a short tutorial on how it works. To be able to run the code version 1.1.6 or higher to be able to run the code you have to install [warbleR](https://cran.r-project.org/package=warbleR) from github using the package [devtools](https://cran.r-project.org/package=devtools)) (`catalog` would be available in version 1.1.6)


{% highlight r %}
#run it only if devtools isn't installed
install.packages("devtools")

devtools::install_github("maRce10/warbleR")
require("warbleR")
{% endhighlight %}


Load the package and save the example sound files in the working directory 


{% highlight r %}
library(warbleR)

data(list = c("Phae.long1", "Phae.long2", "Phae.long3", "Phae.long4", "selec.table"))
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")
{% endhighlight %}

The basic catalog plots the spectrograms of the signals listed in 'X'. This creates a catalog with 2 columns and 5 rows labeled with the sound file name and selection number (labels argument)


{% highlight r %}
catalog(X = selec.table[1:10,], flim = c(1, 10), nrow = 5, ncol = 2, same.time.scale = T,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, gr = FALSE,
 orientation = "v",  labels = c("sound.files", "selec"), legend = T)
{% endhighlight %}

![compare.methods_example1](/img/comp.meth1.png)



{% highlight r %}
 #different time scales and tag palette
catalog(X = selec.table, flim = c(1, 10), nrow = 4, ncol = 2, same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, gr = FALSE, 
 orientation = "v",  labels = c("sound.files", "selec"), legend = T, 
 tag.pal = list(terrain.colors))
  
 #adding tags and changing spectro palette
catalog(X = selec.table, flim = c(1, 10), nrow = 4, ncol = 2, same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, gr = FALSE, pal = reverse.heat.colors,
 orientation = "v",  labels = c("sound.files", "selec"), legend = T, 
 tag.pal = list(terrain.colors), tags = "sound.files")

 #create a bigger selection table
 X <- rbind(selec.table, selec.table, selec.table, selec.table)
 X <- rbind(X, X)
 
 #create some simulated labels
 X$songtype <- sample(letters[1:3], nrow(X), replace = T)
 X$indiv <- sample(letters[1:12], nrow(X), replace = T)

# 12 columns in 5 rows, 2 tags
catalog(X = selec.table, flim = c(1, 10), nrow = 5, ncol = 12, same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, gr = FALSE, 
 orientation = "v",  labels = c("sound.files", "selec"), legend = F, 
 collev = seq(-65, 0, 5), tag.pal = list(terrain.colors), tags = c("songtype", "indiv"))

#'
# with legend
catalog(X = selec.table, flim = c(1, 10), nrow = 5, ncol = 12, same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, gr = FALSE,
 orientation = "v",  labels = c("sound.files", "selec"), legend = T, 
 width = 20, collev = seq(-65, 0, 5), tag.pal = list(terrain.colors),
  tags = c("songtype", "indiv"))
  
  horizontal orientation
catalog(X = selec.table, flim = c(1, 10), nrow = 5, ncol = 12, same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, gr = FALSE,
 orientation = "h",  labels = c("sound.files", "selec"), legend = T, 
 width = 20, collev = seq(-65, 0, 5), tag.pal = list(terrain.colors),
  tags = c("songtype", "indiv"))
{% endhighlight %}

 
The function has many other arguments to specify methods (e.g. bandpass, overlap) and spectrogram settings (e.g. margin, grid, frequency limits). Take a look at the function help document.

