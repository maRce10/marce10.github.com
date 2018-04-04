---
layout: post
title: "Individual sound files for each selection (or how to create a <i>warbleR</i> function)"
date: 06-06-2017
---

A friend of mine wants to "create individual sound files for each selection" in a selection table. This is a good opportunity to show how to create a function that works iteratively on signals in a selection table (like most [warbleR](https://cran.r-project.org/package=warbleR) functions). 

It takes 3 main steps: 

1. Create a (internal) function that does what we want on a single selection (i.e. a single row of the selection table) 

2. Add and `(X)lapply` loop to run the function from step 1 iteratively on each row

3. Put all inside a new function


Other things can be added to the function to check arguments and set working directory, but this is not critical.


### Step 1: Create function that does what we want on a single selection

First install and/or load [warbleR](https://cran.r-project.org/package=warbleR) (which also loads [tuneR](https://cran.r-project.org/package=tuneR), the package for cutting and saving sound files):


{% highlight r %}
if(!"devtools" %in% installed.packages()[,"Package"])  install.packages("devtools")
require("devtools") 

devtools::install_github("maRce10/warbleR")
require("warbleR")
{% endhighlight %}



Save the example sound files as *.wav* in a temporary working directory (to test the code):


{% highlight r %}
setwd(tempdir())

data(list = c("Phae.long1", "Phae.long2", "Phae.long3", 
              "Phae.long4", "selec.table"))
writeWave(Phae.long1,"Phae.long1.wav")
writeWave(Phae.long2,"Phae.long2.wav")
writeWave(Phae.long3,"Phae.long3.wav")
writeWave(Phae.long4,"Phae.long4.wav")
{% endhighlight %}



We can check that now there are 4 sound files in the working directory:


{% highlight r %}
list.files(pattern = "\\.wav$", ignore.case = TRUE)
{% endhighlight %}



{% highlight text %}
## [1] "Phae.long1.wav" "Phae.long2.wav" "Phae.long3.wav" "Phae.long4.wav"
{% endhighlight %}


The selection table `selec.table` contains columns for sound file name, start and end of signals (in seconds), and a unique ID for each selection: 


{% highlight r %}
head(selec.table)
{% endhighlight %}



{% highlight text %}
##      sound.files channel selec     start       end bottom.freq top.freq
## 1 Phae.long1.wav       1     1 1.1693549 1.3423884    2.220105 8.604378
## 2 Phae.long1.wav       1     2 2.1584085 2.3214565    2.169437 8.807053
## 3 Phae.long1.wav       1     3 0.3433366 0.5182553    2.218294 8.756604
## 4 Phae.long2.wav       1     1 0.1595983 0.2921692    2.316862 8.822316
## 5 Phae.long2.wav       1     2 1.4570585 1.5832087    2.284006 8.888027
## 6 Phae.long3.wav       1     1 0.6265520 0.7577715    3.006834 8.822316
##   sel.comment rec.comment
## 1         c24          NA
## 2         c25          NA
## 3         c26          NA
## 4         c27          NA
## 5         c28          NA
## 6         c29          NA
{% endhighlight %}


Now write a code that takes the selection from a single row, extracts the *.wav* file segment, and save it to the working directory. To do this use the functions `readWave` and `writeWave` from [tuneR](https://cran.r-project.org/package=tuneR):


{% highlight r %}
#lets use X for the selection table data frame as is the convention in warbleR functions 
X <- selec.table

# Cut wave for the first row
wvcut <- tuneR::readWave(as.character(X$sound.files[1]), from = X$start[1], to = X$end[1], units = "seconds")

# save cut removing file extension
tuneR::writeWave(object = wvcut, filename = paste0(gsub("\\.wav$", "",X$sound.files[1], ignore.case = TRUE), "-", X$selec[1], ".wav"))
{% endhighlight %}

Note that the sound file name (with the file extension removed) and selection ID were used to name the cut. This is important because it will produce a unique name for each cut, so they won't be overwritten.

The following code shows that there is a new sound file corresponding to the new cut:


{% highlight r %}
list.files(pattern = "\\.wav$", ignore.case = TRUE)
{% endhighlight %}



{% highlight text %}
## [1] "Phae.long1-1.wav" "Phae.long1.wav"   "Phae.long2.wav"  
## [4] "Phae.long3.wav"   "Phae.long4.wav"
{% endhighlight %}


Now put the code inside a function. The index number 1 used above has to be replaced by 'i' so it runs one each row iteratively. I also added a few more line of codes to:
  
  * Allow adding margins at both sides of the signals
  * Adjust the start and end when the margin surpasses the start (0) and end of the whole sound file 




{% highlight r %}
cutFUN <- function(X, i, mar){
    
    # Read sound files, initialize frequency and time limits for spectrogram
    r <- tuneR::readWave(as.character(X$sound.files[i]), header = TRUE)
    f <- r$sample.rate
    t <- c(X$start[i] - mar, X$end[i] + mar)
    
    # fix margins if below 0 or length of recordings
    mar1 <- mar
    mar2 <- mar1 + X$end[i] - X$start[i]
    
    if (t[1] < 0)  t[1] <- 0
    
    if(t[2] > r$samples/f) t[2] <- r$samples/f
    
    # Cut wave
    wvcut <- tuneR::readWave(as.character(X$sound.files[i]), from = t[1], to = t[2], units = "seconds")

tuneR::writeWave(object = wvcut, filename = paste0(as.character(X$sound.files[i]), "-", X$selec[i], ".wav"))

  }
{% endhighlight %}

### Step 2: Add a <i>(X)lapply</i> function

Several versions of the `lapply` function can be used. The function `pblapply` from the package [pbapply](https://cran.r-project.org/package=pbapply) provides a nice progress bar. The following code should produce cuts for each selection in `selec.table`:


{% highlight r %}
out <- pbapply::pblapply(1:nrow(selec.table), function(y) 
  cutFUN(X = selec.table, i = y, mar = 0.05))
{% endhighlight %}

We could also used `lapply` (no progress bar) or `mclapply` ([parallel](https://cran.r-project.org/package=parallel) package, parallel computing), or even `pbmclapply` ([pbmcapply](https://cran.r-project.org/package=pbmcapply) package, parallel computing and progress bar, but not available for windows). In fact, all these options are included in most [warbleR](https://cran.r-project.org/package=pbmcapply) functions.


### Step 3: Put all the code inside a new function

Just copy/paste the `cutFUN` function and the `(X)lapply` function inside a new function:


{% highlight r %}
cut.selections <- function(X, mar){
  
# internal function to cut each selection 
cutFUN <- function(X, i, mar){
    
    # Read sound files, initialize frequency and time limits for spectrogram
    r <- tuneR::readWave(as.character(X$sound.files[i]), header = TRUE)
    f <- r$sample.rate
    t <- c(X$start[i] - mar, X$end[i] + mar)
    
    # fix margins if below 0 or length of recordings
    mar1 <- mar
    mar2 <- mar1 + X$end[i] - X$start[i]
    
    if (t[1] < 0)  t[1] <- 0
    
    if(t[2] > r$samples/f) t[2] <- r$samples/f
    
    # Cut wave
    wvcut <- tuneR::readWave(as.character(X$sound.files[i]), from = t[1], to = t[2], units = "seconds")

tuneR::writeWave(object = wvcut, filename = paste0(as.character(X$sound.files[i]), "-", X$selec[i], ".wav"))

  }
  
# lapply function to run over all selections  
out <- pbapply::pblapply(1:nrow(X), function(y) cutFUN(X = selec.table, i = y, mar = 0.05))
    
}
{% endhighlight %}

Let's see if it works. First we should remove the cuts we created previously. The following code removes only the cuts but not the original sound files (filtered out based on file size):


{% highlight r %}
wvs <- list.files(pattern = "\\.wav$", ignore.case = TRUE)

sz <- file.info(list.files(pattern = "\\.wav$", ignore.case = TRUE))$size

unlink(wvs[sz < 50000])

list.files(pattern = "\\.wav$", ignore.case = TRUE)
{% endhighlight %}



{% highlight text %}
## [1] "Phae.long1.wav" "Phae.long2.wav" "Phae.long3.wav" "Phae.long4.wav"
{% endhighlight %}

And run the function:


{% highlight r %}
cut.selections(X = selec.table, mar = 0.05)
{% endhighlight %}

The cuts now are found in the working directory:


{% highlight r %}
list.files(pattern = "\\.wav$", ignore.case = TRUE)
{% endhighlight %}



{% highlight text %}
##  [1] "Phae.long1.wav"       "Phae.long1.wav-1.wav" "Phae.long1.wav-2.wav"
##  [4] "Phae.long1.wav-3.wav" "Phae.long2.wav"       "Phae.long2.wav-1.wav"
##  [7] "Phae.long2.wav-2.wav" "Phae.long3.wav"       "Phae.long3.wav-1.wav"
## [10] "Phae.long3.wav-2.wav" "Phae.long3.wav-3.wav" "Phae.long4.wav"      
## [13] "Phae.long4.wav-1.wav" "Phae.long4.wav-2.wav" "Phae.long4.wav-3.wav"
{% endhighlight %}

I put together all the code in a new [warbleR](https://cran.r-project.org/package=warbleR) function called `cut_sels` (available in version 1.1.9, currrently only on github).  I added a few more arguments (labels, overwrite, parallel, ...), some argument checks to warn users when using invalid values, and parallel and progress bar options. Here is the code in case you are curious:  


{% highlight r %}
cut_sels <- function(X, mar = 0.05, parallel = 1, path = NULL, dest.path = NULL, pb = TRUE,
                     labels = c("sound.files", "selec"), overwrite = FALSE, ...){
  
  #check path to working directory
  if(!is.null(path))
  {wd <- getwd()
  if(class(try(setwd(path), silent = TRUE)) == "try-error") stop("'path' provided does not exist") else 
    setwd(path)} #set working directory
  
  #check path to working directory
  if(!is.null(dest.path))
  {if(class(try(setwd(dest.path), silent = TRUE)) == "try-error") stop("'dest.path' provided does not exist")} else dest.path <- getwd()
     #set working directory
  
  #if X is not a data frame
  if(!class(X) == "data.frame") stop("X is not a data frame")
  
  if(!all(c("sound.files", "selec", 
            "start", "end") %in% colnames(X))) 
    stop(paste(paste(c("sound.files", "selec", "start", "end")[!(c("sound.files", "selec", 
                                                                   "start", "end") %in% colnames(X))], collapse=", "), "column(s) not found in data frame"))
  
  #if there are NAs in start or end stop
  if(any(is.na(c(X$end, X$start)))) stop("NAs found in start and/or end")  
  
  #if end or start are not numeric stop
  if(all(class(X$end) != "numeric" & class(X$start) != "numeric")) stop("'end' and 'selec' must be numeric")
  
  #if any start higher than end stop
  if(any(X$end - X$start<0)) stop(paste("The start is higher than the end in", length(which(X$end - X$start<0)), "case(s)"))  
  
  #return warning if not all sound files were found
  recs.wd <- list.files(pattern = "\\.wav$", ignore.case = TRUE)
  if(length(unique(X$sound.files[(X$sound.files %in% recs.wd)])) != length(unique(X$sound.files))) 
    (paste(length(unique(X$sound.files))-length(unique(X$sound.files[(X$sound.files %in% recs.wd)])), 
           ".wav file(s) not found"))
  
  #missing label columns
  if(!all(labels %in% colnames(X)))
    stop(paste(paste(labels[!(labels %in% colnames(X))], collapse=", "), "label column(s) not found in data frame"))
  
  #count number of sound files in working directory and if 0 stop
  d <- which(X$sound.files %in% recs.wd) 
  if(length(d) == 0){
    stop("The .wav files are not in the working directory")
  }  else {
    X <- X[d, ]
  }
  
  #convert factors to characters
  X[,sapply(X, is.factor)] <- apply(X[,sapply(X, is.factor)], 2, as.character)
  
  #remove .wav from sound file names
  X2 <- X
  X2$sound.files <- gsub("\\.wav$", "", X2$sound.files, ignore.case = TRUE)
  
  # If parallel is not numeric
  if(!is.numeric(parallel)) stop("'parallel' must be a numeric vector of length 1") 
  if(any(!(parallel %% 1 == 0),parallel < 1)) stop("'parallel' should be a positive integer")
  
  #if parallel and pb in windows
  if(parallel > 1 &  pb & Sys.info()[1] == "Windows") {
    message("parallel with progress bar is currently not available for windows OS")
    message("running parallel without progress bar")
    pb <- FALSE
  } 
  
  #create function to run within Xapply functions downstream     
  cutFUN <- function(X, i, mar, labels, dest.path){
    
    # Read sound files, initialize frequency and time limits for spectrogram
    r <- tuneR::readWave(as.character(X$sound.files[i]), header = TRUE)
    f <- r$sample.rate
    t <- c(X$start[i] - mar, X$end[i] + mar)
    
    # fix margins if below 0 or length of recordings
    mar1 <- mar
    mar2 <- mar1 + X$end[i] - X$start[i]
    
    if (t[1] < 0)  t[1] <- 0
    if(t[2] > r$samples/f) t[2] <- r$samples/f
    
    # Cut wave
    wvcut <- tuneR::readWave(as.character(X$sound.files[i]), from = t[1], to = t[2], units = "seconds")

    
    # save cut
    if(overwrite) unlink(file.path(dest.path, paste0(paste(X2[i, labels], collapse = "-"), ".wav")))

  
    tuneR::writeWave(object = wvcut, filename = file.path(dest.path, paste0(paste(X2[i, labels], collapse = "-"), ".wav")), ...)
       
  }
  
  # Run parallel in windows
  if(parallel > 1) {
    if(Sys.info()[1] == "Windows") {
      
      i <- NULL #only to avoid non-declared objects
      
      cl <- parallel::makeCluster(parallel)
      
      doParallel::registerDoParallel(cl)
      
      out <- foreach::foreach(i = 1:nrow(X)) %dopar% {
        cutFUN(X = X, i = i, mar = mar, labels = labels, dest.path = dest.path)
      }
      
      parallel::stopCluster(cl)
      
    } 
    if(Sys.info()[1] == "Linux") {    # Run parallel in Linux
      
      if(pb)       
        out <- pbmcapply::pbmclapply(1:nrow(X), mc.cores = parallel, function (i) {
          cutFUN(X = X, i = i, mar = mar, labels = labels, dest.path = dest.path)
        }) else
          out <- parallel::mclapply(1:nrow(X), mc.cores = parallel, function (i) {
            cutFUN(X = X, i = i, mar = mar, labels = labels, dest.path = dest.path)
            
          })
    }
    if(!any(Sys.info()[1] == c("Linux", "Windows"))) # parallel in OSX
    {
      cl <- parallel::makeForkCluster(getOption("cl.cores", parallel))
      
      doParallel::registerDoParallel(cl)
      
      out <- foreach::foreach(i = 1:nrow(X)) %dopar% {
        cutFUN(X = X, i = i, mar = mar, labels = labels, dest.path = dest.path)
      }
      
      parallel::stopCluster(cl)
      
    }
  }
  else {
    if(pb)
      out <- pbapply::pblapply(1:nrow(X), function(i) cutFUN(X = X, i = i, mar = mar, labels = labels, dest.path = dest.path)) else 
        out <- lapply(1:nrow(X), function(i) cutFUN(X = X, i = i, mar = mar, labels = labels, dest.path = dest.path))
  }
  
  if(!is.null(path)) setwd(wd)
}
{% endhighlight %}



That's is it. If you developed a function that you think could be useful to other people we could include it in [warbleR](https://cran.r-project.org/package=warbleR).
