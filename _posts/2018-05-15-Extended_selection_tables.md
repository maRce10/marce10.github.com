---
layout: post
title: Extended selection tables
date: 15-05-2018
---

This post shows how to create and use the new [warbleR](https://cran.r-project.org/package=warbleR) object class *extended_selection_table*.

These objects are created with the `selec_table()` function. The function takes data frames containing selection data (sound file name, selection, start, end ...), checks whether the information is consistent (see `checksels()` function for details) and saves the 'diagnostic' metadata as an attribute. When the argument `extended = TRUE` the function generates an object of class *extended_selection_table* which also contains a list of wave objects corresponding to each of the selections in the data frame. Hence, the function **transforms selection tables into self-contained objects** as they no longer need the original sound files for running most acoustic analysis in 
[warbleR](https://cran.r-project.org/package=warbleR). This can facilitate a lot the storing and sharing of (bio)acoustic data. In addition, it also speeds up processes as sound files do not need to be read every time the data is analyzed.

Let's first install and/or load [warbleR](https://cran.r-project.org/package=warbleR) developmental version (if there is an older [warbleR](https://cran.r-project.org/package=warbleR) version installed it has to be removed first):


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



... set a temporary folder, load the example sound files and set [warbleR](https://cran.r-project.org/package=warbleR) options (see `warbleR_options()` documentation):


{% highlight r %}
# set temporary directory
setwd(tempdir())

# load example data
data(list = c("Phae.long1", "Phae.long2", "Phae.long3", "Phae.long4",
              "selec.table"))

# save recordings as wave files
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")

# set warbleR options
warbleR_options(wl = 300, pb = FALSE, 
          parallel = parallel::detectCores() - 1)
{% endhighlight %}

Now, as mentioned above, you need the `selec_table()` function to create extended selection table. You also need to set the the argument `extended = TRUE` (otherwise the class would be a "selection_table"). Here the example data that comes with [warbleR](https://cran.r-project.org/package=warbleR) is used as the data frame to be converted to an object of class *extended_selection_table*:



{% highlight r %}
selec.table
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:740px; "><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> channel </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
   <th style="text-align:center;"> sel.comment </th>
   <th style="text-align:center;"> rec.comment </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.1693549 </td>
   <td style="text-align:center;"> 1.3423884 </td>
   <td style="text-align:center;"> 2.220105 </td>
   <td style="text-align:center;"> 8.604378 </td>
   <td style="text-align:center;"> c24 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2.1584085 </td>
   <td style="text-align:center;"> 2.3214565 </td>
   <td style="text-align:center;"> 2.169437 </td>
   <td style="text-align:center;"> 8.807053 </td>
   <td style="text-align:center;"> c25 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.3433366 </td>
   <td style="text-align:center;"> 0.5182553 </td>
   <td style="text-align:center;"> 2.218294 </td>
   <td style="text-align:center;"> 8.756604 </td>
   <td style="text-align:center;"> c26 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1595983 </td>
   <td style="text-align:center;"> 0.2921692 </td>
   <td style="text-align:center;"> 2.316862 </td>
   <td style="text-align:center;"> 8.822316 </td>
   <td style="text-align:center;"> c27 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.4570585 </td>
   <td style="text-align:center;"> 1.5832087 </td>
   <td style="text-align:center;"> 2.284006 </td>
   <td style="text-align:center;"> 8.888027 </td>
   <td style="text-align:center;"> c28 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.6265520 </td>
   <td style="text-align:center;"> 0.7577715 </td>
   <td style="text-align:center;"> 3.006834 </td>
   <td style="text-align:center;"> 8.822316 </td>
   <td style="text-align:center;"> c29 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.9742132 </td>
   <td style="text-align:center;"> 2.1043921 </td>
   <td style="text-align:center;"> 2.776843 </td>
   <td style="text-align:center;"> 8.888027 </td>
   <td style="text-align:center;"> c30 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.1233643 </td>
   <td style="text-align:center;"> 0.2545812 </td>
   <td style="text-align:center;"> 2.316862 </td>
   <td style="text-align:center;"> 9.315153 </td>
   <td style="text-align:center;"> c31 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.5168116 </td>
   <td style="text-align:center;"> 1.6622365 </td>
   <td style="text-align:center;"> 2.513997 </td>
   <td style="text-align:center;"> 9.216586 </td>
   <td style="text-align:center;"> c32 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2.9326920 </td>
   <td style="text-align:center;"> 3.0768784 </td>
   <td style="text-align:center;"> 2.579708 </td>
   <td style="text-align:center;"> 10.235116 </td>
   <td style="text-align:center;"> c33 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.1453977 </td>
   <td style="text-align:center;"> 0.2904966 </td>
   <td style="text-align:center;"> 2.579708 </td>
   <td style="text-align:center;"> 9.742279 </td>
   <td style="text-align:center;"> c34 </td>
   <td style="text-align:center;"> NA </td>
  </tr>
</tbody>
</table></div>

The following code converts it to an extended selection table:


{% highlight r %}
# make extended selection table
ext_st <- selection_table(X = selec.table, pb = FALSE, 
          extended = TRUE, confirm.extended = FALSE)
{% endhighlight %}

And that's it. Now the acoustic data and the selection data (as well as the additional metadata) are all together in a single *R* object.

 &nbsp; 
 
## Manipulating extended selection tables

Several functions can be used to deal with objects of this class. You can test if the object belongs to the *extended_selection_table*:


{% highlight r %}
is_extended_selection_table(ext_st)
{% endhighlight %}



{% highlight text %}
[1] TRUE
{% endhighlight %}


You can subset the selection in the same way that any other data frame in it will maintain its attributes:


{% highlight r %}
ext_st2 <- ext_st[1:2, ]

is_extended_selection_table(ext_st2)
{% endhighlight %}



{% highlight text %}
[1] TRUE
{% endhighlight %}

There is also a generic version of `print()` for these class of objects: 


{% highlight r %}
## print
print(ext_st)
{% endhighlight %}



{% highlight text %}
object of class 'extended_selection_table' 
 contains a selection table data frame with 11 rows and 9 columns: 
       sound.files channel selec start       end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.2730334    2.220105 8.604378         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.2630480    2.169437 8.807053         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.2749187    2.218294 8.756604         c26          NA
4 Phae.long2.wav_1       1     1   0.1 0.2325709    2.316862 8.822316         c27          NA
5 Phae.long2.wav_2       1     1   0.1 0.2261502    2.284006 8.888027         c28          NA
6 Phae.long3.wav_1       1     1   0.1 0.2312195    3.006834 8.822316         c29          NA
... and 5 more rows 
11 wave objects (as attributes): 
[1] "Phae.long1.wav_1" "Phae.long1.wav_2" "Phae.long1.wav_3" "Phae.long2.wav_1" "Phae.long2.wav_2"
[6] "Phae.long3.wav_1"
... and 5 more 
and a data frame (check.results) generated by checkres() (as attribute) 
the selection table was created by element (see 'class_extended_selection_table')
{% endhighlight %}


{% highlight r %}
## which is the same than this
ext_st
{% endhighlight %}


{% highlight text %}
object of class 'extended_selection_table' 
 contains a selection table data frame with 11 rows and 9 columns: 
       sound.files channel selec start       end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.2730334    2.220105 8.604378         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.2630480    2.169437 8.807053         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.2749187    2.218294 8.756604         c26          NA
4 Phae.long2.wav_1       1     1   0.1 0.2325709    2.316862 8.822316         c27          NA
5 Phae.long2.wav_2       1     1   0.1 0.2261502    2.284006 8.888027         c28          NA
6 Phae.long3.wav_1       1     1   0.1 0.2312195    3.006834 8.822316         c29          NA
... and 5 more rows 
11 wave objects (as attributes): 
[1] "Phae.long1.wav_1" "Phae.long1.wav_2" "Phae.long1.wav_3" "Phae.long2.wav_1" "Phae.long2.wav_2"
[6] "Phae.long3.wav_1"
... and 5 more 
and a data frame (check.results) generated by checkres() (as attribute) 
the selection table was created by element (see 'class_extended_selection_table')
{% endhighlight %}

You can also row-bind them together. Here the original *extended_selection_table* is split into 2 and bind back together using `rbind()`:


{% highlight r %}
ext_st3 <- ext_st[1:5, ]

ext_st4 <- ext_st[6:11, ]

ext_st5 <- rbind(ext_st3, ext_st4)

#print
ext_st5
{% endhighlight %}


{% highlight text %}
object of class 'extended_selection_table' 
 contains a selection table data frame with 11 rows and 9 columns: 
       sound.files channel selec start       end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.2730334    2.220105 8.604378         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.2630480    2.169437 8.807053         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.2749187    2.218294 8.756604         c26          NA
4 Phae.long2.wav_1       1     1   0.1 0.2325709    2.316862 8.822316         c27          NA
5 Phae.long2.wav_2       1     1   0.1 0.2261502    2.284006 8.888027         c28          NA
6 Phae.long3.wav_1       1     1   0.1 0.2312195    3.006834 8.822316         c29          NA
... and 5 more rows 
11 wave objects (as attributes): 
[1] "Phae.long1.wav_1" "Phae.long1.wav_2" "Phae.long1.wav_3" "Phae.long2.wav_1" "Phae.long2.wav_2"
[6] "Phae.long3.wav_1"
... and 5 more 
and a data frame (check.results) generated by checkres() (as attribute) 
the selection table was created by element (see 'class_extended_selection_table')
{% endhighlight %}


{% highlight r %}
# the same than the original one
all.equal(ext_st, ext_st5)
{% endhighlight %}



{% highlight text %}
[1] TRUE
{% endhighlight %}


The wave objects can be indvidually read using `read_wave()`, a wrapper on tuneR's `readWave()` function, that can take extended selection tables: 


{% highlight r %}
wv1 <- read_wave(X = ext_st, index = 3, from = 0, to = 0.37)
{% endhighlight %}

These are regular wave objects:


{% highlight r %}
class(wv1)
{% endhighlight %}



{% highlight text %}
[1] "Wave"
attr(,"package")
[1] "tuneR"
{% endhighlight %}



{% highlight r %}
wv1
{% endhighlight %}



{% highlight text %}

Wave Object
	Number of Samples:      8325
	Duration (seconds):     0.37
	Samplingrate (Hertz):   22500
	Channels (Mono/Stereo): Mono
	PCM (integer format):   TRUE
	Bit (8/16/24/32/64):    16 
{% endhighlight %}



{% highlight r %}
spectro(wv1, wl = 150, grid = FALSE, scale = FALSE, ovlp = 90)
{% endhighlight %}

<img src="/assets/Rfig/extn_sel_8.22-1.png" title="plot of chunk extn_sel_8.22" alt="plot of chunk extn_sel_8.22" width="750" />
<font size="3"><i>Spectrogram of the third selection in the  example 'ext_st' extended selection table</i></font>

&nbsp; 


{% highlight r %}
par(mfrow = c(3, 2), mar = rep(0, 4))

for(i in 1:6){
  
  wv <- read_wave(X = ext_st, index = i, from = 0.05, to = 0.32)

  spectro(wv, wl = 150, grid = FALSE, scale = FALSE, axisX = FALSE,
          axisY = FALSE, ovlp = 90)

}
{% endhighlight %}

<img src="/assets/Rfig/extn_sel_8.23-1.png" title="plot of chunk extn_sel_8.23" alt="plot of chunk extn_sel_8.23" width="750" />
<font size="3"><i>Spectrograms of the first 6 selections in the  example 'ext_st' extended selection table</i></font>

The `read_wave()` function takes the table as well as the index of the selection to be read (e.g. the row number).

Keep in mind that is likely that other functions that modify data frames will remove the attributes in which wave objects and metadata are stored. For instances, merging and extended selection table will get rid of its attributes:


{% highlight r %}
# create a new data frame 
Y <- data.frame(sound.files = ext_st$sound.files, site = "La Selva", lek = c(rep("SUR", 5), rep("CCL", 6)))

# merge
mrg_ext_st <- merge(ext_st, Y, by = "sound.files")

# check class
is_extended_selection_table(mrg_ext_st)
{% endhighlight %}



{% highlight text %}
[1] FALSE
{% endhighlight %}

In this case we can use the `fix_extended_selection_table()` function to transfer the attributes from the original extended selection table:


{% highlight r %}
# fix
mrg_ext_st <- fix_extended_selection_table(X = mrg_ext_st, Y = ext_st)

# check class
is_extended_selection_table(mrg_ext_st)
{% endhighlight %}



{% highlight text %}
[1] TRUE
{% endhighlight %}

This would work as long as some of the original sound files are kept an no other selections are added.

&nbsp; 

## Object size

Extended selection table size will be a function of the number of selections, sampling rate, selection duration and margin duration (the margin is how much extra time you want to keep at each side of the selection). In this example a data frame with 1000 selections is created just by repeating the example data frame several times and then converted to an extended selection table:



{% highlight r %}
lng.selec.table <- do.call(rbind, replicate(100, selec.table, 
                        simplify = FALSE))[1:1000,]

lng.selec.table$selec <- 1:nrow(lng.selec.table)

nrow(lng.selec.table)

lng_ext_st <- selection_table(X = lng.selec.table, pb = FALSE, 
                        extended = TRUE, confirm.extended = FALSE)

lng_ext_st
{% endhighlight %}



{% highlight text %}
object of class 'extended_selection_table' 
 contains a selection table data frame with 1000 rows and 9 columns: 
       sound.files channel selec start       end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.2730334    2.220105 8.604378         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.2630480    2.169437 8.807053         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.2749187    2.218294 8.756604         c26          NA
4 Phae.long2.wav_4       1     1   0.1 0.2325709    2.316862 8.822316         c27          NA
5 Phae.long2.wav_5       1     1   0.1 0.2261502    2.284006 8.888027         c28          NA
6 Phae.long3.wav_6       1     1   0.1 0.2312195    3.006834 8.822316         c29          NA
... and 994 more rows 
1000 wave objects (as attributes): 
[1] "Phae.long1.wav_1" "Phae.long1.wav_2" "Phae.long1.wav_3" "Phae.long2.wav_4" "Phae.long2.wav_5"
[6] "Phae.long3.wav_6"
... and 994 more 
and a data frame (check.results) generated by checkres() (as attribute) 
the selection table was created by element (see 'class_extended_selection_table')
{% endhighlight %}


{% highlight r %}
format(object.size(lng_ext_st), units = "auto")
{% endhighlight %}



{% highlight text %}
[1] "31.3 Mb"
{% endhighlight %}

As you can see the object size is only ~31 MB. So, as a guide, a selection table with 1000 selections similar to those in 'selec.table' (mean duration ~0.15 seconds) at 22.5 kHz sampling rate and the default margin (mar = 0.1) will generate an extended selection table of ~31 MB or ~310 MB for a 10000 row selection table. 

&nbsp; 
 
## Running analysis on extended selection tables

These objects can be used as input for most [warbleR](https://cran.r-project.org/package=warbleR) functions. We need to delete the sound files in order to show the data is actually contained in the new objects:


{% highlight r %}
list.files(pattern = "\\.wav$")
{% endhighlight %}



{% highlight text %}
[1] "Phae.long1.wav" "Phae.long2.wav" "Phae.long3.wav" "Phae.long4.wav"
{% endhighlight %}



{% highlight r %}
# delete files (be careful not to run this 
# if you have sound files in the working directory!)
unlink(list.files(pattern = "\\.wav$"))

list.files(pattern = "\\.wav$")
{% endhighlight %}



{% highlight text %}
character(0)
{% endhighlight %}

Here are a few examples of [warbleR](https://cran.r-project.org/package=warbleR) functions using *extended_selection_table*:

#### Spectral parameters


{% highlight r %}
# spectral parameters
sp <- specan(ext_st)

sp
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:740px; "><table>
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
   <th style="text-align:center;"> meanfun </th>
   <th style="text-align:center;"> minfun </th>
   <th style="text-align:center;"> maxfun </th>
   <th style="text-align:center;"> meandom </th>
   <th style="text-align:center;"> mindom </th>
   <th style="text-align:center;"> maxdom </th>
   <th style="text-align:center;"> dfrange </th>
   <th style="text-align:center;"> modindx </th>
   <th style="text-align:center;"> startdom </th>
   <th style="text-align:center;"> enddom </th>
   <th style="text-align:center;"> dfslope </th>
   <th style="text-align:center;"> meanpeakf </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1730334 </td>
   <td style="text-align:center;"> 6.031212 </td>
   <td style="text-align:center;"> 2.083594 </td>
   <td style="text-align:center;"> 6.355941 </td>
   <td style="text-align:center;"> 5.152997 </td>
   <td style="text-align:center;"> 7.015247 </td>
   <td style="text-align:center;"> 1.862250 </td>
   <td style="text-align:center;"> 0.0827710 </td>
   <td style="text-align:center;"> 0.0526725 </td>
   <td style="text-align:center;"> 0.1203942 </td>
   <td style="text-align:center;"> 0.0677217 </td>
   <td style="text-align:center;"> 2.685397 </td>
   <td style="text-align:center;"> 11.058567 </td>
   <td style="text-align:center;"> 0.9273438 </td>
   <td style="text-align:center;"> 0.9401254 </td>
   <td style="text-align:center;"> 0.8718195 </td>
   <td style="text-align:center;"> 0.5620101 </td>
   <td style="text-align:center;"> 3.692602 </td>
   <td style="text-align:center;"> 2.5000000 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.600000 </td>
   <td style="text-align:center;"> 4.425 </td>
   <td style="text-align:center;"> 8.250 </td>
   <td style="text-align:center;"> 3.825 </td>
   <td style="text-align:center;"> 3.588235 </td>
   <td style="text-align:center;"> 7.125 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 0.4334422 </td>
   <td style="text-align:center;"> 7.135135 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1630480 </td>
   <td style="text-align:center;"> 6.019499 </td>
   <td style="text-align:center;"> 2.069686 </td>
   <td style="text-align:center;"> 6.251534 </td>
   <td style="text-align:center;"> 5.233129 </td>
   <td style="text-align:center;"> 7.036810 </td>
   <td style="text-align:center;"> 1.803681 </td>
   <td style="text-align:center;"> 0.0741414 </td>
   <td style="text-align:center;"> 0.0444848 </td>
   <td style="text-align:center;"> 0.1186263 </td>
   <td style="text-align:center;"> 0.0741414 </td>
   <td style="text-align:center;"> 2.532979 </td>
   <td style="text-align:center;"> 10.766880 </td>
   <td style="text-align:center;"> 0.9311507 </td>
   <td style="text-align:center;"> 0.9444385 </td>
   <td style="text-align:center;"> 0.8794146 </td>
   <td style="text-align:center;"> 0.5808380 </td>
   <td style="text-align:center;"> 3.268827 </td>
   <td style="text-align:center;"> 0.4411765 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.704348 </td>
   <td style="text-align:center;"> 5.250 </td>
   <td style="text-align:center;"> 8.325 </td>
   <td style="text-align:center;"> 3.075 </td>
   <td style="text-align:center;"> 4.487805 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 1.8399488 </td>
   <td style="text-align:center;"> 6.908615 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1749187 </td>
   <td style="text-align:center;"> 6.068502 </td>
   <td style="text-align:center;"> 2.152708 </td>
   <td style="text-align:center;"> 6.463859 </td>
   <td style="text-align:center;"> 4.993760 </td>
   <td style="text-align:center;"> 7.133125 </td>
   <td style="text-align:center;"> 2.139366 </td>
   <td style="text-align:center;"> 0.0874889 </td>
   <td style="text-align:center;"> 0.0510352 </td>
   <td style="text-align:center;"> 0.1312333 </td>
   <td style="text-align:center;"> 0.0801981 </td>
   <td style="text-align:center;"> 3.129201 </td>
   <td style="text-align:center;"> 16.019948 </td>
   <td style="text-align:center;"> 0.9302016 </td>
   <td style="text-align:center;"> 0.9378310 </td>
   <td style="text-align:center;"> 0.8723719 </td>
   <td style="text-align:center;"> 0.5782679 </td>
   <td style="text-align:center;"> 3.681525 </td>
   <td style="text-align:center;"> 1.1842105 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.705000 </td>
   <td style="text-align:center;"> 4.200 </td>
   <td style="text-align:center;"> 8.625 </td>
   <td style="text-align:center;"> 4.425 </td>
   <td style="text-align:center;"> 4.542373 </td>
   <td style="text-align:center;"> 7.050 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 0.8575410 </td>
   <td style="text-align:center;"> 6.833108 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1325709 </td>
   <td style="text-align:center;"> 6.582354 </td>
   <td style="text-align:center;"> 1.930852 </td>
   <td style="text-align:center;"> 6.741936 </td>
   <td style="text-align:center;"> 5.601922 </td>
   <td style="text-align:center;"> 7.610158 </td>
   <td style="text-align:center;"> 2.008236 </td>
   <td style="text-align:center;"> 0.0780131 </td>
   <td style="text-align:center;"> 0.0546092 </td>
   <td style="text-align:center;"> 0.1092183 </td>
   <td style="text-align:center;"> 0.0546092 </td>
   <td style="text-align:center;"> 2.187037 </td>
   <td style="text-align:center;"> 8.869608 </td>
   <td style="text-align:center;"> 0.9244770 </td>
   <td style="text-align:center;"> 0.9502923 </td>
   <td style="text-align:center;"> 0.8785233 </td>
   <td style="text-align:center;"> 0.5187552 </td>
   <td style="text-align:center;"> 6.036429 </td>
   <td style="text-align:center;"> 0.9000000 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.366176 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 7.575 </td>
   <td style="text-align:center;"> 2.550 </td>
   <td style="text-align:center;"> 4.294118 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 5.925 </td>
   <td style="text-align:center;"> 6.7888197 </td>
   <td style="text-align:center;"> 7.361655 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1261502 </td>
   <td style="text-align:center;"> 6.416834 </td>
   <td style="text-align:center;"> 1.946701 </td>
   <td style="text-align:center;"> 6.642857 </td>
   <td style="text-align:center;"> 5.539682 </td>
   <td style="text-align:center;"> 7.468254 </td>
   <td style="text-align:center;"> 1.928571 </td>
   <td style="text-align:center;"> 0.0788611 </td>
   <td style="text-align:center;"> 0.0552028 </td>
   <td style="text-align:center;"> 0.1025194 </td>
   <td style="text-align:center;"> 0.0473167 </td>
   <td style="text-align:center;"> 3.127716 </td>
   <td style="text-align:center;"> 15.809954 </td>
   <td style="text-align:center;"> 0.9179078 </td>
   <td style="text-align:center;"> 0.9500973 </td>
   <td style="text-align:center;"> 0.8721017 </td>
   <td style="text-align:center;"> 0.5271001 </td>
   <td style="text-align:center;"> 5.592905 </td>
   <td style="text-align:center;"> 0.3040541 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.172059 </td>
   <td style="text-align:center;"> 4.800 </td>
   <td style="text-align:center;"> 7.575 </td>
   <td style="text-align:center;"> 2.775 </td>
   <td style="text-align:center;"> 2.783784 </td>
   <td style="text-align:center;"> 4.800 </td>
   <td style="text-align:center;"> 6.525 </td>
   <td style="text-align:center;"> 13.6741761 </td>
   <td style="text-align:center;"> 6.757601 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1312195 </td>
   <td style="text-align:center;"> 6.621037 </td>
   <td style="text-align:center;"> 1.836131 </td>
   <td style="text-align:center;"> 6.690014 </td>
   <td style="text-align:center;"> 6.003467 </td>
   <td style="text-align:center;"> 7.552011 </td>
   <td style="text-align:center;"> 1.548544 </td>
   <td style="text-align:center;"> 0.0617621 </td>
   <td style="text-align:center;"> 0.0463216 </td>
   <td style="text-align:center;"> 0.0926431 </td>
   <td style="text-align:center;"> 0.0463216 </td>
   <td style="text-align:center;"> 2.641876 </td>
   <td style="text-align:center;"> 11.299532 </td>
   <td style="text-align:center;"> 0.9065283 </td>
   <td style="text-align:center;"> 0.9523297 </td>
   <td style="text-align:center;"> 0.8633138 </td>
   <td style="text-align:center;"> 0.4778577 </td>
   <td style="text-align:center;"> 6.696429 </td>
   <td style="text-align:center;"> 3.2142857 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.562500 </td>
   <td style="text-align:center;"> 4.875 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 2.325 </td>
   <td style="text-align:center;"> 3.129032 </td>
   <td style="text-align:center;"> 6.975 </td>
   <td style="text-align:center;"> 7.050 </td>
   <td style="text-align:center;"> 0.5715612 </td>
   <td style="text-align:center;"> 6.757601 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1301789 </td>
   <td style="text-align:center;"> 6.691256 </td>
   <td style="text-align:center;"> 1.789409 </td>
   <td style="text-align:center;"> 6.733753 </td>
   <td style="text-align:center;"> 6.072677 </td>
   <td style="text-align:center;"> 7.610063 </td>
   <td style="text-align:center;"> 1.537386 </td>
   <td style="text-align:center;"> 0.0689412 </td>
   <td style="text-align:center;"> 0.0459608 </td>
   <td style="text-align:center;"> 0.0995817 </td>
   <td style="text-align:center;"> 0.0536209 </td>
   <td style="text-align:center;"> 2.387293 </td>
   <td style="text-align:center;"> 8.901850 </td>
   <td style="text-align:center;"> 0.9025380 </td>
   <td style="text-align:center;"> 0.9540647 </td>
   <td style="text-align:center;"> 0.8610797 </td>
   <td style="text-align:center;"> 0.4631660 </td>
   <td style="text-align:center;"> 6.383929 </td>
   <td style="text-align:center;"> 2.5000000 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.291667 </td>
   <td style="text-align:center;"> 4.575 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 2.325 </td>
   <td style="text-align:center;"> 2.161290 </td>
   <td style="text-align:center;"> 4.575 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 17.8600337 </td>
   <td style="text-align:center;"> 6.682095 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1312170 </td>
   <td style="text-align:center;"> 6.518579 </td>
   <td style="text-align:center;"> 1.853367 </td>
   <td style="text-align:center;"> 6.651872 </td>
   <td style="text-align:center;"> 5.911928 </td>
   <td style="text-align:center;"> 7.544383 </td>
   <td style="text-align:center;"> 1.632455 </td>
   <td style="text-align:center;"> 0.0694824 </td>
   <td style="text-align:center;"> 0.0386013 </td>
   <td style="text-align:center;"> 0.1003634 </td>
   <td style="text-align:center;"> 0.0617621 </td>
   <td style="text-align:center;"> 2.463813 </td>
   <td style="text-align:center;"> 9.271742 </td>
   <td style="text-align:center;"> 0.9040347 </td>
   <td style="text-align:center;"> 0.9578105 </td>
   <td style="text-align:center;"> 0.8658939 </td>
   <td style="text-align:center;"> 0.4799569 </td>
   <td style="text-align:center;"> 7.125000 </td>
   <td style="text-align:center;"> 5.6250000 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.145833 </td>
   <td style="text-align:center;"> 4.650 </td>
   <td style="text-align:center;"> 6.675 </td>
   <td style="text-align:center;"> 2.025 </td>
   <td style="text-align:center;"> 1.555556 </td>
   <td style="text-align:center;"> 4.650 </td>
   <td style="text-align:center;"> 6.600 </td>
   <td style="text-align:center;"> 14.8608842 </td>
   <td style="text-align:center;"> 6.757601 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1454249 </td>
   <td style="text-align:center;"> 6.157345 </td>
   <td style="text-align:center;"> 2.074651 </td>
   <td style="text-align:center;"> 6.229662 </td>
   <td style="text-align:center;"> 5.259074 </td>
   <td style="text-align:center;"> 7.441177 </td>
   <td style="text-align:center;"> 2.182103 </td>
   <td style="text-align:center;"> 0.0842175 </td>
   <td style="text-align:center;"> 0.0459368 </td>
   <td style="text-align:center;"> 0.1148421 </td>
   <td style="text-align:center;"> 0.0689053 </td>
   <td style="text-align:center;"> 1.712257 </td>
   <td style="text-align:center;"> 5.812690 </td>
   <td style="text-align:center;"> 0.9429944 </td>
   <td style="text-align:center;"> 0.9524869 </td>
   <td style="text-align:center;"> 0.8981898 </td>
   <td style="text-align:center;"> 0.6186328 </td>
   <td style="text-align:center;"> 3.402788 </td>
   <td style="text-align:center;"> 1.3235294 </td>
   <td style="text-align:center;"> 5.625 </td>
   <td style="text-align:center;"> 6.165000 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> 8.250 </td>
   <td style="text-align:center;"> 4.275 </td>
   <td style="text-align:center;"> 2.807018 </td>
   <td style="text-align:center;"> 5.325 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> -9.2831413 </td>
   <td style="text-align:center;"> 6.304561 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1441864 </td>
   <td style="text-align:center;"> 6.280565 </td>
   <td style="text-align:center;"> 2.096399 </td>
   <td style="text-align:center;"> 6.270833 </td>
   <td style="text-align:center;"> 5.409722 </td>
   <td style="text-align:center;"> 7.611111 </td>
   <td style="text-align:center;"> 2.201389 </td>
   <td style="text-align:center;"> 0.0834971 </td>
   <td style="text-align:center;"> 0.0455439 </td>
   <td style="text-align:center;"> 0.1138596 </td>
   <td style="text-align:center;"> 0.0683158 </td>
   <td style="text-align:center;"> 2.013845 </td>
   <td style="text-align:center;"> 7.832905 </td>
   <td style="text-align:center;"> 0.9433548 </td>
   <td style="text-align:center;"> 0.9535929 </td>
   <td style="text-align:center;"> 0.8995765 </td>
   <td style="text-align:center;"> 0.6224900 </td>
   <td style="text-align:center;"> 3.720779 </td>
   <td style="text-align:center;"> 2.8125000 </td>
   <td style="text-align:center;"> 5.625 </td>
   <td style="text-align:center;"> 6.532500 </td>
   <td style="text-align:center;"> 3.750 </td>
   <td style="text-align:center;"> 8.775 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 2.850746 </td>
   <td style="text-align:center;"> 8.025 </td>
   <td style="text-align:center;"> 3.750 </td>
   <td style="text-align:center;"> -29.6491108 </td>
   <td style="text-align:center;"> 6.229054 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1450989 </td>
   <td style="text-align:center;"> 5.997400 </td>
   <td style="text-align:center;"> 2.083225 </td>
   <td style="text-align:center;"> 6.048276 </td>
   <td style="text-align:center;"> 4.917241 </td>
   <td style="text-align:center;"> 7.303448 </td>
   <td style="text-align:center;"> 2.386207 </td>
   <td style="text-align:center;"> 0.0840374 </td>
   <td style="text-align:center;"> 0.0458386 </td>
   <td style="text-align:center;"> 0.1145965 </td>
   <td style="text-align:center;"> 0.0687579 </td>
   <td style="text-align:center;"> 1.502165 </td>
   <td style="text-align:center;"> 5.138909 </td>
   <td style="text-align:center;"> 0.9459931 </td>
   <td style="text-align:center;"> 0.9535637 </td>
   <td style="text-align:center;"> 0.9020647 </td>
   <td style="text-align:center;"> 0.6213267 </td>
   <td style="text-align:center;"> 3.538149 </td>
   <td style="text-align:center;"> 2.8125000 </td>
   <td style="text-align:center;"> 5.625 </td>
   <td style="text-align:center;"> 6.071250 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> 7.875 </td>
   <td style="text-align:center;"> 3.900 </td>
   <td style="text-align:center;"> 3.884615 </td>
   <td style="text-align:center;"> 7.875 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> -26.8782139 </td>
   <td style="text-align:center;"> 6.002534 </td>
  </tr>
</tbody>
</table></div>
&nbsp; 

#### Cross correlation


{% highlight r %}
xc <- xcorr(ext_st, frange = c(1, 11))

xc
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-y: scroll; height:500px; overflow-x: scroll; width:740px; "><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Phae.long1.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long1.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long1.wav_3-1 </th>
   <th style="text-align:center;"> Phae.long2.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long2.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long3.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long3.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long3.wav_3-1 </th>
   <th style="text-align:center;"> Phae.long4.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long4.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long4.wav_3-1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_1-1 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7034040 </td>
   <td style="text-align:center;"> 0.6783677 </td>
   <td style="text-align:center;"> 0.3755010 </td>
   <td style="text-align:center;"> 0.3724889 </td>
   <td style="text-align:center;"> 0.4098561 </td>
   <td style="text-align:center;"> 0.3620638 </td>
   <td style="text-align:center;"> 0.4032020 </td>
   <td style="text-align:center;"> 0.3151687 </td>
   <td style="text-align:center;"> 0.3142244 </td>
   <td style="text-align:center;"> 0.3206940 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_2-1 </td>
   <td style="text-align:center;"> 0.7034040 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.6472523 </td>
   <td style="text-align:center;"> 0.3956297 </td>
   <td style="text-align:center;"> 0.4008818 </td>
   <td style="text-align:center;"> 0.4035755 </td>
   <td style="text-align:center;"> 0.3629669 </td>
   <td style="text-align:center;"> 0.4081520 </td>
   <td style="text-align:center;"> 0.3080552 </td>
   <td style="text-align:center;"> 0.3152465 </td>
   <td style="text-align:center;"> 0.3142294 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_3-1 </td>
   <td style="text-align:center;"> 0.6783677 </td>
   <td style="text-align:center;"> 0.6472523 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.3999605 </td>
   <td style="text-align:center;"> 0.4014589 </td>
   <td style="text-align:center;"> 0.4092489 </td>
   <td style="text-align:center;"> 0.3809013 </td>
   <td style="text-align:center;"> 0.4146414 </td>
   <td style="text-align:center;"> 0.3054763 </td>
   <td style="text-align:center;"> 0.2938380 </td>
   <td style="text-align:center;"> 0.3212807 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_1-1 </td>
   <td style="text-align:center;"> 0.3755010 </td>
   <td style="text-align:center;"> 0.3956297 </td>
   <td style="text-align:center;"> 0.3999605 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.6689158 </td>
   <td style="text-align:center;"> 0.6427551 </td>
   <td style="text-align:center;"> 0.6462935 </td>
   <td style="text-align:center;"> 0.6015293 </td>
   <td style="text-align:center;"> 0.3236695 </td>
   <td style="text-align:center;"> 0.2937998 </td>
   <td style="text-align:center;"> 0.3248965 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_2-1 </td>
   <td style="text-align:center;"> 0.3724889 </td>
   <td style="text-align:center;"> 0.4008818 </td>
   <td style="text-align:center;"> 0.4014589 </td>
   <td style="text-align:center;"> 0.6689158 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.6070253 </td>
   <td style="text-align:center;"> 0.6291550 </td>
   <td style="text-align:center;"> 0.6337109 </td>
   <td style="text-align:center;"> 0.3104575 </td>
   <td style="text-align:center;"> 0.2798751 </td>
   <td style="text-align:center;"> 0.3123053 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_1-1 </td>
   <td style="text-align:center;"> 0.4098561 </td>
   <td style="text-align:center;"> 0.4035755 </td>
   <td style="text-align:center;"> 0.4092489 </td>
   <td style="text-align:center;"> 0.6427551 </td>
   <td style="text-align:center;"> 0.6070253 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7540328 </td>
   <td style="text-align:center;"> 0.7098788 </td>
   <td style="text-align:center;"> 0.3055091 </td>
   <td style="text-align:center;"> 0.2780385 </td>
   <td style="text-align:center;"> 0.2964363 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_2-1 </td>
   <td style="text-align:center;"> 0.3620638 </td>
   <td style="text-align:center;"> 0.3629669 </td>
   <td style="text-align:center;"> 0.3809013 </td>
   <td style="text-align:center;"> 0.6462935 </td>
   <td style="text-align:center;"> 0.6291550 </td>
   <td style="text-align:center;"> 0.7540328 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7335990 </td>
   <td style="text-align:center;"> 0.3031006 </td>
   <td style="text-align:center;"> 0.2790153 </td>
   <td style="text-align:center;"> 0.3012493 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_3-1 </td>
   <td style="text-align:center;"> 0.4032020 </td>
   <td style="text-align:center;"> 0.4081520 </td>
   <td style="text-align:center;"> 0.4146414 </td>
   <td style="text-align:center;"> 0.6015293 </td>
   <td style="text-align:center;"> 0.6337109 </td>
   <td style="text-align:center;"> 0.7098788 </td>
   <td style="text-align:center;"> 0.7335990 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.3126956 </td>
   <td style="text-align:center;"> 0.2837184 </td>
   <td style="text-align:center;"> 0.3011785 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_1-1 </td>
   <td style="text-align:center;"> 0.3151687 </td>
   <td style="text-align:center;"> 0.3080552 </td>
   <td style="text-align:center;"> 0.3054763 </td>
   <td style="text-align:center;"> 0.3236695 </td>
   <td style="text-align:center;"> 0.3104575 </td>
   <td style="text-align:center;"> 0.3055091 </td>
   <td style="text-align:center;"> 0.3031006 </td>
   <td style="text-align:center;"> 0.3126956 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7682193 </td>
   <td style="text-align:center;"> 0.7549883 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_2-1 </td>
   <td style="text-align:center;"> 0.3142244 </td>
   <td style="text-align:center;"> 0.3152465 </td>
   <td style="text-align:center;"> 0.2938380 </td>
   <td style="text-align:center;"> 0.2937998 </td>
   <td style="text-align:center;"> 0.2798751 </td>
   <td style="text-align:center;"> 0.2780385 </td>
   <td style="text-align:center;"> 0.2790153 </td>
   <td style="text-align:center;"> 0.2837184 </td>
   <td style="text-align:center;"> 0.7682193 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7600940 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_3-1 </td>
   <td style="text-align:center;"> 0.3206940 </td>
   <td style="text-align:center;"> 0.3142294 </td>
   <td style="text-align:center;"> 0.3212807 </td>
   <td style="text-align:center;"> 0.3248965 </td>
   <td style="text-align:center;"> 0.3123053 </td>
   <td style="text-align:center;"> 0.2964363 </td>
   <td style="text-align:center;"> 0.3012493 </td>
   <td style="text-align:center;"> 0.3011785 </td>
   <td style="text-align:center;"> 0.7549883 </td>
   <td style="text-align:center;"> 0.7600940 </td>
   <td style="text-align:center;"> 1.0000000 </td>
  </tr>
</tbody>
</table></div>
&nbsp; 

#### Signal-to-noise ratio


{% highlight r %}
# signal-to-noise ratio
snr <- sig2noise(ext_st, mar = 0.05)

snr
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:740px; "><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> channel </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
   <th style="text-align:center;"> sel.comment </th>
   <th style="text-align:center;"> rec.comment </th>
   <th style="text-align:center;"> SNR </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2730334 </td>
   <td style="text-align:center;"> 2.220105 </td>
   <td style="text-align:center;"> 8.604378 </td>
   <td style="text-align:center;"> c24 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 21.18244 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2630480 </td>
   <td style="text-align:center;"> 2.169437 </td>
   <td style="text-align:center;"> 8.807053 </td>
   <td style="text-align:center;"> c25 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 20.35483 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2749187 </td>
   <td style="text-align:center;"> 2.218294 </td>
   <td style="text-align:center;"> 8.756604 </td>
   <td style="text-align:center;"> c26 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 19.16430 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2325709 </td>
   <td style="text-align:center;"> 2.316862 </td>
   <td style="text-align:center;"> 8.822316 </td>
   <td style="text-align:center;"> c27 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 23.27315 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2261502 </td>
   <td style="text-align:center;"> 2.284006 </td>
   <td style="text-align:center;"> 8.888027 </td>
   <td style="text-align:center;"> c28 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 26.20566 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2312195 </td>
   <td style="text-align:center;"> 3.006834 </td>
   <td style="text-align:center;"> 8.822316 </td>
   <td style="text-align:center;"> c29 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 25.32589 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2301789 </td>
   <td style="text-align:center;"> 2.776843 </td>
   <td style="text-align:center;"> 8.888027 </td>
   <td style="text-align:center;"> c30 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 25.50842 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2312170 </td>
   <td style="text-align:center;"> 2.316862 </td>
   <td style="text-align:center;"> 9.315153 </td>
   <td style="text-align:center;"> c31 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 24.66928 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2454249 </td>
   <td style="text-align:center;"> 2.513997 </td>
   <td style="text-align:center;"> 9.216586 </td>
   <td style="text-align:center;"> c32 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 27.62022 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2441864 </td>
   <td style="text-align:center;"> 2.579708 </td>
   <td style="text-align:center;"> 10.235116 </td>
   <td style="text-align:center;"> c33 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 28.85208 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.2450989 </td>
   <td style="text-align:center;"> 2.579708 </td>
   <td style="text-align:center;"> 9.742279 </td>
   <td style="text-align:center;"> c34 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 24.29024 </td>
  </tr>
</tbody>
</table></div>
&nbsp; 

#### Dynamic time warping distance


{% highlight r %}
dtw.dist <- dfDTW(ext_st, img = FALSE)

dtw.dist
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 1px; overflow-y: scroll; height:500px; overflow-x: scroll; width:740px; "><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Phae.long1.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long1.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long1.wav_3-1 </th>
   <th style="text-align:center;"> Phae.long2.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long2.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long3.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long3.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long3.wav_3-1 </th>
   <th style="text-align:center;"> Phae.long4.wav_1-1 </th>
   <th style="text-align:center;"> Phae.long4.wav_2-1 </th>
   <th style="text-align:center;"> Phae.long4.wav_3-1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_1-1 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 6.972 </td>
   <td style="text-align:center;"> 7.884 </td>
   <td style="text-align:center;"> 18.164 </td>
   <td style="text-align:center;"> 18.364 </td>
   <td style="text-align:center;"> 11.436 </td>
   <td style="text-align:center;"> 16.843 </td>
   <td style="text-align:center;"> 18.746 </td>
   <td style="text-align:center;"> 22.682 </td>
   <td style="text-align:center;"> 22.932 </td>
   <td style="text-align:center;"> 21.909 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_2-1 </td>
   <td style="text-align:center;"> 6.972 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 9.494 </td>
   <td style="text-align:center;"> 19.137 </td>
   <td style="text-align:center;"> 23.317 </td>
   <td style="text-align:center;"> 13.306 </td>
   <td style="text-align:center;"> 19.885 </td>
   <td style="text-align:center;"> 23.230 </td>
   <td style="text-align:center;"> 25.976 </td>
   <td style="text-align:center;"> 24.078 </td>
   <td style="text-align:center;"> 25.023 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_3-1 </td>
   <td style="text-align:center;"> 7.884 </td>
   <td style="text-align:center;"> 9.494 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 22.209 </td>
   <td style="text-align:center;"> 19.306 </td>
   <td style="text-align:center;"> 14.960 </td>
   <td style="text-align:center;"> 18.880 </td>
   <td style="text-align:center;"> 23.295 </td>
   <td style="text-align:center;"> 27.062 </td>
   <td style="text-align:center;"> 28.581 </td>
   <td style="text-align:center;"> 25.867 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_1-1 </td>
   <td style="text-align:center;"> 18.164 </td>
   <td style="text-align:center;"> 19.137 </td>
   <td style="text-align:center;"> 22.209 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 11.275 </td>
   <td style="text-align:center;"> 13.419 </td>
   <td style="text-align:center;"> 10.606 </td>
   <td style="text-align:center;"> 10.893 </td>
   <td style="text-align:center;"> 14.034 </td>
   <td style="text-align:center;"> 17.344 </td>
   <td style="text-align:center;"> 18.327 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_2-1 </td>
   <td style="text-align:center;"> 18.364 </td>
   <td style="text-align:center;"> 23.317 </td>
   <td style="text-align:center;"> 19.306 </td>
   <td style="text-align:center;"> 11.275 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 10.031 </td>
   <td style="text-align:center;"> 6.988 </td>
   <td style="text-align:center;"> 7.283 </td>
   <td style="text-align:center;"> 16.920 </td>
   <td style="text-align:center;"> 23.744 </td>
   <td style="text-align:center;"> 21.980 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_1-1 </td>
   <td style="text-align:center;"> 11.436 </td>
   <td style="text-align:center;"> 13.306 </td>
   <td style="text-align:center;"> 14.960 </td>
   <td style="text-align:center;"> 13.419 </td>
   <td style="text-align:center;"> 10.031 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 7.563 </td>
   <td style="text-align:center;"> 8.528 </td>
   <td style="text-align:center;"> 23.179 </td>
   <td style="text-align:center;"> 25.229 </td>
   <td style="text-align:center;"> 22.872 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_2-1 </td>
   <td style="text-align:center;"> 16.843 </td>
   <td style="text-align:center;"> 19.885 </td>
   <td style="text-align:center;"> 18.880 </td>
   <td style="text-align:center;"> 10.606 </td>
   <td style="text-align:center;"> 6.988 </td>
   <td style="text-align:center;"> 7.563 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 5.606 </td>
   <td style="text-align:center;"> 19.530 </td>
   <td style="text-align:center;"> 24.345 </td>
   <td style="text-align:center;"> 23.278 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_3-1 </td>
   <td style="text-align:center;"> 18.746 </td>
   <td style="text-align:center;"> 23.230 </td>
   <td style="text-align:center;"> 23.295 </td>
   <td style="text-align:center;"> 10.893 </td>
   <td style="text-align:center;"> 7.283 </td>
   <td style="text-align:center;"> 8.528 </td>
   <td style="text-align:center;"> 5.606 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 16.576 </td>
   <td style="text-align:center;"> 23.187 </td>
   <td style="text-align:center;"> 20.182 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_1-1 </td>
   <td style="text-align:center;"> 22.682 </td>
   <td style="text-align:center;"> 25.976 </td>
   <td style="text-align:center;"> 27.062 </td>
   <td style="text-align:center;"> 14.034 </td>
   <td style="text-align:center;"> 16.920 </td>
   <td style="text-align:center;"> 23.179 </td>
   <td style="text-align:center;"> 19.530 </td>
   <td style="text-align:center;"> 16.576 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 8.237 </td>
   <td style="text-align:center;"> 10.729 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_2-1 </td>
   <td style="text-align:center;"> 22.932 </td>
   <td style="text-align:center;"> 24.078 </td>
   <td style="text-align:center;"> 28.581 </td>
   <td style="text-align:center;"> 17.344 </td>
   <td style="text-align:center;"> 23.744 </td>
   <td style="text-align:center;"> 25.229 </td>
   <td style="text-align:center;"> 24.345 </td>
   <td style="text-align:center;"> 23.187 </td>
   <td style="text-align:center;"> 8.237 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 8.542 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_3-1 </td>
   <td style="text-align:center;"> 21.909 </td>
   <td style="text-align:center;"> 25.023 </td>
   <td style="text-align:center;"> 25.867 </td>
   <td style="text-align:center;"> 18.327 </td>
   <td style="text-align:center;"> 21.980 </td>
   <td style="text-align:center;"> 22.872 </td>
   <td style="text-align:center;"> 23.278 </td>
   <td style="text-align:center;"> 20.182 </td>
   <td style="text-align:center;"> 10.729 </td>
   <td style="text-align:center;"> 8.542 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
</tbody>
</table></div>
&nbsp; 

## Performance

Using *extended_selection_table* objects can improve performance (in our case measured as time). Here we used the [microbenchmark](https://cran.r-project.org/package=microbenchmark) to compare the performance of `sig2noise()` and [ggplot2](https://cran.r-project.org/package=ggplot2) to plot the results. We also need to save the wave files again to be able to run the analysis with regular data frames:


{% highlight r %}
# save recordings as wave files
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")

#run this one if microbenchmark is not installed
# install.packages("microbenchmark")
library(microbenchmark)

# install.packages("ggplot2")
library(ggplot2)

# use only 1 core
warbleR_options(parallel = 1, pb = FALSE)

# use the first 100 selection for the long selection tables
mbmrk.snr <- microbenchmark(extended = sig2noise(lng_ext_st[1:100, ], 
      mar = 0.05), regular = sig2noise(lng.selec.table[1:100, ], 
                    mar = 0.05), times = 50)

autoplot(mbmrk.snr) + ggtitle("sig2noise")
{% endhighlight %}

<img src="/assets/Rfig/extn_sel_13-1.png" title="plot of chunk extn_sel_13" alt="plot of chunk extn_sel_13" width="750" />

<font size="3"><i>Distribution of <i>`sig2noise()`</i> timing on regular and extended selection tables</i></font>

The function runs much faster on extended selection tables. The gain in performance is likely to improve when using longer recordings and data sets (i.e. compensate for computing overhead).


## By song

The extended selection tables above were all made 'by selection'. This is, each sound file inside the object contains a single selection (i.e. 1:1 correspondence between selections and wave objects). Extended selection tables, however, can also be created by using a higher hierarchical level with the argument `by.song`. In this case, 'song' represents a higher level that contains one or more selections and that the user may want to keep together for some particular analysis (e.g. gap duration). The argument `by.song` takes the name of the character or factor column with the IDs of the different "songs" within a sound file (note that the function assumes that a given song can only be found in a single sound file so selections with the same song ID but from different sound files is taken as different 'songs').

For the sake of the example, let's add an artificial song column to our example data set in which each sound files 2 songs:  


{% highlight r %}
# add column
selec.table$song <- c(1, 1, 2, 1, 2, 1, 1, 2, 1, 2, 2)
{% endhighlight %}

The data frame looks like this:

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:740px; "><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> channel </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
   <th style="text-align:center;"> sel.comment </th>
   <th style="text-align:center;"> rec.comment </th>
   <th style="text-align:center;"> song </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.16935 </td>
   <td style="text-align:center;"> 1.34239 </td>
   <td style="text-align:center;"> 2.2201 </td>
   <td style="text-align:center;"> 8.6044 </td>
   <td style="text-align:center;"> c24 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2.15841 </td>
   <td style="text-align:center;"> 2.32146 </td>
   <td style="text-align:center;"> 2.1694 </td>
   <td style="text-align:center;"> 8.8071 </td>
   <td style="text-align:center;"> c25 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.34334 </td>
   <td style="text-align:center;"> 0.51826 </td>
   <td style="text-align:center;"> 2.2183 </td>
   <td style="text-align:center;"> 8.7566 </td>
   <td style="text-align:center;"> c26 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15960 </td>
   <td style="text-align:center;"> 0.29217 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 8.8223 </td>
   <td style="text-align:center;"> c27 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.45706 </td>
   <td style="text-align:center;"> 1.58321 </td>
   <td style="text-align:center;"> 2.2840 </td>
   <td style="text-align:center;"> 8.8880 </td>
   <td style="text-align:center;"> c28 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.62655 </td>
   <td style="text-align:center;"> 0.75777 </td>
   <td style="text-align:center;"> 3.0068 </td>
   <td style="text-align:center;"> 8.8223 </td>
   <td style="text-align:center;"> c29 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.97421 </td>
   <td style="text-align:center;"> 2.10439 </td>
   <td style="text-align:center;"> 2.7768 </td>
   <td style="text-align:center;"> 8.8880 </td>
   <td style="text-align:center;"> c30 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.12336 </td>
   <td style="text-align:center;"> 0.25458 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 9.3151 </td>
   <td style="text-align:center;"> c31 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1.51681 </td>
   <td style="text-align:center;"> 1.66224 </td>
   <td style="text-align:center;"> 2.5140 </td>
   <td style="text-align:center;"> 9.2166 </td>
   <td style="text-align:center;"> c32 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2.93269 </td>
   <td style="text-align:center;"> 3.07688 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 10.2351 </td>
   <td style="text-align:center;"> c33 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0.14540 </td>
   <td style="text-align:center;"> 0.29050 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 9.7423 </td>
   <td style="text-align:center;"> c34 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
  </tr>
</tbody>
</table></div>

Now we can create an extended selection table 'by song' using the name of the 'song' column (which in this silly example is also 'song') as the input for the `by.song` argument:


{% highlight r %}
bs_ext_st <- selection_table(X = selec.table, extended = TRUE,
                              confirm.extended = FALSE, by.song = "song")
{% endhighlight %}

In this case we should only have 8 wave objects instead of 11 as when the object was created 'by selection':


{% highlight r %}
# by element
length(attr(ext_st, "wave.objects"))
{% endhighlight %}



{% highlight text %}
[1] 11
{% endhighlight %}



{% highlight r %}
# by song
length(attr(bs_ext_st, "wave.objects"))
{% endhighlight %}



{% highlight text %}
[1] 8
{% endhighlight %}


Again, these objects can also be used on further analysis:


{% highlight r %}
# signal-to-noise ratio
bs_snr <- sig2noise(bs_ext_st, mar = 0.05)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:740px; "><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> channel </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> top.freq </th>
   <th style="text-align:center;"> sel.comment </th>
   <th style="text-align:center;"> rec.comment </th>
   <th style="text-align:center;"> song </th>
   <th style="text-align:center;"> SNR </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav-song_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.27303 </td>
   <td style="text-align:center;"> 2.2201 </td>
   <td style="text-align:center;"> 8.6044 </td>
   <td style="text-align:center;"> c24 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 21.182 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav-song_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.0891 </td>
   <td style="text-align:center;"> 1.25210 </td>
   <td style="text-align:center;"> 2.1694 </td>
   <td style="text-align:center;"> 8.8071 </td>
   <td style="text-align:center;"> c25 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 20.357 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav-song_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.27492 </td>
   <td style="text-align:center;"> 2.2183 </td>
   <td style="text-align:center;"> 8.7566 </td>
   <td style="text-align:center;"> c26 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 19.164 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav-song_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.23257 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 8.8223 </td>
   <td style="text-align:center;"> c27 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 23.273 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav-song_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.22615 </td>
   <td style="text-align:center;"> 2.2840 </td>
   <td style="text-align:center;"> 8.8880 </td>
   <td style="text-align:center;"> c28 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 26.206 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav-song_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.23122 </td>
   <td style="text-align:center;"> 3.0068 </td>
   <td style="text-align:center;"> 8.8223 </td>
   <td style="text-align:center;"> c29 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 25.326 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav-song_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 1.4477 </td>
   <td style="text-align:center;"> 1.57784 </td>
   <td style="text-align:center;"> 2.7768 </td>
   <td style="text-align:center;"> 8.8880 </td>
   <td style="text-align:center;"> c30 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 25.512 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav-song_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.23122 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 9.3151 </td>
   <td style="text-align:center;"> c31 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 24.669 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav-song_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.24542 </td>
   <td style="text-align:center;"> 2.5140 </td>
   <td style="text-align:center;"> 9.2166 </td>
   <td style="text-align:center;"> c32 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 27.620 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav-song_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.8873 </td>
   <td style="text-align:center;"> 3.03148 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 10.2351 </td>
   <td style="text-align:center;"> c33 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 28.841 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav-song_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1000 </td>
   <td style="text-align:center;"> 0.24510 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 9.7423 </td>
   <td style="text-align:center;"> c34 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 24.290 </td>
  </tr>
</tbody>
</table></div>

The margin would be an important parameter to take into consideration for some downstream functions like those producing plots or using additional time segments around selection to run analysis (e.g. `sig2noise()` or `xcorr()`).

## Sharing acoustic data

The new object class allows to share complete data sets, including the acoustic data. For instance, with the following code you can download a subset of the data used in [Araya-Salas *et al* (2017)](https://marceloarayasalas.weebly.com/uploads/2/5/5/2/25524573/araya-salas_smith-vidaurre___webster_2017._table_s1._recording_metadata.xlsx) (it can also be downloaded [here](https://marceloarayasalas.weebly.com/uploads/2/5/5/2/25524573/extended.selection.table.araya-salas.et.al.2017.bioacoustics.100.sels.rds)):


{% highlight r %}
URL <- "https://marceloarayasalas.weebly.com/uploads/2/5/5/2/25524573/extended.selection.table.araya-salas.et.al.2017.bioacoustics.100.sels.rds"

dat <- readRDS(gzcon(url(URL)))

nrow(dat)
{% endhighlight %}



{% highlight text %}
[1] 100
{% endhighlight %}



{% highlight r %}
format(object.size(dat), units = "auto")
{% endhighlight %}



{% highlight text %}
[1] "10.1 Mb"
{% endhighlight %}

The total size of the 100 sound files from which these selections were taken adds up to 1.1 GB. The size of the extended selection table is just 10.1 MB.

This data is ready to be used:


{% highlight r %}
sp <- specan(dat)

head(sp)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 1px; overflow-x: scroll; width:740px; "><table>
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
   <th style="text-align:center;"> meanfun </th>
   <th style="text-align:center;"> minfun </th>
   <th style="text-align:center;"> maxfun </th>
   <th style="text-align:center;"> meandom </th>
   <th style="text-align:center;"> mindom </th>
   <th style="text-align:center;"> maxdom </th>
   <th style="text-align:center;"> dfrange </th>
   <th style="text-align:center;"> modindx </th>
   <th style="text-align:center;"> startdom </th>
   <th style="text-align:center;"> enddom </th>
   <th style="text-align:center;"> dfslope </th>
   <th style="text-align:center;"> meanpeakf </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Pyrrhura rupicola Macaulay Library 132 .wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15048 </td>
   <td style="text-align:center;"> 4.6763 </td>
   <td style="text-align:center;"> 2.3249 </td>
   <td style="text-align:center;"> 4.2085 </td>
   <td style="text-align:center;"> 3.3243 </td>
   <td style="text-align:center;"> 5.6912 </td>
   <td style="text-align:center;"> 2.3669 </td>
   <td style="text-align:center;"> 0.07198 </td>
   <td style="text-align:center;"> 0.03926 </td>
   <td style="text-align:center;"> 0.11124 </td>
   <td style="text-align:center;"> 0.07198 </td>
   <td style="text-align:center;"> 4.0281 </td>
   <td style="text-align:center;"> 24.420 </td>
   <td style="text-align:center;"> 0.83665 </td>
   <td style="text-align:center;"> 0.95113 </td>
   <td style="text-align:center;"> 0.79576 </td>
   <td style="text-align:center;"> 0.12486 </td>
   <td style="text-align:center;"> 1.8592 </td>
   <td style="text-align:center;"> 0.65821 </td>
   <td style="text-align:center;"> 2.3211 </td>
   <td style="text-align:center;"> 3.7109 </td>
   <td style="text-align:center;"> 1.9810 </td>
   <td style="text-align:center;"> 6.8045 </td>
   <td style="text-align:center;"> 4.8234 </td>
   <td style="text-align:center;"> 5.3750 </td>
   <td style="text-align:center;"> 4.4789 </td>
   <td style="text-align:center;"> 1.9810 </td>
   <td style="text-align:center;"> -16.5996 </td>
   <td style="text-align:center;"> 4.0208 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 0.CCE.1971.4.4.ITM70863A-23.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.16556 </td>
   <td style="text-align:center;"> 7.4982 </td>
   <td style="text-align:center;"> 4.2091 </td>
   <td style="text-align:center;"> 6.6224 </td>
   <td style="text-align:center;"> 5.6193 </td>
   <td style="text-align:center;"> 8.2961 </td>
   <td style="text-align:center;"> 2.6767 </td>
   <td style="text-align:center;"> 0.08279 </td>
   <td style="text-align:center;"> 0.03821 </td>
   <td style="text-align:center;"> 0.12100 </td>
   <td style="text-align:center;"> 0.08279 </td>
   <td style="text-align:center;"> 3.8653 </td>
   <td style="text-align:center;"> 22.506 </td>
   <td style="text-align:center;"> 0.91266 </td>
   <td style="text-align:center;"> 0.94153 </td>
   <td style="text-align:center;"> 0.85929 </td>
   <td style="text-align:center;"> 0.49415 </td>
   <td style="text-align:center;"> 4.2372 </td>
   <td style="text-align:center;"> 0.52500 </td>
   <td style="text-align:center;"> 7.3500 </td>
   <td style="text-align:center;"> 6.6003 </td>
   <td style="text-align:center;"> 3.5314 </td>
   <td style="text-align:center;"> 8.1826 </td>
   <td style="text-align:center;"> 4.6512 </td>
   <td style="text-align:center;"> 3.2037 </td>
   <td style="text-align:center;"> 8.1826 </td>
   <td style="text-align:center;"> 6.8906 </td>
   <td style="text-align:center;"> -7.8036 </td>
   <td style="text-align:center;"> 6.0961 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 0.SAT.1989.6.2.ITM70866A-32.wav_5 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15425 </td>
   <td style="text-align:center;"> 7.3011 </td>
   <td style="text-align:center;"> 4.2056 </td>
   <td style="text-align:center;"> 6.5831 </td>
   <td style="text-align:center;"> 4.8968 </td>
   <td style="text-align:center;"> 8.1008 </td>
   <td style="text-align:center;"> 3.2040 </td>
   <td style="text-align:center;"> 0.08356 </td>
   <td style="text-align:center;"> 0.04499 </td>
   <td style="text-align:center;"> 0.11570 </td>
   <td style="text-align:center;"> 0.07070 </td>
   <td style="text-align:center;"> 3.4398 </td>
   <td style="text-align:center;"> 17.254 </td>
   <td style="text-align:center;"> 0.90865 </td>
   <td style="text-align:center;"> 0.94323 </td>
   <td style="text-align:center;"> 0.85707 </td>
   <td style="text-align:center;"> 0.48203 </td>
   <td style="text-align:center;"> 3.2220 </td>
   <td style="text-align:center;"> 1.26000 </td>
   <td style="text-align:center;"> 6.3000 </td>
   <td style="text-align:center;"> 6.4492 </td>
   <td style="text-align:center;"> 4.7373 </td>
   <td style="text-align:center;"> 8.0965 </td>
   <td style="text-align:center;"> 3.3592 </td>
   <td style="text-align:center;"> 3.4872 </td>
   <td style="text-align:center;"> 6.3738 </td>
   <td style="text-align:center;"> 6.5461 </td>
   <td style="text-align:center;"> 1.1168 </td>
   <td style="text-align:center;"> 7.0473 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 23.CCE.2011.7.21.7.42.wav_6 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15496 </td>
   <td style="text-align:center;"> 5.5026 </td>
   <td style="text-align:center;"> 2.3525 </td>
   <td style="text-align:center;"> 5.1579 </td>
   <td style="text-align:center;"> 4.3703 </td>
   <td style="text-align:center;"> 6.5329 </td>
   <td style="text-align:center;"> 2.1626 </td>
   <td style="text-align:center;"> 0.06458 </td>
   <td style="text-align:center;"> 0.03875 </td>
   <td style="text-align:center;"> 0.10333 </td>
   <td style="text-align:center;"> 0.06458 </td>
   <td style="text-align:center;"> 3.6555 </td>
   <td style="text-align:center;"> 19.129 </td>
   <td style="text-align:center;"> 0.84312 </td>
   <td style="text-align:center;"> 0.94541 </td>
   <td style="text-align:center;"> 0.79709 </td>
   <td style="text-align:center;"> 0.15365 </td>
   <td style="text-align:center;"> 4.0046 </td>
   <td style="text-align:center;"> 0.45938 </td>
   <td style="text-align:center;"> 7.3500 </td>
   <td style="text-align:center;"> 4.9854 </td>
   <td style="text-align:center;"> 2.3256 </td>
   <td style="text-align:center;"> 7.7519 </td>
   <td style="text-align:center;"> 5.4264 </td>
   <td style="text-align:center;"> 2.1587 </td>
   <td style="text-align:center;"> 7.3213 </td>
   <td style="text-align:center;"> 2.3256 </td>
   <td style="text-align:center;"> -32.2397 </td>
   <td style="text-align:center;"> 4.3667 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Cyanoliseus patagonus Macaulay Library 79 .wav_5 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15989 </td>
   <td style="text-align:center;"> 2.6520 </td>
   <td style="text-align:center;"> 1.5761 </td>
   <td style="text-align:center;"> 2.2644 </td>
   <td style="text-align:center;"> 1.8203 </td>
   <td style="text-align:center;"> 3.2152 </td>
   <td style="text-align:center;"> 1.3949 </td>
   <td style="text-align:center;"> 0.05757 </td>
   <td style="text-align:center;"> 0.03198 </td>
   <td style="text-align:center;"> 0.09595 </td>
   <td style="text-align:center;"> 0.06396 </td>
   <td style="text-align:center;"> 5.5610 </td>
   <td style="text-align:center;"> 43.476 </td>
   <td style="text-align:center;"> 0.76308 </td>
   <td style="text-align:center;"> 0.94119 </td>
   <td style="text-align:center;"> 0.71820 </td>
   <td style="text-align:center;"> 0.03763 </td>
   <td style="text-align:center;"> 1.2834 </td>
   <td style="text-align:center;"> 1.10250 </td>
   <td style="text-align:center;"> 1.3364 </td>
   <td style="text-align:center;"> 1.7657 </td>
   <td style="text-align:center;"> 1.2059 </td>
   <td style="text-align:center;"> 2.4979 </td>
   <td style="text-align:center;"> 1.2920 </td>
   <td style="text-align:center;"> 4.6000 </td>
   <td style="text-align:center;"> 1.6365 </td>
   <td style="text-align:center;"> 2.2395 </td>
   <td style="text-align:center;"> 3.7710 </td>
   <td style="text-align:center;"> 2.2913 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 0.HC1.2011.8.7.9.20.wav_4 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15380 </td>
   <td style="text-align:center;"> 7.2597 </td>
   <td style="text-align:center;"> 4.2607 </td>
   <td style="text-align:center;"> 6.7047 </td>
   <td style="text-align:center;"> 4.9098 </td>
   <td style="text-align:center;"> 8.3370 </td>
   <td style="text-align:center;"> 3.4271 </td>
   <td style="text-align:center;"> 0.07692 </td>
   <td style="text-align:center;"> 0.04487 </td>
   <td style="text-align:center;"> 0.10896 </td>
   <td style="text-align:center;"> 0.06410 </td>
   <td style="text-align:center;"> 6.1538 </td>
   <td style="text-align:center;"> 59.207 </td>
   <td style="text-align:center;"> 0.90094 </td>
   <td style="text-align:center;"> 0.94619 </td>
   <td style="text-align:center;"> 0.85246 </td>
   <td style="text-align:center;"> 0.47193 </td>
   <td style="text-align:center;"> 2.7777 </td>
   <td style="text-align:center;"> 0.55823 </td>
   <td style="text-align:center;"> 5.5125 </td>
   <td style="text-align:center;"> 6.1334 </td>
   <td style="text-align:center;"> 4.9096 </td>
   <td style="text-align:center;"> 8.5272 </td>
   <td style="text-align:center;"> 3.6176 </td>
   <td style="text-align:center;"> 4.0714 </td>
   <td style="text-align:center;"> 5.3402 </td>
   <td style="text-align:center;"> 4.9096 </td>
   <td style="text-align:center;"> -2.8002 </td>
   <td style="text-align:center;"> 4.9720 </td>
  </tr>
</tbody>
</table></div>

And the spectrograms can be displayed:


{% highlight r %}
par(mfrow = c(3, 2), mar = rep(0, 4))

for(i in 1:6){
  
  wv <- read_wave(X = dat, index = i, from = 0.17, to = 0.4)

  spectro(wv, wl = 250, grid = FALSE, scale = FALSE, axisX = FALSE,
          axisY = FALSE, ovlp = 90, flim = c(0, 12), 
          palette = reverse.gray.colors.1)
}
{% endhighlight %}

<img src="/assets/Rfig/extn.sel_21-1.png" title="plot of chunk extn.sel_21" alt="plot of chunk extn.sel_21" width="750" />
<font size="3"><i>Spectrograms of the first 6 selections in the 'dat' extended selection table</i></font>

The ability to compress large data sets and the easiness of conducting analyses requiring only a single *R* object can potentially simplify data sharing and the reproducibility of bioacoustic analyses.

Please report any bugs [here](https://github.com/maRce10/warbleR/issues).

---

<font size="4">Session information</font>


{% highlight text %}
R version 3.4.4 (2018-03-15)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 16.04.4 LTS

Matrix products: default
BLAS: /usr/lib/openblas-base/libblas.so.3
LAPACK: /usr/lib/libopenblasp-r0.2.18.so

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
 [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
[10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] ggplot2_2.2.1        microbenchmark_1.4-4 kableExtra_0.7.0     knitr_1.20          
[5] warbleR_1.1.13       NatureSounds_1.0.0   seewave_2.1.0        tuneR_1.3.2         
[9] maps_3.3.0          

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.14         pracma_2.1.4         highr_0.6            plyr_1.8.4          
 [5] pillar_1.0.1         compiler_3.4.4       bitops_1.0-6         iterators_1.0.9     
 [9] tools_3.4.4          Sim.DiffProc_4.0     digest_0.6.13        gtable_0.2.0        
[13] viridisLite_0.2.0    tibble_1.4.1         evaluate_0.10.1      fftw_1.0-4          
[17] pkgconfig_2.0.1      rlang_0.1.6          yaml_2.1.16          parallel_3.4.4      
[21] xml2_1.2.0           httr_1.3.1           stringr_1.2.0        hms_0.4.0           
[25] grid_3.4.4           rprojroot_1.3-2      scatterplot3d_0.3-40 R6_2.2.2            
[29] dtw_1.18-1           jpeg_0.1-8           pbapply_1.3-4        rgl_0.95.1441       
[33] rmarkdown_1.8        readr_1.1.1          magrittr_1.5         scales_0.5.0        
[37] backports_1.1.2      htmltools_0.3.6      MASS_7.3-49          rvest_0.3.2         
[41] colorspace_1.3-2     Deriv_3.8.4          proxy_0.4-22         stringi_1.1.6       
[45] lazyeval_0.2.1       munsell_0.4.3        signal_0.7-6         RCurl_1.95-4.10     
[49] rjson_0.2.18        
{% endhighlight %}



