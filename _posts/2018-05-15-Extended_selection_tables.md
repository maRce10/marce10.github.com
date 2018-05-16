---
layout: post
title: Extended selection tables
date: 15-05-2018
---

This post shows how to create and use the new [warbleR](https://cran.r-project.org/package=warbleR) object class *extended_selection_table*.

These objects are created with the `selec_table()` function. This function takes data frames containing selection data (sound file name, selection, start, end ...), checks whether the information is consistent (see `checksels()` function for details) and saves the 'diagnostic' metadata as an attribute. When the argument `extended = TRUE` the function generates an object of class *extended_selection_table* which also contains a list of wave objects corresponding to each of the selections in the data frame. Hence, the function **transforms selection tables into self-contained objects** as they no longer need the original sound files for running most acoustic analysis in 
[warbleR](https://cran.r-project.org/package=warbleR). This can facilitate a lot the storing and sharing of (bio)acoustic data. In addition, it also speeds up processes as sound files do not need to be read every time.

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

The following code converts it to a extended selection table:


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

And finally they can also be row-bind together. Here the original *extended_selection_table* is split into 2 and bind back together using `rbind()`:


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

Keep in mind that other functions that deal with data frames are likely to remove the attributes in which wave objects and metadata are stored.

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

As you can see the object size is only ~31 Mb. So, as a guide, a selection table with 1000 selections similar to those in 'selec.table' (mean duration ~0.15 seconds) at 22.5 kHz sampling rate and the default margin (mar = 0.1) will generate a extended selection table of ~31 MB or ~310 MB for a 10000 row selection table. 

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
   <td style="text-align:center;"> 0.17303 </td>
   <td style="text-align:center;"> 6.0312 </td>
   <td style="text-align:center;"> 2.0836 </td>
   <td style="text-align:center;"> 6.3559 </td>
   <td style="text-align:center;"> 5.1530 </td>
   <td style="text-align:center;"> 7.0152 </td>
   <td style="text-align:center;"> 1.8622 </td>
   <td style="text-align:center;"> 0.08277 </td>
   <td style="text-align:center;"> 0.05267 </td>
   <td style="text-align:center;"> 0.12039 </td>
   <td style="text-align:center;"> 0.06772 </td>
   <td style="text-align:center;"> 2.6854 </td>
   <td style="text-align:center;"> 11.0586 </td>
   <td style="text-align:center;"> 0.92734 </td>
   <td style="text-align:center;"> 0.94013 </td>
   <td style="text-align:center;"> 0.87182 </td>
   <td style="text-align:center;"> 0.56201 </td>
   <td style="text-align:center;"> 3.6926 </td>
   <td style="text-align:center;"> 2.50000 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.6000 </td>
   <td style="text-align:center;"> 4.425 </td>
   <td style="text-align:center;"> 8.250 </td>
   <td style="text-align:center;"> 3.825 </td>
   <td style="text-align:center;"> 3.5882 </td>
   <td style="text-align:center;"> 7.125 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 0.43344 </td>
   <td style="text-align:center;"> 7.1351 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.16305 </td>
   <td style="text-align:center;"> 6.0195 </td>
   <td style="text-align:center;"> 2.0697 </td>
   <td style="text-align:center;"> 6.2515 </td>
   <td style="text-align:center;"> 5.2331 </td>
   <td style="text-align:center;"> 7.0368 </td>
   <td style="text-align:center;"> 1.8037 </td>
   <td style="text-align:center;"> 0.07414 </td>
   <td style="text-align:center;"> 0.04448 </td>
   <td style="text-align:center;"> 0.11863 </td>
   <td style="text-align:center;"> 0.07414 </td>
   <td style="text-align:center;"> 2.5330 </td>
   <td style="text-align:center;"> 10.7669 </td>
   <td style="text-align:center;"> 0.93115 </td>
   <td style="text-align:center;"> 0.94444 </td>
   <td style="text-align:center;"> 0.87941 </td>
   <td style="text-align:center;"> 0.58084 </td>
   <td style="text-align:center;"> 3.2688 </td>
   <td style="text-align:center;"> 0.44118 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.7043 </td>
   <td style="text-align:center;"> 5.250 </td>
   <td style="text-align:center;"> 8.325 </td>
   <td style="text-align:center;"> 3.075 </td>
   <td style="text-align:center;"> 4.4878 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 1.83995 </td>
   <td style="text-align:center;"> 6.9086 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long1.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.17492 </td>
   <td style="text-align:center;"> 6.0685 </td>
   <td style="text-align:center;"> 2.1527 </td>
   <td style="text-align:center;"> 6.4639 </td>
   <td style="text-align:center;"> 4.9938 </td>
   <td style="text-align:center;"> 7.1331 </td>
   <td style="text-align:center;"> 2.1394 </td>
   <td style="text-align:center;"> 0.08749 </td>
   <td style="text-align:center;"> 0.05104 </td>
   <td style="text-align:center;"> 0.13123 </td>
   <td style="text-align:center;"> 0.08020 </td>
   <td style="text-align:center;"> 3.1292 </td>
   <td style="text-align:center;"> 16.0200 </td>
   <td style="text-align:center;"> 0.93020 </td>
   <td style="text-align:center;"> 0.93783 </td>
   <td style="text-align:center;"> 0.87237 </td>
   <td style="text-align:center;"> 0.57827 </td>
   <td style="text-align:center;"> 3.6815 </td>
   <td style="text-align:center;"> 1.18421 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.7050 </td>
   <td style="text-align:center;"> 4.200 </td>
   <td style="text-align:center;"> 8.625 </td>
   <td style="text-align:center;"> 4.425 </td>
   <td style="text-align:center;"> 4.5424 </td>
   <td style="text-align:center;"> 7.050 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 0.85754 </td>
   <td style="text-align:center;"> 6.8331 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13257 </td>
   <td style="text-align:center;"> 6.5823 </td>
   <td style="text-align:center;"> 1.9308 </td>
   <td style="text-align:center;"> 6.7419 </td>
   <td style="text-align:center;"> 5.6019 </td>
   <td style="text-align:center;"> 7.6102 </td>
   <td style="text-align:center;"> 2.0082 </td>
   <td style="text-align:center;"> 0.07801 </td>
   <td style="text-align:center;"> 0.05461 </td>
   <td style="text-align:center;"> 0.10922 </td>
   <td style="text-align:center;"> 0.05461 </td>
   <td style="text-align:center;"> 2.1870 </td>
   <td style="text-align:center;"> 8.8696 </td>
   <td style="text-align:center;"> 0.92448 </td>
   <td style="text-align:center;"> 0.95029 </td>
   <td style="text-align:center;"> 0.87852 </td>
   <td style="text-align:center;"> 0.51876 </td>
   <td style="text-align:center;"> 6.0364 </td>
   <td style="text-align:center;"> 0.90000 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.3662 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 7.575 </td>
   <td style="text-align:center;"> 2.550 </td>
   <td style="text-align:center;"> 4.2941 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 5.925 </td>
   <td style="text-align:center;"> 6.78882 </td>
   <td style="text-align:center;"> 7.3617 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long2.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.12615 </td>
   <td style="text-align:center;"> 6.4168 </td>
   <td style="text-align:center;"> 1.9467 </td>
   <td style="text-align:center;"> 6.6429 </td>
   <td style="text-align:center;"> 5.5397 </td>
   <td style="text-align:center;"> 7.4683 </td>
   <td style="text-align:center;"> 1.9286 </td>
   <td style="text-align:center;"> 0.07886 </td>
   <td style="text-align:center;"> 0.05520 </td>
   <td style="text-align:center;"> 0.10252 </td>
   <td style="text-align:center;"> 0.04732 </td>
   <td style="text-align:center;"> 3.1277 </td>
   <td style="text-align:center;"> 15.8100 </td>
   <td style="text-align:center;"> 0.91791 </td>
   <td style="text-align:center;"> 0.95010 </td>
   <td style="text-align:center;"> 0.87210 </td>
   <td style="text-align:center;"> 0.52710 </td>
   <td style="text-align:center;"> 5.5929 </td>
   <td style="text-align:center;"> 0.30405 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.1721 </td>
   <td style="text-align:center;"> 4.800 </td>
   <td style="text-align:center;"> 7.575 </td>
   <td style="text-align:center;"> 2.775 </td>
   <td style="text-align:center;"> 2.7838 </td>
   <td style="text-align:center;"> 4.800 </td>
   <td style="text-align:center;"> 6.525 </td>
   <td style="text-align:center;"> 13.67418 </td>
   <td style="text-align:center;"> 6.7576 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13122 </td>
   <td style="text-align:center;"> 6.6210 </td>
   <td style="text-align:center;"> 1.8361 </td>
   <td style="text-align:center;"> 6.6900 </td>
   <td style="text-align:center;"> 6.0035 </td>
   <td style="text-align:center;"> 7.5520 </td>
   <td style="text-align:center;"> 1.5485 </td>
   <td style="text-align:center;"> 0.06176 </td>
   <td style="text-align:center;"> 0.04632 </td>
   <td style="text-align:center;"> 0.09264 </td>
   <td style="text-align:center;"> 0.04632 </td>
   <td style="text-align:center;"> 2.6419 </td>
   <td style="text-align:center;"> 11.2995 </td>
   <td style="text-align:center;"> 0.90653 </td>
   <td style="text-align:center;"> 0.95233 </td>
   <td style="text-align:center;"> 0.86331 </td>
   <td style="text-align:center;"> 0.47786 </td>
   <td style="text-align:center;"> 6.6964 </td>
   <td style="text-align:center;"> 3.21429 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.5625 </td>
   <td style="text-align:center;"> 4.875 </td>
   <td style="text-align:center;"> 7.200 </td>
   <td style="text-align:center;"> 2.325 </td>
   <td style="text-align:center;"> 3.1290 </td>
   <td style="text-align:center;"> 6.975 </td>
   <td style="text-align:center;"> 7.050 </td>
   <td style="text-align:center;"> 0.57156 </td>
   <td style="text-align:center;"> 6.7576 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13018 </td>
   <td style="text-align:center;"> 6.6913 </td>
   <td style="text-align:center;"> 1.7894 </td>
   <td style="text-align:center;"> 6.7337 </td>
   <td style="text-align:center;"> 6.0727 </td>
   <td style="text-align:center;"> 7.6101 </td>
   <td style="text-align:center;"> 1.5374 </td>
   <td style="text-align:center;"> 0.06894 </td>
   <td style="text-align:center;"> 0.04596 </td>
   <td style="text-align:center;"> 0.09958 </td>
   <td style="text-align:center;"> 0.05362 </td>
   <td style="text-align:center;"> 2.3873 </td>
   <td style="text-align:center;"> 8.9018 </td>
   <td style="text-align:center;"> 0.90254 </td>
   <td style="text-align:center;"> 0.95406 </td>
   <td style="text-align:center;"> 0.86108 </td>
   <td style="text-align:center;"> 0.46317 </td>
   <td style="text-align:center;"> 6.3839 </td>
   <td style="text-align:center;"> 2.50000 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.2917 </td>
   <td style="text-align:center;"> 4.575 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 2.325 </td>
   <td style="text-align:center;"> 2.1613 </td>
   <td style="text-align:center;"> 4.575 </td>
   <td style="text-align:center;"> 6.900 </td>
   <td style="text-align:center;"> 17.86003 </td>
   <td style="text-align:center;"> 6.6821 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long3.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.13122 </td>
   <td style="text-align:center;"> 6.5186 </td>
   <td style="text-align:center;"> 1.8534 </td>
   <td style="text-align:center;"> 6.6519 </td>
   <td style="text-align:center;"> 5.9119 </td>
   <td style="text-align:center;"> 7.5444 </td>
   <td style="text-align:center;"> 1.6324 </td>
   <td style="text-align:center;"> 0.06948 </td>
   <td style="text-align:center;"> 0.03860 </td>
   <td style="text-align:center;"> 0.10036 </td>
   <td style="text-align:center;"> 0.06176 </td>
   <td style="text-align:center;"> 2.4638 </td>
   <td style="text-align:center;"> 9.2717 </td>
   <td style="text-align:center;"> 0.90403 </td>
   <td style="text-align:center;"> 0.95781 </td>
   <td style="text-align:center;"> 0.86589 </td>
   <td style="text-align:center;"> 0.47996 </td>
   <td style="text-align:center;"> 7.1250 </td>
   <td style="text-align:center;"> 5.62500 </td>
   <td style="text-align:center;"> 7.500 </td>
   <td style="text-align:center;"> 6.1458 </td>
   <td style="text-align:center;"> 4.650 </td>
   <td style="text-align:center;"> 6.675 </td>
   <td style="text-align:center;"> 2.025 </td>
   <td style="text-align:center;"> 1.5556 </td>
   <td style="text-align:center;"> 4.650 </td>
   <td style="text-align:center;"> 6.600 </td>
   <td style="text-align:center;"> 14.86088 </td>
   <td style="text-align:center;"> 6.7576 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_1 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.14542 </td>
   <td style="text-align:center;"> 6.1574 </td>
   <td style="text-align:center;"> 2.0747 </td>
   <td style="text-align:center;"> 6.2297 </td>
   <td style="text-align:center;"> 5.2591 </td>
   <td style="text-align:center;"> 7.4412 </td>
   <td style="text-align:center;"> 2.1821 </td>
   <td style="text-align:center;"> 0.08422 </td>
   <td style="text-align:center;"> 0.04594 </td>
   <td style="text-align:center;"> 0.11484 </td>
   <td style="text-align:center;"> 0.06891 </td>
   <td style="text-align:center;"> 1.7123 </td>
   <td style="text-align:center;"> 5.8127 </td>
   <td style="text-align:center;"> 0.94299 </td>
   <td style="text-align:center;"> 0.95249 </td>
   <td style="text-align:center;"> 0.89819 </td>
   <td style="text-align:center;"> 0.61863 </td>
   <td style="text-align:center;"> 3.4028 </td>
   <td style="text-align:center;"> 1.32353 </td>
   <td style="text-align:center;"> 5.625 </td>
   <td style="text-align:center;"> 6.1650 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> 8.250 </td>
   <td style="text-align:center;"> 4.275 </td>
   <td style="text-align:center;"> 2.8070 </td>
   <td style="text-align:center;"> 5.325 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> -9.28314 </td>
   <td style="text-align:center;"> 6.3046 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_2 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.14419 </td>
   <td style="text-align:center;"> 6.2806 </td>
   <td style="text-align:center;"> 2.0964 </td>
   <td style="text-align:center;"> 6.2708 </td>
   <td style="text-align:center;"> 5.4097 </td>
   <td style="text-align:center;"> 7.6111 </td>
   <td style="text-align:center;"> 2.2014 </td>
   <td style="text-align:center;"> 0.08350 </td>
   <td style="text-align:center;"> 0.04554 </td>
   <td style="text-align:center;"> 0.11386 </td>
   <td style="text-align:center;"> 0.06832 </td>
   <td style="text-align:center;"> 2.0139 </td>
   <td style="text-align:center;"> 7.8329 </td>
   <td style="text-align:center;"> 0.94335 </td>
   <td style="text-align:center;"> 0.95359 </td>
   <td style="text-align:center;"> 0.89958 </td>
   <td style="text-align:center;"> 0.62249 </td>
   <td style="text-align:center;"> 3.7208 </td>
   <td style="text-align:center;"> 2.81250 </td>
   <td style="text-align:center;"> 5.625 </td>
   <td style="text-align:center;"> 6.5325 </td>
   <td style="text-align:center;"> 3.750 </td>
   <td style="text-align:center;"> 8.775 </td>
   <td style="text-align:center;"> 5.025 </td>
   <td style="text-align:center;"> 2.8508 </td>
   <td style="text-align:center;"> 8.025 </td>
   <td style="text-align:center;"> 3.750 </td>
   <td style="text-align:center;"> -29.64911 </td>
   <td style="text-align:center;"> 6.2290 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phae.long4.wav_3 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.14510 </td>
   <td style="text-align:center;"> 5.9974 </td>
   <td style="text-align:center;"> 2.0832 </td>
   <td style="text-align:center;"> 6.0483 </td>
   <td style="text-align:center;"> 4.9172 </td>
   <td style="text-align:center;"> 7.3034 </td>
   <td style="text-align:center;"> 2.3862 </td>
   <td style="text-align:center;"> 0.08404 </td>
   <td style="text-align:center;"> 0.04584 </td>
   <td style="text-align:center;"> 0.11460 </td>
   <td style="text-align:center;"> 0.06876 </td>
   <td style="text-align:center;"> 1.5022 </td>
   <td style="text-align:center;"> 5.1389 </td>
   <td style="text-align:center;"> 0.94599 </td>
   <td style="text-align:center;"> 0.95356 </td>
   <td style="text-align:center;"> 0.90206 </td>
   <td style="text-align:center;"> 0.62133 </td>
   <td style="text-align:center;"> 3.5381 </td>
   <td style="text-align:center;"> 2.81250 </td>
   <td style="text-align:center;"> 5.625 </td>
   <td style="text-align:center;"> 6.0713 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> 7.875 </td>
   <td style="text-align:center;"> 3.900 </td>
   <td style="text-align:center;"> 3.8846 </td>
   <td style="text-align:center;"> 7.875 </td>
   <td style="text-align:center;"> 3.975 </td>
   <td style="text-align:center;"> -26.87821 </td>
   <td style="text-align:center;"> 6.0025 </td>
  </tr>
</tbody>
</table></div>

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
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.70319 </td>
   <td style="text-align:center;"> 0.67786 </td>
   <td style="text-align:center;"> 0.37903 </td>
   <td style="text-align:center;"> 0.37639 </td>
   <td style="text-align:center;"> 0.41326 </td>
   <td style="text-align:center;"> 0.36085 </td>
   <td style="text-align:center;"> 0.40296 </td>
   <td style="text-align:center;"> 0.31506 </td>
   <td style="text-align:center;"> 0.32050 </td>
   <td style="text-align:center;"> 0.32054 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_2-1 </td>
   <td style="text-align:center;"> 0.70319 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.64425 </td>
   <td style="text-align:center;"> 0.39984 </td>
   <td style="text-align:center;"> 0.40571 </td>
   <td style="text-align:center;"> 0.40178 </td>
   <td style="text-align:center;"> 0.35871 </td>
   <td style="text-align:center;"> 0.40272 </td>
   <td style="text-align:center;"> 0.31016 </td>
   <td style="text-align:center;"> 0.31850 </td>
   <td style="text-align:center;"> 0.31455 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long1.wav_3-1 </td>
   <td style="text-align:center;"> 0.67786 </td>
   <td style="text-align:center;"> 0.64425 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.40352 </td>
   <td style="text-align:center;"> 0.40582 </td>
   <td style="text-align:center;"> 0.40634 </td>
   <td style="text-align:center;"> 0.37767 </td>
   <td style="text-align:center;"> 0.41297 </td>
   <td style="text-align:center;"> 0.30521 </td>
   <td style="text-align:center;"> 0.30567 </td>
   <td style="text-align:center;"> 0.32297 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_1-1 </td>
   <td style="text-align:center;"> 0.37903 </td>
   <td style="text-align:center;"> 0.39984 </td>
   <td style="text-align:center;"> 0.40352 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.66489 </td>
   <td style="text-align:center;"> 0.64077 </td>
   <td style="text-align:center;"> 0.64592 </td>
   <td style="text-align:center;"> 0.60911 </td>
   <td style="text-align:center;"> 0.32219 </td>
   <td style="text-align:center;"> 0.29553 </td>
   <td style="text-align:center;"> 0.32559 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long2.wav_2-1 </td>
   <td style="text-align:center;"> 0.37639 </td>
   <td style="text-align:center;"> 0.40571 </td>
   <td style="text-align:center;"> 0.40582 </td>
   <td style="text-align:center;"> 0.66489 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.60558 </td>
   <td style="text-align:center;"> 0.62962 </td>
   <td style="text-align:center;"> 0.63864 </td>
   <td style="text-align:center;"> 0.31114 </td>
   <td style="text-align:center;"> 0.27942 </td>
   <td style="text-align:center;"> 0.31345 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_1-1 </td>
   <td style="text-align:center;"> 0.41326 </td>
   <td style="text-align:center;"> 0.40178 </td>
   <td style="text-align:center;"> 0.40634 </td>
   <td style="text-align:center;"> 0.64077 </td>
   <td style="text-align:center;"> 0.60558 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.75517 </td>
   <td style="text-align:center;"> 0.71210 </td>
   <td style="text-align:center;"> 0.30168 </td>
   <td style="text-align:center;"> 0.28201 </td>
   <td style="text-align:center;"> 0.29369 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_2-1 </td>
   <td style="text-align:center;"> 0.36085 </td>
   <td style="text-align:center;"> 0.35871 </td>
   <td style="text-align:center;"> 0.37767 </td>
   <td style="text-align:center;"> 0.64592 </td>
   <td style="text-align:center;"> 0.62962 </td>
   <td style="text-align:center;"> 0.75517 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.73621 </td>
   <td style="text-align:center;"> 0.30238 </td>
   <td style="text-align:center;"> 0.28260 </td>
   <td style="text-align:center;"> 0.29942 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long3.wav_3-1 </td>
   <td style="text-align:center;"> 0.40296 </td>
   <td style="text-align:center;"> 0.40272 </td>
   <td style="text-align:center;"> 0.41297 </td>
   <td style="text-align:center;"> 0.60911 </td>
   <td style="text-align:center;"> 0.63864 </td>
   <td style="text-align:center;"> 0.71210 </td>
   <td style="text-align:center;"> 0.73621 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.30987 </td>
   <td style="text-align:center;"> 0.28622 </td>
   <td style="text-align:center;"> 0.29783 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_1-1 </td>
   <td style="text-align:center;"> 0.31506 </td>
   <td style="text-align:center;"> 0.31016 </td>
   <td style="text-align:center;"> 0.30521 </td>
   <td style="text-align:center;"> 0.32219 </td>
   <td style="text-align:center;"> 0.31114 </td>
   <td style="text-align:center;"> 0.30168 </td>
   <td style="text-align:center;"> 0.30238 </td>
   <td style="text-align:center;"> 0.30987 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.76558 </td>
   <td style="text-align:center;"> 0.75519 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_2-1 </td>
   <td style="text-align:center;"> 0.32050 </td>
   <td style="text-align:center;"> 0.31850 </td>
   <td style="text-align:center;"> 0.30567 </td>
   <td style="text-align:center;"> 0.29553 </td>
   <td style="text-align:center;"> 0.27942 </td>
   <td style="text-align:center;"> 0.28201 </td>
   <td style="text-align:center;"> 0.28260 </td>
   <td style="text-align:center;"> 0.28622 </td>
   <td style="text-align:center;"> 0.76558 </td>
   <td style="text-align:center;"> 1.00000 </td>
   <td style="text-align:center;"> 0.75906 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phae.long4.wav_3-1 </td>
   <td style="text-align:center;"> 0.32054 </td>
   <td style="text-align:center;"> 0.31455 </td>
   <td style="text-align:center;"> 0.32297 </td>
   <td style="text-align:center;"> 0.32559 </td>
   <td style="text-align:center;"> 0.31345 </td>
   <td style="text-align:center;"> 0.29369 </td>
   <td style="text-align:center;"> 0.29942 </td>
   <td style="text-align:center;"> 0.29783 </td>
   <td style="text-align:center;"> 0.75519 </td>
   <td style="text-align:center;"> 0.75906 </td>
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

## Performance

Using *extended_selection_table* objects can improve performance (in our case measured as time). Here we used the [microbenchmark](https://cran.r-project.org/package=microbenchmark) to compare the performance and [ggplot2](https://cran.r-project.org/package=ggplot2) to plot the results. We also need to save the wave files again to be able to run the analysis with regular data frames:


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

# repetitions for each process
reps <- 50

# use the first 100 selection for the long selection tables
mbmrk.snr <- microbenchmark(extended = sig2noise(lng_ext_st[1:100, ], 
      mar = 0.05), regular = sig2noise(lng.selec.table[1:100, ], 
                    mar = 0.05), times = reps)

autoplot(mbmrk.snr) + ggtitle("sig2noise")
{% endhighlight %}

<img src="/assets/Rfig/extn_sel_13-1.png" title="plot of chunk extn_sel_13" alt="plot of chunk extn_sel_13" width="750" />

{% highlight r %}
mbmrk.dtw <- microbenchmark(extended = dfDTW(lng_ext_st[1:100, ], 
          img = FALSE), regular = dfDTW(lng.selec.table[1:100, ], 
                              img = FALSE), times = reps)

autoplot(mbmrk.dtw) + ggtitle("dfDTW")
{% endhighlight %}

<img src="/assets/Rfig/extn_sel_13-2.png" title="plot of chunk extn_sel_13" alt="plot of chunk extn_sel_13" width="750" />

{% highlight r %}
# on the first 20 selections
mbmrk.xc <- microbenchmark(extended = xcorr(lng_ext_st[1:20, ], 
    frange = c(1, 11)), regular = xcorr(lng.selec.table[1:20, ], 
        frange = c(1, 11)), times = reps)

autoplot(mbmrk.xc) + ggtitle("xcorr")
{% endhighlight %}

<img src="/assets/Rfig/extn_sel_13-3.png" title="plot of chunk extn_sel_13" alt="plot of chunk extn_sel_13" width="750" />

The gain in performance is likely to improve when using longer recordings and data sets (i.e. compensate for computing overhead).


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


Again, these objects can also be used for further analysis:


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
 [1] rgl_0.95.1441        Rcpp_0.12.14         mvtnorm_1.0-6        lattice_0.20-35     
 [5] fftw_1.0-4           zoo_1.8-1            rprojroot_1.3-2      digest_0.6.13       
 [9] R6_2.2.2             plyr_1.8.4           Sim.DiffProc_4.0     backports_1.1.2     
[13] signal_0.7-6         evaluate_0.10.1      pracma_2.1.4         httr_1.3.1          
[17] highr_0.6            pillar_1.0.1         rlang_0.1.6          lazyeval_0.2.1      
[21] curl_3.1             multcomp_1.4-8       Matrix_1.2-14        rmarkdown_1.8       
[25] devtools_1.13.4      splines_3.4.4        readr_1.1.1          stringr_1.2.0       
[29] RCurl_1.95-4.10      munsell_0.4.3        proxy_0.4-22         compiler_3.4.4      
[33] Deriv_3.8.4          pkgconfig_2.0.1      htmltools_0.3.6      tibble_1.4.1        
[37] dtw_1.18-1           codetools_0.2-15     viridisLite_0.2.0    withr_2.1.1         
[41] MASS_7.3-49          bitops_1.0-6         grid_3.4.4           gtable_0.2.0        
[45] git2r_0.21.0         magrittr_1.5         scales_0.5.0         stringi_1.1.6       
[49] pbapply_1.3-4        scatterplot3d_0.3-40 xml2_1.2.0           sandwich_2.4-0      
[53] TH.data_1.0-8        rjson_0.2.18         iterators_1.0.9      tools_3.4.4         
[57] hms_0.4.0            jpeg_0.1-8           parallel_3.4.4       survival_2.42-3     
[61] yaml_2.1.16          colorspace_1.3-2     rvest_0.3.2          memoise_1.1.0       
{% endhighlight %}



