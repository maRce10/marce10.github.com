---
layout: post
title: "Song similarity using dynamic time warping"
date: 12-09-2016
---

Here I show how to use the `dfDTW` function in [warbleR](https://cran.r-project.org/package=warbleR) to compare acoustics signals using dynamic time warping (DTW).

First load these packages (if not installed the code will install it):

{% highlight r %}
x<-c("vegan", "warbleR")

A <- lapply(x, function(y) {
  if(!y %in% installed.packages()[,"Package"])  install.packages(y)
require(y, character.only = T)
  })
{% endhighlight %}

and load example data from `warbleR`


{% highlight r %}
# optional, save it in a temporal folder
# setwd(tempdir())
 
data(list = c( "Phae.long1", "Phae.long2","Phae.long3", "Phae.long4","selec.table"))

writeWave(Phae.long1, "Phae.long1.wav")
writeWave(Phae.long2, "Phae.long2.wav")
writeWave(Phae.long3, "Phae.long3.wav") 
writeWave(Phae.long4, "Phae.long4.wav")
{% endhighlight %}

These recordings all come from long-billed hermits with different song types.

We can run the DTW analysis to compare these time series usin the [warbleR](https://cran.r-project.org/package=warbleR) function `dfDTW` which calculates the dominant frequency contours of each sgnals and compares using dynamic time warping. Internally it applies the `dtwDist` function from the [dtw](https://cran.r-project.org/package=dtw) package.


{% highlight r %}
dm <- dfDTW(selec.table, length.out = 30, flim = c(1, 12), bp = c(2, 9), wl = 300, img = FALSE, pb = F)
{% endhighlight %}


Let's see if the dissimilarity from dtw represents the acoutic differences. First we need a binary matrix representing same recording with 0s, and different recording with 1s. The following functions does exactly that:


{% highlight r %}
recid<-function(x) {
  for(i in 1:ncol(x))
  {
    for(j in 1:length(x[,i])){
      if(sapply(strsplit(as.character(colnames(x)), "-",fixed=T), "[[", 1)[j]==sapply(strsplit(as.character(colnames(x)), "-",fixed=T), "[[", 1)[i]) x[j,i]<-0
      if(sapply(strsplit(as.character(colnames(x)), "-",fixed=T), "[[", 1)[j]!=sapply(strsplit(as.character(colnames(x)), "-",fixed=T), "[[", 1)[i]) x[j,i]<-1      
    }
  }
  return(x)}

recmat <- recid(dm)
{% endhighlight %}

these 2 matrices can be compared with a mantel test:


{% highlight r %}
mantel(dm,as.dist(recmat),permutations = 1000)
{% endhighlight %}



{% highlight text %}
## 
## Mantel statistic based on Pearson's product-moment correlation 
## 
## Call:
## mantel(xdis = dm, ydis = as.dist(recmat), permutations = 1000) 
## 
## Mantel statistic r: 0.676 
##       Significance: 0.000999 
## 
## Upper quantiles of permutations (null model):
##   90%   95% 97.5%   99% 
## 0.192 0.263 0.323 0.417 
## Permutation: free
## Number of permutations: 1000
{% endhighlight %}

As you can see there is a strong association between song type variation and acoustic similarity measured by means of DTW.

What about its performance compare to a more standard method like measuring a bunch of acoustic parameters? 
We can calculate "acoustic distance" using acoustic parameters and then correlate it to the "recording id" matrix


{% highlight r %}
span<-specan(selec.table)

dspan<-dist(span[,3:ncol(span)],method = "euclidean",diag = T,upper = T)

mantel(dspan,as.dist(recmat),permutations = 10000)
{% endhighlight %}



{% highlight text %}
## 
## Mantel statistic based on Pearson's product-moment correlation 
## 
## Call:
## mantel(xdis = dspan, ydis = as.dist(recmat), permutations = 10000) 
## 
## Mantel statistic r: 0.418 
##       Significance: 8e-04 
## 
## Upper quantiles of permutations (null model):
##   90%   95% 97.5%   99% 
## 0.171 0.220 0.260 0.317 
## Permutation: free
## Number of permutations: 10000
{% endhighlight %}

Looks like DTW represents the acoustic variation a little better, although both methods produce significant correlations with relatively high  mantel r's.


DTW and acoustic parameter distances are also correlated:

{% highlight r %}
mantel(dm, dspan, permutations = 10000)
{% endhighlight %}



{% highlight text %}
## 
## Mantel statistic based on Pearson's product-moment correlation 
## 
## Call:
## mantel(xdis = dm, ydis = dspan, permutations = 10000) 
## 
## Mantel statistic r: 0.458 
##       Significance: 0.0027 
## 
## Upper quantiles of permutations (null model):
##   90%   95% 97.5%   99% 
## 0.188 0.254 0.308 0.367 
## Permutation: free
## Number of permutations: 10000
{% endhighlight %}

