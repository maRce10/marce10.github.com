---
title: Sub-national level administrative areas
author: Yabin
date: '2021-01-23'
slug: sub-national-level-administrative-areas
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2022-06-23T16:37:18-06:00'
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

This post documents interesting sources for world-level, country-level, and sub-national level (i.e., states/provinces, cities, counties, etc) maps (administrative areas) data. It could be particularly useful when you are trying to downscale gridded data to specific geographical levels in spatial analysis. 

# Database of Global Administrative Areas (GADM)

[GADM](https://gadm.org/) provides maps and spatial data for all countries and their sub-divisions. You can browse the maps or download the data to make your own maps.

See an example of spatial data for China. Level-0, 1, 2, 3 stands for country level, province level, city level, and county level I guess. But you should double check that. 

![](/data/2021-01-23-sub-national-level-administrative-areas.en_files/Untitled.png)


See the [data](https://gadm.org/formats.html) package for more information in data format.

- Reference

  Dang and Trinh. Does the COVID-19 lockdown improve global air quality? New cross-national evidence on its unintended consequences. Journal of Environmental Economics and Management 105 (2021). [Link](https://doi.org/10.1016/j.jeem.2020.102401)
  
  
# Natural Earth

[Natural Earth](https://www.naturalearthdata.com/) is a public domain map dataset available at 1:10m, 1:50m, and 1:110 million scales. Featuring tightly integrated vector and raster data, with Natural Earth you can make a variety of visually pleasing, well-crafted maps with cartography or GIS software.

This dataset provides vector data at country-level, state-level, and populated places and obviously, is not as detailed as in GADM. **But it pretty suitable for ploting at the the worldwide level**. Natural Earth also provides vector data on coasline, land, ocean, reefs, rivers, lakes, etc, as well as raster data.

- Reference

  Hong, C., Burney, J.A., Pongratz, J. et al. Global and regional drivers of land-use emissions in 1961–2017. Nature 589, 554–561 (2021). [Link](https://doi.org/10.1038/s41586-020-03138-y).
  

