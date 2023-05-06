---
# Documentation: https://wowchemy.com/docs/managing-content/

title: 'warbleR: An r package to streamline analysis of animal acoustic signals'
subtitle: ''
summary: ''
authors:
- admin
- Grace Smith-Vidaurre
tags:
- Bioinformatics
- Evolutionary biology
- Software
- Acoustic methods
- R
- Scientific programming
categories: []
date: '2017-01-01'
lastmod: 2023-04-28T11:33:36-06:00
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
publishDate: '2023-04-28T18:12:02.086821Z'
publication_types:
- '2'
abstract: Animal acoustic communication is one of the most fruitful research areas
  in behavioural and evolutionary biology. Work in this area depends largely on quantifying
  the structure of acoustic signals, which has often depended upon closed-source or
  graphical user interface (GUI)-based software. Here, we describe the r package warbleR,
  a new package for the analysis of animal acoustic signal structure. The package
  offers functions for downloading avian vocalizations from the open-access online
  repository Xeno-Canto, displaying the geographic extent of the recordings, manipulating
  sound files, detecting acoustic signals or importing detected signals from other
  software, assessing performance of methods that measure acoustic similarity, conducting
  cross-correlations, measuring acoustic parameters and analysing interactive vocal
  signals, among others. Functions working iteratively allow parallelization to improve
  computational efficiency. We present a case study showing how warbleR functions
  can be used in a workflow to evaluate the structure of acoustic signals. We analyse
  geographic variation in long-billed hermit hummingbirds (Phaethornis longirostris)
  songs obtained from Xeno-Canto. The code in warbleR can be executed by less experienced
  r users, but has also been thoroughly commented, which will facilitate further customization
  by advanced users. The combination of the tools described here with other acoustic
  analysis packages in r should significantly expand the range of analytical approaches
  available.
publication: '*Methods in Ecology and Evolution*'
links:
- name: URL
  url: https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.12624
- name: Repository
  url: https://github.com/maRce10/warbleR
url_pdf: uploads/araya-salas-2017-f.pdf
---
