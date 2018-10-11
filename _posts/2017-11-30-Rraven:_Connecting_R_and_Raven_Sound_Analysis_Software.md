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
 
Let's also use a temporary folder as the working directory in which to save all sound and data files:


{% highlight r %}
setwd(tempdir())

#load example data
data(list = c("Phae.long1", "Phae.long2", "Phae.long3", "Phae.long4", 
              "selec.table", "selection_files"))

# save sound files  in temporary directory
writeWave(Phae.long1,"Phae.long1.wav", extensible = FALSE)
writeWave(Phae.long2,"Phae.long2.wav", extensible = FALSE)
writeWave(Phae.long3,"Phae.long3.wav", extensible = FALSE)
writeWave(Phae.long4,"Phae.long4.wav", extensible = FALSE)

#save Raven selection tables in the temporary directory
out <- lapply(1:4, function(x)
writeLines(selection_files[[x]], con = names(selection_files)[x]))

# this is the temporary directory location (of course different each 
# time is run)
getwd() 
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

rvn.dat
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 1px; overflow-y: scroll; height:900px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> Selection </th>
   <th style="text-align:center;"> View </th>
   <th style="text-align:center;"> Channel </th>
   <th style="text-align:center;"> Begin Time (s) </th>
   <th style="text-align:center;"> End Time (s) </th>
   <th style="text-align:center;"> Low Freq (Hz) </th>
   <th style="text-align:center;"> High Freq (Hz) </th>
   <th style="text-align:center;"> Begin File </th>
   <th style="text-align:center;"> channel </th>
   <th style="text-align:center;"> Begin Path </th>
   <th style="text-align:center;"> File Offset (s) </th>
   <th style="text-align:center;"> selec.file </th>
   <th style="text-align:center;"> File Offset </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.169 </td>
   <td style="text-align:center;"> 1.342 </td>
   <td style="text-align:center;"> 2220 </td>
   <td style="text-align:center;"> 8604 </td>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:center;"> 1.169 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.158 </td>
   <td style="text-align:center;"> 2.321 </td>
   <td style="text-align:center;"> 2169 </td>
   <td style="text-align:center;"> 8807 </td>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:center;"> 2.158 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.343 </td>
   <td style="text-align:center;"> 0.518 </td>
   <td style="text-align:center;"> 2218 </td>
   <td style="text-align:center;"> 8757 </td>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long1.wav </td>
   <td style="text-align:center;"> 0.343 </td>
   <td style="text-align:center;"> LBH 1 selection table example.txt </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.160 </td>
   <td style="text-align:center;"> 0.292 </td>
   <td style="text-align:center;"> 2317 </td>
   <td style="text-align:center;"> 8822 </td>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long2.wav </td>
   <td style="text-align:center;"> 0.160 </td>
   <td style="text-align:center;"> LBH 2 selection table example.txt </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.457 </td>
   <td style="text-align:center;"> 1.583 </td>
   <td style="text-align:center;"> 2284 </td>
   <td style="text-align:center;"> 8888 </td>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long2.wav </td>
   <td style="text-align:center;"> 1.457 </td>
   <td style="text-align:center;"> LBH 2 selection table example.txt </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.627 </td>
   <td style="text-align:center;"> 0.758 </td>
   <td style="text-align:center;"> 3007 </td>
   <td style="text-align:center;"> 8822 </td>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long3.wav </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> LBH 3 selection table example.txt </td>
   <td style="text-align:center;"> 0.627 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.974 </td>
   <td style="text-align:center;"> 2.104 </td>
   <td style="text-align:center;"> 2777 </td>
   <td style="text-align:center;"> 8888 </td>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long3.wav </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> LBH 3 selection table example.txt </td>
   <td style="text-align:center;"> 1.974 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.123 </td>
   <td style="text-align:center;"> 0.255 </td>
   <td style="text-align:center;"> 2317 </td>
   <td style="text-align:center;"> 9315 </td>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long3.wav </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> LBH 3 selection table example.txt </td>
   <td style="text-align:center;"> 0.123 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.517 </td>
   <td style="text-align:center;"> 1.662 </td>
   <td style="text-align:center;"> 2514 </td>
   <td style="text-align:center;"> 9217 </td>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long4.wav </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> LBH 4 selection table example.txt </td>
   <td style="text-align:center;"> 1.517 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.933 </td>
   <td style="text-align:center;"> 3.077 </td>
   <td style="text-align:center;"> 2580 </td>
   <td style="text-align:center;"> 10235 </td>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long4.wav </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> LBH 4 selection table example.txt </td>
   <td style="text-align:center;"> 2.933 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.290 </td>
   <td style="text-align:center;"> 2580 </td>
   <td style="text-align:center;"> 9742 </td>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> /tmp/RtmpWpOeaR/Phae.long4.wav </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> LBH 4 selection table example.txt </td>
   <td style="text-align:center;"> 0.145 </td>
  </tr>
</tbody>
</table></div>
 &nbsp; 
 
Note that the 'waveform' view data has been removed. It can also be imported by setting the 'waveform' argument to `TRUE`. 


[Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) selections can also be imported in a 'selection.table' format so it can be directly input into [warbleR](https://cran.r-project.org/package=warbleR) functions. To do this you need to set the `all.data = FALSE` and indicate which column contains the sound file name (using the 'sound.file.col' argument): 


{% highlight r %}
#providing the name of the column with the sound file names
rvn.dat <- imp_raven(sound.file.col = "Begin File", all.data = FALSE, 
                     freq.cols = TRUE)

rvn.dat
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> channel.Channel </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.169 </td>
   <td style="text-align:center;"> 1.342 </td>
   <td style="text-align:center;"> 2.22 </td>
   <td style="text-align:center;"> 8.60 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2.158 </td>
   <td style="text-align:center;"> 2.321 </td>
   <td style="text-align:center;"> 2.17 </td>
   <td style="text-align:center;"> 8.81 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.343 </td>
   <td style="text-align:center;"> 0.518 </td>
   <td style="text-align:center;"> 2.22 </td>
   <td style="text-align:center;"> 8.76 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.160 </td>
   <td style="text-align:center;"> 0.292 </td>
   <td style="text-align:center;"> 2.32 </td>
   <td style="text-align:center;"> 8.82 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.457 </td>
   <td style="text-align:center;"> 1.583 </td>
   <td style="text-align:center;"> 2.28 </td>
   <td style="text-align:center;"> 8.89 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.627 </td>
   <td style="text-align:center;"> 0.758 </td>
   <td style="text-align:center;"> 3.01 </td>
   <td style="text-align:center;"> 8.82 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.974 </td>
   <td style="text-align:center;"> 2.104 </td>
   <td style="text-align:center;"> 2.78 </td>
   <td style="text-align:center;"> 8.89 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.123 </td>
   <td style="text-align:center;"> 0.255 </td>
   <td style="text-align:center;"> 2.32 </td>
   <td style="text-align:center;"> 9.31 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.517 </td>
   <td style="text-align:center;"> 1.662 </td>
   <td style="text-align:center;"> 2.51 </td>
   <td style="text-align:center;"> 9.22 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2.933 </td>
   <td style="text-align:center;"> 3.077 </td>
   <td style="text-align:center;"> 2.58 </td>
   <td style="text-align:center;"> 10.23 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.290 </td>
   <td style="text-align:center;"> 2.58 </td>
   <td style="text-align:center;"> 9.74 </td>
  </tr>
</tbody>
</table></div>
 &nbsp; 
 
The data frame contains the following columns: sound.files, channel, selec, start, end, and selec.file. You can also import the frequency range parameters in the 'selection.table' by setting 'freq.cols' tp `TRUE`. The data frame returned by "imp_raven" (when in the 'warbleR' format) can be input into several [warbleR](https://cran.r-project.org/package=warbleR) functions for further analysis. For instance, the following code runs additional parameter measurements on the imported selections:


{% highlight r %}
# convert to class selection.table
rvn.dat.st <- selection_table(rvn.dat)

sp <- specan(X = rvn.dat.st, bp = "frange", wl = 150, pb = FALSE, 
             ovlp = 90)

sp
{% endhighlight %}


{% highlight text %}
checking selections:
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
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
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.173 </td>
   <td style="text-align:center;"> 5.98 </td>
   <td style="text-align:center;"> 1.40 </td>
   <td style="text-align:center;"> 6.33 </td>
   <td style="text-align:center;"> 5.30 </td>
   <td style="text-align:center;"> 6.87 </td>
   <td style="text-align:center;"> 1.57 </td>
   <td style="text-align:center;"> 0.076 </td>
   <td style="text-align:center;"> 0.047 </td>
   <td style="text-align:center;"> 0.117 </td>
   <td style="text-align:center;"> 0.071 </td>
   <td style="text-align:center;"> 2.00 </td>
   <td style="text-align:center;"> 7.02 </td>
   <td style="text-align:center;"> 0.943 </td>
   <td style="text-align:center;"> 0.887 </td>
   <td style="text-align:center;"> 0.837 </td>
   <td style="text-align:center;"> 0.651 </td>
   <td style="text-align:center;"> 6.40 </td>
   <td style="text-align:center;"> 3.75 </td>
   <td style="text-align:center;"> 8.25 </td>
   <td style="text-align:center;"> 4.50 </td>
   <td style="text-align:center;"> 8.60 </td>
   <td style="text-align:center;"> 6.90 </td>
   <td style="text-align:center;"> 7.50 </td>
   <td style="text-align:center;"> 3.47 </td>
   <td style="text-align:center;"> 7.12 </td>
   <td style="text-align:center;"> 2.22 </td>
   <td style="text-align:center;"> 8.60 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.163 </td>
   <td style="text-align:center;"> 6.00 </td>
   <td style="text-align:center;"> 1.42 </td>
   <td style="text-align:center;"> 6.21 </td>
   <td style="text-align:center;"> 5.33 </td>
   <td style="text-align:center;"> 6.88 </td>
   <td style="text-align:center;"> 1.55 </td>
   <td style="text-align:center;"> 0.077 </td>
   <td style="text-align:center;"> 0.044 </td>
   <td style="text-align:center;"> 0.116 </td>
   <td style="text-align:center;"> 0.072 </td>
   <td style="text-align:center;"> 1.92 </td>
   <td style="text-align:center;"> 7.33 </td>
   <td style="text-align:center;"> 0.947 </td>
   <td style="text-align:center;"> 0.889 </td>
   <td style="text-align:center;"> 0.841 </td>
   <td style="text-align:center;"> 0.668 </td>
   <td style="text-align:center;"> 6.64 </td>
   <td style="text-align:center;"> 3.90 </td>
   <td style="text-align:center;"> 8.40 </td>
   <td style="text-align:center;"> 4.50 </td>
   <td style="text-align:center;"> 4.90 </td>
   <td style="text-align:center;"> 6.75 </td>
   <td style="text-align:center;"> 7.20 </td>
   <td style="text-align:center;"> 2.76 </td>
   <td style="text-align:center;"> 6.97 </td>
   <td style="text-align:center;"> 2.17 </td>
   <td style="text-align:center;"> 8.81 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.175 </td>
   <td style="text-align:center;"> 6.02 </td>
   <td style="text-align:center;"> 1.52 </td>
   <td style="text-align:center;"> 6.43 </td>
   <td style="text-align:center;"> 5.15 </td>
   <td style="text-align:center;"> 6.98 </td>
   <td style="text-align:center;"> 1.83 </td>
   <td style="text-align:center;"> 0.090 </td>
   <td style="text-align:center;"> 0.053 </td>
   <td style="text-align:center;"> 0.128 </td>
   <td style="text-align:center;"> 0.074 </td>
   <td style="text-align:center;"> 2.50 </td>
   <td style="text-align:center;"> 11.14 </td>
   <td style="text-align:center;"> 0.945 </td>
   <td style="text-align:center;"> 0.887 </td>
   <td style="text-align:center;"> 0.838 </td>
   <td style="text-align:center;"> 0.672 </td>
   <td style="text-align:center;"> 6.50 </td>
   <td style="text-align:center;"> 2.25 </td>
   <td style="text-align:center;"> 8.55 </td>
   <td style="text-align:center;"> 6.30 </td>
   <td style="text-align:center;"> 11.19 </td>
   <td style="text-align:center;"> 8.40 </td>
   <td style="text-align:center;"> 7.20 </td>
   <td style="text-align:center;"> -6.86 </td>
   <td style="text-align:center;"> 7.12 </td>
   <td style="text-align:center;"> 2.22 </td>
   <td style="text-align:center;"> 8.76 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.133 </td>
   <td style="text-align:center;"> 6.40 </td>
   <td style="text-align:center;"> 1.34 </td>
   <td style="text-align:center;"> 6.60 </td>
   <td style="text-align:center;"> 5.61 </td>
   <td style="text-align:center;"> 7.38 </td>
   <td style="text-align:center;"> 1.77 </td>
   <td style="text-align:center;"> 0.077 </td>
   <td style="text-align:center;"> 0.054 </td>
   <td style="text-align:center;"> 0.104 </td>
   <td style="text-align:center;"> 0.049 </td>
   <td style="text-align:center;"> 1.57 </td>
   <td style="text-align:center;"> 6.02 </td>
   <td style="text-align:center;"> 0.942 </td>
   <td style="text-align:center;"> 0.895 </td>
   <td style="text-align:center;"> 0.844 </td>
   <td style="text-align:center;"> 0.609 </td>
   <td style="text-align:center;"> 6.41 </td>
   <td style="text-align:center;"> 4.80 </td>
   <td style="text-align:center;"> 7.95 </td>
   <td style="text-align:center;"> 3.15 </td>
   <td style="text-align:center;"> 11.14 </td>
   <td style="text-align:center;"> 5.85 </td>
   <td style="text-align:center;"> 6.15 </td>
   <td style="text-align:center;"> 2.26 </td>
   <td style="text-align:center;"> 7.42 </td>
   <td style="text-align:center;"> 2.32 </td>
   <td style="text-align:center;"> 8.82 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.126 </td>
   <td style="text-align:center;"> 6.31 </td>
   <td style="text-align:center;"> 1.37 </td>
   <td style="text-align:center;"> 6.60 </td>
   <td style="text-align:center;"> 5.61 </td>
   <td style="text-align:center;"> 7.21 </td>
   <td style="text-align:center;"> 1.60 </td>
   <td style="text-align:center;"> 0.076 </td>
   <td style="text-align:center;"> 0.053 </td>
   <td style="text-align:center;"> 0.098 </td>
   <td style="text-align:center;"> 0.045 </td>
   <td style="text-align:center;"> 2.47 </td>
   <td style="text-align:center;"> 10.88 </td>
   <td style="text-align:center;"> 0.936 </td>
   <td style="text-align:center;"> 0.898 </td>
   <td style="text-align:center;"> 0.840 </td>
   <td style="text-align:center;"> 0.615 </td>
   <td style="text-align:center;"> 6.10 </td>
   <td style="text-align:center;"> 3.00 </td>
   <td style="text-align:center;"> 7.65 </td>
   <td style="text-align:center;"> 4.65 </td>
   <td style="text-align:center;"> 9.58 </td>
   <td style="text-align:center;"> 5.55 </td>
   <td style="text-align:center;"> 5.70 </td>
   <td style="text-align:center;"> 1.19 </td>
   <td style="text-align:center;"> 6.67 </td>
   <td style="text-align:center;"> 2.28 </td>
   <td style="text-align:center;"> 8.89 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.131 </td>
   <td style="text-align:center;"> 6.61 </td>
   <td style="text-align:center;"> 1.09 </td>
   <td style="text-align:center;"> 6.67 </td>
   <td style="text-align:center;"> 6.07 </td>
   <td style="text-align:center;"> 7.35 </td>
   <td style="text-align:center;"> 1.28 </td>
   <td style="text-align:center;"> 0.064 </td>
   <td style="text-align:center;"> 0.043 </td>
   <td style="text-align:center;"> 0.090 </td>
   <td style="text-align:center;"> 0.047 </td>
   <td style="text-align:center;"> 1.77 </td>
   <td style="text-align:center;"> 6.63 </td>
   <td style="text-align:center;"> 0.930 </td>
   <td style="text-align:center;"> 0.896 </td>
   <td style="text-align:center;"> 0.833 </td>
   <td style="text-align:center;"> 0.570 </td>
   <td style="text-align:center;"> 6.68 </td>
   <td style="text-align:center;"> 4.80 </td>
   <td style="text-align:center;"> 8.10 </td>
   <td style="text-align:center;"> 3.30 </td>
   <td style="text-align:center;"> 11.04 </td>
   <td style="text-align:center;"> 5.40 </td>
   <td style="text-align:center;"> 7.95 </td>
   <td style="text-align:center;"> 19.43 </td>
   <td style="text-align:center;"> 6.67 </td>
   <td style="text-align:center;"> 3.01 </td>
   <td style="text-align:center;"> 8.82 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.130 </td>
   <td style="text-align:center;"> 6.64 </td>
   <td style="text-align:center;"> 1.12 </td>
   <td style="text-align:center;"> 6.67 </td>
   <td style="text-align:center;"> 6.11 </td>
   <td style="text-align:center;"> 7.43 </td>
   <td style="text-align:center;"> 1.32 </td>
   <td style="text-align:center;"> 0.068 </td>
   <td style="text-align:center;"> 0.046 </td>
   <td style="text-align:center;"> 0.094 </td>
   <td style="text-align:center;"> 0.048 </td>
   <td style="text-align:center;"> 1.55 </td>
   <td style="text-align:center;"> 4.97 </td>
   <td style="text-align:center;"> 0.923 </td>
   <td style="text-align:center;"> 0.896 </td>
   <td style="text-align:center;"> 0.828 </td>
   <td style="text-align:center;"> 0.532 </td>
   <td style="text-align:center;"> 6.58 </td>
   <td style="text-align:center;"> 4.50 </td>
   <td style="text-align:center;"> 8.10 </td>
   <td style="text-align:center;"> 3.60 </td>
   <td style="text-align:center;"> 9.92 </td>
   <td style="text-align:center;"> 5.55 </td>
   <td style="text-align:center;"> 6.45 </td>
   <td style="text-align:center;"> 6.91 </td>
   <td style="text-align:center;"> 6.67 </td>
   <td style="text-align:center;"> 2.78 </td>
   <td style="text-align:center;"> 8.89 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.131 </td>
   <td style="text-align:center;"> 6.59 </td>
   <td style="text-align:center;"> 1.25 </td>
   <td style="text-align:center;"> 6.66 </td>
   <td style="text-align:center;"> 6.04 </td>
   <td style="text-align:center;"> 7.39 </td>
   <td style="text-align:center;"> 1.36 </td>
   <td style="text-align:center;"> 0.065 </td>
   <td style="text-align:center;"> 0.041 </td>
   <td style="text-align:center;"> 0.092 </td>
   <td style="text-align:center;"> 0.051 </td>
   <td style="text-align:center;"> 1.80 </td>
   <td style="text-align:center;"> 5.89 </td>
   <td style="text-align:center;"> 0.919 </td>
   <td style="text-align:center;"> 0.896 </td>
   <td style="text-align:center;"> 0.824 </td>
   <td style="text-align:center;"> 0.526 </td>
   <td style="text-align:center;"> 6.47 </td>
   <td style="text-align:center;"> 4.65 </td>
   <td style="text-align:center;"> 8.10 </td>
   <td style="text-align:center;"> 3.45 </td>
   <td style="text-align:center;"> 11.17 </td>
   <td style="text-align:center;"> 4.95 </td>
   <td style="text-align:center;"> 6.90 </td>
   <td style="text-align:center;"> 14.86 </td>
   <td style="text-align:center;"> 6.67 </td>
   <td style="text-align:center;"> 2.32 </td>
   <td style="text-align:center;"> 9.31 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 6.22 </td>
   <td style="text-align:center;"> 1.48 </td>
   <td style="text-align:center;"> 6.24 </td>
   <td style="text-align:center;"> 5.46 </td>
   <td style="text-align:center;"> 7.31 </td>
   <td style="text-align:center;"> 1.85 </td>
   <td style="text-align:center;"> 0.080 </td>
   <td style="text-align:center;"> 0.044 </td>
   <td style="text-align:center;"> 0.110 </td>
   <td style="text-align:center;"> 0.066 </td>
   <td style="text-align:center;"> 1.27 </td>
   <td style="text-align:center;"> 4.46 </td>
   <td style="text-align:center;"> 0.964 </td>
   <td style="text-align:center;"> 0.892 </td>
   <td style="text-align:center;"> 0.861 </td>
   <td style="text-align:center;"> 0.760 </td>
   <td style="text-align:center;"> 6.15 </td>
   <td style="text-align:center;"> 3.30 </td>
   <td style="text-align:center;"> 8.70 </td>
   <td style="text-align:center;"> 5.40 </td>
   <td style="text-align:center;"> 8.28 </td>
   <td style="text-align:center;"> 8.40 </td>
   <td style="text-align:center;"> 3.30 </td>
   <td style="text-align:center;"> -35.07 </td>
   <td style="text-align:center;"> 6.22 </td>
   <td style="text-align:center;"> 2.51 </td>
   <td style="text-align:center;"> 9.22 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.144 </td>
   <td style="text-align:center;"> 6.47 </td>
   <td style="text-align:center;"> 1.59 </td>
   <td style="text-align:center;"> 6.34 </td>
   <td style="text-align:center;"> 5.63 </td>
   <td style="text-align:center;"> 7.58 </td>
   <td style="text-align:center;"> 1.94 </td>
   <td style="text-align:center;"> 0.082 </td>
   <td style="text-align:center;"> 0.043 </td>
   <td style="text-align:center;"> 0.107 </td>
   <td style="text-align:center;"> 0.064 </td>
   <td style="text-align:center;"> 1.69 </td>
   <td style="text-align:center;"> 6.43 </td>
   <td style="text-align:center;"> 0.959 </td>
   <td style="text-align:center;"> 0.893 </td>
   <td style="text-align:center;"> 0.856 </td>
   <td style="text-align:center;"> 0.719 </td>
   <td style="text-align:center;"> 6.35 </td>
   <td style="text-align:center;"> 2.85 </td>
   <td style="text-align:center;"> 9.00 </td>
   <td style="text-align:center;"> 6.15 </td>
   <td style="text-align:center;"> 3.71 </td>
   <td style="text-align:center;"> 7.95 </td>
   <td style="text-align:center;"> 2.85 </td>
   <td style="text-align:center;"> -35.37 </td>
   <td style="text-align:center;"> 6.22 </td>
   <td style="text-align:center;"> 2.58 </td>
   <td style="text-align:center;"> 10.23 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 6.12 </td>
   <td style="text-align:center;"> 1.54 </td>
   <td style="text-align:center;"> 6.08 </td>
   <td style="text-align:center;"> 5.18 </td>
   <td style="text-align:center;"> 7.24 </td>
   <td style="text-align:center;"> 2.06 </td>
   <td style="text-align:center;"> 0.079 </td>
   <td style="text-align:center;"> 0.044 </td>
   <td style="text-align:center;"> 0.109 </td>
   <td style="text-align:center;"> 0.064 </td>
   <td style="text-align:center;"> 1.08 </td>
   <td style="text-align:center;"> 4.19 </td>
   <td style="text-align:center;"> 0.964 </td>
   <td style="text-align:center;"> 0.893 </td>
   <td style="text-align:center;"> 0.861 </td>
   <td style="text-align:center;"> 0.733 </td>
   <td style="text-align:center;"> 6.21 </td>
   <td style="text-align:center;"> 3.15 </td>
   <td style="text-align:center;"> 8.55 </td>
   <td style="text-align:center;"> 5.40 </td>
   <td style="text-align:center;"> 5.22 </td>
   <td style="text-align:center;"> 7.65 </td>
   <td style="text-align:center;"> 6.45 </td>
   <td style="text-align:center;"> -8.27 </td>
   <td style="text-align:center;"> 6.08 </td>
   <td style="text-align:center;"> 2.58 </td>
   <td style="text-align:center;"> 9.74 </td>
  </tr>
</tbody>
</table></div>
 &nbsp; 
 


And this code creates song catalogs:


{% highlight r %}
catalog(X = rvn.dat.st[1:9, ], flim = c(1, 10), nrow = 3, ncol = 3, 
        same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, 
 pal = reverse.heat.colors, width = 20,  
 labels = c("sound.files", "selec"), legend = 1, 
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
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak Freq Contour (Hz)")
 
head(fcts)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> PFC..1 </th>
   <th style="text-align:center;"> PFC..2 </th>
   <th style="text-align:center;"> PFC..3 </th>
   <th style="text-align:center;"> PFC..4 </th>
   <th style="text-align:center;"> PFC..5 </th>
   <th style="text-align:center;"> PFC..6 </th>
   <th style="text-align:center;"> PFC..7 </th>
   <th style="text-align:center;"> PFC..8 </th>
   <th style="text-align:center;"> PFC..9 </th>
   <th style="text-align:center;"> PFC..10 </th>
   <th style="text-align:center;"> PFC..11 </th>
   <th style="text-align:center;"> PFC..12 </th>
   <th style="text-align:center;"> PFC..13 </th>
   <th style="text-align:center;"> PFC..14 </th>
   <th style="text-align:center;"> PFC..15 </th>
   <th style="text-align:center;"> PFC..16 </th>
   <th style="text-align:center;"> PFC..17 </th>
   <th style="text-align:center;"> PFC..18 </th>
   <th style="text-align:center;"> PFC..19 </th>
   <th style="text-align:center;"> PFC..20 </th>
   <th style="text-align:center;"> PFC..21 </th>
   <th style="text-align:center;"> PFC..22 </th>
   <th style="text-align:center;"> PFC..23 </th>
   <th style="text-align:center;"> PFC..24 </th>
   <th style="text-align:center;"> PFC..25 </th>
   <th style="text-align:center;"> PFC..26 </th>
   <th style="text-align:center;"> PFC..27 </th>
   <th style="text-align:center;"> PFC..28 </th>
   <th style="text-align:center;"> PFC..29 </th>
   <th style="text-align:center;"> PFC..30 </th>
   <th style="text-align:center;"> PFC..31 </th>
   <th style="text-align:center;"> PFC..32 </th>
   <th style="text-align:center;"> PFC..33 </th>
   <th style="text-align:center;"> PFC..34 </th>
   <th style="text-align:center;"> PFC..35 </th>
   <th style="text-align:center;"> PFC..36 </th>
   <th style="text-align:center;"> PFC..37 </th>
   <th style="text-align:center;"> PFC..38 </th>
   <th style="text-align:center;"> PFC..39 </th>
   <th style="text-align:center;"> PFC..40 </th>
   <th style="text-align:center;"> PFC..41 </th>
   <th style="text-align:center;"> PFC..42 </th>
   <th style="text-align:center;"> PFC..43 </th>
   <th style="text-align:center;"> PFC..44 </th>
   <th style="text-align:center;"> PFC..45 </th>
   <th style="text-align:center;"> PFC..46 </th>
   <th style="text-align:center;"> PFC..47 </th>
   <th style="text-align:center;"> PFC..48 </th>
   <th style="text-align:center;"> PFC..49 </th>
   <th style="text-align:center;"> PFC..50 </th>
   <th style="text-align:center;"> PFC..51 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7295 </td>
   <td style="text-align:center;"> 7295 </td>
   <td style="text-align:center;"> 7295 </td>
   <td style="text-align:center;"> 7383 </td>
   <td style="text-align:center;"> 7471 </td>
   <td style="text-align:center;"> 7646 </td>
   <td style="text-align:center;"> 5186 </td>
   <td style="text-align:center;"> 5273 </td>
   <td style="text-align:center;"> 5361 </td>
   <td style="text-align:center;"> 5449 </td>
   <td style="text-align:center;"> 5449 </td>
   <td style="text-align:center;"> 5537 </td>
   <td style="text-align:center;"> 5537 </td>
   <td style="text-align:center;"> 5713 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 5713 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 6240 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 6328 </td>
   <td style="text-align:center;"> 5186 </td>
   <td style="text-align:center;"> 5010 </td>
   <td style="text-align:center;"> 4658 </td>
   <td style="text-align:center;"> 4307 </td>
   <td style="text-align:center;"> 3955 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7031 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7119 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7295 </td>
   <td style="text-align:center;"> 7383 </td>
   <td style="text-align:center;"> 7471 </td>
   <td style="text-align:center;"> 7559 </td>
   <td style="text-align:center;"> 7559 </td>
   <td style="text-align:center;"> 7646 </td>
   <td style="text-align:center;"> 5186 </td>
   <td style="text-align:center;"> 5361 </td>
   <td style="text-align:center;"> 5537 </td>
   <td style="text-align:center;"> 8262 </td>
   <td style="text-align:center;"> 8262 </td>
   <td style="text-align:center;"> 8350 </td>
   <td style="text-align:center;"> 5801 </td>
   <td style="text-align:center;"> 6152 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 6680 </td>
   <td style="text-align:center;"> 5889 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 5625 </td>
   <td style="text-align:center;"> 6152 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 5273 </td>
   <td style="text-align:center;"> 5273 </td>
   <td style="text-align:center;"> 4570 </td>
   <td style="text-align:center;"> 4307 </td>
   <td style="text-align:center;"> 3867 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 4746 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 4834 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 4922 </td>
   <td style="text-align:center;"> 4922 </td>
   <td style="text-align:center;"> 7559 </td>
   <td style="text-align:center;"> 7646 </td>
   <td style="text-align:center;"> 7734 </td>
   <td style="text-align:center;"> 7998 </td>
   <td style="text-align:center;"> 8086 </td>
   <td style="text-align:center;"> 5449 </td>
   <td style="text-align:center;"> 8086 </td>
   <td style="text-align:center;"> 8350 </td>
   <td style="text-align:center;"> 7998 </td>
   <td style="text-align:center;"> 8701 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 5801 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 6328 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 5449 </td>
   <td style="text-align:center;"> 6152 </td>
   <td style="text-align:center;"> 5361 </td>
   <td style="text-align:center;"> 5273 </td>
   <td style="text-align:center;"> 4922 </td>
   <td style="text-align:center;"> 4482 </td>
   <td style="text-align:center;"> 4131 </td>
   <td style="text-align:center;"> 3779 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 7031 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7031 </td>
   <td style="text-align:center;"> 7295 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7031 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7031 </td>
   <td style="text-align:center;"> 7031 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7119 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 5889 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 4570 </td>
   <td style="text-align:center;"> 4834 </td>
   <td style="text-align:center;"> 5186 </td>
   <td style="text-align:center;"> 5537 </td>
   <td style="text-align:center;"> 5537 </td>
   <td style="text-align:center;"> 5801 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 3779 </td>
   <td style="text-align:center;"> 6240 </td>
   <td style="text-align:center;"> 6328 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 5273 </td>
   <td style="text-align:center;"> 5713 </td>
   <td style="text-align:center;"> 4922 </td>
   <td style="text-align:center;"> 7383 </td>
   <td style="text-align:center;"> 6064 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 7646 </td>
   <td style="text-align:center;"> 5801 </td>
   <td style="text-align:center;"> 7471 </td>
   <td style="text-align:center;"> 7295 </td>
   <td style="text-align:center;"> 7383 </td>
   <td style="text-align:center;"> 5537 </td>
   <td style="text-align:center;"> 6152 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 5889 </td>
   <td style="text-align:center;"> 7559 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 7295 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 7822 </td>
   <td style="text-align:center;"> 7822 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 6064 </td>
   <td style="text-align:center;"> 6152 </td>
   <td style="text-align:center;"> 6152 </td>
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
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 4570 </td>
   <td style="text-align:center;"> 4746 </td>
   <td style="text-align:center;"> 4922 </td>
   <td style="text-align:center;"> 5098 </td>
   <td style="text-align:center;"> 5098 </td>
   <td style="text-align:center;"> 5186 </td>
   <td style="text-align:center;"> 5801 </td>
   <td style="text-align:center;"> 5713 </td>
   <td style="text-align:center;"> 5889 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 6064 </td>
   <td style="text-align:center;"> 6064 </td>
   <td style="text-align:center;"> 4570 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6680 </td>
   <td style="text-align:center;"> 6328 </td>
   <td style="text-align:center;"> 7646 </td>
   <td style="text-align:center;"> 5713 </td>
   <td style="text-align:center;"> 7207 </td>
   <td style="text-align:center;"> 6680 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 6240 </td>
   <td style="text-align:center;"> 6856 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 7559 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 5713 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 5537 </td>
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
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 4219 </td>
   <td style="text-align:center;"> 6240 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 6680 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 5010 </td>
   <td style="text-align:center;"> 5801 </td>
   <td style="text-align:center;"> 6240 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 6328 </td>
   <td style="text-align:center;"> 6328 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 6680 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 5537 </td>
   <td style="text-align:center;"> 6680 </td>
   <td style="text-align:center;"> 6680 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 5977 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 6768 </td>
   <td style="text-align:center;"> 7471 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 7471 </td>
   <td style="text-align:center;"> 6592 </td>
   <td style="text-align:center;"> 7998 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7910 </td>
   <td style="text-align:center;"> 7031 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 7471 </td>
   <td style="text-align:center;"> 6943 </td>
   <td style="text-align:center;"> 7734 </td>
   <td style="text-align:center;"> 7119 </td>
   <td style="text-align:center;"> 7822 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 6856 </td>
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
</table></div>
&nbsp;

Note that these sequences are not all of equal length (one has NAs at the end).
`extract_ts` can also interpolate values so all time series have the same length:


{% highlight r %}
# Peak freq contour equal length
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak Freq Contour (Hz)",
                   equal.length = TRUE)

#look at the last rows wit no NAs
fcts[ , 21:32]
{% endhighlight %}
 
<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> PFC..19 </th>
   <th style="text-align:center;"> PFC..20 </th>
   <th style="text-align:center;"> PFC..21 </th>
   <th style="text-align:center;"> PFC..22 </th>
   <th style="text-align:center;"> PFC..23 </th>
   <th style="text-align:center;"> PFC..24 </th>
   <th style="text-align:center;"> PFC..25 </th>
   <th style="text-align:center;"> PFC..26 </th>
   <th style="text-align:center;"> PFC..27 </th>
   <th style="text-align:center;"> PFC..28 </th>
   <th style="text-align:center;"> PFC..29 </th>
   <th style="text-align:center;"> PFC..30 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 6246 </td>
   <td style="text-align:center;"> 6374 </td>
   <td style="text-align:center;"> 6501 </td>
   <td style="text-align:center;"> 6628 </td>
   <td style="text-align:center;"> 6755 </td>
   <td style="text-align:center;"> 6883 </td>
   <td style="text-align:center;"> 7010 </td>
   <td style="text-align:center;"> 7137 </td>
   <td style="text-align:center;"> 7265 </td>
   <td style="text-align:center;"> 7392 </td>
   <td style="text-align:center;"> 7519 </td>
   <td style="text-align:center;"> 7646 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6649 </td>
   <td style="text-align:center;"> 6804 </td>
   <td style="text-align:center;"> 6959 </td>
   <td style="text-align:center;"> 7113 </td>
   <td style="text-align:center;"> 7268 </td>
   <td style="text-align:center;"> 7422 </td>
   <td style="text-align:center;"> 7577 </td>
   <td style="text-align:center;"> 7731 </td>
   <td style="text-align:center;"> 7886 </td>
   <td style="text-align:center;"> 8040 </td>
   <td style="text-align:center;"> 8195 </td>
   <td style="text-align:center;"> 8350 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6834 </td>
   <td style="text-align:center;"> 7004 </td>
   <td style="text-align:center;"> 7174 </td>
   <td style="text-align:center;"> 7343 </td>
   <td style="text-align:center;"> 7513 </td>
   <td style="text-align:center;"> 7683 </td>
   <td style="text-align:center;"> 7853 </td>
   <td style="text-align:center;"> 8022 </td>
   <td style="text-align:center;"> 8192 </td>
   <td style="text-align:center;"> 8362 </td>
   <td style="text-align:center;"> 8531 </td>
   <td style="text-align:center;"> 8701 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6289 </td>
   <td style="text-align:center;"> 6428 </td>
   <td style="text-align:center;"> 6568 </td>
   <td style="text-align:center;"> 6707 </td>
   <td style="text-align:center;"> 6846 </td>
   <td style="text-align:center;"> 6986 </td>
   <td style="text-align:center;"> 7125 </td>
   <td style="text-align:center;"> 7265 </td>
   <td style="text-align:center;"> 7404 </td>
   <td style="text-align:center;"> 7543 </td>
   <td style="text-align:center;"> 7683 </td>
   <td style="text-align:center;"> 7822 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6480 </td>
   <td style="text-align:center;"> 6586 </td>
   <td style="text-align:center;"> 6692 </td>
   <td style="text-align:center;"> 6798 </td>
   <td style="text-align:center;"> 6904 </td>
   <td style="text-align:center;"> 7010 </td>
   <td style="text-align:center;"> 7116 </td>
   <td style="text-align:center;"> 7222 </td>
   <td style="text-align:center;"> 7328 </td>
   <td style="text-align:center;"> 7434 </td>
   <td style="text-align:center;"> 7540 </td>
   <td style="text-align:center;"> 7646 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6565 </td>
   <td style="text-align:center;"> 6695 </td>
   <td style="text-align:center;"> 6825 </td>
   <td style="text-align:center;"> 6955 </td>
   <td style="text-align:center;"> 7086 </td>
   <td style="text-align:center;"> 7216 </td>
   <td style="text-align:center;"> 7346 </td>
   <td style="text-align:center;"> 7477 </td>
   <td style="text-align:center;"> 7607 </td>
   <td style="text-align:center;"> 7737 </td>
   <td style="text-align:center;"> 7868 </td>
   <td style="text-align:center;"> 7998 </td>
  </tr>
</tbody>
</table></div>
 &nbsp; 

And the length of the series can also be specified:


{% highlight r %}
# Peak freq contour equal length 10 measurements
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak Freq Contour (Hz)",
equal.length = T, length.out = 10)  

fcts
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> PFC..1 </th>
   <th style="text-align:center;"> PFC..2 </th>
   <th style="text-align:center;"> PFC..3 </th>
   <th style="text-align:center;"> PFC..4 </th>
   <th style="text-align:center;"> PFC..5 </th>
   <th style="text-align:center;"> PFC..6 </th>
   <th style="text-align:center;"> PFC..7 </th>
   <th style="text-align:center;"> PFC..8 </th>
   <th style="text-align:center;"> PFC..9 </th>
   <th style="text-align:center;"> PFC..10 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3955 </td>
   <td style="text-align:center;"> 4365 </td>
   <td style="text-align:center;"> 4775 </td>
   <td style="text-align:center;"> 5186 </td>
   <td style="text-align:center;"> 5596 </td>
   <td style="text-align:center;"> 6006 </td>
   <td style="text-align:center;"> 6416 </td>
   <td style="text-align:center;"> 6826 </td>
   <td style="text-align:center;"> 7236 </td>
   <td style="text-align:center;"> 7646 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 3867 </td>
   <td style="text-align:center;"> 4365 </td>
   <td style="text-align:center;"> 4863 </td>
   <td style="text-align:center;"> 5361 </td>
   <td style="text-align:center;"> 5859 </td>
   <td style="text-align:center;"> 6357 </td>
   <td style="text-align:center;"> 6855 </td>
   <td style="text-align:center;"> 7354 </td>
   <td style="text-align:center;"> 7852 </td>
   <td style="text-align:center;"> 8350 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 3779 </td>
   <td style="text-align:center;"> 4326 </td>
   <td style="text-align:center;"> 4873 </td>
   <td style="text-align:center;"> 5420 </td>
   <td style="text-align:center;"> 5967 </td>
   <td style="text-align:center;"> 6514 </td>
   <td style="text-align:center;"> 7061 </td>
   <td style="text-align:center;"> 7607 </td>
   <td style="text-align:center;"> 8154 </td>
   <td style="text-align:center;"> 8701 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 3779 </td>
   <td style="text-align:center;"> 4229 </td>
   <td style="text-align:center;"> 4678 </td>
   <td style="text-align:center;"> 5127 </td>
   <td style="text-align:center;"> 5576 </td>
   <td style="text-align:center;"> 6025 </td>
   <td style="text-align:center;"> 6475 </td>
   <td style="text-align:center;"> 6924 </td>
   <td style="text-align:center;"> 7373 </td>
   <td style="text-align:center;"> 7822 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 4570 </td>
   <td style="text-align:center;"> 4912 </td>
   <td style="text-align:center;"> 5254 </td>
   <td style="text-align:center;"> 5596 </td>
   <td style="text-align:center;"> 5938 </td>
   <td style="text-align:center;"> 6279 </td>
   <td style="text-align:center;"> 6621 </td>
   <td style="text-align:center;"> 6963 </td>
   <td style="text-align:center;"> 7305 </td>
   <td style="text-align:center;"> 7646 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 4219 </td>
   <td style="text-align:center;"> 4639 </td>
   <td style="text-align:center;"> 5059 </td>
   <td style="text-align:center;"> 5479 </td>
   <td style="text-align:center;"> 5898 </td>
   <td style="text-align:center;"> 6318 </td>
   <td style="text-align:center;"> 6738 </td>
   <td style="text-align:center;"> 7158 </td>
   <td style="text-align:center;"> 7578 </td>
   <td style="text-align:center;"> 7998 </td>
  </tr>
</tbody>
</table></div>
&nbsp; 

The time series data frame can be directly input into the `dfDTW` [warbleR](https://cran.r-project.org/package=warbleR) function to calculate [Dynamic Time Warping](https://en.wikipedia.org/wiki/Dynamic_time_warping) distances:


{% highlight r %}
dfDTW(ts.df = fcts)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Phae.long1.wav-1 </th>
   <th style="text-align:center;"> Phae.long1.wav-2 </th>
   <th style="text-align:center;"> Phae.long1.wav-3 </th>
   <th style="text-align:center;"> Phae.long2.wav-4 </th>
   <th style="text-align:center;"> Phae.long2.wav-5 </th>
   <th style="text-align:center;"> Phae.long3.wav-6 </th>
   <th style="text-align:center;"> Phae.long3.wav-7 </th>
   <th style="text-align:center;"> Phae.long3.wav-8 </th>
   <th style="text-align:center;"> Phae.long4.wav-9 </th>
   <th style="text-align:center;"> Phae.long4.wav-10 </th>
   <th style="text-align:center;"> Phae.long4.wav-11 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav-1 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 2666 </td>
   <td style="text-align:center;"> 3652 </td>
   <td style="text-align:center;"> 1778 </td>
   <td style="text-align:center;"> 2256 </td>
   <td style="text-align:center;"> 2403 </td>
   <td style="text-align:center;"> 3007 </td>
   <td style="text-align:center;"> 3252 </td>
   <td style="text-align:center;"> 4219 </td>
   <td style="text-align:center;"> 4610 </td>
   <td style="text-align:center;"> 4170 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav-2 </td>
   <td style="text-align:center;"> 2666 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 2734 </td>
   <td style="text-align:center;"> 2744 </td>
   <td style="text-align:center;"> 3457 </td>
   <td style="text-align:center;"> 3027 </td>
   <td style="text-align:center;"> 3428 </td>
   <td style="text-align:center;"> 3897 </td>
   <td style="text-align:center;"> 3486 </td>
   <td style="text-align:center;"> 3584 </td>
   <td style="text-align:center;"> 3242 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav-3 </td>
   <td style="text-align:center;"> 3652 </td>
   <td style="text-align:center;"> 2734 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 3516 </td>
   <td style="text-align:center;"> 4287 </td>
   <td style="text-align:center;"> 3340 </td>
   <td style="text-align:center;"> 3731 </td>
   <td style="text-align:center;"> 4424 </td>
   <td style="text-align:center;"> 3047 </td>
   <td style="text-align:center;"> 2774 </td>
   <td style="text-align:center;"> 3310 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav-4 </td>
   <td style="text-align:center;"> 1778 </td>
   <td style="text-align:center;"> 2744 </td>
   <td style="text-align:center;"> 3516 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 3047 </td>
   <td style="text-align:center;"> 2783 </td>
   <td style="text-align:center;"> 3262 </td>
   <td style="text-align:center;"> 3819 </td>
   <td style="text-align:center;"> 3750 </td>
   <td style="text-align:center;"> 4180 </td>
   <td style="text-align:center;"> 3486 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav-5 </td>
   <td style="text-align:center;"> 2256 </td>
   <td style="text-align:center;"> 3457 </td>
   <td style="text-align:center;"> 4287 </td>
   <td style="text-align:center;"> 3047 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 2539 </td>
   <td style="text-align:center;"> 2266 </td>
   <td style="text-align:center;"> 869 </td>
   <td style="text-align:center;"> 5244 </td>
   <td style="text-align:center;"> 5420 </td>
   <td style="text-align:center;"> 5723 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav-6 </td>
   <td style="text-align:center;"> 2403 </td>
   <td style="text-align:center;"> 3027 </td>
   <td style="text-align:center;"> 3340 </td>
   <td style="text-align:center;"> 2783 </td>
   <td style="text-align:center;"> 2539 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 2061 </td>
   <td style="text-align:center;"> 2637 </td>
   <td style="text-align:center;"> 3614 </td>
   <td style="text-align:center;"> 4034 </td>
   <td style="text-align:center;"> 4619 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav-7 </td>
   <td style="text-align:center;"> 3007 </td>
   <td style="text-align:center;"> 3428 </td>
   <td style="text-align:center;"> 3731 </td>
   <td style="text-align:center;"> 3262 </td>
   <td style="text-align:center;"> 2266 </td>
   <td style="text-align:center;"> 2061 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 2031 </td>
   <td style="text-align:center;"> 4610 </td>
   <td style="text-align:center;"> 5079 </td>
   <td style="text-align:center;"> 5752 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav-8 </td>
   <td style="text-align:center;"> 3252 </td>
   <td style="text-align:center;"> 3897 </td>
   <td style="text-align:center;"> 4424 </td>
   <td style="text-align:center;"> 3819 </td>
   <td style="text-align:center;"> 869 </td>
   <td style="text-align:center;"> 2637 </td>
   <td style="text-align:center;"> 2031 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 5352 </td>
   <td style="text-align:center;"> 5645 </td>
   <td style="text-align:center;"> 6504 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav-9 </td>
   <td style="text-align:center;"> 4219 </td>
   <td style="text-align:center;"> 3486 </td>
   <td style="text-align:center;"> 3047 </td>
   <td style="text-align:center;"> 3750 </td>
   <td style="text-align:center;"> 5244 </td>
   <td style="text-align:center;"> 3614 </td>
   <td style="text-align:center;"> 4610 </td>
   <td style="text-align:center;"> 5352 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 1758 </td>
   <td style="text-align:center;"> 4815 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav-10 </td>
   <td style="text-align:center;"> 4610 </td>
   <td style="text-align:center;"> 3584 </td>
   <td style="text-align:center;"> 2774 </td>
   <td style="text-align:center;"> 4180 </td>
   <td style="text-align:center;"> 5420 </td>
   <td style="text-align:center;"> 4034 </td>
   <td style="text-align:center;"> 5079 </td>
   <td style="text-align:center;"> 5645 </td>
   <td style="text-align:center;"> 1758 </td>
   <td style="text-align:center;"> 0 </td>
   <td style="text-align:center;"> 3701 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav-11 </td>
   <td style="text-align:center;"> 4170 </td>
   <td style="text-align:center;"> 3242 </td>
   <td style="text-align:center;"> 3310 </td>
   <td style="text-align:center;"> 3486 </td>
   <td style="text-align:center;"> 5723 </td>
   <td style="text-align:center;"> 4619 </td>
   <td style="text-align:center;"> 5752 </td>
   <td style="text-align:center;"> 6504 </td>
   <td style="text-align:center;"> 4815 </td>
   <td style="text-align:center;"> 3701 </td>
   <td style="text-align:center;"> 0 </td>
  </tr>
</tbody>
</table></div>


---

### *relabel_colms*

This is a very simple function to relabel columns so they match the selection table format used in [warbleR](https://cran.r-project.org/package=warbleR):


{% highlight r %}
#to simplify the example select a subset of the columns 
st1 <- rvn.dat.st[ ,1:7]

#check original column names
st1
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> Selection </th>
   <th style="text-align:center;"> View </th>
   <th style="text-align:center;"> Channel </th>
   <th style="text-align:center;"> Begin Time (s) </th>
   <th style="text-align:center;"> End Time (s) </th>
   <th style="text-align:center;"> Low Freq (Hz) </th>
   <th style="text-align:center;"> High Freq (Hz) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.169 </td>
   <td style="text-align:center;"> 1.342 </td>
   <td style="text-align:center;"> 2220 </td>
   <td style="text-align:center;"> 8604 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.158 </td>
   <td style="text-align:center;"> 2.321 </td>
   <td style="text-align:center;"> 2169 </td>
   <td style="text-align:center;"> 8807 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.343 </td>
   <td style="text-align:center;"> 0.518 </td>
   <td style="text-align:center;"> 2218 </td>
   <td style="text-align:center;"> 8757 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.660 </td>
   <td style="text-align:center;"> 2.792 </td>
   <td style="text-align:center;"> 2317 </td>
   <td style="text-align:center;"> 8822 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3.957 </td>
   <td style="text-align:center;"> 4.083 </td>
   <td style="text-align:center;"> 2284 </td>
   <td style="text-align:center;"> 8888 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.827 </td>
   <td style="text-align:center;"> 4.958 </td>
   <td style="text-align:center;"> 3007 </td>
   <td style="text-align:center;"> 8822 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6.174 </td>
   <td style="text-align:center;"> 6.304 </td>
   <td style="text-align:center;"> 2777 </td>
   <td style="text-align:center;"> 8888 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.323 </td>
   <td style="text-align:center;"> 4.455 </td>
   <td style="text-align:center;"> 2317 </td>
   <td style="text-align:center;"> 9315 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 7.917 </td>
   <td style="text-align:center;"> 8.062 </td>
   <td style="text-align:center;"> 2514 </td>
   <td style="text-align:center;"> 9217 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 9.333 </td>
   <td style="text-align:center;"> 9.477 </td>
   <td style="text-align:center;"> 2580 </td>
   <td style="text-align:center;"> 10235 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6.545 </td>
   <td style="text-align:center;"> 6.691 </td>
   <td style="text-align:center;"> 2580 </td>
   <td style="text-align:center;"> 9742 </td>
  </tr>
</tbody>
</table></div>



{% highlight r %}
# Relabel the basic columns required by warbleR
relabel_colms(st1)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
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
   <td style="text-align:center;"> 1.169355 </td>
   <td style="text-align:center;"> 1.342388 </td>
   <td style="text-align:center;"> 2220.1 </td>
   <td style="text-align:center;"> 8604.4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.158408 </td>
   <td style="text-align:center;"> 2.321457 </td>
   <td style="text-align:center;"> 2169.4 </td>
   <td style="text-align:center;"> 8807.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.343337 </td>
   <td style="text-align:center;"> 0.518255 </td>
   <td style="text-align:center;"> 2218.3 </td>
   <td style="text-align:center;"> 8756.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.659643 </td>
   <td style="text-align:center;"> 2.792214 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3.957103 </td>
   <td style="text-align:center;"> 4.083253 </td>
   <td style="text-align:center;"> 2284.0 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.826641 </td>
   <td style="text-align:center;"> 4.957860 </td>
   <td style="text-align:center;"> 3006.8 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6.174302 </td>
   <td style="text-align:center;"> 6.304481 </td>
   <td style="text-align:center;"> 2776.8 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.323453 </td>
   <td style="text-align:center;"> 4.454670 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 9315.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 7.916900 </td>
   <td style="text-align:center;"> 8.062325 </td>
   <td style="text-align:center;"> 2514.0 </td>
   <td style="text-align:center;"> 9216.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 9.332781 </td>
   <td style="text-align:center;"> 9.476967 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 10235.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6.545487 </td>
   <td style="text-align:center;"> 6.690585 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 9742.3 </td>
  </tr>
</tbody>
</table></div>
 &nbsp; 

Additional columns can also be relabeled:

{% highlight r %}
# 1 additional column 
relabel_colms(st1, extra.cols.name = "View",
              extra.cols.new.name = "Raven view")
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
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
   <td style="text-align:center;"> 1.169355 </td>
   <td style="text-align:center;"> 1.342388 </td>
   <td style="text-align:center;"> 2220.1 </td>
   <td style="text-align:center;"> 8604.4 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.158408 </td>
   <td style="text-align:center;"> 2.321457 </td>
   <td style="text-align:center;"> 2169.4 </td>
   <td style="text-align:center;"> 8807.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.343337 </td>
   <td style="text-align:center;"> 0.518255 </td>
   <td style="text-align:center;"> 2218.3 </td>
   <td style="text-align:center;"> 8756.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.659643 </td>
   <td style="text-align:center;"> 2.792214 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3.957103 </td>
   <td style="text-align:center;"> 4.083253 </td>
   <td style="text-align:center;"> 2284.0 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.826641 </td>
   <td style="text-align:center;"> 4.957860 </td>
   <td style="text-align:center;"> 3006.8 </td>
   <td style="text-align:center;"> 8822.3 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6.174302 </td>
   <td style="text-align:center;"> 6.304481 </td>
   <td style="text-align:center;"> 2776.8 </td>
   <td style="text-align:center;"> 8888.0 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.323453 </td>
   <td style="text-align:center;"> 4.454670 </td>
   <td style="text-align:center;"> 2316.9 </td>
   <td style="text-align:center;"> 9315.2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 7.916900 </td>
   <td style="text-align:center;"> 8.062325 </td>
   <td style="text-align:center;"> 2514.0 </td>
   <td style="text-align:center;"> 9216.6 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 9.332781 </td>
   <td style="text-align:center;"> 9.476967 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 10235.1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> Spectrogram 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 6.545487 </td>
   <td style="text-align:center;"> 6.690585 </td>
   <td style="text-align:center;"> 2579.7 </td>
   <td style="text-align:center;"> 9742.3 </td>
  </tr>
</tbody>
</table></div>
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
cut_sels(X = selec.table, mar = 0.05, path = tempdir(), 
         dest.path = file.path(tempdir(), "cuts"), 
         labels = c("rownames", "sound.files", "selec"), 
         pb = FALSE)

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
xcorr.rav <- imp_corr_mat(file = "BatchCorrOutput.txt", 
                          path = tempdir())
{% endhighlight %}


 &nbsp; 
 
The function returns a list containing the correlation matrix (here only showing the first 5 rows/columns):


{% highlight r %}
xcorr.rav$correlation
{% endhighlight %}
&nbsp; 

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> 01-Phae.long1-1.wav </th>
   <th style="text-align:center;"> 10-Phae.long4-2.wav </th>
   <th style="text-align:center;"> 11-Phae.long4-3.wav </th>
   <th style="text-align:center;"> 07-Phae.long3-2.wav </th>
   <th style="text-align:center;"> 05-Phae.long2-2.wav </th>
   <th style="text-align:center;"> 09-Phae.long4-1.wav </th>
   <th style="text-align:center;"> 04-Phae.long2-1.wav </th>
   <th style="text-align:center;"> 02-Phae.long1-2.wav </th>
   <th style="text-align:center;"> 06-Phae.long3-1.wav </th>
   <th style="text-align:center;"> 03-Phae.long1-3.wav </th>
   <th style="text-align:center;"> 08-Phae.long3-3.wav </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01-Phae.long1-1.wav </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.216 </td>
   <td style="text-align:center;"> 0.184 </td>
   <td style="text-align:center;"> 0.285 </td>
   <td style="text-align:center;"> 0.443 </td>
   <td style="text-align:center;"> 0.195 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.613 </td>
   <td style="text-align:center;"> 0.360 </td>
   <td style="text-align:center;"> 0.812 </td>
   <td style="text-align:center;"> 0.236 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-Phae.long4-2.wav </td>
   <td style="text-align:center;"> 0.216 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.781 </td>
   <td style="text-align:center;"> 0.290 </td>
   <td style="text-align:center;"> 0.235 </td>
   <td style="text-align:center;"> 0.907 </td>
   <td style="text-align:center;"> 0.289 </td>
   <td style="text-align:center;"> 0.176 </td>
   <td style="text-align:center;"> 0.204 </td>
   <td style="text-align:center;"> 0.209 </td>
   <td style="text-align:center;"> 0.323 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11-Phae.long4-3.wav </td>
   <td style="text-align:center;"> 0.184 </td>
   <td style="text-align:center;"> 0.781 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.279 </td>
   <td style="text-align:center;"> 0.186 </td>
   <td style="text-align:center;"> 0.804 </td>
   <td style="text-align:center;"> 0.274 </td>
   <td style="text-align:center;"> 0.127 </td>
   <td style="text-align:center;"> 0.189 </td>
   <td style="text-align:center;"> 0.185 </td>
   <td style="text-align:center;"> 0.393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 07-Phae.long3-2.wav </td>
   <td style="text-align:center;"> 0.285 </td>
   <td style="text-align:center;"> 0.290 </td>
   <td style="text-align:center;"> 0.279 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.433 </td>
   <td style="text-align:center;"> 0.281 </td>
   <td style="text-align:center;"> 0.270 </td>
   <td style="text-align:center;"> 0.251 </td>
   <td style="text-align:center;"> 0.635 </td>
   <td style="text-align:center;"> 0.274 </td>
   <td style="text-align:center;"> 0.496 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05-Phae.long2-2.wav </td>
   <td style="text-align:center;"> 0.443 </td>
   <td style="text-align:center;"> 0.235 </td>
   <td style="text-align:center;"> 0.186 </td>
   <td style="text-align:center;"> 0.433 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.197 </td>
   <td style="text-align:center;"> 0.243 </td>
   <td style="text-align:center;"> 0.449 </td>
   <td style="text-align:center;"> 0.397 </td>
   <td style="text-align:center;"> 0.363 </td>
   <td style="text-align:center;"> 0.304 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 09-Phae.long4-1.wav </td>
   <td style="text-align:center;"> 0.195 </td>
   <td style="text-align:center;"> 0.907 </td>
   <td style="text-align:center;"> 0.804 </td>
   <td style="text-align:center;"> 0.281 </td>
   <td style="text-align:center;"> 0.197 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.310 </td>
   <td style="text-align:center;"> 0.164 </td>
   <td style="text-align:center;"> 0.199 </td>
   <td style="text-align:center;"> 0.214 </td>
   <td style="text-align:center;"> 0.322 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04-Phae.long2-1.wav </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.289 </td>
   <td style="text-align:center;"> 0.274 </td>
   <td style="text-align:center;"> 0.270 </td>
   <td style="text-align:center;"> 0.243 </td>
   <td style="text-align:center;"> 0.310 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.151 </td>
   <td style="text-align:center;"> 0.302 </td>
   <td style="text-align:center;"> 0.182 </td>
   <td style="text-align:center;"> 0.256 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 02-Phae.long1-2.wav </td>
   <td style="text-align:center;"> 0.613 </td>
   <td style="text-align:center;"> 0.176 </td>
   <td style="text-align:center;"> 0.127 </td>
   <td style="text-align:center;"> 0.251 </td>
   <td style="text-align:center;"> 0.449 </td>
   <td style="text-align:center;"> 0.164 </td>
   <td style="text-align:center;"> 0.151 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.264 </td>
   <td style="text-align:center;"> 0.448 </td>
   <td style="text-align:center;"> 0.200 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 06-Phae.long3-1.wav </td>
   <td style="text-align:center;"> 0.360 </td>
   <td style="text-align:center;"> 0.204 </td>
   <td style="text-align:center;"> 0.189 </td>
   <td style="text-align:center;"> 0.635 </td>
   <td style="text-align:center;"> 0.397 </td>
   <td style="text-align:center;"> 0.199 </td>
   <td style="text-align:center;"> 0.302 </td>
   <td style="text-align:center;"> 0.264 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.318 </td>
   <td style="text-align:center;"> 0.377 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 03-Phae.long1-3.wav </td>
   <td style="text-align:center;"> 0.812 </td>
   <td style="text-align:center;"> 0.209 </td>
   <td style="text-align:center;"> 0.185 </td>
   <td style="text-align:center;"> 0.274 </td>
   <td style="text-align:center;"> 0.363 </td>
   <td style="text-align:center;"> 0.214 </td>
   <td style="text-align:center;"> 0.182 </td>
   <td style="text-align:center;"> 0.448 </td>
   <td style="text-align:center;"> 0.318 </td>
   <td style="text-align:center;"> 1.000 </td>
   <td style="text-align:center;"> 0.227 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08-Phae.long3-3.wav </td>
   <td style="text-align:center;"> 0.236 </td>
   <td style="text-align:center;"> 0.323 </td>
   <td style="text-align:center;"> 0.393 </td>
   <td style="text-align:center;"> 0.496 </td>
   <td style="text-align:center;"> 0.304 </td>
   <td style="text-align:center;"> 0.322 </td>
   <td style="text-align:center;"> 0.256 </td>
   <td style="text-align:center;"> 0.200 </td>
   <td style="text-align:center;"> 0.377 </td>
   <td style="text-align:center;"> 0.227 </td>
   <td style="text-align:center;"> 1.000 </td>
  </tr>
</tbody>
</table></div>
 &nbsp; 
 
and the time lag matrix:


{% highlight r %}
xcorr.rav$`lag (s)`
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:900px;  font-size: 13px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> 01-Phae.long1-1.wav </th>
   <th style="text-align:center;"> 10-Phae.long4-2.wav </th>
   <th style="text-align:center;"> 11-Phae.long4-3.wav </th>
   <th style="text-align:center;"> 07-Phae.long3-2.wav </th>
   <th style="text-align:center;"> 05-Phae.long2-2.wav </th>
   <th style="text-align:center;"> 09-Phae.long4-1.wav </th>
   <th style="text-align:center;"> 04-Phae.long2-1.wav </th>
   <th style="text-align:center;"> 02-Phae.long1-2.wav </th>
   <th style="text-align:center;"> 06-Phae.long3-1.wav </th>
   <th style="text-align:center;"> 03-Phae.long1-3.wav </th>
   <th style="text-align:center;"> 08-Phae.long3-3.wav </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01-Phae.long1-1.wav </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;"> 0.006 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> 0.034 </td>
   <td style="text-align:center;"> 0.006 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> -0.006 </td>
   <td style="text-align:center;"> 0.023 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-Phae.long4-2.wav </td>
   <td style="text-align:center;"> -0.011 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.006 </td>
   <td style="text-align:center;"> 0.040 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> -0.006 </td>
   <td style="text-align:center;"> -0.028 </td>
   <td style="text-align:center;"> -0.017 </td>
   <td style="text-align:center;"> 0.040 </td>
   <td style="text-align:center;"> -0.017 </td>
   <td style="text-align:center;"> 0.057 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11-Phae.long4-3.wav </td>
   <td style="text-align:center;"> -0.006 </td>
   <td style="text-align:center;"> 0.006 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.046 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> -0.074 </td>
   <td style="text-align:center;"> 0.046 </td>
   <td style="text-align:center;"> -0.011 </td>
   <td style="text-align:center;"> 0.063 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 07-Phae.long3-2.wav </td>
   <td style="text-align:center;"> -0.028 </td>
   <td style="text-align:center;"> -0.040 </td>
   <td style="text-align:center;"> -0.046 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.011 </td>
   <td style="text-align:center;"> -0.046 </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> -0.034 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.028 </td>
   <td style="text-align:center;"> 0.017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05-Phae.long2-2.wav </td>
   <td style="text-align:center;"> -0.034 </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> -0.028 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.028 </td>
   <td style="text-align:center;"> 0.017 </td>
   <td style="text-align:center;"> -0.028 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> -0.040 </td>
   <td style="text-align:center;"> 0.006 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 09-Phae.long4-1.wav </td>
   <td style="text-align:center;"> -0.006 </td>
   <td style="text-align:center;"> 0.006 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.046 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> 0.034 </td>
   <td style="text-align:center;"> 0.046 </td>
   <td style="text-align:center;"> -0.011 </td>
   <td style="text-align:center;"> 0.063 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04-Phae.long2-1.wav </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> -0.017 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.057 </td>
   <td style="text-align:center;"> 0.057 </td>
   <td style="text-align:center;"> -0.051 </td>
   <td style="text-align:center;"> 0.017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 02-Phae.long1-2.wav </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.017 </td>
   <td style="text-align:center;"> 0.074 </td>
   <td style="text-align:center;"> 0.034 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> -0.034 </td>
   <td style="text-align:center;"> 0.057 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.040 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.023 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 06-Phae.long3-1.wav </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> -0.040 </td>
   <td style="text-align:center;"> -0.046 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> -0.046 </td>
   <td style="text-align:center;"> -0.057 </td>
   <td style="text-align:center;"> -0.040 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.028 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 03-Phae.long1-3.wav </td>
   <td style="text-align:center;"> 0.006 </td>
   <td style="text-align:center;"> 0.017 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> 0.040 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;"> 0.051 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.023 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08-Phae.long3-3.wav </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> -0.057 </td>
   <td style="text-align:center;"> -0.063 </td>
   <td style="text-align:center;"> -0.017 </td>
   <td style="text-align:center;"> -0.006 </td>
   <td style="text-align:center;"> -0.063 </td>
   <td style="text-align:center;"> -0.017 </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> -0.023 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
</tbody>
</table></div>
 &nbsp; 
 
This output is ready for stats. For instance, the following code runs a mantel test between cross-correlation (converted to distances) and [warbleR](https://cran.r-project.org/package=warbleR) spectral parameter pairwise dissimilarities:


{% highlight r %}
#convert cross-corr to distance
xcorr.rvn <- 1- xcorr.rav$correlation

#sort matrix to match selection table
xcorr.rvn <- xcorr.rvn[order(rownames(xcorr.rvn)), 
                       order(colnames(xcorr.rvn))]

#convert it to distance matrix
xcorr.rvn <- as.dist(xcorr.rvn)

# measure acoustic parameters
sp.wrblR <- specan(selec.table, bp = c(1, 11), wl = 150, 
                   pb = FALSE)

#convert them to distance matrix
dist.sp.wrblR <- dist(sp.wrblR)

vegan::mantel(xcorr.rvn, dist.sp.wrblR)
{% endhighlight %}



{% highlight text %}

Mantel statistic based on Pearson's product-moment correlation 

Call:
vegan::mantel(xdis = xcorr.rvn, ydis = dist.sp.wrblR) 

Mantel statistic r: 0.277 
      Significance: 0.014 

Upper quantiles of permutations (null model):
  90%   95% 97.5%   99% 
0.157 0.204 0.245 0.282 
Permutation: free
Number of permutations: 999
{% endhighlight %}
 &nbsp; 

There is actually a decent match between the two types of analysis.

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
exp_raven(st1, file.name = "Phaethornis 1", khz.to.hz = TRUE, 
          sound.file.path = tempdir())
{% endhighlight %}
![gif2](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/exp_raven1.gif)
 &nbsp; 

This is useful to add new selections or even new measurements:

![gif3](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/exp_raven2.gif)
 &nbsp; 

If several sound files are available, users can either export them as a single selection file or as multiple selection files (one for each sound file). This example creates a multiple sound file selection:


{% highlight r %}
exp_raven(X = selec.table, 
          file.name = "Phaethornis multiple sound files", 
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
run_raven(raven.path = raven.path, sound.files = c("Phae.long1.wav",
    "Phae.long2.wav", "Phae.long3.wav", "Phae.long4.wav"), import = F, at.the.time = 1, 
 all.data = TRUE)  
{% endhighlight %}

![gif5](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/run_raven1.gif)
 &nbsp; 
 
See `imp_raven` above for more details on additional settings when importing selections.

---

### *raven_batch_detec*

As the name suggests, *raven_batch_detec* runs [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) detector on multiple sound files (sequentially). Batch detection in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) can also take files in 'mp3', 'flac' and 'aif' format (although this could not be further analyzed in R at the time!).

This is example runs the detector on one of the example sound files that comes by default with [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html):


{% highlight r %}
detec.res <- raven_batch_detec(raven.path = raven.path, 
  sound.files = "BlackCappedVireo.aif", detector.type = "Amplitude Detector",
  path = file.path(raven.path, "Examples"))
{% endhighlight %}

![gif6](https://raw.githubusercontent.com/maRce10/Rraven/master/gifs/raven_batch_detec.gif)
 &nbsp; 
 
---

Please report any bugs [here](https://github.com/maRce10/Rraven/issues). The `Rraven` package should be cited as follows: 

Araya-Salas. (2017), *Rraven: connecting R and Raven bioacoustic software*. R package version 1.0.0.



