---
title: Creating a separate section for working papers on your website
author: 'Yabin Da'
date: '2021-05-30'
slug: creating-a-section-for-working-paper
categories:
  - Data
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2021-05-30T17:07:37-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---



I spent quite some time figuring out how to present publications and working papers independently in separate sections. Most importantly, I'd like working papers to be displayed in the same format as a publication. See examples on my website. 

However, it turned out not easy. I first created a `workingpaper.md` file in the `home` folder and set the `page_type = "publication"`. Simoutaounsly, I created a new folder named `workingpaper` to store the working papers. After deployment, the website ended up displaying publications in the `publication` folder instead of the working papers in the newly created `working paper` folder. 

I further explored by changing the `page_type = "workingpaper"`. This time the working papers were displayed on the website. The problem was that they displayed as a post NOT in a publication format. 

I thus posted this question in the discussion section of the `wowchemy`. See the original [post](https://github.com/wowchemy/wowchemy-hugo-modules/discussions/2298#discussioncomment-765481). The problem was solved perfectly.

Specifically,

- Create a new `workingpaper.md` file in `./content/home/` folder (you can simply copy the `publications.md` file and rename it). In the `workingpaper.md` file, set `page_type = "publication"` and also set `content.filter.publication_type = "3"` (**This is important!!**).

- Go to `./content/home/publications.md` and set `content.filter.publication_type = "2"`.

- Import pulications and working papers in the `./content/publication/` folder (following this [post](https://www.yabin-da.com/notes_in_r/blogdownwebsite/#add-publications-to-your-website) to import). Simply set the `publication_types: ["2"]` or `publication_types: ["3"]` in the associated `index.md` file for that publication/working paper.

- Deploy the website. We are all set!




