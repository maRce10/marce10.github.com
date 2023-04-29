---
# Documentation: https://wowchemy.com/docs/managing-content/

title: A machine learning approach for classifying and quantifying acoustic diversity
subtitle: ''
summary: ''
authors:
- Sara C. Keen
- Karan J. Odom
- Michael S. Webster
- Gregory M. Kohn
- Timothy F. Wright
- admin
tags:
- acoustic diversity
- acoustic space
- classification
- data augmentation
- random forest
- repertoire size
- unsupervised machine learning
- vocal signals
categories: []
date: '2021-07-01'
lastmod: 2023-04-28T11:33:41-06:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ''
  focal_point: ''
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
publishDate: '2023-04-28T18:11:57.311647Z'
publication_types:
- '2'
abstract: 'Assessing diversity of discretely varying behaviour is a classical ethological
  problem. In particular, the challenge of calculating an individuals’ or species’
  vocal repertoire size is often an important step in ecological and behavioural studies,
  but a reproducible and broadly applicable method for accomplishing this task is
  not currently available. We offer a generalizable method to automate the calculation
  and quantification of acoustic diversity using an unsupervised random forest framework.
  We tested our method using natural and synthetic datasets of known repertoire sizes
  that exhibit standardized variation in common acoustic features as well as in recording
  quality. We tested two approaches to estimate acoustic diversity using the output
  from unsupervised random forest analyses: (a) cluster analysis to estimate the number
  of discrete acoustic signals (e.g. repertoire size) and (b) an estimation of acoustic
  area in acoustic feature space, as a proxy for repertoire size. We find that our
  unsupervised analyses classify acoustic structure with high accuracy. Specifically,
  both approaches accurately estimate element diversity when repertoire size is small
  to intermediate (5–20 unique elements). However, for larger datasets (20–100 unique
  elements), we find that calculating the size of the area occupied in acoustic space
  is a more reliable proxy for estimating repertoire size.  We conclude that our implementation
  of unsupervised random forest analysis offers a generalizable tool that researchers
  can apply to classify acoustic structure of diverse datasets. Additionally, output
  from these analyses can be used to compare the distribution and diversity of signals
  in acoustic space, creating opportunities to quantify and compare the amount of
  acoustic variation among individuals, populations or species in a standardized way.
  We provide R code and examples to aid researchers interested in using these techniques.'
publication: '*Methods in Ecology and Evolution*'
links:
- name: URL
  url: https://onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13599
- name: Supp Mat
  url: https://figshare.com/articles/dataset/Acoustic_diversity_dataset/13661315
url_pdf: uploads/keen-2021.pdf
---
