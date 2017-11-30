---
layout: post
title: "Rraven: Connecting R and Raven Sound Analysis Software"
date: 30-11-2017
---


 &nbsp; 

The `Rraven` package is designed to facilitate the exchange of data between R and  [Raven sound analysis software](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) ([Cornell Lab of Ornithology](http://www.birds.cornell.edu)). [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) provides very  powerful tools for the analysis of (animal) sounds. R can simplify the automatization of complex routines of analyses. Furthermore, R packages as [warbleR](https://cran.r-project.org/package=warbleR), [seewave](https://cran.r-project.org/package=seewave) and [monitoR](https://cran.r-project.org/package=monitoR) (among others) provide additional methods of analysis, working as a perfect complement for those found in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html). Hence, bridging these applications can largely expand the bioacoustician's toolkit.

Currently, most analyses in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) cannot be run in the background from a command terminal. Thus, most `Rraven` functions are design to simplify the exchange of data between the two programs, and in some cases, export files to  [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) for further analysis. This vignette provides detailed examples for each function in `Rraven`, including both the R code as well as the additional steps in [Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) required to fully accomplished the analyses. Raven Pro must be installed to be able to run some of the code.

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
 #providing the name of the column with the sound file names
rvn.dat <- imp_raven(all.data = TRUE)

head(rvn.dat)
{% endhighlight %}


| Selection |     View      | Channel | Begin.Time..s. | End.Time..s. |
|:---------:|:-------------:|:-------:|:--------------:|:------------:|
|     1     | Spectrogram 1 |    1    |   1.1693549    |  1.3423884   |
|     2     | Spectrogram 1 |    1    |   2.1584085    |  2.3214565   |
|     3     | Spectrogram 1 |    1    |   0.3433366    |  0.5182553   |
|     1     | Spectrogram 1 |    1    |   0.1595983    |  0.2921692   |
|     2     | Spectrogram 1 |    1    |   1.4570585    |  1.5832087   |
|     1     | Spectrogram 1 |    1    |   0.6265520    |  0.7577715   |



| Low.Freq..Hz. | High.Freq..Hz. |   Begin.File   | channel |           Begin.Path           | File.Offset |            selec.file             |
|:-------------:|:--------------:|:--------------:|:-------:|:------------------------------:|:-----------:|:---------------------------------:|
|   2220.105    |    8604.378    | Phae.long1.wav |    1    | /tmp/RtmpWpOeaR/Phae.long1.wav |  1.1693549  | LBH 1 selection table example.txt |
|   2169.437    |    8807.053    | Phae.long1.wav |    1    | /tmp/RtmpWpOeaR/Phae.long1.wav |  2.1584085  | LBH 1 selection table example.txt |
|   2218.294    |    8756.604    | Phae.long1.wav |    1    | /tmp/RtmpWpOeaR/Phae.long1.wav |  0.3433366  | LBH 1 selection table example.txt |
|   2316.862    |    8822.316    | Phae.long2.wav |    1    | /tmp/RtmpWpOeaR/Phae.long2.wav |  0.1595983  | LBH 2 selection table example.txt |
|   2284.006    |    8888.027    | Phae.long2.wav |    1    | /tmp/RtmpWpOeaR/Phae.long2.wav |  1.4570585  | LBH 2 selection table example.txt |
|   3006.834    |    8822.316    | Phae.long3.wav |    1    | /tmp/RtmpWpOeaR/Phae.long3.wav |  0.6265520  | LBH 3 selection table example.txt |
 &nbsp; 
 
Note that the 'waveform' view data has been removed. It can also be imported as follows: 


{% highlight r %}
rvn.dat <- imp_raven(all.data = TRUE, waveform = TRUE)

head(rvn.dat)
{% endhighlight %}


 &nbsp; 
 
[Raven](http://www.birds.cornell.edu/brp/raven/RavenOverview.html) selections can also be imported in a 'selection.table' format so it can be directly input into [warbleR](https://cran.r-project.org/package=warbleR) functions. To do this you need to set the `all.data = FALSE` and indicate which column contains the sound file name (using the 'sound.file.col' argument): 


{% highlight r %}
 #providing the name of the column with the sound file names
rvn.dat <- imp_raven(sound.file.col = "End.File", all.data = FALSE, freq.cols = TRUE)

head(rvn.dat)
{% endhighlight %}


|  sound.files   | channel.Channel | channel.channel | selec |   start   |    end    |            selec.file             | bottom.freq | top.freq |
|:--------------:|:---------------:|:---------------:|:-----:|:---------:|:---------:|:---------------------------------:|:-----------:|:--------:|
| Phae.long1.wav |        1        |        1        |   1   | 1.1693549 | 1.3423884 | LBH 1 selection table example.txt |  2.220105   | 8.604378 |
| Phae.long1.wav |        1        |        1        |   2   | 2.1584085 | 2.3214565 | LBH 1 selection table example.txt |  2.169437   | 8.807053 |
| Phae.long1.wav |        1        |        1        |   3   | 0.3433366 | 0.5182553 | LBH 1 selection table example.txt |  2.218294   | 8.756604 |
| Phae.long2.wav |        1        |        1        |   1   | 0.1595983 | 0.2921692 | LBH 2 selection table example.txt |  2.316862   | 8.822316 |
| Phae.long2.wav |        1        |        1        |   2   | 1.4570585 | 1.5832087 | LBH 2 selection table example.txt |  2.284006   | 8.888027 |
| Phae.long3.wav |        1        |        1        |   1   | 0.6265520 | 0.7577715 | LBH 3 selection table example.txt |  3.006834   | 8.822316 |
 &nbsp; 
 
The data frame contains the following columns: sound.files, channel, selec, start, end, and selec.file. You can also import the frequency range parameters in the 'selection.table' by setting 'freq.cols' tp `TRUE`. The data frame returned by "imp_raven" (when in the 'warbleR' format) can be input into several [warbleR](https://cran.r-project.org/package=warbleR) functions for further analysis. For instance, the following code runs additional parameter measurements on the imported selections:


{% highlight r %}
# convert to class selection.table
rvn.dat.st <- make.selection.table(rvn.dat)

sp <- specan(X = rvn.dat, bp = "frange", wl = 150, pb = FALSE, ovlp = 90)

head(sp)
{% endhighlight %}


|  sound.files   | selec | duration  | meanfreq |    sd    | freq.median |
|:--------------:|:-----:|:---------:|:--------:|:--------:|:-----------:|
| Phae.long1.wav |   1   | 0.1730334 | 5.982350 | 1.399687 |  6.331716   |
| Phae.long1.wav |   2   | 0.1630480 | 5.997299 | 1.422930 |  6.212125   |
| Phae.long1.wav |   3   | 0.1749187 | 6.020600 | 1.515536 |  6.428439   |
| Phae.long2.wav |   1   | 0.1325709 | 6.398304 | 1.340412 |  6.595971   |
| Phae.long2.wav |   2   | 0.1261502 | 6.311837 | 1.370040 |  6.602020   |
| Phae.long3.wav |   1   | 0.1312195 | 6.612400 | 1.093120 |  6.670130   |



| freq.median | freq.Q25 | freq.Q75 | freq.IQR | time.median | time.Q25  | time.Q75  | time.IQR  |   skew   |   kurt    |
|:-----------:|:--------:|:--------:|:--------:|:-----------:|:---------:|:---------:|:---------:|:--------:|:---------:|
|  6.331716   | 5.296584 | 6.869521 | 1.572937 |  0.0764552  | 0.0465681 | 0.1174629 | 0.0708948 | 1.998039 | 7.021565  |
|  6.212125   | 5.328746 | 6.880795 | 1.552049 |  0.0766553  | 0.0439026 | 0.1156798 | 0.0717772 | 1.918356 | 7.334323  |
|  6.428439   | 5.152811 | 6.983309 | 1.830498 |  0.0902434  | 0.0534519 | 0.1277291 | 0.0742772 | 2.495361 | 11.139125 |
|  6.595971   | 5.607323 | 7.380852 | 1.773529 |  0.0768669  | 0.0543005 | 0.1036645 | 0.0493641 | 1.568523 | 6.016392  |
|  6.602020   | 5.609829 | 7.213209 | 1.603380 |  0.0761028  | 0.0528492 | 0.0979471 | 0.0450980 | 2.468996 | 10.884349 |
|  6.670130   | 6.067212 | 7.349366 | 1.282153 |  0.0635054  | 0.0430425 | 0.0896131 | 0.0465706 | 1.773688 | 6.626019  |
 &nbsp; 


And this code creates song catalogs:


{% highlight r %}
catalog(X = rvn.dat.st[1:9, ], flim = c(1, 10), nrow = 3, ncol = 3, same.time.scale = F,
 ovlp = 90, parallel = 1, mar = 0.01, wl = 200, pal = reverse.heat.colors, width = 20,  labels = c("sound.files", "selec"), legend = 1, 
 tag.pal = list(terrain.colors), tags = "sound.files")
{% endhighlight %}

![catalog](Catalog.jpeg)
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


|  sound.files   | selec | P.F.1  | P.F.2  | P.F.3  | P.F.4  | P.F.5  | P.F.6  | P.F.7  | P.F.8  | P.F.9  | P.F.10 | P.F.11 | P.F.12 |
|:--------------:|:-----:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|
| Phae.long1.wav |   1   | 6943.4 | 7119.1 | 7294.9 | 7294.9 | 7294.9 | 7382.8 | 7470.7 | 7646.5 | 5185.5 | 5273.4 | 5361.3 | 5449.2 |
| Phae.long1.wav |   2   | 6767.6 | 6943.4 | 7207.0 | 7207.0 | 7294.9 | 7382.8 | 7470.7 | 7558.6 | 7558.6 | 7646.5 | 5185.5 | 5361.3 |
| Phae.long1.wav |   3   | 6943.4 | 4746.1 | 7119.1 | 4834.0 | 7207.0 | 4921.9 | 4921.9 | 7558.6 | 7646.5 | 7734.4 | 7998.0 | 8085.9 |
| Phae.long2.wav |   4   | 5888.7 | 6503.9 | 4570.3 | 4834.0 | 5185.5 | 5537.1 | 5537.1 | 5800.8 | 6503.9 | 3779.3 | 6240.2 | 6328.1 |
| Phae.long2.wav |   5   | 4570.3 | 4746.1 | 4921.9 | 5097.7 | 5097.7 | 5185.5 | 5800.8 | 5712.9 | 5888.7 | 5976.6 | 6064.5 | 6064.5 |
| Phae.long3.wav |   6   | 4218.8 | 6240.2 | 6591.8 | 6679.7 | 7119.1 | 5009.8 | 5800.8 | 6240.2 | 6767.6 | 6416.0 | 6328.1 | 6328.1 |



| P.F.37 | P.F.38 | P.F.39 | P.F.40 | P.F.41 | P.F.42 | P.F.43 | P.F.44 | P.F.45 | P.F.46 | P.F.47 | P.F.48 | P.F.49 | P.F.50 | P.F.51 |
|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|
| 6943.4 | 7119.1 | 7207.0 | 7207.0 | 7207.0 | 7031.2 | 6943.4 | 6591.8 | 7119.1 | 7119.1 | 7207.0 | 7119.1 | 7207.0 | 7119.1 | 7119.1 |
| 6943.4 | 7119.1 | 7207.0 | 7207.0 | 7207.0 | 7207.0 | 7207.0 | 7119.1 | 7119.1 | 7207.0 | 7119.1 | 7207.0 |   NA   |   NA   |   NA   |
| 6943.4 | 7031.2 | 7119.1 | 7031.2 | 7294.9 | 7207.0 | 7207.0 | 7031.2 | 7207.0 | 7031.2 | 7031.2 | 7119.1 | 7119.1 | 7207.0 | 7119.1 |
| 6064.5 | 6152.3 | 6152.3 |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |
| 5537.1 |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |
| 7119.1 | 7822.3 | 6416.0 | 6855.5 |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |   NA   |
 &nbsp;
 
Note that these sequences are not all of equal length (one has NAs at the end).
`extract_ts` can also interpolate values so all time series have the same length:


{% highlight r %}
# Peak freq contour equal length
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak.Freq.Contour..Hz.",  equal.length = TRUE)

#look at the last rows wit no NAs
head(fcts[,21:32])
{% endhighlight %}
 

|  P.F.19  |  P.F.20  |  P.F.21  |  P.F.22  |  P.F.23  |  P.F.24  |  P.F.25  |  P.F.26  |  P.F.27  |  P.F.28  |  P.F.29  | P.F.30 |
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:------:|
| 6246.314 | 6373.603 | 6500.893 | 6628.183 | 6755.472 | 6882.762 | 7010.052 | 7137.341 | 7264.631 | 7391.921 | 7519.210 | 7646.5 |
| 6649.379 | 6803.945 | 6958.510 | 7113.076 | 7267.641 | 7422.207 | 7576.772 | 7731.338 | 7885.903 | 8040.469 | 8195.034 | 8349.6 |
| 6834.272 | 7003.993 | 7173.714 | 7343.434 | 7513.155 | 7682.876 | 7852.597 | 8022.317 | 8192.038 | 8361.759 | 8531.479 | 8701.2 |
| 6288.748 | 6428.162 | 6567.576 | 6706.990 | 6846.403 | 6985.817 | 7125.231 | 7264.645 | 7404.059 | 7543.472 | 7682.886 | 7822.3 |
| 6479.666 | 6585.741 | 6691.817 | 6797.893 | 6903.969 | 7010.045 | 7116.121 | 7222.197 | 7328.272 | 7434.348 | 7540.424 | 7646.5 |
| 6564.510 | 6694.828 | 6825.145 | 6955.462 | 7085.779 | 7216.097 | 7346.414 | 7476.731 | 7607.048 | 7737.366 | 7867.683 | 7998.0 |
 &nbsp; 

And the length of the series can also be specified:


{% highlight r %}
# Peak freq contour equal length 10 measurements
fcts <- extract_ts(X = rvn.dat, ts.column = "Peak.Freq.Contour..Hz.",
equal.length = T, length.out = 10)  

knitr::kable(head(fcts), align = "c", row.names = FALSE)
{% endhighlight %}


|  sound.files   | selec | P.F.1  |  P.F.2   |  P.F.3   |  P.F.4   |  P.F.5   |  P.F.6   |  P.F.7   |  P.F.8   |  P.F.9   | P.F.10 |
|:--------------:|:-----:|:------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:------:|
| Phae.long1.wav |   1   | 3955.1 | 4365.256 | 4775.411 | 5185.567 | 5595.722 | 6005.878 | 6416.033 | 6826.189 | 7236.344 | 7646.5 |
| Phae.long1.wav |   2   | 3867.2 | 4365.244 | 4863.289 | 5361.333 | 5859.378 | 6357.422 | 6855.467 | 7353.511 | 7851.556 | 8349.6 |
| Phae.long1.wav |   3   | 3779.3 | 4326.178 | 4873.056 | 5419.933 | 5966.811 | 6513.689 | 7060.567 | 7607.444 | 8154.322 | 8701.2 |
| Phae.long2.wav |   4   | 3779.3 | 4228.522 | 4677.744 | 5126.967 | 5576.189 | 6025.411 | 6474.633 | 6923.856 | 7373.078 | 7822.3 |
| Phae.long2.wav |   5   | 4570.3 | 4912.100 | 5253.900 | 5595.700 | 5937.500 | 6279.300 | 6621.100 | 6962.900 | 7304.700 | 7646.5 |
| Phae.long3.wav |   6   | 4218.8 | 4638.711 | 5058.622 | 5478.533 | 5898.444 | 6318.356 | 6738.267 | 7158.178 | 7578.089 | 7998.0 |
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


| Selection |     View      | Channel | Begin.Time..s. | End.Time..s. | Low.Freq..Hz. | High.Freq..Hz. |
|:---------:|:-------------:|:-------:|:--------------:|:------------:|:-------------:|:--------------:|
|     1     | Spectrogram 1 |    1    |     1.169      |  1.3420334   |    2220.1     |     8604.4     |
|     2     | Spectrogram 1 |    1    |     2.158      |  2.3210480   |    2169.4     |     8807.1     |
|     3     | Spectrogram 1 |    1    |     0.343      |  0.5179187   |    2218.3     |     8756.6     |
|     4     | Spectrogram 1 |    1    |     0.160      |  0.2925709   |    2316.9     |     8822.3     |
|     5     | Spectrogram 1 |    1    |     1.457      |  1.5831502   |    2284.0     |     8888.0     |
|     6     | Spectrogram 1 |    1    |     0.627      |  0.7582195   |    3006.8     |     8822.3     |
|     7     | Spectrogram 1 |    1    |     1.974      |  2.1041789   |    2776.8     |     8888.0     |
|     8     | Spectrogram 1 |    1    |     0.123      |  0.2542170   |    2316.9     |     9315.2     |
|     9     | Spectrogram 1 |    1    |     1.517      |  1.6624249   |    2514.0     |     9216.6     |
|    10     | Spectrogram 1 |    1    |     2.933      |  3.0771864   |    2579.7     |    10235.1     |
|    11     | Spectrogram 1 |    1    |     0.145      |  0.2900989   |    2579.7     |     9742.3     |



{% highlight r %}
# Relabel the basic columns required by warbleR
relabel_colms(st1)
{% endhighlight %}


| selec |     View      | Channel | start |    end    | bottom.freq | top.freq |
|:-----:|:-------------:|:-------:|:-----:|:---------:|:-----------:|:--------:|
|   1   | Spectrogram 1 |    1    | 1.169 | 1.3420334 |   2220.1    |  8604.4  |
|   2   | Spectrogram 1 |    1    | 2.158 | 2.3210480 |   2169.4    |  8807.1  |
|   3   | Spectrogram 1 |    1    | 0.343 | 0.5179187 |   2218.3    |  8756.6  |
|   4   | Spectrogram 1 |    1    | 0.160 | 0.2925709 |   2316.9    |  8822.3  |
|   5   | Spectrogram 1 |    1    | 1.457 | 1.5831502 |   2284.0    |  8888.0  |
|   6   | Spectrogram 1 |    1    | 0.627 | 0.7582195 |   3006.8    |  8822.3  |
|   7   | Spectrogram 1 |    1    | 1.974 | 2.1041789 |   2776.8    |  8888.0  |
|   8   | Spectrogram 1 |    1    | 0.123 | 0.2542170 |   2316.9    |  9315.2  |
|   9   | Spectrogram 1 |    1    | 1.517 | 1.6624249 |   2514.0    |  9216.6  |
|  10   | Spectrogram 1 |    1    | 2.933 | 3.0771864 |   2579.7    | 10235.1  |
|  11   | Spectrogram 1 |    1    | 0.145 | 0.2900989 |   2579.7    |  9742.3  |
 &nbsp; 

Additional columns can also be relabeled:

{% highlight r %}
# 2 additional column 
relabel_colms(st1, extra.cols.name = c("selec.file", "View"),
              extra.cols.new.name = c("Raven selection file", "Raven view"))
{% endhighlight %}


| selec |  Raven view   | Channel | start |    end    | bottom.freq | top.freq |
|:-----:|:-------------:|:-------:|:-----:|:---------:|:-----------:|:--------:|
|   1   | Spectrogram 1 |    1    | 1.169 | 1.3420334 |   2220.1    |  8604.4  |
|   2   | Spectrogram 1 |    1    | 2.158 | 2.3210480 |   2169.4    |  8807.1  |
|   3   | Spectrogram 1 |    1    | 0.343 | 0.5179187 |   2218.3    |  8756.6  |
|   4   | Spectrogram 1 |    1    | 0.160 | 0.2925709 |   2316.9    |  8822.3  |
|   5   | Spectrogram 1 |    1    | 1.457 | 1.5831502 |   2284.0    |  8888.0  |
|   6   | Spectrogram 1 |    1    | 0.627 | 0.7582195 |   3006.8    |  8822.3  |
|   7   | Spectrogram 1 |    1    | 1.974 | 2.1041789 |   2776.8    |  8888.0  |
|   8   | Spectrogram 1 |    1    | 0.123 | 0.2542170 |   2316.9    |  9315.2  |
|   9   | Spectrogram 1 |    1    | 1.517 | 1.6624249 |   2514.0    |  9216.6  |
|  10   | Spectrogram 1 |    1    | 2.933 | 3.0771864 |   2579.7    | 10235.1  |
|  11   | Spectrogram 1 |    1    | 0.145 | 0.2900989 |   2579.7    |  9742.3  |
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



