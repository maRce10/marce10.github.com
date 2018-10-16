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
   <td style="text-align:center;"> 1.16935 </td>
   <td style="text-align:center;"> 1.34239 </td>
   <td style="text-align:center;"> 2.2201 </td>
   <td style="text-align:center;"> 8.6044 </td>
   <td style="text-align:center;"> c24 </td>
   <td style="text-align:center;"> NA </td>
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
       sound.files channel selec start     end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.27303      2.2201   8.6044         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.26305      2.1694   8.8071         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.27492      2.2183   8.7566         c26          NA
4 Phae.long2.wav_1       1     1   0.1 0.23257      2.3169   8.8223         c27          NA
5 Phae.long2.wav_2       1     1   0.1 0.22615      2.2840   8.8880         c28          NA
6 Phae.long3.wav_1       1     1   0.1 0.23122      3.0068   8.8223         c29          NA
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
       sound.files channel selec start     end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.27303      2.2201   8.6044         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.26305      2.1694   8.8071         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.27492      2.2183   8.7566         c26          NA
4 Phae.long2.wav_1       1     1   0.1 0.23257      2.3169   8.8223         c27          NA
5 Phae.long2.wav_2       1     1   0.1 0.22615      2.2840   8.8880         c28          NA
6 Phae.long3.wav_1       1     1   0.1 0.23122      3.0068   8.8223         c29          NA
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
       sound.files channel selec start     end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.27303      2.2201   8.6044         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.26305      2.1694   8.8071         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.27492      2.2183   8.7566         c26          NA
4 Phae.long2.wav_1       1     1   0.1 0.23257      2.3169   8.8223         c27          NA
5 Phae.long2.wav_2       1     1   0.1 0.22615      2.2840   8.8880         c28          NA
6 Phae.long3.wav_1       1     1   0.1 0.23122      3.0068   8.8223         c29          NA
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

This works as long as some of the original sound files are kept and no other selections are added.

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
       sound.files channel selec start     end bottom.freq top.freq sel.comment rec.comment
1 Phae.long1.wav_1       1     1   0.1 0.27303      2.2201   8.6044         c24          NA
2 Phae.long1.wav_2       1     1   0.1 0.26305      2.1694   8.8071         c25          NA
3 Phae.long1.wav_3       1     1   0.1 0.27492      2.2183   8.7566         c26          NA
4 Phae.long2.wav_4       1     1   0.1 0.23257      2.3169   8.8223         c27          NA
5 Phae.long2.wav_5       1     1   0.1 0.22615      2.2840   8.8880         c28          NA
6 Phae.long3.wav_6       1     1   0.1 0.23122      3.0068   8.8223         c29          NA
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
   <td style="text-align:center;"> Phae.long1.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.17303 </td>
   <td style="text-align:center;"> 5.9824 </td>
   <td style="text-align:center;"> 1.3998 </td>
   <td style="text-align:center;"> 6.3317 </td>
   <td style="text-align:center;"> 5.2966 </td>
   <td style="text-align:center;"> 6.8695 </td>
   <td style="text-align:center;"> 1.5729 </td>
   <td style="text-align:center;"> 0.07525 </td>
   <td style="text-align:center;"> 0.05267 </td>
   <td style="text-align:center;"> 0.12039 </td>
   <td style="text-align:center;"> 0.06772 </td>
   <td style="text-align:center;"> 1.9978 </td>
   <td style="text-align:center;"> 7.0216 </td>
   <td style="text-align:center;"> 0.94345 </td>
   <td style="text-align:center;"> 0.93979 </td>
   <td style="text-align:center;"> 0.88664 </td>
   <td style="text-align:center;"> 0.65109 </td>
   <td style="text-align:center;"> 6.6000 </td>
   <td style="text-align:center;"> 4.425 </td>
   <td style="text-align:center;"> 8.250 </td>
   <td style="text-align:center;"> 3.825 </td>
   <td style="text-align:center;"> 3.5882 </td>
   <td style="text-align:center;"> 7.125 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 0.43344 </td>
   <td style="text-align:center;"> 7.1351 </td>
   <td style="text-align:center;"> 2.2201 </td>
   <td style="text-align:center;"> 8.6044 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.16305 </td>
   <td style="text-align:center;"> 5.9966 </td>
   <td style="text-align:center;"> 1.4244 </td>
   <td style="text-align:center;"> 6.2121 </td>
   <td style="text-align:center;"> 5.3288 </td>
   <td style="text-align:center;"> 6.8808 </td>
   <td style="text-align:center;"> 1.5520 </td>
   <td style="text-align:center;"> 0.07414 </td>
   <td style="text-align:center;"> 0.04448 </td>
   <td style="text-align:center;"> 0.11863 </td>
   <td style="text-align:center;"> 0.07414 </td>
   <td style="text-align:center;"> 1.9229 </td>
   <td style="text-align:center;"> 7.3492 </td>
   <td style="text-align:center;"> 0.94676 </td>
   <td style="text-align:center;"> 0.94412 </td>
   <td style="text-align:center;"> 0.89385 </td>
   <td style="text-align:center;"> 0.66938 </td>
   <td style="text-align:center;"> 6.7043 </td>
   <td style="text-align:center;"> 5.250 </td>
   <td style="text-align:center;"> 8.325 </td>
   <td style="text-align:center;"> 3.075 </td>
   <td style="text-align:center;"> 4.4878 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 1.83995 </td>
   <td style="text-align:center;"> 6.9086 </td>
   <td style="text-align:center;"> 2.1694 </td>
   <td style="text-align:center;"> 8.8071 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.17492 </td>
   <td style="text-align:center;"> 6.0208 </td>
   <td style="text-align:center;"> 1.5161 </td>
   <td style="text-align:center;"> 6.4284 </td>
   <td style="text-align:center;"> 5.1528 </td>
   <td style="text-align:center;"> 6.9833 </td>
   <td style="text-align:center;"> 1.8305 </td>
   <td style="text-align:center;"> 0.08749 </td>
   <td style="text-align:center;"> 0.05833 </td>
   <td style="text-align:center;"> 0.13123 </td>
   <td style="text-align:center;"> 0.07291 </td>
   <td style="text-align:center;"> 2.4887 </td>
   <td style="text-align:center;"> 11.0887 </td>
   <td style="text-align:center;"> 0.94484 </td>
   <td style="text-align:center;"> 0.93764 </td>
   <td style="text-align:center;"> 0.88592 </td>
   <td style="text-align:center;"> 0.66888 </td>
   <td style="text-align:center;"> 6.7050 </td>
   <td style="text-align:center;"> 4.200 </td>
   <td style="text-align:center;"> 8.625 </td>
   <td style="text-align:center;"> 4.425 </td>
   <td style="text-align:center;"> 4.5424 </td>
   <td style="text-align:center;"> 7.050 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 0.85754 </td>
   <td style="text-align:center;"> 6.8331 </td>
   <td style="text-align:center;"> 2.2183 </td>
   <td style="text-align:center;"> 8.7566 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13257 </td>
   <td style="text-align:center;"> 6.4003 </td>
   <td style="text-align:center;"> 1.3403 </td>
   <td style="text-align:center;"> 6.5960 </td>
   <td style="text-align:center;"> 5.6073 </td>
   <td style="text-align:center;"> 7.3808 </td>
   <td style="text-align:center;"> 1.7735 </td>
   <td style="text-align:center;"> 0.07801 </td>
   <td style="text-align:center;"> 0.05461 </td>
   <td style="text-align:center;"> 0.10922 </td>
   <td style="text-align:center;"> 0.05461 </td>
   <td style="text-align:center;"> 1.5768 </td>
   <td style="text-align:center;"> 6.0674 </td>
   <td style="text-align:center;"> 0.94297 </td>
   <td style="text-align:center;"> 0.95021 </td>
   <td style="text-align:center;"> 0.89602 </td>
   <td style="text-align:center;"> 0.61135 </td>
   <td style="text-align:center;"> 6.3662 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 7.575 </td>
   <td style="text-align:center;"> 2.550 </td>
   <td style="text-align:center;"> 4.2941 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 5.925 </td>
   <td style="text-align:center;"> 6.78882 </td>
   <td style="text-align:center;"> 7.3617 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 8.8223 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.12615 </td>
   <td style="text-align:center;"> 6.3126 </td>
   <td style="text-align:center;"> 1.3707 </td>
   <td style="text-align:center;"> 6.6020 </td>
   <td style="text-align:center;"> 5.6098 </td>
   <td style="text-align:center;"> 7.2132 </td>
   <td style="text-align:center;"> 1.6034 </td>
   <td style="text-align:center;"> 0.07886 </td>
   <td style="text-align:center;"> 0.05520 </td>
   <td style="text-align:center;"> 0.10252 </td>
   <td style="text-align:center;"> 0.04732 </td>
   <td style="text-align:center;"> 2.4717 </td>
   <td style="text-align:center;"> 10.8978 </td>
   <td style="text-align:center;"> 0.93610 </td>
   <td style="text-align:center;"> 0.95051 </td>
   <td style="text-align:center;"> 0.88977 </td>
   <td style="text-align:center;"> 0.62029 </td>
   <td style="text-align:center;"> 6.1721 </td>
   <td style="text-align:center;"> 4.800 </td>
   <td style="text-align:center;"> 7.575 </td>
   <td style="text-align:center;"> 2.775 </td>
   <td style="text-align:center;"> 2.7838 </td>
   <td style="text-align:center;"> 4.800 </td>
   <td style="text-align:center;"> 6.525 </td>
   <td style="text-align:center;"> 13.67418 </td>
   <td style="text-align:center;"> 6.7576 </td>
   <td style="text-align:center;"> 2.2840 </td>
   <td style="text-align:center;"> 8.8880 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13122 </td>
   <td style="text-align:center;"> 6.6120 </td>
   <td style="text-align:center;"> 1.0932 </td>
   <td style="text-align:center;"> 6.6701 </td>
   <td style="text-align:center;"> 6.0672 </td>
   <td style="text-align:center;"> 7.3494 </td>
   <td style="text-align:center;"> 1.2821 </td>
   <td style="text-align:center;"> 0.06176 </td>
   <td style="text-align:center;"> 0.04632 </td>
   <td style="text-align:center;"> 0.09264 </td>
   <td style="text-align:center;"> 0.04632 </td>
   <td style="text-align:center;"> 1.7739 </td>
   <td style="text-align:center;"> 6.6263 </td>
   <td style="text-align:center;"> 0.93026 </td>
   <td style="text-align:center;"> 0.95181 </td>
   <td style="text-align:center;"> 0.88543 </td>
   <td style="text-align:center;"> 0.57033 </td>
   <td style="text-align:center;"> 6.5625 </td>
   <td style="text-align:center;"> 4.875 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 2.325 </td>
   <td style="text-align:center;"> 3.1290 </td>
   <td style="text-align:center;"> 6.975 </td>
   <td style="text-align:center;"> 7.050 </td>
   <td style="text-align:center;"> 0.57156 </td>
   <td style="text-align:center;"> 6.7576 </td>
   <td style="text-align:center;"> 3.0068 </td>
   <td style="text-align:center;"> 8.8223 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13018 </td>
   <td style="text-align:center;"> 6.6414 </td>
   <td style="text-align:center;"> 1.1175 </td>
   <td style="text-align:center;"> 6.6742 </td>
   <td style="text-align:center;"> 6.1053 </td>
   <td style="text-align:center;"> 7.4198 </td>
   <td style="text-align:center;"> 1.3145 </td>
   <td style="text-align:center;"> 0.06894 </td>
   <td style="text-align:center;"> 0.04596 </td>
   <td style="text-align:center;"> 0.09958 </td>
   <td style="text-align:center;"> 0.05362 </td>
   <td style="text-align:center;"> 1.5525 </td>
   <td style="text-align:center;"> 5.0724 </td>
   <td style="text-align:center;"> 0.92348 </td>
   <td style="text-align:center;"> 0.95342 </td>
   <td style="text-align:center;"> 0.88047 </td>
   <td style="text-align:center;"> 0.53236 </td>
   <td style="text-align:center;"> 6.2917 </td>
   <td style="text-align:center;"> 4.575 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 2.325 </td>
   <td style="text-align:center;"> 2.1613 </td>
   <td style="text-align:center;"> 4.575 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 17.86003 </td>
   <td style="text-align:center;"> 6.6821 </td>
   <td style="text-align:center;"> 2.7768 </td>
   <td style="text-align:center;"> 8.8880 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13122 </td>
   <td style="text-align:center;"> 6.5880 </td>
   <td style="text-align:center;"> 1.2534 </td>
   <td style="text-align:center;"> 6.6546 </td>
   <td style="text-align:center;"> 6.0371 </td>
   <td style="text-align:center;"> 7.3941 </td>
   <td style="text-align:center;"> 1.3570 </td>
   <td style="text-align:center;"> 0.06948 </td>
   <td style="text-align:center;"> 0.03860 </td>
   <td style="text-align:center;"> 0.10036 </td>
   <td style="text-align:center;"> 0.06176 </td>
   <td style="text-align:center;"> 1.8047 </td>
   <td style="text-align:center;"> 5.9891 </td>
   <td style="text-align:center;"> 0.91986 </td>
   <td style="text-align:center;"> 0.95764 </td>
   <td style="text-align:center;"> 0.88090 </td>
   <td style="text-align:center;"> 0.53116 </td>
   <td style="text-align:center;"> 6.1458 </td>
   <td style="text-align:center;"> 4.650 </td>
   <td style="text-align:center;"> 6.675 </td>
   <td style="text-align:center;"> 2.025 </td>
   <td style="text-align:center;"> 1.5556 </td>
   <td style="text-align:center;"> 4.650 </td>
   <td style="text-align:center;"> 6.600 </td>
   <td style="text-align:center;"> 14.86088 </td>
   <td style="text-align:center;"> 6.7576 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 9.3151 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.14542 </td>
   <td style="text-align:center;"> 6.2233 </td>
   <td style="text-align:center;"> 1.4789 </td>
   <td style="text-align:center;"> 6.2369 </td>
   <td style="text-align:center;"> 5.4593 </td>
   <td style="text-align:center;"> 7.3104 </td>
   <td style="text-align:center;"> 1.8511 </td>
   <td style="text-align:center;"> 0.08422 </td>
   <td style="text-align:center;"> 0.04594 </td>
   <td style="text-align:center;"> 0.11484 </td>
   <td style="text-align:center;"> 0.06891 </td>
   <td style="text-align:center;"> 1.2507 </td>
   <td style="text-align:center;"> 4.2866 </td>
   <td style="text-align:center;"> 0.96418 </td>
   <td style="text-align:center;"> 0.95206 </td>
   <td style="text-align:center;"> 0.91795 </td>
   <td style="text-align:center;"> 0.75803 </td>
   <td style="text-align:center;"> 6.1650 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> 8.250 </td>
   <td style="text-align:center;"> 4.275 </td>
   <td style="text-align:center;"> 2.8070 </td>
   <td style="text-align:center;"> 5.325 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> -9.28314 </td>
   <td style="text-align:center;"> 6.3046 </td>
   <td style="text-align:center;"> 2.5140 </td>
   <td style="text-align:center;"> 9.2166 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.14419 </td>
   <td style="text-align:center;"> 6.4692 </td>
   <td style="text-align:center;"> 1.5921 </td>
   <td style="text-align:center;"> 6.3345 </td>
   <td style="text-align:center;"> 5.6335 </td>
   <td style="text-align:center;"> 7.5838 </td>
   <td style="text-align:center;"> 1.9503 </td>
   <td style="text-align:center;"> 0.08350 </td>
   <td style="text-align:center;"> 0.04554 </td>
   <td style="text-align:center;"> 0.11386 </td>
   <td style="text-align:center;"> 0.06832 </td>
   <td style="text-align:center;"> 1.6977 </td>
   <td style="text-align:center;"> 6.4039 </td>
   <td style="text-align:center;"> 0.95838 </td>
   <td style="text-align:center;"> 0.95309 </td>
   <td style="text-align:center;"> 0.91342 </td>
   <td style="text-align:center;"> 0.72121 </td>
   <td style="text-align:center;"> 6.5325 </td>
   <td style="text-align:center;"> 3.750 </td>
   <td style="text-align:center;"> 8.775 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 2.8508 </td>
   <td style="text-align:center;"> 8.025 </td>
   <td style="text-align:center;"> 3.750 </td>
   <td style="text-align:center;"> -29.64911 </td>
   <td style="text-align:center;"> 6.2290 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 10.2351 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.14510 </td>
   <td style="text-align:center;"> 6.1237 </td>
   <td style="text-align:center;"> 1.5432 </td>
   <td style="text-align:center;"> 6.0817 </td>
   <td style="text-align:center;"> 5.1786 </td>
   <td style="text-align:center;"> 7.2467 </td>
   <td style="text-align:center;"> 2.0681 </td>
   <td style="text-align:center;"> 0.08404 </td>
   <td style="text-align:center;"> 0.04584 </td>
   <td style="text-align:center;"> 0.11460 </td>
   <td style="text-align:center;"> 0.06876 </td>
   <td style="text-align:center;"> 1.0908 </td>
   <td style="text-align:center;"> 4.1060 </td>
   <td style="text-align:center;"> 0.96434 </td>
   <td style="text-align:center;"> 0.95302 </td>
   <td style="text-align:center;"> 0.91904 </td>
   <td style="text-align:center;"> 0.73709 </td>
   <td style="text-align:center;"> 6.0713 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> 7.875 </td>
   <td style="text-align:center;"> 3.900 </td>
   <td style="text-align:center;"> 3.8846 </td>
   <td style="text-align:center;"> 7.875 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> -26.87821 </td>
   <td style="text-align:center;"> 6.0025 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 9.7423 </td>
  </tr>
</tbody>
</table></div>
&nbsp; 

#### Cross correlation


{% highlight r %}
xc <- xcorr(ext_st, bp = c(1, 11))

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
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.70098 </td>
   <td style="text-align:center;"> 0.67774 </td>
   <td style="text-align:center;"> 0.37965 </td>
   <td style="text-align:center;"> 0.37656 </td>
   <td style="text-align:center;"> 0.41595 </td>
   <td style="text-align:center;"> 0.36969 </td>
   <td style="text-align:center;"> 0.40227 </td>
   <td style="text-align:center;"> 0.31495 </td>
   <td style="text-align:center;"> 0.31186 </td>
   <td style="text-align:center;"> 0.32389 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_2-1 </td>
   <td style="text-align:center;"> 0.70098 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.64562 </td>
   <td style="text-align:center;"> 0.39796 </td>
   <td style="text-align:center;"> 0.40553 </td>
   <td style="text-align:center;"> 0.40322 </td>
   <td style="text-align:center;"> 0.36674 </td>
   <td style="text-align:center;"> 0.40986 </td>
   <td style="text-align:center;"> 0.31026 </td>
   <td style="text-align:center;"> 0.31066 </td>
   <td style="text-align:center;"> 0.32019 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_3-1 </td>
   <td style="text-align:center;"> 0.67774 </td>
   <td style="text-align:center;"> 0.64562 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.40397 </td>
   <td style="text-align:center;"> 0.40515 </td>
   <td style="text-align:center;"> 0.40939 </td>
   <td style="text-align:center;"> 0.38032 </td>
   <td style="text-align:center;"> 0.41243 </td>
   <td style="text-align:center;"> 0.30668 </td>
   <td style="text-align:center;"> 0.29962 </td>
   <td style="text-align:center;"> 0.32628 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_1-1 </td>
   <td style="text-align:center;"> 0.37965 </td>
   <td style="text-align:center;"> 0.39796 </td>
   <td style="text-align:center;"> 0.40397 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.66783 </td>
   <td style="text-align:center;"> 0.64736 </td>
   <td style="text-align:center;"> 0.64770 </td>
   <td style="text-align:center;"> 0.60379 </td>
   <td style="text-align:center;"> 0.32453 </td>
   <td style="text-align:center;"> 0.29737 </td>
   <td style="text-align:center;"> 0.32423 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_2-1 </td>
   <td style="text-align:center;"> 0.37656 </td>
   <td style="text-align:center;"> 0.40553 </td>
   <td style="text-align:center;"> 0.40515 </td>
   <td style="text-align:center;"> 0.66783 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.60930 </td>
   <td style="text-align:center;"> 0.63169 </td>
   <td style="text-align:center;"> 0.63351 </td>
   <td style="text-align:center;"> 0.31042 </td>
   <td style="text-align:center;"> 0.27856 </td>
   <td style="text-align:center;"> 0.31651 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_1-1 </td>
   <td style="text-align:center;"> 0.41595 </td>
   <td style="text-align:center;"> 0.40322 </td>
   <td style="text-align:center;"> 0.40939 </td>
   <td style="text-align:center;"> 0.64736 </td>
   <td style="text-align:center;"> 0.60930 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.75640 </td>
   <td style="text-align:center;"> 0.71382 </td>
   <td style="text-align:center;"> 0.30416 </td>
   <td style="text-align:center;"> 0.27581 </td>
   <td style="text-align:center;"> 0.29938 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_2-1 </td>
   <td style="text-align:center;"> 0.36969 </td>
   <td style="text-align:center;"> 0.36674 </td>
   <td style="text-align:center;"> 0.38032 </td>
   <td style="text-align:center;"> 0.64770 </td>
   <td style="text-align:center;"> 0.63169 </td>
   <td style="text-align:center;"> 0.75640 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.73529 </td>
   <td style="text-align:center;"> 0.30324 </td>
   <td style="text-align:center;"> 0.27773 </td>
   <td style="text-align:center;"> 0.30050 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_3-1 </td>
   <td style="text-align:center;"> 0.40227 </td>
   <td style="text-align:center;"> 0.40986 </td>
   <td style="text-align:center;"> 0.41243 </td>
   <td style="text-align:center;"> 0.60379 </td>
   <td style="text-align:center;"> 0.63351 </td>
   <td style="text-align:center;"> 0.71382 </td>
   <td style="text-align:center;"> 0.73529 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.31193 </td>
   <td style="text-align:center;"> 0.28016 </td>
   <td style="text-align:center;"> 0.30141 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_1-1 </td>
   <td style="text-align:center;"> 0.31495 </td>
   <td style="text-align:center;"> 0.31026 </td>
   <td style="text-align:center;"> 0.30668 </td>
   <td style="text-align:center;"> 0.32453 </td>
   <td style="text-align:center;"> 0.31042 </td>
   <td style="text-align:center;"> 0.30416 </td>
   <td style="text-align:center;"> 0.30324 </td>
   <td style="text-align:center;"> 0.31193 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.76814 </td>
   <td style="text-align:center;"> 0.75387 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_2-1 </td>
   <td style="text-align:center;"> 0.31186 </td>
   <td style="text-align:center;"> 0.31066 </td>
   <td style="text-align:center;"> 0.29962 </td>
   <td style="text-align:center;"> 0.29737 </td>
   <td style="text-align:center;"> 0.27856 </td>
   <td style="text-align:center;"> 0.27581 </td>
   <td style="text-align:center;"> 0.27773 </td>
   <td style="text-align:center;"> 0.28016 </td>
   <td style="text-align:center;"> 0.76814 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.75907 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_3-1 </td>
   <td style="text-align:center;"> 0.32389 </td>
   <td style="text-align:center;"> 0.32019 </td>
   <td style="text-align:center;"> 0.32628 </td>
   <td style="text-align:center;"> 0.32423 </td>
   <td style="text-align:center;"> 0.31651 </td>
   <td style="text-align:center;"> 0.29938 </td>
   <td style="text-align:center;"> 0.30050 </td>
   <td style="text-align:center;"> 0.30141 </td>
   <td style="text-align:center;"> 0.75387 </td>
   <td style="text-align:center;"> 0.75907 </td>
   <td style="text-align:center;"> 1.00000 </td>
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
   <td style="text-align:center;"> 0.27303 </td>
   <td style="text-align:center;"> 2.2201 </td>
   <td style="text-align:center;"> 8.6044 </td>
   <td style="text-align:center;"> c24 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 21.182 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.26305 </td>
   <td style="text-align:center;"> 2.1694 </td>
   <td style="text-align:center;"> 8.8071 </td>
   <td style="text-align:center;"> c25 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 20.355 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.27492 </td>
   <td style="text-align:center;"> 2.2183 </td>
   <td style="text-align:center;"> 8.7566 </td>
   <td style="text-align:center;"> c26 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 19.164 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.23257 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 8.8223 </td>
   <td style="text-align:center;"> c27 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 23.273 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.22615 </td>
   <td style="text-align:center;"> 2.2840 </td>
   <td style="text-align:center;"> 8.8880 </td>
   <td style="text-align:center;"> c28 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 26.206 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.23122 </td>
   <td style="text-align:center;"> 3.0068 </td>
   <td style="text-align:center;"> 8.8223 </td>
   <td style="text-align:center;"> c29 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 25.326 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.23018 </td>
   <td style="text-align:center;"> 2.7768 </td>
   <td style="text-align:center;"> 8.8880 </td>
   <td style="text-align:center;"> c30 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 25.508 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.23122 </td>
   <td style="text-align:center;"> 2.3169 </td>
   <td style="text-align:center;"> 9.3151 </td>
   <td style="text-align:center;"> c31 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 24.669 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.24542 </td>
   <td style="text-align:center;"> 2.5140 </td>
   <td style="text-align:center;"> 9.2166 </td>
   <td style="text-align:center;"> c32 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 27.620 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.24419 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 10.2351 </td>
   <td style="text-align:center;"> c33 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 28.852 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> 0.24510 </td>
   <td style="text-align:center;"> 2.5797 </td>
   <td style="text-align:center;"> 9.7423 </td>
   <td style="text-align:center;"> c34 </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 24.290 </td>
  </tr>
</tbody>
</table></div>
&nbsp; 

#### Dynamic time warping distance


{% highlight r %}
dtw.dist <- dfDTW(ext_st, img = FALSE)

dtw.dist
{% endhighlight %}



{% highlight text %}
calculating DTW distances (step 2 of 2, no progress bar):
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
   <td style="text-align:center;"> 16.465 </td>
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
   <td style="text-align:center;"> 19.740 </td>
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
   <td style="text-align:center;"> 19.919 </td>
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
   <td style="text-align:center;"> 16.465 </td>
   <td style="text-align:center;"> 19.740 </td>
   <td style="text-align:center;"> 19.919 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 9.064 </td>
   <td style="text-align:center;"> 10.258 </td>
   <td style="text-align:center;"> 7.864 </td>
   <td style="text-align:center;"> 9.698 </td>
   <td style="text-align:center;"> 18.931 </td>
   <td style="text-align:center;"> 24.143 </td>
   <td style="text-align:center;"> 24.309 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_2-1 </td>
   <td style="text-align:center;"> 18.364 </td>
   <td style="text-align:center;"> 23.317 </td>
   <td style="text-align:center;"> 19.306 </td>
   <td style="text-align:center;"> 9.064 </td>
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
   <td style="text-align:center;"> 10.258 </td>
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
   <td style="text-align:center;"> 7.864 </td>
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
   <td style="text-align:center;"> 9.698 </td>
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
   <td style="text-align:center;"> 18.931 </td>
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
   <td style="text-align:center;"> 24.143 </td>
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
   <td style="text-align:center;"> 24.309 </td>
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
sp <- specan(dat, bp = c(2, 10))

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
   <td style="text-align:center;"> 4.6570 </td>
   <td style="text-align:center;"> 1.7692 </td>
   <td style="text-align:center;"> 4.2876 </td>
   <td style="text-align:center;"> 3.4364 </td>
   <td style="text-align:center;"> 5.6243 </td>
   <td style="text-align:center;"> 2.1879 </td>
   <td style="text-align:center;"> 0.06543 </td>
   <td style="text-align:center;"> 0.03926 </td>
   <td style="text-align:center;"> 0.10469 </td>
   <td style="text-align:center;"> 0.06543 </td>
   <td style="text-align:center;"> 2.6003 </td>
   <td style="text-align:center;"> 11.8598 </td>
   <td style="text-align:center;"> 0.92349 </td>
   <td style="text-align:center;"> 0.95082 </td>
   <td style="text-align:center;"> 0.87807 </td>
   <td style="text-align:center;"> 0.54127 </td>
   <td style="text-align:center;"> 3.9580 </td>
   <td style="text-align:center;"> 2.2395 </td>
   <td style="text-align:center;"> 6.8045 </td>
   <td style="text-align:center;"> 4.5650 </td>
   <td style="text-align:center;"> 3.5660 </td>
   <td style="text-align:center;"> 4.4789 </td>
   <td style="text-align:center;"> 4.0482 </td>
   <td style="text-align:center;"> -2.8620 </td>
   <td style="text-align:center;"> 4.0208 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 0.CCE.1971.4.4.ITM70863A-23.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.16556 </td>
   <td style="text-align:center;"> 6.2556 </td>
   <td style="text-align:center;"> 1.6484 </td>
   <td style="text-align:center;"> 6.3505 </td>
   <td style="text-align:center;"> 5.6072 </td>
   <td style="text-align:center;"> 7.2024 </td>
   <td style="text-align:center;"> 1.5952 </td>
   <td style="text-align:center;"> 0.08279 </td>
   <td style="text-align:center;"> 0.03821 </td>
   <td style="text-align:center;"> 0.12100 </td>
   <td style="text-align:center;"> 0.08279 </td>
   <td style="text-align:center;"> 2.3775 </td>
   <td style="text-align:center;"> 10.1358 </td>
   <td style="text-align:center;"> 0.93975 </td>
   <td style="text-align:center;"> 0.94103 </td>
   <td style="text-align:center;"> 0.88434 </td>
   <td style="text-align:center;"> 0.63367 </td>
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
   <td style="text-align:center;"> 6.0960 </td>
   <td style="text-align:center;"> 1.6472 </td>
   <td style="text-align:center;"> 5.8475 </td>
   <td style="text-align:center;"> 4.9067 </td>
   <td style="text-align:center;"> 7.3982 </td>
   <td style="text-align:center;"> 2.4915 </td>
   <td style="text-align:center;"> 0.08356 </td>
   <td style="text-align:center;"> 0.04499 </td>
   <td style="text-align:center;"> 0.11570 </td>
   <td style="text-align:center;"> 0.07070 </td>
   <td style="text-align:center;"> 1.9681 </td>
   <td style="text-align:center;"> 7.2878 </td>
   <td style="text-align:center;"> 0.93913 </td>
   <td style="text-align:center;"> 0.94322 </td>
   <td style="text-align:center;"> 0.88581 </td>
   <td style="text-align:center;"> 0.60968 </td>
   <td style="text-align:center;"> 6.3221 </td>
   <td style="text-align:center;"> 3.2731 </td>
   <td style="text-align:center;"> 8.0965 </td>
   <td style="text-align:center;"> 4.8234 </td>
   <td style="text-align:center;"> 3.1071 </td>
   <td style="text-align:center;"> 6.3738 </td>
   <td style="text-align:center;"> 3.2731 </td>
   <td style="text-align:center;"> -20.1021 </td>
   <td style="text-align:center;"> 7.0473 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 23.CCE.2011.7.21.7.42.wav_6 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15496 </td>
   <td style="text-align:center;"> 5.4239 </td>
   <td style="text-align:center;"> 1.4632 </td>
   <td style="text-align:center;"> 5.1832 </td>
   <td style="text-align:center;"> 4.4278 </td>
   <td style="text-align:center;"> 6.4358 </td>
   <td style="text-align:center;"> 2.0081 </td>
   <td style="text-align:center;"> 0.06458 </td>
   <td style="text-align:center;"> 0.03875 </td>
   <td style="text-align:center;"> 0.10333 </td>
   <td style="text-align:center;"> 0.06458 </td>
   <td style="text-align:center;"> 2.1063 </td>
   <td style="text-align:center;"> 8.0438 </td>
   <td style="text-align:center;"> 0.92290 </td>
   <td style="text-align:center;"> 0.94473 </td>
   <td style="text-align:center;"> 0.87189 </td>
   <td style="text-align:center;"> 0.50696 </td>
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
   <td style="text-align:center;"> 3.1546 </td>
   <td style="text-align:center;"> 1.2261 </td>
   <td style="text-align:center;"> 2.5692 </td>
   <td style="text-align:center;"> 2.2439 </td>
   <td style="text-align:center;"> 3.6575 </td>
   <td style="text-align:center;"> 1.4136 </td>
   <td style="text-align:center;"> 0.06396 </td>
   <td style="text-align:center;"> 0.03838 </td>
   <td style="text-align:center;"> 0.09595 </td>
   <td style="text-align:center;"> 0.05757 </td>
   <td style="text-align:center;"> 4.5462 </td>
   <td style="text-align:center;"> 29.4729 </td>
   <td style="text-align:center;"> 0.82325 </td>
   <td style="text-align:center;"> 0.93564 </td>
   <td style="text-align:center;"> 0.77027 </td>
   <td style="text-align:center;"> 0.12652 </td>
   <td style="text-align:center;"> 2.5166 </td>
   <td style="text-align:center;"> 2.0672 </td>
   <td style="text-align:center;"> 4.2205 </td>
   <td style="text-align:center;"> 2.1533 </td>
   <td style="text-align:center;"> 3.2000 </td>
   <td style="text-align:center;"> 2.4117 </td>
   <td style="text-align:center;"> 2.2395 </td>
   <td style="text-align:center;"> -1.0774 </td>
   <td style="text-align:center;"> 2.2913 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 0.HC1.2011.8.7.9.20.wav_4 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.15380 </td>
   <td style="text-align:center;"> 6.0302 </td>
   <td style="text-align:center;"> 1.7597 </td>
   <td style="text-align:center;"> 6.4163 </td>
   <td style="text-align:center;"> 4.9203 </td>
   <td style="text-align:center;"> 7.1837 </td>
   <td style="text-align:center;"> 2.2634 </td>
   <td style="text-align:center;"> 0.07692 </td>
   <td style="text-align:center;"> 0.04487 </td>
   <td style="text-align:center;"> 0.10896 </td>
   <td style="text-align:center;"> 0.06410 </td>
   <td style="text-align:center;"> 4.1566 </td>
   <td style="text-align:center;"> 27.8331 </td>
   <td style="text-align:center;"> 0.92869 </td>
   <td style="text-align:center;"> 0.94595 </td>
   <td style="text-align:center;"> 0.87849 </td>
   <td style="text-align:center;"> 0.60299 </td>
   <td style="text-align:center;"> 6.1017 </td>
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
Running under: Ubuntu 16.04.5 LTS

Matrix products: default
BLAS: /usr/lib/openblas-base/libblas.so.3
LAPACK: /usr/lib/libopenblasp-r0.2.18.so

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] ggplot2_3.0.0        microbenchmark_1.4-4 kableExtra_0.9.0     knitr_1.20           warbleR_1.1.15      
[6] NatureSounds_1.0.0   seewave_2.1.0        tuneR_1.3.3          maps_3.3.0          

loaded via a namespace (and not attached):
 [1] rgl_0.95.1441        Rcpp_0.12.18         fftw_1.0-4           assertthat_0.2.0     rprojroot_1.3-2     
 [6] digest_0.6.16        R6_2.2.2             plyr_1.8.4           Sim.DiffProc_4.1     backports_1.1.2     
[11] signal_0.7-6         evaluate_0.11        pracma_2.1.5         httr_1.3.1           highr_0.7           
[16] pillar_1.3.0         rlang_0.2.2          lazyeval_0.2.1       curl_3.2             rstudioapi_0.7      
[21] rmarkdown_1.10       devtools_1.13.6      moments_0.14         readr_1.1.1          stringr_1.3.1       
[26] RCurl_1.95-4.11      munsell_0.5.0        proxy_0.4-22         compiler_3.4.4       Deriv_3.8.5         
[31] pkgconfig_2.0.2      htmltools_0.3.6      tidyselect_0.2.4     tibble_1.4.2         dtw_1.20-1          
[36] bioacoustics_0.1.5   viridisLite_0.3.0    crayon_1.3.4         dplyr_0.7.6          withr_2.1.2         
[41] MASS_7.3-50          bitops_1.0-6         grid_3.4.4           gtable_0.2.0         git2r_0.23.0        
[46] magrittr_1.5         scales_1.0.0         stringi_1.2.4        pbapply_1.3-4        scatterplot3d_0.3-41
[51] bindrcpp_0.2.2       xml2_1.2.0           rjson_0.2.20         iterators_1.0.10     tools_3.4.4         
[56] glue_1.3.0           purrr_0.2.5          hms_0.4.2            jpeg_0.1-8           parallel_3.4.4      
[61] yaml_2.2.0           colorspace_1.3-2     soundgen_1.3.1       rvest_0.3.2          memoise_1.1.0       
[66] bindr_0.1.1         
{% endhighlight %}



