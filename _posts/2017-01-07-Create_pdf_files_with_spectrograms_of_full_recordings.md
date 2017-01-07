---
layout: post
title: "Pdf files with spectrograms of full recordings"
date: 07-01-2017
---

The [warbleR](https://cran.r-project.org/package=warbleR) function `lspec`  produces image files with spectrograms of whole recordings split into multiple rows. For a long recording several image files will be produced, which could be inconvenient when dealing with many long recordings. I recently added a new function `lspec2pdf` that combines `lspec` images in .jpeg format into a single pdf file (available in warbleR 1.1.5 or higher).    

You need [warbleR](https://cran.r-project.org/package=warbleR) version 1.1.5 or higher to be able to run the code (currently you have to download it from github using the package [devtools](https://cran.r-project.org/package=devtools)).


{% highlight r %}
#run it only if devtools isn't installed
install.packages("devtools")

devtools::install_github("maRce10/warbleR")
require("warbleR")
{% endhighlight %}



Download a couple of long recordings (> 2 min) from xeno-canto and convert them to .wav format


{% highlight r %}
rec1 <- querxc(qword = 'nr:153989', download = TRUE)
{% endhighlight %}



{% highlight text %}
## Error in querxc(qword = "nr:153989", download = TRUE): No connection to xeno-canto.org (check your internet connection!)
{% endhighlight %}



{% highlight r %}
rec2 <- querxc(qword = 'nr:154190', download = TRUE)
{% endhighlight %}



{% highlight text %}
## Error in querxc(qword = "nr:154190", download = TRUE): No connection to xeno-canto.org (check your internet connection!)
{% endhighlight %}



{% highlight r %}
mp32wav()
{% endhighlight %}



{% highlight text %}
## Error in mp32wav(): no 'mp3' files in working directory
{% endhighlight %}


Create the long spectrograms in .jpeg format


{% highlight r %}
lspec(flim = c(0, 6), sxrow = 10, pal = reverse.heat.colors, wl = 200, it = "jpeg")
{% endhighlight %}



{% highlight text %}
## Error in lspec(flim = c(0, 6), sxrow = 10, pal = reverse.heat.colors, : no .wav files in working directory
{% endhighlight %}


And the last step is to create a single pdf file for each sound file. Note that the `keep.jpeg` argument allows to remove the .jpeg files (when set to FALSE) 


{% highlight r %}
lspec2pdf(keep.jpeg = FALSE)
{% endhighlight %}



{% highlight text %}
## Error in lspec2pdf(keep.jpeg = FALSE): No .jpeg files were found in the working directory
{% endhighlight %}

You should get 2 pdf files that look like [this one](https://github.com/maRce10/marce10.github.com/blob/master/_pdfs/Crypturellus-boucardi-153989.pdf)


