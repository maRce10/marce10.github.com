---
title: Start your first post with blogdown website
author: Yabin Da
date: '2020-09-29'
slug: start-your-first-post-with-blogdown-website
categories:
  - Fun
tags:
  - First Post
subtitle: ''
summary: ''
authors: []
lastmod: '2021-01-17T22:11:37-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []


output:
  blogdown::html_page:
    toc: true
    toc_depth: 4
---


After you successfully create your website with `blogdown`, you may want to start your first post right away. In this short section, I am going to briefly introduce how to create a new post with `blogdown`. 


### Start your first post

I highly recommend you start your post using the  `New Post` button in `Addins` in `RStudio`. See the figure below.

```{r, echo=F, fig.align='default', fig.show='hold'}

knitr::include_graphics("/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files/plot1.png", error = F)


```

It's followed by an interface, see the figure below. You can easily fill up the basic information for your new post, such as `Title`, `Author`, and `Date`. The `Subdirectory` will allow you to specify the type of this new post, either it can be a post or publication or talk etc.  

The `Categories` and `Tags` fields will automatically display the existing categories and tags. But you can add new ones directly in the fields. The `Filename` will be automatically generated. Finally, you are free to choose the `Format` you are comfortable with. The differences between these three formats are explained [here](https://bookdown.org/yihui/blogdown/output-format.html)

```{r, echo=F, fig.align='default', fig.show='hold'}

knitr::include_graphics("/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files/plot2.png", error = F)

```


### Customize your first post


After you click `Done`, the associated `.Rmd` file (if you chose the `.Rmd` format) will show up in the respective folder under the `content` folder. The `YAML` front matter will also be created in the `.Rmd` file. You can easily customize the `YAML` front matter based on your needs. 

For instance, if the post is a draft and is not ready to display on your website, you can simply add `draft: true` in the `YAML`. When you are ready to publish the post, simply delete the `draft: true` or set `true` to `false`. Additionally, if you want to feature this post, just add `feature: true` in the `YAML`.  

Another useful trick is that if you are writing a long post and wish to display the table of content in the post, you can add the followings to your `YAML` front matter.

```
output:
  blogdown::html_page:
    toc: true
    toc_depth: 4


```

### How to embed images in your website

One benefit of creating website with `blogdown` is that it allows you to execute `R` code chunks in the `Rmd` files. That means you can easily add `R` plots on your website. In this section, I will focus on how to insert external images instead. 

It should be noted that all static content (i.e. images, data, etc.) on your website should be stored in the `static` folder. You can create new folders inside the `static` folder to organize static contents for each of the post. 

Also note that the static contents will be automatically copied to the `public` folder after we deploy the website. 

#### Insert images via `Insert Image` in `Addins`

This is the easiest way to do the job. In the interface below, you can specify the `Width` and `Height` of the figure. 

Note that `Target file path` will be automatically created and target to the `static` folder. That says the inserted images will be automatically copied to the `static` folder, regardless of the original image path. 

![](/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files/plot3.png)

After you click `done`, the figure will be inserted by the code below. You can see that the image is placed to the automatically created folder `static/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files` that is associated with the post. 



```
![](/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files/IMG_20190313_120505.jpg)

```

The images will show up on your website. (see the armadillo below). 


![](/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files/IMG_20190313_120505.jpg)


#### Insert images with `Knitr::include_graphic`

In some cases, you may want to insert images with `Knitr::include_graphic` which is a function rooted in `R markdown` and more straightforward.

The trick here is to correctly specify the image path. As I mentioned in the preceding section, the default path for static content is the `static` folder. That means `R` will search for the image in the default `static` folder. So in order to successfully insert the external image, you should place the image in the `static` folder. 

As `Knitr` does not automatically create new folder under the `static` folder, it's recommended that you create new folders manually and store static contents (i.e. images) separately for each post. See the code chunk below. 

Please remember to set the `error = FALSE` in the `include_graphics`, otherwise you will end up with errors. 

```{r, echo=T, fig.align='default', fig.show='hold', eval=F}

knitr::include_graphics("/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files/plot3.png", 
                        error = False)

```


Next you can customize the code chunk options to add figure caption, adjust figure alignment, output width, etc. See the example below. 

```{r, echo=F, fig.align='center', fig.cap='This is a figure with smaller size', out.width='50%'}

knitr::include_graphics("/post/2020-09-29-start-your-first-post-with-blogdown-website.en_files/IMG_20190313_120505.jpg", 
                        error = FALSE)

```

