---
layout: post
title: "Updates on catalog function"
date: 31-07-2017
---

A [previous post](https://marce10.github.io/2017/03/17/Creating_song_catalogs.html) described the new function `catalog`. Here are a few updates on `catalog` based on suggestions from [warbleR](https://cran.r-project.org/package=warbleR) users.

To be able to run the code you need [warbleR](https://cran.r-project.org/package=warbleR) 1.1.9 or higher, which hasn't been released on CRAN and it's only available in the most recent development version on github. It can be installed using the [devtools](https://cran.r-project.org/package=devtools) package as follows


{% highlight r %}
# install devtools if is not yet installed
if(!"devtools" %in% installed.packages()[,"Package"]) install.packages("devtools")

devtools::install_github("maRce10/warbleR")
{% endhighlight %}

And load the package and save the example sound files as .wav in the working directory


{% highlight r %}
library(warbleR)

data(list = c("Phae.long1", "Phae.long2", "Phae.long3", 
              "Phae.long4", "selec.table"))
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")
{% endhighlight %}

---

### 1) Arguments "spec.mar", "lab.mar", "max.group.colors" and "group.tag" to color background of selection groups


The following code creates a catalog with 3 columns and 3 rows labeled with the sound file name and selection number (default `labels` argument)


{% highlight r %}
catalog(X = selec.table[1:9,], flim = c(1, 11), nrow = 3, ncol = 3, 
        height = 10, width = 10, same.time.scale = TRUE, mar = 0.01, 
        wl = 150, gr = FALSE, box = FALSE)
{% endhighlight %}

![upd.catalog1](/img/Updates_Catalog_p1.png)

The new arguments can be used to add a background color that is shared by selections belonging to the same grouping variable level. The following code uses the "sound.files" column to color selection groups using "group.tag". It also makes use of the "spec.mar" to increase the colored areas around the spectrograms and "lab.mar" to shrink the area allocated for selection labels and tags


{% highlight r %}
# modify palette to have softer colors
cmc <- function(n) cm.colors(n, alpha = 0.5)

catalog(X = selec.table[1:9,], flim = c(1, 11), nrow = 3, ncol = 3, 
        height = 10, width = 10, tag.pal = list(cmc), cex = 0.8,
        same.time.scale = TRUE, mar = 0.01, wl = 150, gr = FALSE, 
        group.tag = "sound.files", spec.mar = 0.4, lab.mar = 0.8, box = FALSE)
{% endhighlight %}

![upd.catalog2](/img/Updates_Catalog_p2.png)


Note that the selection tables are sorted to ensure that selection sharing the same grouping factor level are clumped together in the catalog.

In the example some sound files are highlighted with very similar colors, which makes the visual identification of groups difficult. Using a different palette might solve the problem. Alternatively, the "max.group.cols" argument can be used to set a maximum number of different colors (independent of the levels of the grouping variable) that will be recycled when the number of colors is smaller than the number of levels. This works as follows


{% highlight r %}
catalog(X = selec.table[1:9,], flim = c(1, 10), nrow = 3, ncol = 3, 
        height = 10, width = 10, tag.pal = list(cmc), cex = 0.8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE, 
        group.tag = "sound.files", spec.mar = 0.4, lab.mar = 0.8,
        max.group.cols = 3, box = FALSE)
{% endhighlight %}

![upd.catalog3](/img/Updates_Catalog_p3.png)

---

### 2) Arguments "title", "by.row", "prop.mar", "box" and "rm.axes" to further customize catalog setup


As their names suggest, the arguments "title" and "rm.axes" allow users to add a title at the top of catalogs and remove the *x* and *y* axes. respectively:


{% highlight r %}
catalog(X = selec.table[1:9,], flim = c(1, 10), nrow = 3, ncol = 3, 
        height = 10, width = 10, tag.pal = list(cmc), cex = 0.8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE, 
        group.tag = "sound.files", spec.mar = 0.4, lab.mar = 0.8,
        max.group.cols = 3, rm.axes = TRUE, 
        title = "This one has a title and no axes", box = FALSE)
{% endhighlight %}

![upd.catalog4](/img/Updates_Catalog_p4.png)


The argument "by.row" allows to fill catalogs either by rows (if TRUE) or by columns (if FALSE).

By column


{% highlight r %}
catalog(X = selec.table[1:9,], flim = c(1, 10), nrow = 3, ncol = 3, 
        height = 10, width = 10, tag.pal = list(cmc), cex = 0.8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE, 
        group.tag = "sound.files", spec.mar = 0.4, lab.mar = 0.8,
        max.group.cols = 3, rm.axes = TRUE, title = "By column", 
        by.row = FALSE, box = FALSE)
{% endhighlight %}

![upd.catalog5](/img/Updates_Catalog_p5.png)

By row


{% highlight r %}
catalog(X = selec.table[1:9,], flim = c(1, 10), nrow = 3, ncol = 3, 
        height = 10, width = 10, tag.pal = list(cmc), cex = 0.8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE, 
        group.tag = "sound.files", spec.mar = 0.4, lab.mar = 0.8,
        max.group.cols = 3, rm.axes = TRUE, title = "By row", 
        by.row = TRUE, box = FALSE)
{% endhighlight %}

![upd.catalog6](/img/Updates_Catalog_p6.png)

The argument "box" allows users to draw a rectangle around the spectrogram and corresponding labels and tags


{% highlight r %}
catalog(X = selec.table[1:9,], flim = c(1, 10), nrow = 3, ncol = 3, 
        height = 10, width = 10, tag.pal = list(cmc), cex = 0.8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE, 
        group.tag = "sound.files", spec.mar = 0.4, lab.mar = 0.8,
        max.group.cols = 3, rm.axes = TRUE, title = "By row", 
        by.row = TRUE, tags = "sel.comment", box = TRUE)
{% endhighlight %}

![upd.catalog7](/img/Updates_Catalog_p7.png)


Finally, the argument "prop.mar" allows to add margins at both sides of the signals (when creating the spectrogram) that is proportional to the duration of the signal. For instance a value of 0.1 in a signal of 1s will add 0.1 s at the beginning and end of the signal. This can be particularly useful when the duration of signals varies a lot. In this example a margin equals to a third of signal duration is used:


{% highlight r %}
catalog(X = selec.table[1:9,], flim = c(1, 10), nrow = 3, ncol = 3, 
        height = 10, width = 10, tag.pal = list(cmc), cex = 0.8,
        same.time.scale = TRUE, mar = 0.01, wl = 200, gr = FALSE, 
        group.tag = "sound.files", spec.mar = 0.4, lab.mar = 0.8,
        max.group.cols = 3, rm.axes = TRUE, title = "By row", 
        by.row = TRUE, prop.mar = 1/3, tags = "sel.comment", box = TRUE)
{% endhighlight %}

![upd.catalog8](/img/Updates_Catalog_p8.png)
