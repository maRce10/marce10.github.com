---
layout: post
title: "Signal detection with cross-correlation using monitoR "
date: 15-12-2016
categories: cross-correlation, automatic detection
tags: cross-correlation, automatic detection
---
<br>
Here I show how to detect signals using corss-correlation using the awesome package [monitoR](https://cran.r-project.org/package=monitoR). It is similar but much less detailed than the [quick start](https://cran.r-project.org/web/packages/monitoR/vignettes/monitoR_QuickStart.pdf) vignette of the [monitoR](https://cran.r-project.org/package=monitoR) package. So I encourage to look at the vignette if you want to learn more about it. 
<br>
The package [monitoR](https://cran.r-project.org/package=monitoR) runs cross-correlation across sound files to search for the signals using previously defined templates. Thus, templates should be examples of the signals we want to detect. It can search for several templates in the same run. I show how the package works using the sound files and data examples that come with the [warbleR](https://cran.r-project.org/package=warbleR) package. These are recordings from long-billed hermits, each one singing a diferent song type.
<br>
First we need to load the packages (the code will install the packages if missing):
<br>
``` r
x<-c("warbleR", "monitoR")

A <- lapply(x, function(y) {
  if(!y %in% installed.packages()[,"Package"])  install.packages(y)
require(y, character.only = T)
  })
```
<br>
We need to create the templates. We just have to select and example from each sound file and provide the start and end as well as the frequency range of the signal. We will load the long-billed hermit sound:
<br>
``` r
#optional: write files in temporal file
# setwd(file.path(tempdir()))

# load sound files and data
data(list = c("Phae.long1", "Phae.long2", "Phae.long3", "Phae.long4", "manualoc.df"))

#write files to disk
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")
```
<br>
and create the templates:
<br>
``` r
phae1T1<-makeCorTemplate("Phae.long1.wav", t.lim=c(manualoc.df$start[2],manualoc.df$end[2]),wl = 300,ovlp=90,
    frq.lim=c(1, 11), dens=1, name="phae11")
```
<br>
![plot of chunk unnamed-chunk-3](/assets/Rfig/unnamed-chunk-3-1.svg)
<br>
``` r
## 
## Automatic point selection.
## 
## Done.
```
<br>
``` r
phae2T1<-makeCorTemplate("Phae.long2.wav", t.lim=c(manualoc.df$start[5],manualoc.df$end[5]),wl = 300,ovlp=90,
       frq.lim=c(1, 11), dens=1, name="phae21")
```
<br>
![plot of chunk unnamed-chunk-3](/assets/Rfig/unnamed-chunk-3-2.svg)
<br>
``` r
## 
## Automatic point selection.
## 
## Done.
```
<br>
``` r
phae3T1<-makeCorTemplate("Phae.long3.wav", t.lim=c(manualoc.df$start[7],manualoc.df$end[7]),wl = 300,ovlp=90,
       frq.lim=c(1, 11), dens=1, name="phae31")
```
<br>
![plot of chunk unnamed-chunk-3](/assets/Rfig/unnamed-chunk-3-3.svg)
<br>
``` r
## 
## Automatic point selection.
## 
## Done.
```
<br>
``` r
phae4T1<-makeCorTemplate("Phae.long4.wav", t.lim=c(manualoc.df$start[9],manualoc.df$end[9]),wl = 300,ovlp=90,
       frq.lim=c(1, 11), dens=1, name="phae41")
```
<br>
![plot of chunk unnamed-chunk-3](/assets/Rfig/unnamed-chunk-3-4.svg)
<br>
``` r
## 
## Automatic point selection.
## 
## Done.
```
<br>
Now we put together all templates in a single object:
<br>
``` r
ctemps<-combineCorTemplates(phae1T1, phae2T1, phae3T1, phae4T1)
```
<br>
Now that we have the templates we can search fo those "acoustic patterns" in a sound file. As the function usese cross-correlation to determine the similarity to the templates we need to select a correlation method. In this case we use pearson correlation. Lets do it first with the template from the Phae.long1.wav file
<br>
``` r
cm<-"pearson"
cscoresPhae1<-corMatch(survey = "Phae.long1.wav",templates = phae1T1, parallel = T,show.prog = F, time.source = "fileinfo",
                  cor.method = cm,warn=F,write.wav = T)
```
<br>
``` r
## 
## Starting  phae11 . . .
## 	Fourier transform on survey . . .
## 	Continuing. . .
## 
## 	Done.
```
<br>
And now lets look at the results detecting each template in its original file:
<br>
``` r
cdetectsPhae1<-findPeaks(cscoresPhae1, parallel = TRUE)
```
<br>
``` r
## 
## Done with  phae11
## Done
```
<br>
``` r
# View results
plot(cdetectsPhae1, hit.marker="points")
```
<br>
![plot of chunk unnamed-chunk-6](/assets/Rfig/unnamed-chunk-6-1.svg)
<br>
We can do the same for each sound file:
<br>
``` r
cscoresPhae2<-corMatch(survey = "Phae.long2.wav",templates = phae2T1, parallel = T,show.prog = F, time.source = "fileinfo",
                  cor.method = cm,warn=F,write.wav = T)
```
<br>
``` r
## 
## Starting  phae21 . . .
## 	Fourier transform on survey . . .
## 	Continuing. . .
## 
## 	Done.
```
<br>
``` r
cdetectsPhae2<-findPeaks(cscoresPhae2, parallel = TRUE)
```
<br>
``` r
## 
## Done with  phae21
## Done
```
<br>
``` r
# View results
plot(cdetectsPhae2, hit.marker="points")
```
<br>
![plot of chunk unnamed-chunk-7](/assets/Rfig/unnamed-chunk-7-1.svg)
<br>
``` r
cscoresPhae3<-corMatch(survey = "Phae.long3.wav",templates = phae3T1, parallel = T,show.prog = F, time.source = "fileinfo",
                  cor.method = cm,warn=F,write.wav = T)
```
<br>
``` r
## 
## Starting  phae31 . . .
## 	Fourier transform on survey . . .
## 	Continuing. . .
## 
## 	Done.
```
<br>
``` r
cdetectsPhae3<-findPeaks(cscoresPhae3, parallel = TRUE)
```
<br>
``` r
## 
## Done with  phae31
## Done
```
<br>
``` r
# View results
plot(cdetectsPhae3, hit.marker="points")
```
<br>
![plot of chunk unnamed-chunk-8](/assets/Rfig/unnamed-chunk-8-1.svg)
<br>
``` r
cscoresPhae4<-corMatch(survey = "Phae.long4.wav",templates = phae4T1, parallel = T,show.prog = F, time.source = "fileinfo",
                  cor.method = cm,warn=F,write.wav = T)
```
<br>
``` r
## 
## Starting  phae41 . . .
## 	Fourier transform on survey . . .
## 	Continuing. . .
## 
## 	Done.
```
<br>
``` r
cdetectsPhae4<-findPeaks(cscoresPhae4, parallel = TRUE)
```
<br>
``` r
## 
## Done with  phae41
## Done
```
<br>
``` r
# View results
plot(cdetectsPhae4, hit.marker="points")
```
<br>
![plot of chunk unnamed-chunk-9](/assets/Rfig/unnamed-chunk-9-1.svg)
<br>
We can also run all templates on a single sound file:
<br>
``` r
cscoresPhae4all<-corMatch(survey = "Phae.long1.wav",templates = ctemps, parallel = T,show.prog = F, time.source = "fileinfo",
                  cor.method = cm,warn=F, write.wav = T)
```
<br>
``` r
## 
## Starting  phae11 . . .
## 	Fourier transform on survey . . .
## 	Continuing. . .
## 
## 	Done.
## 
## Starting  phae21 . . .
## 	Done.
## 
## Starting  phae31 . . .
## 	Done.
## 
## Starting  phae41 . . .
## 	Done.
```
<br>
``` r
cdetectsPhae4all<-findPeaks(cscoresPhae4all, parallel = TRUE)
```
<br>
``` r
## 
## Done
```
<br>
``` r
# View results
plot(cdetectsPhae4all, hit.marker="points")
```
<br>
![plot of chunk unnamed-chunk-10](/assets/Rfig/unnamed-chunk-10-1.svg)
<br>
