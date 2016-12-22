---
layout: post
title: "Song similarity using dynamic time warping"
date: 12-09-2016
---

This short tutorial shows how to use the `dfDTW` function in `warbleR` to compare acoustics signals using dynamic time warping (DTW).

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
 
data(list = c( "Phae.long1", "Phae.long2","Phae.long3", "Phae.long4","manualoc.df"))

writeWave(Phae.long1, "Phae.long1.wav")
writeWave(Phae.long2, "Phae.long2.wav")
writeWave(Phae.long3, "Phae.long3.wav") 
writeWave(Phae.long4, "Phae.long4.wav")
{% endhighlight %}

These recordings all come from long-billed hermits with different song types.

We can run the DTW analysis to compare these time series usin the [warbleR](https://cran.r-project.org/package=warbleR) function `dfDTW` which calculates the dominant frequency contours of each sgnals and compares using dynamic time warping. Internally it applies the `dtwDist` function from the [dtw](https://cran.r-project.org/package=dtw) package.


{% highlight r %}
dm <- dfDTW(manualoc.df, length.out = 30, flim = c(1, 12), bp = c(2, 9), wl = 300, img = FALSE, pb = F)
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
## Mantel statistic r: 0.6544 
##       Significance: 0.000999 
## 
## Upper quantiles of permutations (null model):
##   90%   95% 97.5%   99% 
## 0.177 0.241 0.295 0.378 
## Permutation: free
## Number of permutations: 1000
{% endhighlight %}

As you can see there is a strong association between song type variation and acoustic similarity measured by means of DTW.

What about its performance compare to a more standard method like measuring a bunch of acoustic parameters? 
We can calculate "acoustic distance" using acoustic parameters and then correlate it to the "recording id" matrix


{% highlight r %}
span<-specan(manualoc.df)
{% endhighlight %}



{% highlight text %}
## 
   |+++++                                             | 9 % ~00s          
   |++++++++++                                        | 18% ~00s          
   |++++++++++++++                                    | 27% ~00s          
   |+++++++++++++++++++                               | 36% ~00s          
   |+++++++++++++++++++++++                           | 45% ~00s          
   |++++++++++++++++++++++++++++                      | 55% ~00s          
   |++++++++++++++++++++++++++++++++                  | 64% ~00s          
   |+++++++++++++++++++++++++++++++++++++             | 73% ~00s          
   |+++++++++++++++++++++++++++++++++++++++++         | 82% ~00s          
   |++++++++++++++++++++++++++++++++++++++++++++++    | 91% ~00s          
   |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 00s
{% endhighlight %}



{% highlight r %}
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
## Mantel statistic r: 0.5269 
##       Significance: 0.00039996 
## 
## Upper quantiles of permutations (null model):
##   90%   95% 97.5%   99% 
## 0.191 0.254 0.309 0.364 
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
## Mantel statistic r: 0.3582 
##       Significance: 0.016198 
## 
## Upper quantiles of permutations (null model):
##   90%   95% 97.5%   99% 
## 0.189 0.260 0.328 0.394 
## Permutation: free
## Number of permutations: 10000
{% endhighlight %}

