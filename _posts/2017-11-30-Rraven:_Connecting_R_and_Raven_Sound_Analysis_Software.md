---
layout: post
title: "Rraven: Connecting R and Raven Sound Analysis Software"
date: 30-11-2017
---

The `Rraven` package is designed to facilitate the exchange of data between R and  [Raven sound analysis software](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) ([Cornell Lab of Ornithology](http://www.birds.cornell.edu)). [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) provides very  powerful tools for the analysis of (animal) sounds. R can simplify the automatization of complex routines of analyses. Furthermore, R packages as [warbleR](https://cran.r-project.org/package=warbleR), [seewave](https://cran.r-project.org/package=seewave) and [monitoR](https://cran.r-project.org/package=monitoR) (among others) provide additional methods of analysis, working as a perfect complement for those found in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html). Hence, bridging these applications can largely expand the bioacoustician's toolkit.

Currently, most analyses in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) cannot be run in the background from a command terminal. Thus, most `Rraven` functions are design to simplify the exchange of data between the two programs, and in some cases, export files to  [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) for further analysis. This post provides detailed examples for each function in `Rraven`, including both the R code as well as the additional steps in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) required to fully accomplished the analyses. Raven Pro must be installed to be able to run some of the code.

Before getting into the functions, the packages must be installed and loaded. I recommend using the latest developmental version, which is found in [github](http://github.com/). To do so, you need the R package [devtools](https://cran.r-project.org/package=devtools) (which of course should be installed!). Some [warbleR](https://cran.r-project.org/package=warbleR) functions and example data sets will be used, so [warbleR](https://cran.r-project.org/package=warbleR) should be installed as well:





{% highlight r %}
devtools::install_github("maRce10/warbleR")

devtools::install_github("maRce10/Rraven")

#from CRAN would be
#install.packages("warbleR")

#load packages
library(warbleR)
library(Rraven)
{% endhighlight %}
 &nbsp; 
 
Let's also use a temporary folder as the working directory i which to save all sound files and data files:


{% highlight r %}
setwd(tempdir())

#load example data
data(list = c("Phae.long1", "Phae.long2", "Phae.long3", "Phae.long4", "selec.table", "selection_files"))

#save sound files  in temporary directory
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")

#save Raven selection tables in the temporary directory
out <- lapply(1:4, function(x)
writeLines(selection_files[[x]], con = names(selection_files)[x]))

#this is the temporary directory location (of course different each time is run)
getwd() 
{% endhighlight %}


{% highlight text %}
[1] "/tmp/RtmpVJQbOW"
{% endhighlight %}
 &nbsp; 

--- 

## Importing data from Raven

### *imp_raven*

This function imports [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) selection tables. Multiple files can be imported at once. [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) selection tables including data from multiple recordings can also be imported. It returns a single data frame with the information contained in the selection files. We already have 2 [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) selection tables in the working directory:


{% highlight r %}
list.files(path = tempdir(), pattern = "\\.txt$")
{% endhighlight %}



{% highlight text %}
[1] "LBH 1 selection table example.txt" "LBH 2 selection table example.txt" "LBH 3 selection table example.txt" "LBH 4 selection table example.txt"
{% endhighlight %}
 &nbsp; 


This code shows how to import all the data contained in those files into R:


{% highlight r %}
rvn.dat <- imp_raven(all.data = TRUE)

head(rvn.dat)
{% endhighlight %}


<table>
 <thead>
  <tr>
   <th style="text-align:center;"> Selection </th>
   <th style="text-align:center;"> View </th>
   <th style="text-align:center;"> Channel </th>
   <th style="text-align:center;"> Begin.Time..s. </th>
   <th style="text-align:center;"> End.Time..s. </th>
   <th style="text-align:center;"> Low.Freq..Hz. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.1693549 </td>
   <td style="text-align:center;"> 1.3423884 </td>
   <td style="text-align:center;"> 2220.105 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.1584085 </td>
   <td style="text-align:center;"> 2.3214565 </td>
   <td style="text-align:center;"> 2169.437 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.3433366 </td>
   <td style="text-align:center;"> 0.5182553 </td>
   <td style="text-align:center;"> 2218.294 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1595983 </td>
   <td style="text-align:center;"> 0.2921692 </td>
   <td style="text-align:center;"> 2316.862 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.4570585 </td>
   <td style="text-align:center;"> 1.5832087 </td>
   <td style="text-align:center;"> 2284.006 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.6265520 </td>
   <td style="text-align:center;"> 0.7577715 </td>
   <td style="text-align:center;"> 3006.834 </td>
  </tr>
</tbody>
</table>
 &nbsp; 
 
<table>
 <thead>
  <tr>
   <th style="text-align:center;"> High.Freq..Hz. </th>
   <th style="text-align:center;"> Begin.File </th>
   <th style="text-align:center;"> channel </th>
   <th style="text-align:center;"> Begin.Path </th>
   <th style="text-align:center;"> File.Offset </th>
   <th style="text-align:center;"> selec.file </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 8604.378 </td>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:center;"> 1.1693549 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8807.053 </td>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:center;"> 2.1584085 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8756.604 </td>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:center;"> 0.3433366 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8822.316 </td>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long2.wav </td>
   <td style="text-align:center;"> 0.1595983 </td>
   <td style="text-align:center;"> LBH 2 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8888.027 </td>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long2.wav </td>
   <td style="text-align:center;"> 1.4570585 </td>
   <td style="text-align:center;"> LBH 2 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8822.316 </td>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long3.wav </td>
   <td style="text-align:center;"> 0.6265520 </td>
   <td style="text-align:center;"> LBH 3 selection table example.txt </td>
  </tr>
</tbody>
</table>

 &nbsp; 
 
Note that the 'waveform' view data has been removed. It can also be imported as follows: 


{% highlight r %}
rvn.dat <- imp_raven(all.data = TRUE, waveform = TRUE)

head(rvn.dat)
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> Selection </th>
   <th style="text-align:left;"> View </th>
   <th style="text-align:right;"> Channel </th>
   <th style="text-align:right;"> Begin.Time..s. </th>
   <th style="text-align:right;"> End.Time..s. </th>
   <th style="text-align:right;"> Low.Freq..Hz. </th>
   <th style="text-align:right;"> High.Freq..Hz. </th>
   <th style="text-align:left;"> Begin.File </th>
   <th style="text-align:right;"> channel </th>
   <th style="text-align:left;"> Begin.Path </th>
   <th style="text-align:right;"> File.Offset </th>
   <th style="text-align:left;"> selec.file </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Spectrogram 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.1693549 </td>
   <td style="text-align:right;"> 1.3423884 </td>
   <td style="text-align:right;"> 2220.105 </td>
   <td style="text-align:right;"> 8604.378 </td>
   <td style="text-align:left;"> Phae.long1.wav </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:right;"> 1.1693549 </td>
   <td style="text-align:left;"> LBH 1 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Spectrogram 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2.1584085 </td>
   <td style="text-align:right;"> 2.3214565 </td>
   <td style="text-align:right;"> 2169.437 </td>
   <td style="text-align:right;"> 8807.053 </td>
   <td style="text-align:left;"> Phae.long1.wav </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:right;"> 2.1584085 </td>
   <td style="text-align:left;"> LBH 1 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Spectrogram 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.3433366 </td>
   <td style="text-align:right;"> 0.5182553 </td>
   <td style="text-align:right;"> 2218.294 </td>
   <td style="text-align:right;"> 8756.604 </td>
   <td style="text-align:left;"> Phae.long1.wav </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:right;"> 0.3433366 </td>
   <td style="text-align:left;"> LBH 1 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Spectrogram 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.1595983 </td>
   <td style="text-align:right;"> 0.2921692 </td>
   <td style="text-align:right;"> 2316.862 </td>
   <td style="text-align:right;"> 8822.316 </td>
   <td style="text-align:left;"> Phae.long2.wav </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> /tmp/RtmpWpOeaR/Phae.long2.wav </td>
   <td style="text-align:right;"> 0.1595983 </td>
   <td style="text-align:left;"> LBH 2 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Spectrogram 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.4570585 </td>
   <td style="text-align:right;"> 1.5832087 </td>
   <td style="text-align:right;"> 2284.006 </td>
   <td style="text-align:right;"> 8888.027 </td>
   <td style="text-align:left;"> Phae.long2.wav </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> /tmp/RtmpWpOeaR/Phae.long2.wav </td>
   <td style="text-align:right;"> 1.4570585 </td>
   <td style="text-align:left;"> LBH 2 selection table example.txt </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Spectrogram 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.6265520 </td>
   <td style="text-align:right;"> 0.7577715 </td>
   <td style="text-align:right;"> 3006.834 </td>
   <td style="text-align:right;"> 8822.316 </td>
   <td style="text-align:left;"> Phae.long3.wav </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> /tmp/RtmpWpOeaR/Phae.long3.wav </td>
   <td style="text-align:right;"> 0.6265520 </td>
   <td style="text-align:left;"> LBH 3 selection table example.txt </td>
  </tr>
</tbody>
</table>
 &nbsp; 
 
[Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) selections can also be imported in a 'selection.table' format so it can be directly input into [warbleR](https://cran.r-project.org/package=warbleR) functions. To do this you need to set the `all.data = FALSE` and indicate which column contains the sound file name (using the 'sound.file.col' argument): 


{% highlight r %}
#providing the name of the column with the sound file names
rvn.dat <- imp_raven(sound.file.col = "End.File", all.data = FALSE, freq.cols = TRUE)

head(rvn.dat)
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> channel </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> selec.file </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.1693549 </td>
   <td style="text-align:center;"> 1.3423884 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
   <td style="text-align:center;"> 2.220105 </td>
   <td style="text-align:center;"> 8.604378 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2.1584085 </td>
   <td style="text-align:center;"> 2.3214565 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
   <td style="text-align:center;"> 2.169437 </td>
   <td style="text-align:center;"> 8.807053 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.3433366 </td>
   <td style="text-align:center;"> 0.5182553 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
   <td style="text-align:center;"> 2.218294 </td>
   <td style="text-align:center;"> 8.756604 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1595983 </td>
   <td style="text-align:center;"> 0.2921692 </td>
   <td style="text-align:center;"> LBH 2 selection table example.txt </td>
   <td style="text-align:center;"> 2.316862 </td>
   <td style="text-align:center;"> 8.822316 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.4570585 </td>
   <td style="text-align:center;"> 1.5832087 </td>
   <td style="text-align:center;"> LBH 2 selection table example.txt </td>
   <td style="text-align:center;"> 2.284006 </td>
   <td style="text-align:center;"> 8.888027 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.6265520 </td>
   <td style="text-align:center;"> 0.7577715 </td>
   <td style="text-align:center;"> LBH 3 selection table example.txt </td>
   <td style="text-align:center;"> 3.006834 </td>
   <td style="text-align:center;"> 8.822316 </td>
  </tr>
</tbody>
</table>
 &nbsp; 
 
The data frame contains the following columns: sound.files, channel, selec, start, end, and selec.file. You can also import the frequency range parameters in the 'selection.table' by setting 'freq.cols' tp `TRUE`. The data frame returned by "imp_raven" (when in the 'warbleR' format) can be input into several [warbleR](https://cran.r-project.org/package=warbleR) functions for further analysis. For instance, the following code runs additional parameter measurements on the imported selections:


{% highlight r %}
# convert to class selection.table
rvn.dat.st <- make.selection.table(rvn.dat)

sp <- specan(X = rvn.dat, bp = "frange", wl = 150, pb = FALSE, ovlp = 90)

head(sp)
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> duration </th>
   <th style="text-align:center;"> meanfreq </th>
   <th style="text-align:center;"> sd </th>
   <th style="text-align:center;"> freq.median </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1730334 </td>
   <td style="text-align:center;"> 5.982350 </td>
   <td style="text-align:center;"> 1.399687 </td>
   <td style="text-align:center;"> 6.331716 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1630480 </td>
   <td style="text-align:center;"> 5.997299 </td>
   <td style="text-align:center;"> 1.422930 </td>
   <td style="text-align:center;"> 6.212125 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.1749187 </td>
   <td style="text-align:center;"> 6.020600 </td>
   <td style="text-align:center;"> 1.515536 </td>
   <td style="text-align:center;"> 6.428439 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1325709 </td>
   <td style="text-align:center;"> 6.398304 </td>
   <td style="text-align:center;"> 1.340412 </td>
   <td style="text-align:center;"> 6.595971 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1261502 </td>
   <td style="text-align:center;"> 6.311837 </td>
   <td style="text-align:center;"> 1.370040 </td>
   <td style="text-align:center;"> 6.602020 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1312195 </td>
   <td style="text-align:center;"> 6.612400 </td>
   <td style="text-align:center;"> 1.093120 </td>
   <td style="text-align:center;"> 6.670130 </td>
  </tr>
</tbody>
</table>
 &nbsp; 
 
<table>
 <thead>
  <tr>
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
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 6.331716 </td>
   <td style="text-align:center;"> 5.296584 </td>
   <td style="text-align:center;"> 6.869521 </td>
   <td style="text-align:center;"> 1.572937 </td>
   <td style="text-align:center;"> 0.0764552 </td>
   <td style="text-align:center;"> 0.0465681 </td>
   <td style="text-align:center;"> 0.1174629 </td>
   <td style="text-align:center;"> 0.0708948 </td>
   <td style="text-align:center;"> 1.998039 </td>
   <td style="text-align:center;"> 7.021565 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6.212125 </td>
   <td style="text-align:center;"> 5.328746 </td>
   <td style="text-align:center;"> 6.880795 </td>
   <td style="text-align:center;"> 1.552049 </td>
   <td style="text-align:center;"> 0.0766553 </td>
   <td style="text-align:center;"> 0.0439026 </td>
   <td style="text-align:center;"> 0.1156798 </td>
   <td style="text-align:center;"> 0.0717772 </td>
   <td style="text-align:center;"> 1.918356 </td>
   <td style="text-align:center;"> 7.334323 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6.428439 </td>
   <td style="text-align:center;"> 5.152811 </td>
   <td style="text-align:center;"> 6.983309 </td>
   <td style="text-align:center;"> 1.830498 </td>
   <td style="text-align:center;"> 0.0902434 </td>
   <td style="text-align:center;"> 0.0534519 </td>
   <td style="text-align:center;"> 0.1277291 </td>
   <td style="text-align:center;"> 0.0742772 </td>
   <td style="text-align:center;"> 2.495361 </td>
   <td style="text-align:center;"> 11.139125 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6.595971 </td>
   <td style="text-align:center;"> 5.607323 </td>
   <td style="text-align:center;"> 7.380852 </td>
   <td style="text-align:center;"> 1.773529 </td>
   <td style="text-align:center;"> 0.0768669 </td>
   <td style="text-align:center;"> 0.0543005 </td>
   <td style="text-align:center;"> 0.1036645 </td>
   <td style="text-align:center;"> 0.0493641 </td>
   <td style="text-align:center;"> 1.568523 </td>
   <td style="text-align:center;"> 6.016392 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6.602020 </td>
   <td style="text-align:center;"> 5.609829 </td>
   <td style="text-align:center;"> 7.213209 </td>
   <td style="text-align:center;"> 1.603380 </td>
   <td style="text-align:center;"> 0.0761028 </td>
   <td style="text-align:center;"> 0.0528492 </td>
   <td style="text-align:center;"> 0.0979471 </td>
   <td style="text-align:center;"> 0.0450980 </td>
   <td style="text-align:center;"> 2.468996 </td>
   <td style="text-align:center;"> 10.884349 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6.670130 </td>
   <td style="text-align:center;"> 6.067212 </td>
   <td style="text-align:center;"> 7.349366 </td>
   <td style="text-align:center;"> 1.282153 </td>
   <td style="text-align:center;"> 0.0635054 </td>
   <td style="text-align:center;"> 0.0430425 </td>
   <td style="text-align:center;"> 0.0896131 </td>
   <td style="text-align:center;"> 0.0465706 </td>
   <td style="text-align:center;"> 1.773688 </td>
   <td style="text-align:center;"> 6.626019 </td>
  </tr>
</tbody>
</table>
 &nbsp; 



And this code creates song catalogs:


{% highlight r %}
catalog(X = rvn.dat.st[1:9, ], flim = c(1, 10), nrow = 3, ncol = 3, same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, pal = reverse.heat.colors, width = 20,  labels = c("sound.files", "selec"), legend = 1, 
 tag.pal = list(terrain.colors), tags = "sound.files")
{% endhighlight %}

![catalog](/img/catalog.png)
---

This is just to cite a few analysis that can be implemented in [warbleR](https://cran.r-project.org/package=warbleR).

`Rraven` also contains the function `imp_syrinx` to import selections from [Syrinx sound analyis software](www.syrinxpc.com) (although this program is not been maintained any longer).


### *extract_ts*

The function extracts parameters encoded as time series in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) selection tables. The resulting data frame can be directly input into functions for time series analysis of acoustic signals as in the [warbleR](https://cran.r-project.org/package=warbleR) function `dfDTW`. The function needs an R data frame, so the data should have been previously imported using `imp_raven`. This example uses the `selection_file.ts` example data that comes with `Rraven`: 



{% highlight r %}
#remove previous raven data files
unlink(list.files(pattern = "\\.txt$"))

#save Raven selection table in the temporary directory
writeLines(selection_files[[5]], con = names(selection_files)[5])

rvn.dat <- imp_raven(all.data = TRUE) 

# Peak freq contour dif length
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak.Freq.Contour..Hz.")
 
head(fcts[,1:14])
head(fcts[,39:53])
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> P.F.1 </th>
   <th style="text-align:center;"> P.F.2 </th>
   <th style="text-align:center;"> P.F.3 </th>
   <th style="text-align:center;"> P.F.4 </th>
   <th style="text-align:center;"> P.F.5 </th>
   <th style="text-align:center;"> P.F.6 </th>
   <th style="text-align:center;"> P.F.7 </th>
   <th style="text-align:center;"> P.F.8 </th>
   <th style="text-align:center;"> P.F.9 </th>
   <th style="text-align:center;"> P.F.10 </th>
   <th style="text-align:center;"> P.F.11 </th>
   <th style="text-align:center;"> P.F.12 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6943.4 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7294.9 </td>
   <td style="text-align:center;"> 7294.9 </td>
   <td style="text-align:center;"> 7294.9 </td>
   <td style="text-align:center;"> 7382.8 </td>
   <td style="text-align:center;"> 7470.7 </td>
   <td style="text-align:center;"> 7646.5 </td>
   <td style="text-align:center;"> 5185.5 </td>
   <td style="text-align:center;"> 5273.4 </td>
   <td style="text-align:center;"> 5361.3 </td>
   <td style="text-align:center;"> 5449.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 6767.6 </td>
   <td style="text-align:center;"> 6943.4 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7294.9 </td>
   <td style="text-align:center;"> 7382.8 </td>
   <td style="text-align:center;"> 7470.7 </td>
   <td style="text-align:center;"> 7558.6 </td>
   <td style="text-align:center;"> 7558.6 </td>
   <td style="text-align:center;"> 7646.5 </td>
   <td style="text-align:center;"> 5185.5 </td>
   <td style="text-align:center;"> 5361.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 6943.4 </td>
   <td style="text-align:center;"> 4746.1 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 4834.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 4921.9 </td>
   <td style="text-align:center;"> 4921.9 </td>
   <td style="text-align:center;"> 7558.6 </td>
   <td style="text-align:center;"> 7646.5 </td>
   <td style="text-align:center;"> 7734.4 </td>
   <td style="text-align:center;"> 7998.0 </td>
   <td style="text-align:center;"> 8085.9 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 5888.7 </td>
   <td style="text-align:center;"> 6503.9 </td>
   <td style="text-align:center;"> 4570.3 </td>
   <td style="text-align:center;"> 4834.0 </td>
   <td style="text-align:center;"> 5185.5 </td>
   <td style="text-align:center;"> 5537.1 </td>
   <td style="text-align:center;"> 5537.1 </td>
   <td style="text-align:center;"> 5800.8 </td>
   <td style="text-align:center;"> 6503.9 </td>
   <td style="text-align:center;"> 3779.3 </td>
   <td style="text-align:center;"> 6240.2 </td>
   <td style="text-align:center;"> 6328.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 4570.3 </td>
   <td style="text-align:center;"> 4746.1 </td>
   <td style="text-align:center;"> 4921.9 </td>
   <td style="text-align:center;"> 5097.7 </td>
   <td style="text-align:center;"> 5097.7 </td>
   <td style="text-align:center;"> 5185.5 </td>
   <td style="text-align:center;"> 5800.8 </td>
   <td style="text-align:center;"> 5712.9 </td>
   <td style="text-align:center;"> 5888.7 </td>
   <td style="text-align:center;"> 5976.6 </td>
   <td style="text-align:center;"> 6064.5 </td>
   <td style="text-align:center;"> 6064.5 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 4218.8 </td>
   <td style="text-align:center;"> 6240.2 </td>
   <td style="text-align:center;"> 6591.8 </td>
   <td style="text-align:center;"> 6679.7 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 5009.8 </td>
   <td style="text-align:center;"> 5800.8 </td>
   <td style="text-align:center;"> 6240.2 </td>
   <td style="text-align:center;"> 6767.6 </td>
   <td style="text-align:center;"> 6416.0 </td>
   <td style="text-align:center;"> 6328.1 </td>
   <td style="text-align:center;"> 6328.1 </td>
  </tr>
</tbody>
</table>


 &nbsp;

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> P.F.37 </th>
   <th style="text-align:center;"> P.F.38 </th>
   <th style="text-align:center;"> P.F.39 </th>
   <th style="text-align:center;"> P.F.40 </th>
   <th style="text-align:center;"> P.F.41 </th>
   <th style="text-align:center;"> P.F.42 </th>
   <th style="text-align:center;"> P.F.43 </th>
   <th style="text-align:center;"> P.F.44 </th>
   <th style="text-align:center;"> P.F.45 </th>
   <th style="text-align:center;"> P.F.46 </th>
   <th style="text-align:center;"> P.F.47 </th>
   <th style="text-align:center;"> P.F.48 </th>
   <th style="text-align:center;"> P.F.49 </th>
   <th style="text-align:center;"> P.F.50 </th>
   <th style="text-align:center;"> P.F.51 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 6943.4 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7031.2 </td>
   <td style="text-align:center;"> 6943.4 </td>
   <td style="text-align:center;"> 6591.8 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7119.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6943.4 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6943.4 </td>
   <td style="text-align:center;"> 7031.2 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7031.2 </td>
   <td style="text-align:center;"> 7294.9 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7031.2 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7031.2 </td>
   <td style="text-align:center;"> 7031.2 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7207.0 </td>
   <td style="text-align:center;"> 7119.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6064.5 </td>
   <td style="text-align:center;"> 6152.3 </td>
   <td style="text-align:center;"> 6152.3 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5537.1 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7119.1 </td>
   <td style="text-align:center;"> 7822.3 </td>
   <td style="text-align:center;"> 6416.0 </td>
   <td style="text-align:center;"> 6855.5 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
</tbody>
</table>
 &nbsp;
 
Note that these sequences are not all of equal length (one has NAs at the end).
`extract_ts` can also interpolate values so all time series have the same length:


{% highlight r %}
# Peak freq contour equal length
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak.Freq.Contour..Hz.",  equal.length = TRUE)

#look at the last rows wit no NAs
head(fcts[,21:32])
{% endhighlight %}
 
<table>
 <thead>
  <tr>
   <th style="text-align:center;"> P.F.19 </th>
   <th style="text-align:center;"> P.F.20 </th>
   <th style="text-align:center;"> P.F.21 </th>
   <th style="text-align:center;"> P.F.22 </th>
   <th style="text-align:center;"> P.F.23 </th>
   <th style="text-align:center;"> P.F.24 </th>
   <th style="text-align:center;"> P.F.25 </th>
   <th style="text-align:center;"> P.F.26 </th>
   <th style="text-align:center;"> P.F.27 </th>
   <th style="text-align:center;"> P.F.28 </th>
   <th style="text-align:center;"> P.F.29 </th>
   <th style="text-align:center;"> P.F.30 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 6246.314 </td>
   <td style="text-align:center;"> 6373.603 </td>
   <td style="text-align:center;"> 6500.893 </td>
   <td style="text-align:center;"> 6628.183 </td>
   <td style="text-align:center;"> 6755.472 </td>
   <td style="text-align:center;"> 6882.762 </td>
   <td style="text-align:center;"> 7010.052 </td>
   <td style="text-align:center;"> 7137.341 </td>
   <td style="text-align:center;"> 7264.631 </td>
   <td style="text-align:center;"> 7391.921 </td>
   <td style="text-align:center;"> 7519.210 </td>
   <td style="text-align:center;"> 7646.5 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6649.379 </td>
   <td style="text-align:center;"> 6803.945 </td>
   <td style="text-align:center;"> 6958.510 </td>
   <td style="text-align:center;"> 7113.076 </td>
   <td style="text-align:center;"> 7267.641 </td>
   <td style="text-align:center;"> 7422.207 </td>
   <td style="text-align:center;"> 7576.772 </td>
   <td style="text-align:center;"> 7731.338 </td>
   <td style="text-align:center;"> 7885.903 </td>
   <td style="text-align:center;"> 8040.469 </td>
   <td style="text-align:center;"> 8195.034 </td>
   <td style="text-align:center;"> 8349.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6834.272 </td>
   <td style="text-align:center;"> 7003.993 </td>
   <td style="text-align:center;"> 7173.714 </td>
   <td style="text-align:center;"> 7343.434 </td>
   <td style="text-align:center;"> 7513.155 </td>
   <td style="text-align:center;"> 7682.876 </td>
   <td style="text-align:center;"> 7852.597 </td>
   <td style="text-align:center;"> 8022.317 </td>
   <td style="text-align:center;"> 8192.038 </td>
   <td style="text-align:center;"> 8361.759 </td>
   <td style="text-align:center;"> 8531.479 </td>
   <td style="text-align:center;"> 8701.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6288.748 </td>
   <td style="text-align:center;"> 6428.162 </td>
   <td style="text-align:center;"> 6567.576 </td>
   <td style="text-align:center;"> 6706.990 </td>
   <td style="text-align:center;"> 6846.403 </td>
   <td style="text-align:center;"> 6985.817 </td>
   <td style="text-align:center;"> 7125.231 </td>
   <td style="text-align:center;"> 7264.645 </td>
   <td style="text-align:center;"> 7404.059 </td>
   <td style="text-align:center;"> 7543.472 </td>
   <td style="text-align:center;"> 7682.886 </td>
   <td style="text-align:center;"> 7822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6479.666 </td>
   <td style="text-align:center;"> 6585.741 </td>
   <td style="text-align:center;"> 6691.817 </td>
   <td style="text-align:center;"> 6797.893 </td>
   <td style="text-align:center;"> 6903.969 </td>
   <td style="text-align:center;"> 7010.045 </td>
   <td style="text-align:center;"> 7116.121 </td>
   <td style="text-align:center;"> 7222.197 </td>
   <td style="text-align:center;"> 7328.272 </td>
   <td style="text-align:center;"> 7434.348 </td>
   <td style="text-align:center;"> 7540.424 </td>
   <td style="text-align:center;"> 7646.5 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6564.510 </td>
   <td style="text-align:center;"> 6694.828 </td>
   <td style="text-align:center;"> 6825.145 </td>
   <td style="text-align:center;"> 6955.462 </td>
   <td style="text-align:center;"> 7085.779 </td>
   <td style="text-align:center;"> 7216.097 </td>
   <td style="text-align:center;"> 7346.414 </td>
   <td style="text-align:center;"> 7476.731 </td>
   <td style="text-align:center;"> 7607.048 </td>
   <td style="text-align:center;"> 7737.366 </td>
   <td style="text-align:center;"> 7867.683 </td>
   <td style="text-align:center;"> 7998.0 </td>
  </tr>
</tbody>
</table>
 &nbsp; 

And the length of the series can also be specified:


{% highlight r %}
# Peak freq contour equal length 10 measurements
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak.Freq.Contour..Hz.",
equal.length = T, length.out = 10)  

kable(head(fcts), align = "c", row.names = FALSE,   format = "html")
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> P.F.1 </th>
   <th style="text-align:center;"> P.F.2 </th>
   <th style="text-align:center;"> P.F.3 </th>
   <th style="text-align:center;"> P.F.4 </th>
   <th style="text-align:center;"> P.F.5 </th>
   <th style="text-align:center;"> P.F.6 </th>
   <th style="text-align:center;"> P.F.7 </th>
   <th style="text-align:center;"> P.F.8 </th>
   <th style="text-align:center;"> P.F.9 </th>
   <th style="text-align:center;"> P.F.10 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3955.1 </td>
   <td style="text-align:center;"> 4365.256 </td>
   <td style="text-align:center;"> 4775.411 </td>
   <td style="text-align:center;"> 5185.567 </td>
   <td style="text-align:center;"> 5595.722 </td>
   <td style="text-align:center;"> 6005.878 </td>
   <td style="text-align:center;"> 6416.033 </td>
   <td style="text-align:center;"> 6826.189 </td>
   <td style="text-align:center;"> 7236.344 </td>
   <td style="text-align:center;"> 7646.5 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 3867.2 </td>
   <td style="text-align:center;"> 4365.244 </td>
   <td style="text-align:center;"> 4863.289 </td>
   <td style="text-align:center;"> 5361.333 </td>
   <td style="text-align:center;"> 5859.378 </td>
   <td style="text-align:center;"> 6357.422 </td>
   <td style="text-align:center;"> 6855.467 </td>
   <td style="text-align:center;"> 7353.511 </td>
   <td style="text-align:center;"> 7851.556 </td>
   <td style="text-align:center;"> 8349.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 3779.3 </td>
   <td style="text-align:center;"> 4326.178 </td>
   <td style="text-align:center;"> 4873.056 </td>
   <td style="text-align:center;"> 5419.933 </td>
   <td style="text-align:center;"> 5966.811 </td>
   <td style="text-align:center;"> 6513.689 </td>
   <td style="text-align:center;"> 7060.567 </td>
   <td style="text-align:center;"> 7607.444 </td>
   <td style="text-align:center;"> 8154.322 </td>
   <td style="text-align:center;"> 8701.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 3779.3 </td>
   <td style="text-align:center;"> 4228.522 </td>
   <td style="text-align:center;"> 4677.744 </td>
   <td style="text-align:center;"> 5126.967 </td>
   <td style="text-align:center;"> 5576.189 </td>
   <td style="text-align:center;"> 6025.411 </td>
   <td style="text-align:center;"> 6474.633 </td>
   <td style="text-align:center;"> 6923.856 </td>
   <td style="text-align:center;"> 7373.078 </td>
   <td style="text-align:center;"> 7822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 4570.3 </td>
   <td style="text-align:center;"> 4912.100 </td>
   <td style="text-align:center;"> 5253.900 </td>
   <td style="text-align:center;"> 5595.700 </td>
   <td style="text-align:center;"> 5937.500 </td>
   <td style="text-align:center;"> 6279.300 </td>
   <td style="text-align:center;"> 6621.100 </td>
   <td style="text-align:center;"> 6962.900 </td>
   <td style="text-align:center;"> 7304.700 </td>
   <td style="text-align:center;"> 7646.5 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 4218.8 </td>
   <td style="text-align:center;"> 4638.711 </td>
   <td style="text-align:center;"> 5058.622 </td>
   <td style="text-align:center;"> 5478.533 </td>
   <td style="text-align:center;"> 5898.444 </td>
   <td style="text-align:center;"> 6318.356 </td>
   <td style="text-align:center;"> 6738.267 </td>
   <td style="text-align:center;"> 7158.178 </td>
   <td style="text-align:center;"> 7578.089 </td>
   <td style="text-align:center;"> 7998.0 </td>
  </tr>
</tbody>
</table>
 &nbsp; 

The time series data frame can be directly input into the `dfDTW` [warbleR](https://cran.r-project.org/package=warbleR) function to calculate [Dynamic Time Warping](https://en.wikipedia.org/wiki/Dynamic_time_warping) distances:


{% highlight r %}
dfDTW(ts.df = fcts)
{% endhighlight %}



{% highlight text %}
                  Phae.long1.wav-1 Phae.long1.wav-2 Phae.long1.wav-3 Phae.long2.wav-4 Phae.long2.wav-5 Phae.long3.wav-6 Phae.long3.wav-7
Phae.long1.wav-1             0.000         2665.922         3652.378         1777.533         2255.756         2402.544         3007.411
Phae.long1.wav-2          2665.922            0.000         2734.500         2744.233         3456.878         3027.333         3427.622
Phae.long1.wav-3          3652.378         2734.500            0.000         3515.600         4287.078         3340.089         3730.722
Phae.long2.wav-4          1777.533         2744.233         3515.600            0.000         3046.867         2783.167         3261.922
Phae.long2.wav-5          2255.756         3456.878         4287.078         3046.867            0.000         2539.122         2265.967
Phae.long3.wav-6          2402.544         3027.333         3340.089         2783.167         2539.122            0.000         2060.578
Phae.long3.wav-7          3007.411         3427.622         3730.722         3261.922         2265.967         2060.578            0.000
Phae.long3.wav-8          3251.644         3896.578         4423.944         3818.556          868.900         2636.633         2031.244
Phae.long4.wav-9          4218.800         3486.478         3047.033         3750.033         5244.222         3613.667         4609.611
                  Phae.long3.wav-8 Phae.long4.wav-9 Phae.long4.wav-10 Phae.long4.wav-11
Phae.long1.wav-1          3251.644         4218.800          4609.500          4169.867
Phae.long1.wav-2          3896.578         3486.478          3583.922          3242.167
Phae.long1.wav-3          4423.944         3047.033          2773.678          3310.367
Phae.long2.wav-4          3818.556         3750.033          4179.911          3486.267
Phae.long2.wav-5           868.900         5244.222          5420.067          5722.533
Phae.long3.wav-6          2636.633         3613.667          4033.744          4619.300
Phae.long3.wav-7          2031.244         4609.611          5078.578          5751.878
Phae.long3.wav-8             0.000         5351.944          5645.189          6503.867
Phae.long4.wav-9          5351.944            0.000          1758.000          4814.789
 [ reached getOption("max.print") -- omitted 2 rows ]
{% endhighlight %}

---

### *relabel_colms*

This is a very simple function to relabel columns so they match the selection table format used in [warbleR](https://cran.r-project.org/package=warbleR):


{% highlight r %}
#to simplify the example select a subset of the columns 
st1 <- rvn.dat[ ,1:7]

#check original column names
st1
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> Selection </th>
   <th style="text-align:center;"> View </th>
   <th style="text-align:center;"> Channel </th>
   <th style="text-align:center;"> Begin.Time..s. </th>
   <th style="text-align:center;"> End.Time..s. </th>
   <th style="text-align:center;"> Low.Freq..Hz. </th>
   <th style="text-align:center;"> High.Freq..Hz. </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.169 </td>
   <td style="text-align:center;"> 1.3420334 </td>
   <td style="text-align:center;"> 2220.1 </td>
   <td style="text-align:center;"> 8604.4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.158 </td>
   <td style="text-align:center;"> 2.3210480 </td>
   <td style="text-align:center;"> 2169.4 </td>
   <td style="text-align:center;"> 8807.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.343 </td>
   <td style="text-align:center;"> 0.5179187 </td>
   <td style="text-align:center;"> 2218.3 </td>
   <td style="text-align:center;"> 8756.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.160 </td>
   <td style="text-align:center;"> 0.2925709 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.457 </td>
   <td style="text-align:center;"> 1.5831502 </td>
   <td style="text-align:center;"> 2284.0 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.627 </td>
   <td style="text-align:center;"> 0.7582195 </td>
   <td style="text-align:center;"> 3006.8 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.974 </td>
   <td style="text-align:center;"> 2.1041789 </td>
   <td style="text-align:center;"> 2776.8 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.123 </td>
   <td style="text-align:center;"> 0.2542170 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 9315.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.517 </td>
   <td style="text-align:center;"> 1.6624249 </td>
   <td style="text-align:center;"> 2514.0 </td>
   <td style="text-align:center;"> 9216.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.933 </td>
   <td style="text-align:center;"> 3.0771864 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 10235.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.2900989 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 9742.3 </td>
  </tr>
</tbody>
</table>



{% highlight r %}
# Relabel the basic columns required by warbleR
relabel_colms(st1)
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> View </th>
   <th style="text-align:center;"> Channel </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.169 </td>
   <td style="text-align:center;"> 1.3420334 </td>
   <td style="text-align:center;"> 2220.1 </td>
   <td style="text-align:center;"> 8604.4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.158 </td>
   <td style="text-align:center;"> 2.3210480 </td>
   <td style="text-align:center;"> 2169.4 </td>
   <td style="text-align:center;"> 8807.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.343 </td>
   <td style="text-align:center;"> 0.5179187 </td>
   <td style="text-align:center;"> 2218.3 </td>
   <td style="text-align:center;"> 8756.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.160 </td>
   <td style="text-align:center;"> 0.2925709 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.457 </td>
   <td style="text-align:center;"> 1.5831502 </td>
   <td style="text-align:center;"> 2284.0 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.627 </td>
   <td style="text-align:center;"> 0.7582195 </td>
   <td style="text-align:center;"> 3006.8 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.974 </td>
   <td style="text-align:center;"> 2.1041789 </td>
   <td style="text-align:center;"> 2776.8 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.123 </td>
   <td style="text-align:center;"> 0.2542170 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 9315.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.517 </td>
   <td style="text-align:center;"> 1.6624249 </td>
   <td style="text-align:center;"> 2514.0 </td>
   <td style="text-align:center;"> 9216.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.933 </td>
   <td style="text-align:center;"> 3.0771864 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 10235.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.2900989 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 9742.3 </td>
  </tr>
</tbody>
</table>
 &nbsp; 

Additional columns can also be relabeled:

{% highlight r %}
# 2 additional column 
relabel_colms(st1, extra.cols.name = c("selec.file", "View"),
              extra.cols.new.name = c("Raven selection file", "Raven view"))
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> Raven view </th>
   <th style="text-align:center;"> Channel </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.169 </td>
   <td style="text-align:center;"> 1.3420334 </td>
   <td style="text-align:center;"> 2220.1 </td>
   <td style="text-align:center;"> 8604.4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.158 </td>
   <td style="text-align:center;"> 2.3210480 </td>
   <td style="text-align:center;"> 2169.4 </td>
   <td style="text-align:center;"> 8807.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.343 </td>
   <td style="text-align:center;"> 0.5179187 </td>
   <td style="text-align:center;"> 2218.3 </td>
   <td style="text-align:center;"> 8756.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.160 </td>
   <td style="text-align:center;"> 0.2925709 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.457 </td>
   <td style="text-align:center;"> 1.5831502 </td>
   <td style="text-align:center;"> 2284.0 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.627 </td>
   <td style="text-align:center;"> 0.7582195 </td>
   <td style="text-align:center;"> 3006.8 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.974 </td>
   <td style="text-align:center;"> 2.1041789 </td>
   <td style="text-align:center;"> 2776.8 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.123 </td>
   <td style="text-align:center;"> 0.2542170 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 9315.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.517 </td>
   <td style="text-align:center;"> 1.6624249 </td>
   <td style="text-align:center;"> 2514.0 </td>
   <td style="text-align:center;"> 9216.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.933 </td>
   <td style="text-align:center;"> 3.0771864 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 10235.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.2900989 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 9742.3 </td>
  </tr>
</tbody>
</table>
 &nbsp; 

---

### *imp_corr_mat*

The function imports the output of a batch correlation routine in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html). Both the correlation and lag matrices contained in the output '.txt' file are read and both waveform and spectrogram (cross-correlation) correlations can be imported. 

This example shows how to input the sound files into [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) and how to bring the results back to R. First, the selections need to be cut as single sound files for the [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) correlator to be able to read it. We can do this using the `cut_sels` function from [warbleR](https://cran.r-project.org/package=warbleR):


{% highlight r %}
#create new folder to put cuts
dir.create("cuts")

# add a rowname column to be able to match cuts and selections
selec.table$rownames <- sprintf("%02d",1:nrow(selec.table))

# cut files
cut_sels(X = selec.table, mar = 0.05, path = tempdir(), dest.path = file.path(tempdir(), "cuts"), labels = c("rownames", "sound.files", "selec"), pb = FALSE)

#list cuts
list.files(path = file.path(tempdir(), "cuts"))
{% endhighlight %}
 &nbsp; 
 
Every selection is in its own sound file (labeled as `paste(sound.files, selec)`). Now open [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) and run the batch correlator on the 'cuts' folder as follows:

![gif1](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/raven_correlator.gif)
 &nbsp; 

And then import the output file into R:
 

{% highlight r %}
# Import output (change the name of the file if you used a different one)
xcorr.rav <- imp_corr_mat(file = "BatchCorrOutput.txt", path = tempdir())
{% endhighlight %}


{% highlight text %}
Error in file(con, "r"): cannot open the connection
{% endhighlight %}
 &nbsp; 
 
The function returns a list containing the correlation matrix (here only showing the first 5 rows/columns):


{% highlight r %}
xcorr.rav$correlation[1:5, 1:5]
{% endhighlight %}



{% highlight text %}
Error in eval(expr, envir, enclos): object 'xcorr.rav' not found
{% endhighlight %}
 &nbsp; 
 
and the time lag matrix:


{% highlight r %}
xcorr.rav$`lag (s)`[1:5, 1:5]
{% endhighlight %}



{% highlight text %}
Error in eval(expr, envir, enclos): object 'xcorr.rav' not found
{% endhighlight %}
 &nbsp; 
 
This output is ready for stats. For instance, the following code runs a mantel test between cross-correlation (converted to distances) and [warbleR](https://cran.r-project.org/package=warbleR) spectral parameter pairwise dissimilarities:


{% highlight r %}
#convert cross-corr to distance
xcorr.rvn <- 1- xcorr.rav$correlation
{% endhighlight %}



{% highlight text %}
Error in eval(expr, envir, enclos): object 'xcorr.rav' not found
{% endhighlight %}



{% highlight r %}
#sort matrix to match selection table
xcorr.rvn <- xcorr.rvn[order(rownames(xcorr.rvn)), order(colnames(xcorr.rvn))]
{% endhighlight %}



{% highlight text %}
Error in eval(expr, envir, enclos): object 'xcorr.rvn' not found
{% endhighlight %}



{% highlight r %}
#convert it to distance matrix
xcorr.rvn <- as.dist(xcorr.rvn)
{% endhighlight %}



{% highlight text %}
Error in as.dist(xcorr.rvn): object 'xcorr.rvn' not found
{% endhighlight %}



{% highlight r %}
# measure acoustic parameters
sp.wrblR <- specan(selec.table, bp = c(1, 11), wl = 150, pb = FALSE)

#convert them to distance matrix
dist.sp.wrblR <- dist(sp.wrblR)

vegan::mantel(xcorr.rvn, dist.sp.wrblR)
{% endhighlight %}



{% highlight text %}
Error in as.dist(xdis): object 'xcorr.rvn' not found
{% endhighlight %}
 &nbsp; 

There is actually a good match between two types of analysis!

---
 
 
## Exporting R data to Raven

### *exp_raven*

*exp_raven* saves a selection table in '.txt' format that can be directly opened in Raven. No objects are returned into the R environment. The following code exports a data table from a single sound file:


{% highlight r %}
# Select data for a single sound file
st1 <- selec.table[selec.table$sound.files == "Phae.long1.wav",]

# Export data of a single sound file
exp_raven(st1, file.name = "Phaethornis 1", khz.to.hz = TRUE)
{% endhighlight %}
 &nbsp; 
 
If the path to the sound file is provided, the functions exports a 'sound selection table' which can be directly open by [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) (and which will also open the associated sound file):


{% highlight r %}
# Select data for a single sound file
st1 <- selec.table[selec.table$sound.files == "Phae.long1.wav",]

# Export data of a single sound file
exp_raven(st1, file.name = "Phaethornis 1", khz.to.hz = TRUE, sound.file.path = tempdir())
{% endhighlight %}
![gif2](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/exp_raven1.gif)
 &nbsp; 

This is useful to add new selections or even new measurements:

![gif3](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/exp_raven2.gif)
 &nbsp; 

If several sound files are available, users can either export them as a single selection file or as multiple selection files (one for each sound file). This example creates a multiple sound file selection:


{% highlight r %}
exp_raven(X = selec.table, file.name = "Phaethornis multiple sound files", 
sound.file.path = tempdir(), single.file = TRUE)
{% endhighlight %}
 &nbsp; 

These type of tables can be opened as a multiple file display in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html):

![gif4](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/exp_raven3.gif)
 &nbsp; 

---

## Running Raven from R

### *run_raven*

The function opens multiple sound files simultaneously in  [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html). When the analysis is finished (and the  [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) window is closed) the data can be automatically imported back into R using the 'import' argument. Note that [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html), unlike R, can also handle files in 'mp3', 'flac' and 'aif' format . 



{% highlight r %}
# here replace with the path where Raven is install in your computer
raven.path <- "PATH_TO_RAVEN_DIRECTORY_HERE" 

# run function 
run_raven(raven.path = raven.path, sound.files = c("Phae.long1.wav", "Phae.long2.wav", "Phae.long3.wav", "Phae.long4.wav"), import = TRUE, 
 all.data = TRUE)  
{% endhighlight %}

![gif5](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/run_raven1.gif)
 &nbsp; 
 
See `imp_raven` above for more details on additional settings when importing selections.

---

### *raven_batch_detec*

As the name suggests, *raven_batch_detec* runs [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) detector on multiple sound files (sequentially). Batch detection in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) can also take files in 'mp3', 'flac' and 'aif' format (although this could not be further analyzed in R!).

This is example runs the detector on one of the example sound files that comes by default with [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html):


{% highlight r %}
detec.res <- raven_batch_detec(raven.path = raven.path, 
sound.files = "BlackCappedVireo.aif", path = file.path(raven.path, "Examples"))
{% endhighlight %}

![gif6](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/raven_batch_detec.gif)
 &nbsp; 
 
---

Please report any bugs [here](https://github.com/maRce10/Rraven/issues). The `Rraven` package should be cited as follows: 

Araya-Salas. (2017), *Rraven: connecting R and Raven bioacoustic software*. R package version 1.0.0.



