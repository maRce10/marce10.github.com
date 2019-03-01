---
layout: post
title: "Working with higher structural levels in vocal signals"
date: 16-02-2019
---



Animal vocalizations can be hierarchically structured: elements group together in syllables, syllables in songs, songs in bouts and so on. Many important biological patterns of vocal variation are better described at higher structural levels, so we are often interested in characterizing vocalizations at those levels. There are several tools in [warbleR](https://cran.r-project.org/package=warbleR) to explore and measure features above the element level. For simplicity, any level above 'elements' will be refered to as 'songs' in this post as well as in the [warbleR](https://cran.r-project.org/package=warbleR) functions described here.
  

We will work on a recording from a [Scale-throated Hermit (hummingbird) (*Phaethornis eurynome*)](https://www.xeno-canto.org/species/Phaethornis-eurynome):

<img src="/./img/Phaethornis-eurynome-15607-p1.jpeg" title="plot of chunk song 1" alt="plot of chunk song 1" width="900px" style="display: block; margin: auto;" />

<iframe src='https://www.xeno-canto.org/15607/embed?simple=1' scrolling='no' frameborder='0' width='900' height='150'></iframe>


It has a very simple song with a couple of elements. The code for selecting elements and adding labels (creating the 'pe_st' selection table) is found at the end of the post. For now it's enough to say that the only extra feature in 'pe_st' is a couple of columns containing the element and song labels. 

We can make spectrograms of the full recording with boxes on the elements and orange lines above the elements highlighting those that belong to the same song. This can be done using the 'song' argument in [lspec](https://marce10.github.io/warbleR/reference/lspec.html). The argument simply takes the name of the column with the song labels:


{% highlight r %}
# load warbleR 
library(warbleR)

# set warbleR global parameters
warbleR_options(flim = c(2.5, 14), wl = 200, ovlp = 90)

# create spetrogram of the whole recording
lspec(pe_st, sxrow = 2.5, rows = 7, fast.spec = TRUE, 
      horizontal = TRUE, song = "song")
{% endhighlight %}

<img src="/./img/Phaethornis-eurynome-15607-labeled.jpeg" title="plot of chunk songs 2.3" alt="plot of chunk songs 2.3" width="900px" style="display: block; margin: auto;" />


We can plot single spectrograms of each song using the 'song' argument in [specreator](https://marce10.github.io/warbleR/reference/specreator.html). The function will label each element using the 'selec' column label:
 

{% highlight r %}
specreator(pe_st, by.song = "song")
{% endhighlight %}
 
<img src="/./img/Phaethornis-eurynome-15607.wav-3.jpeg" title="plot of chunk songs 3" alt="plot of chunk songs 3" style="display: block; margin: auto;" />
 
The function then makes a single spectrogram per song instead of one per element as is the case when no song column is declared.

We can also use our own labels on the elements. In this case the column 'elm' has the labels I used to classified the 2 elements in the song:


{% highlight r %}
specreator(pe_st, by.song = "song", sel.labels = "elm")
{% endhighlight %}

<img src="/./img/Phaethornis-eurynome-15607.wav-3-labeled.jpeg" title="plot of chunk songs 5" alt="plot of chunk songs 5" style="display: block; margin: auto;" />

Song features can be measured using [song_param](https://marce10.github.io/warbleR/reference/song_param.html). The function calculates several descriptive features of songs, including start and end time, top and bottom frequency (the lowest bottom and highest top frequency of all elements), mean element duration, song duration, number of elements, frequency range, song rate (elements per second) and gap duration:



{% highlight r %}
song_feat <- song_param(pe_st, song_colm = "song")

head(song_feat)
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:740px;  font-size: 12px; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> top.freq </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> song </th>
   <th style="text-align:center;"> num.elms </th>
   <th style="text-align:center;"> elm.duration </th>
   <th style="text-align:center;"> freq.range </th>
   <th style="text-align:center;"> song.duration </th>
   <th style="text-align:center;"> song.rate </th>
   <th style="text-align:center;"> gap.duration </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.773606 </td>
   <td style="text-align:center;"> 1.151724 </td>
   <td style="text-align:center;"> 9.15075 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1766441 </td>
   <td style="text-align:center;"> 6.17400 </td>
   <td style="text-align:center;"> 0.3781182 </td>
   <td style="text-align:center;"> 5.289352 </td>
   <td style="text-align:center;"> 0.0248299 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.807666 </td>
   <td style="text-align:center;"> 3.184560 </td>
   <td style="text-align:center;"> 10.00000 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1760545 </td>
   <td style="text-align:center;"> 7.02325 </td>
   <td style="text-align:center;"> 0.3768937 </td>
   <td style="text-align:center;"> 5.306536 </td>
   <td style="text-align:center;"> 0.0247846 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.200887 </td>
   <td style="text-align:center;"> 4.571976 </td>
   <td style="text-align:center;"> 10.00000 </td>
   <td style="text-align:center;"> 3.19725 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1761566 </td>
   <td style="text-align:center;"> 6.80275 </td>
   <td style="text-align:center;"> 0.3710887 </td>
   <td style="text-align:center;"> 5.389547 </td>
   <td style="text-align:center;"> 0.0187755 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.966239 </td>
   <td style="text-align:center;"> 5.344562 </td>
   <td style="text-align:center;"> 9.81225 </td>
   <td style="text-align:center;"> 3.19725 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1829026 </td>
   <td style="text-align:center;"> 6.61500 </td>
   <td style="text-align:center;"> 0.3783223 </td>
   <td style="text-align:center;"> 5.286498 </td>
   <td style="text-align:center;"> 0.0125170 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 5.956716 </td>
   <td style="text-align:center;"> 6.323474 </td>
   <td style="text-align:center;"> 10.00000 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1615874 </td>
   <td style="text-align:center;"> 7.02325 </td>
   <td style="text-align:center;"> 0.3667576 </td>
   <td style="text-align:center;"> 5.453193 </td>
   <td style="text-align:center;"> 0.0435828 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 7.424245 </td>
   <td style="text-align:center;"> 7.796151 </td>
   <td style="text-align:center;"> 8.93025 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1591724 </td>
   <td style="text-align:center;"> 5.51250 </td>
   <td style="text-align:center;"> 0.3719050 </td>
   <td style="text-align:center;"> 5.377717 </td>
   <td style="text-align:center;"> 0.0535601 </td>
  </tr>
</tbody>
</table></div>

If the element label column is supplied the function will also return the number of unique element types ('elm.types' column) and the mean number of times element types are found in a song ('mean.elm.count'):


{% highlight r %}
song_feat <- song_param(pe_st, song_colm = "song", elm_colm = "elm")

# look at data, exclude some columns just for visualization
head(song_feat[, -c(2:6)])
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:740px;  font-size: 12px; width: auto !important; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> elm.duration </th>
   <th style="text-align:center;"> freq.range </th>
   <th style="text-align:center;"> song.duration </th>
   <th style="text-align:center;"> song.rate </th>
   <th style="text-align:center;"> gap.duration </th>
   <th style="text-align:center;"> elm.types </th>
   <th style="text-align:center;"> mean.elm.count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 0.1766441 </td>
   <td style="text-align:center;"> 6.17400 </td>
   <td style="text-align:center;"> 0.3781182 </td>
   <td style="text-align:center;"> 5.289352 </td>
   <td style="text-align:center;"> 0.0248299 </td>
   <td style="text-align:center;background-color: #ccebff;"> 2 </td>
   <td style="text-align:center;background-color: #ccebff;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 0.1760545 </td>
   <td style="text-align:center;"> 7.02325 </td>
   <td style="text-align:center;"> 0.3768937 </td>
   <td style="text-align:center;"> 5.306536 </td>
   <td style="text-align:center;"> 0.0247846 </td>
   <td style="text-align:center;background-color: #ccebff;"> 2 </td>
   <td style="text-align:center;background-color: #ccebff;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 0.1761566 </td>
   <td style="text-align:center;"> 6.80275 </td>
   <td style="text-align:center;"> 0.3710887 </td>
   <td style="text-align:center;"> 5.389547 </td>
   <td style="text-align:center;"> 0.0187755 </td>
   <td style="text-align:center;background-color: #ccebff;"> 2 </td>
   <td style="text-align:center;background-color: #ccebff;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 0.1829026 </td>
   <td style="text-align:center;"> 6.61500 </td>
   <td style="text-align:center;"> 0.3783223 </td>
   <td style="text-align:center;"> 5.286498 </td>
   <td style="text-align:center;"> 0.0125170 </td>
   <td style="text-align:center;background-color: #ccebff;"> 2 </td>
   <td style="text-align:center;background-color: #ccebff;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 0.1615874 </td>
   <td style="text-align:center;"> 7.02325 </td>
   <td style="text-align:center;"> 0.3667576 </td>
   <td style="text-align:center;"> 5.453193 </td>
   <td style="text-align:center;"> 0.0435828 </td>
   <td style="text-align:center;background-color: #ccebff;"> 2 </td>
   <td style="text-align:center;background-color: #ccebff;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 0.1591724 </td>
   <td style="text-align:center;"> 5.51250 </td>
   <td style="text-align:center;"> 0.3719050 </td>
   <td style="text-align:center;"> 5.377717 </td>
   <td style="text-align:center;"> 0.0535601 </td>
   <td style="text-align:center;background-color: #ccebff;"> 2 </td>
   <td style="text-align:center;background-color: #ccebff;"> 1 </td>
  </tr>
</tbody>
</table></div>

And if spectral parameters have been measured on the elements they can also be averaged by song as follows:


{% highlight r %}
# measure acoustic parameters
elm_sp <- specan(pe_st)

# add song data
elm_sp <- merge(elm_sp[ , -c(3:4)], pe_st, by = c("sound.files", "selec"))

# calculate mean kurtosis and entropy
song_feat <- song_param(X = elm_sp, song_colm = "song", 
                        mean_colm = c("kurt", "sp.ent"))

# look at data
head(song_feat)
{% endhighlight %}

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:740px;  font-size: 12px; width: auto !important; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> top.freq </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> song </th>
   <th style="text-align:center;"> kurt </th>
   <th style="text-align:center;"> sp.ent </th>
   <th style="text-align:center;"> num.elms </th>
   <th style="text-align:center;"> elm.duration </th>
   <th style="text-align:center;"> freq.range </th>
   <th style="text-align:center;"> song.duration </th>
   <th style="text-align:center;"> song.rate </th>
   <th style="text-align:center;"> gap.duration </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.773606 </td>
   <td style="text-align:center;"> 1.151724 </td>
   <td style="text-align:center;"> 9.15075 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;background-color: #ccebff;"> 9.431925 </td>
   <td style="text-align:center;background-color: #ccebff;"> 0.9259725 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1766441 </td>
   <td style="text-align:center;"> 6.17400 </td>
   <td style="text-align:center;"> 0.3781182 </td>
   <td style="text-align:center;"> 5.289352 </td>
   <td style="text-align:center;"> 0.0248299 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 5.956716 </td>
   <td style="text-align:center;"> 6.323474 </td>
   <td style="text-align:center;"> 10.00000 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;background-color: #ccebff;"> 5.903726 </td>
   <td style="text-align:center;background-color: #ccebff;"> 0.9283246 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1615874 </td>
   <td style="text-align:center;"> 7.02325 </td>
   <td style="text-align:center;"> 0.3667576 </td>
   <td style="text-align:center;"> 5.453193 </td>
   <td style="text-align:center;"> -0.3667576 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 7.424245 </td>
   <td style="text-align:center;"> 7.796151 </td>
   <td style="text-align:center;"> 8.93025 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;background-color: #ccebff;"> 10.269098 </td>
   <td style="text-align:center;background-color: #ccebff;"> 0.9192882 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1591724 </td>
   <td style="text-align:center;"> 5.51250 </td>
   <td style="text-align:center;"> 0.3719050 </td>
   <td style="text-align:center;"> 5.377717 </td>
   <td style="text-align:center;"> 0.0535601 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 8.851344 </td>
   <td style="text-align:center;"> 9.218011 </td>
   <td style="text-align:center;"> 9.37125 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;background-color: #ccebff;"> 5.396240 </td>
   <td style="text-align:center;background-color: #ccebff;"> 0.9283730 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1539684 </td>
   <td style="text-align:center;"> 5.95350 </td>
   <td style="text-align:center;"> 0.3666669 </td>
   <td style="text-align:center;"> 5.454542 </td>
   <td style="text-align:center;"> 0.0587302 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 10.932547 </td>
   <td style="text-align:center;"> 11.307672 </td>
   <td style="text-align:center;"> 8.70975 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;background-color: #ccebff;"> 8.002969 </td>
   <td style="text-align:center;background-color: #ccebff;"> 0.9225578 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1724491 </td>
   <td style="text-align:center;"> 5.29200 </td>
   <td style="text-align:center;"> 0.3751250 </td>
   <td style="text-align:center;"> 5.331556 </td>
   <td style="text-align:center;"> 0.0302268 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 12.159691 </td>
   <td style="text-align:center;"> 12.539737 </td>
   <td style="text-align:center;"> 8.93025 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;background-color: #ccebff;"> 7.194692 </td>
   <td style="text-align:center;background-color: #ccebff;"> 0.9294223 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1790704 </td>
   <td style="text-align:center;"> 5.51250 </td>
   <td style="text-align:center;"> 0.3800456 </td>
   <td style="text-align:center;"> 5.262526 </td>
   <td style="text-align:center;"> 0.0219048 </td>
  </tr>
</tbody>
</table></div>

The minimum, maximum and standard error can also be returned using the 'min_colm', 'max_colm' and 'sd' arguments respectively.

Given that the start, end bottom and top frequency are returned by [song_param](https://marce10.github.io/warbleR/reference/song_param.html), then the output can be used as a selection table to measure or compare the songs themselves, rather than the elements. For instance, we can run cross-correlation between songs, perhaps as a metric of song consistency, as follows:


{% highlight r %}
# calculate mean kurtosis and entropy
song_feat <- song_param(X = elm_sp, song_colm = "song")

# run cross correlation using the first 10 songs
xc <- xcorr(song_feat[1:10, ])

head(xc)
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:740px;  font-size: 12px; width: auto !important; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
   <th style="text-align:center;"> Phaethornis-eurynome-15607.wav-1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.8157989 </td>
   <td style="text-align:center;"> 0.8028429 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.8157989 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.7995524 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.8157989 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8164737 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.8157989 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8157989 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8164737 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.7995524 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.8480690 </td>
   <td style="text-align:center;"> 0.7393546 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.8157989 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.8157989 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 0.8249025 </td>
   <td style="text-align:center;"> 0.8445801 </td>
   <td style="text-align:center;"> 0.7438566 </td>
   <td style="text-align:center;"> 1.0000000 </td>
   <td style="text-align:center;"> 0.8028429 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Phaethornis-eurynome-15607.wav-1 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 0.8157989 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.8157989 </td>
   <td style="text-align:center;"> 0.8164737 </td>
   <td style="text-align:center;"> 0.7995524 </td>
   <td style="text-align:center;"> 0.8157989 </td>
   <td style="text-align:center;"> 0.8028429 </td>
   <td style="text-align:center;"> 1.0000000 </td>
  </tr>
</tbody>
</table></div>

Finally, extended selection tables, which are objects containing both annotations and acoustic data ([see this post](https://marce10.github.io/2018/05/15/Extended_selection_tables.html)), can be created at the song level. This means that all elements in a song will be contained in a single wave object within the selection table. This enables users to take song level metrics as those described above using this type of objects (this is not possible when creating them based on elements, which is the default behavior).   

The song level extended selection table can be created using the argument 'by.song', which takes the song label column, as follows:


{% highlight r %}
# create extended selection table
pe_est <- selection_table(pe_st, extended = TRUE, 
              confirm.extended = FALSE, by.song = "song")

pe_est
{% endhighlight %}


{% highlight text %}
## all selections are OK
{% endhighlight %}



{% highlight text %}
## object of class 'extended_selection_table' 
##  contains a selection table data frame with 46 rows and 8 columns: 
##                             sound.files selec     start       end
## 1 Phaethornis-eurynome-15607.wav-song_1     1 0.1000000 0.2779820
## 2 Phaethornis-eurynome-15607.wav-song_1     2 0.3028119 0.4781182
## 3 Phaethornis-eurynome-15607.wav-song_2     1 0.1000000 0.2761906
## 4 Phaethornis-eurynome-15607.wav-song_2     2 0.3009752 0.4768937
## 5 Phaethornis-eurynome-15607.wav-song_3     1 0.1000000 0.2809979
## 6 Phaethornis-eurynome-15607.wav-song_3     2 0.2997734 0.4710887
##   bottom.freq top.freq song elm
## 1     4.07925  8.48925    1   a
## 2     2.97675  9.15075    1   b
## 3     4.29975  6.94575    2   a
## 4     2.97675 10.00000    2   b
## 5     4.07925  6.94575    3   a
## 6     3.19725 10.00000    3   b
## ... and 40 more rows 
## 23 wave objects (as attributes): 
## [1] "Phaethornis-eurynome-15607.wav-song_1"
## [2] "Phaethornis-eurynome-15607.wav-song_2"
## [3] "Phaethornis-eurynome-15607.wav-song_3"
## [4] "Phaethornis-eurynome-15607.wav-song_4"
## [5] "Phaethornis-eurynome-15607.wav-song_5"
## [6] "Phaethornis-eurynome-15607.wav-song_6"
## ... and 17 more 
## and a data frame (check.results) generated by checkres() (as attribute) 
## the selection table was created by song (see 'class_extended_selection_table')
{% endhighlight %}



It has 23 wave objects, 1 for each song.

Now we can measure things on songs without having to keep the original sound file. The following code deletes the sound file and measures song level parameters using the extended selection table:


{% highlight r %}
# delete sound file
unlink("Phaethornis-eurynome-15607.wav")

# measure song features
song_feat <- song_param(pe_est, song_colm = "song")
{% endhighlight %}


<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:740px;  font-size: 12px; width: auto !important; margin-left: auto; margin-right: auto;" class="table table-striped"><table>
 <thead>
  <tr>
   <th style="text-align:center;"> sound.files </th>
   <th style="text-align:center;"> selec </th>
   <th style="text-align:center;"> start </th>
   <th style="text-align:center;"> end </th>
   <th style="text-align:center;"> top.freq </th>
   <th style="text-align:center;"> bottom.freq </th>
   <th style="text-align:center;"> song </th>
   <th style="text-align:center;"> num.elms </th>
   <th style="text-align:center;"> elm.duration </th>
   <th style="text-align:center;"> freq.range </th>
   <th style="text-align:center;"> song.duration </th>
   <th style="text-align:center;"> song.rate </th>
   <th style="text-align:center;"> gap.duration </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0.773606 </td>
   <td style="text-align:center;"> 1.151724 </td>
   <td style="text-align:center;"> 9.15075 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1766441 </td>
   <td style="text-align:center;"> 6.17400 </td>
   <td style="text-align:center;"> 0.3781182 </td>
   <td style="text-align:center;"> 5.289352 </td>
   <td style="text-align:center;"> 0.0248299 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 2.807666 </td>
   <td style="text-align:center;"> 3.184560 </td>
   <td style="text-align:center;"> 10.00000 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1760545 </td>
   <td style="text-align:center;"> 7.02325 </td>
   <td style="text-align:center;"> 0.3768937 </td>
   <td style="text-align:center;"> 5.306536 </td>
   <td style="text-align:center;"> 0.0247846 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.200887 </td>
   <td style="text-align:center;"> 4.571976 </td>
   <td style="text-align:center;"> 10.00000 </td>
   <td style="text-align:center;"> 3.19725 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1761566 </td>
   <td style="text-align:center;"> 6.80275 </td>
   <td style="text-align:center;"> 0.3710887 </td>
   <td style="text-align:center;"> 5.389547 </td>
   <td style="text-align:center;"> 0.0187755 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 4.966239 </td>
   <td style="text-align:center;"> 5.344562 </td>
   <td style="text-align:center;"> 9.81225 </td>
   <td style="text-align:center;"> 3.19725 </td>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1829026 </td>
   <td style="text-align:center;"> 6.61500 </td>
   <td style="text-align:center;"> 0.3783223 </td>
   <td style="text-align:center;"> 5.286498 </td>
   <td style="text-align:center;"> 0.0125170 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 5.956716 </td>
   <td style="text-align:center;"> 6.323474 </td>
   <td style="text-align:center;"> 10.00000 </td>
   <td style="text-align:center;"> 2.97675 </td>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1615874 </td>
   <td style="text-align:center;"> 7.02325 </td>
   <td style="text-align:center;"> 0.3667576 </td>
   <td style="text-align:center;"> 5.453193 </td>
   <td style="text-align:center;"> 0.0435828 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Phaethornis-eurynome-15607.wav </td>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 7.424245 </td>
   <td style="text-align:center;"> 7.796151 </td>
   <td style="text-align:center;"> 8.93025 </td>
   <td style="text-align:center;"> 3.41775 </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0.1591724 </td>
   <td style="text-align:center;"> 5.51250 </td>
   <td style="text-align:center;"> 0.3719050 </td>
   <td style="text-align:center;"> 5.377717 </td>
   <td style="text-align:center;"> 0.0535601 </td>
  </tr>
</tbody>
</table></div>
That's it! 

<font size="4">Creating example data</font>


{% highlight r %}
# load warbleR 
library(warbleR)

# set warbleR options
warbleR_options(bp =  c(2, 8), flim = c(2.5, 14), wl = 200, 
                ovlp = 90)

# set temporary working directory
 setwd(tempdir())

# Query and download  Xeno-Canto for metadata catalog id
out <- quer_xc(qword = "nr:15607", download = TRUE)

# Convert mp3 to wav format
mp32wav(samp.rate = 44.1)

# detect signals in time
ad <- auto_detec(wl = 200, threshold = 5, ssmooth = 1200, 
                 bp = c(2.5, 8), mindur = 0.05, 
                 maxdur = 0.25, img = FALSE)

# get frequency range
fr_ad <- freq_range(X = ad, bp = c(2, 10), fsmooth = 0.001, 
                    ovlp = 95, wl = 200, threshold = 20, 
                    img = FALSE, impute = TRUE)

# add song label column
fr_ad$song <- rep(1:(nrow(fr_ad) / 2), each = 2)

# add element label column
fr_ad$elm <- rep(c("a", "b"), nrow(fr_ad) / 2)

# create selection table (not mandatory but advice)
pe_st <- selection_table(fr_ad, extended = FALSE)

# create the first spectrogram in the post
lspec(pe_st, sxrow = 2.5, rows = 7, fast.spec = TRUE, 
      horizontal = TRUE, song = "song")
{% endhighlight %}



---


<font size="4"><b>Session information</b></font>


{% highlight text %}
## R version 3.5.1 (2018-07-02)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 18.10
## 
## Matrix products: default
## BLAS: /usr/lib/x86_64-linux-gnu/openblas/libblas.so.3
## LAPACK: /usr/lib/x86_64-linux-gnu/libopenblasp-r0.3.3.so
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] kableExtra_0.9.0   warbleR_1.1.16     NatureSounds_1.0.1
## [4] seewave_2.1.0      tuneR_1.3.3        maps_3.3.0        
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.0        pracma_2.2.2      highr_0.7        
##  [4] compiler_3.5.1    pillar_1.3.0      bitops_1.0-6     
##  [7] iterators_1.0.10  tools_3.5.1       Sim.DiffProc_4.3 
## [10] digest_0.6.18     viridisLite_0.3.0 evaluate_0.12    
## [13] tibble_1.4.2      fftw_1.0-4        pkgconfig_2.0.2  
## [16] rlang_0.3.1       rstudioapi_0.9.0  yaml_2.2.0       
## [19] parallel_3.5.1    xml2_1.2.0        httr_1.4.0       
## [22] stringr_1.3.1     knitr_1.20        hms_0.4.2        
## [25] rprojroot_1.3-2   R6_2.3.0          dtw_1.20-1       
## [28] jpeg_0.1-8        pbapply_1.4-0     rmarkdown_1.10   
## [31] soundgen_1.3.2    readr_1.3.1       magrittr_1.5     
## [34] scales_1.0.0      backports_1.1.3   htmltools_0.3.6  
## [37] MASS_7.3-50       rvest_0.3.2       colorspace_1.3-2 
## [40] Deriv_3.8.5       stringi_1.2.4     proxy_0.4-22     
## [43] munsell_0.5.0     signal_0.7-6      RCurl_1.95-4.11  
## [46] crayon_1.3.4      rjson_0.2.20
{% endhighlight %}

