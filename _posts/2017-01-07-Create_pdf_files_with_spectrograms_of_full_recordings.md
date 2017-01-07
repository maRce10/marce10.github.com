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
## 
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 00s
## 
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 17s
{% endhighlight %}



{% highlight r %}
rec2 <- querxc(qword = 'nr:154190', download = TRUE)
{% endhighlight %}



{% highlight text %}
## 
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 00s
## 
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 17s
{% endhighlight %}



{% highlight r %}
mp32wav()
{% endhighlight %}



{% highlight text %}
## 
   |+++++++++++++++++++++++++                         | 50% ~01s          
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 02s
{% endhighlight %}


Create the long spectrograms in .jpeg format


{% highlight r %}
lspec(flim = c(0, 6), sxrow = 10, pal = reverse.heat.colors, wl = 200, it = "jpeg")
{% endhighlight %}



{% highlight text %}
## 
   |+++++++++++++++++++++++++                         | 50% ~10s
{% endhighlight %}



{% highlight text %}
## 
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 24s
{% endhighlight %}


And the last step is to create a single pdf file for each sound file. Note that the `keep.jpeg` argument allows to remove the .jpeg files (when set to FALSE) 


{% highlight r %}
lspec2pdf(keep.jpeg = FALSE)
{% endhighlight %}



{% highlight text %}
## 
   |+++++++++++++++++++++++++                         | 50% ~01s
{% endhighlight %}



{% highlight text %}
## 
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 03s
{% endhighlight %}

You should get 2 pdf files that look like [this one](http://marceloarayasalas.weebly.com/uploads/2/5/5/2/25524573/crypturellus-boucardi-153989.pdf)


