---
layout: post
title: "Create song catalogs"
date: 17-03-2017
---



The analysis of geographic variation of animal sounds typically relies on visual exploration of acoustic similarities within and between sites. This can be challenging when large number of signals, individuals and/or sites. The new [warbleR](https://cran.r-project.org/package=warbleR) function `catalog` aims to simplify this task.

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

data(list = c("Phae.long1", "Phae.long2", "Phae.long3", 
              "Phae.long4", "selec.table"))
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")
{% endhighlight %}

The basic catalog plots the spectrograms of the signals listed in 'X'. 'X' is simply a data frame with the name of sound files and the temporal position of the signals in those sound files (as in the `selec.table` example data). The function creates a catalog with 2 columns and 5 rows labeled with the sound file name and selection number (labels argument)


{% highlight r %}
catalog(X = selec.table[1:10,], flim = c(1, 10), nrow = 5, ncol = 2, 
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE)
{% endhighlight %}

![catalog1](/img/Catalog_p1-.png)

Spectrograms can be color-tagged using the `tags` argument. A legend is added with `legend` = TRUE. The duration can also be allowed to vary between spectrograms setting `same.time.scale`= TRUE


{% highlight r %}
catalog(X = selec.table[1:10,], flim = c(1, 10), nrow = 5, ncol = 2, 
        same.time.scale = FALSE, mar = 0.01, wl = 200, 
        gr = FALSE, tags = c("sound.files"), leg.wd = 10)
{% endhighlight %}
  
![catalog2](/img/Catalog_p1-2.png)

Two color tags can be used at the same times (`tags` argument) using different color palettes for each tag (`tag.pal` argument). In this example we also use a different color palette for the spectrogram and set `orientation` of the output image file to horizontal
  

{% highlight r %}
catalog(X = selec.table[1:10,], flim = c(1, 10), nrow = 5, ncol = 2, 
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE, 
        orientation = "h",  tags = c("sound.files", "selec"), leg.wd = 10)
{% endhighlight %}

![catalog3](/img/Catalog_p1-3.png)

Many more columns and rows can be displayed. In this example a bigger selection data frame is created by combining binding several times the data used in the previous examples. The code also creates some new (hypothetical) data for song type and site> Note that the data is sorted by sites so songs from the same site are closer in the catalog


{% highlight r %}
#create bigger data
Y <- selec.table

for(i in 1:4) Y <- rbind(Y, Y)

#simulated columns
  Y$songtype <- sample(letters[1:3], nrow(Y), replace = T)
  Y$site <- rep(letters[4:25], nrow(Y))[1:nrow(Y)]

  #sort by site and the by song type 
Y <- Y[sort(Y$site, Y$songtype), ]
  
  
catalog(X = Y, flim = c(1, 10), nrow = 12, ncol = 5, cex = 2, leg.wd = 8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE,
        labels = c("sound.files","songtype", "site"), legend = TRUE, 
 width = 23, height = 30, tag.pal = list(terrain.colors, temp.colors),
  tags = c("songtype", "site"))
{% endhighlight %}

 The first image would look like this (several image are produced in the signals don't fit in a single one).

 ![catalog4](/img/Catalog_p1-4.png)

When several levels are displayed in a tag colors could become very similar. In that case cross-hatched labels can be used using the `hatching` argument. Either one or both color tags can be cross-hatched
 

{% highlight r %}
#create bigger data
Y <- selec.table

for(i in 1:4) Y <- rbind(Y, Y)

#simulated columns
  Y$songtype <- sample(letters[1:3], nrow(Y), replace = T)
  Y$site <- rep(letters[4:25], nrow(Y))[1:nrow(Y)]

  #sort by site and the by song type 
Y <- Y[sort(Y$site, Y$songtype), ]
  
  
catalog(X = Y, flim = c(1, 10), nrow = 12, ncol = 5, cex = 2, leg.wd = 8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE,
        labels = c("sound.files","songtype", "site"), legend = TRUE, 
 width = 23, height = 30, tag.pal = list(terrain.colors, temp.colors),
  tags = c("songtype", "site"), hatching = 2)
{% endhighlight %}

 ![catalog5](/img/Catalog_p1-5.png)
 
The function has many other arguments to specify spectrogram settings (e.g. margin, grid, frequency limits) and image parameters. Take a look at the function help document.
