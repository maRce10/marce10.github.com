---
layout: post
title: "Download a single recording for each species in a country from Xeno-Canto"
date: 22-12-2016
---

A [warbleR](https://cran.r-project.org/package=warbleR) user asks if "there is any method for downloading from xeno canto a SINGLE individual of each species in Costa Rica".

This can be done by 1) downloading the metadata of all recordings in a given site (in this case Costa Rica) using the `querxc` function from the package [warbleR](https://cran.r-project.org/package=warbleR) (which searches and downloads recordings from [Xeno-Canto](http://www.xeno-canto.org)), 2) filtering the metadata to have only one recording per species, and 3) input the filtered metadata back into `querxc`to download the selected recordings.

You will need [warbleR](https://cran.r-project.org/package=warbleR) version 1.1.5 or higher to be able to run this code (currently you have to download it from github using the package [devtools](https://cran.r-project.org/package=devtools)).


{% highlight r %}
#run it only if devtools isn't installed
install.packages("devtools")

devtools::install_github("maRce10/warbleR")
require("warbleR")
{% endhighlight %}




then search for all recordings in Costa Rica setting the download argument to `FALSE` to obtain only the metadata. Note that the search term follows the xeno-canto advanced query syntax. This syntax uses tags to search within a particular aspect of the recordings (e.g. country, location, sound type). Tags are of the form tag:searchterm'. See [http://www.xeno-canto.org/help/search](http://www.xeno-canto.org/help/search) for a full description. (Note that in `querxc` you can also search for species names or families without using any tags)


{% highlight r %}
CR.recs <- querxc(qword = 'cnt:"costa rica"', download = FALSE)
{% endhighlight %}



This query returned more than 38000 recordings from ~518 species (at the time I am writing this post)


{% highlight r %}
#number of recordings
nrow(CR.recs)
{% endhighlight %}



{% highlight text %}
## [1] 3874
{% endhighlight %}



{% highlight r %}
#number of songs
length(unique(CR.recs$English_name))
{% endhighlight %}



{% highlight text %}
## [1] 520
{% endhighlight %}

Now filter the metadata. First split the data in 'songs' and 'other sounds' (possibly calls) and then select a single recording for each species. Sort the metadata by recording quality before filtering so the best quality recordings are found higher up in the list (which ensures that selected recordings are the highest quality recordings for each species)


{% highlight r %}
#order by quality
CR.recs <- CR.recs[order(order(match(CR.recs$Quality, 
                c("A", "B", "C", "D", "E", "no score")))),]


#subset in song and no-songs
CR.songs <- CR.recs[grep("song", CR.recs$Vocalization_type, ignore.case = T),]
CR.no.songs <- CR.recs[grep("song", 
                      CR.recs$Vocalization_type, ignore.case = T, invert = T),]


#remove duplicates by species
CR.songs <- CR.songs[!duplicated(CR.songs$English_name),]
CR.no.songs <- CR.no.songs[!duplicated(CR.no.songs$English_name),]
{% endhighlight %}

We ended up with songs from 379 species and no-songs from 420 species


{% highlight r %}
#number of species with songs
nrow(CR.songs)
{% endhighlight %}



{% highlight text %}
## [1] 380
{% endhighlight %}



{% highlight r %}
#number of species with other sounds
nrow(CR.no.songs)
{% endhighlight %}



{% highlight text %}
## [1] 424
{% endhighlight %}

To download the files just input the filtered metadata back into `querxc` (this will probably take several minutes!)


{% highlight r %}
querxc(X = CR.songs)

#in case you want to download other sounds
querxc(X = CR.no.songs)
{% endhighlight %}


I would rather download no-songs only for those species that have no song in Xeno-Canto. To do this simply remove the species with songs from the 'no-song' data


{% highlight r %}
CR.no.songs2 <- CR.no.songs[!CR.no.songs$English_name %in% CR.songs$English_name, ]

querxc(X = CR.no.songs2)
{% endhighlight %}

That's it!
