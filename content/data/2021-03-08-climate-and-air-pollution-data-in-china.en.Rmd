---
title: Climate and air pollution data in China
author: Yabin Da
date: '2021-03-08'
slug: climate-and-air-pollution-data-in-china
categories:
  - Data
tags: []
subtitle: ''
summary: ''
authors: [Yabin Da]
lastmod: '2021-07-03T15:56:13-06:00'
featured: no
draft: false
math: true
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

There is an increasing body of literature investigating the environmental problems in China, including air pollution, water pollution, etc. The studies cover a range of topics, such as evaluations of environmental regulations, the health effects of air pollution, and such. 

I have also repeatedly seen paper discussing the environmental regulations in the political economy arena. For instance, a recent paper by [Wu and Cao (2021)](https://www.sciencedirect.com/science/article/pii/S0095069621000231?dgcid=raven_sd_aip_email) examine the effect of local environment regulation outcomes, i.e., local pollution, on leaders' chances of promotion.

This post intends to collect and summarize the sources for pollutants (primarily air pollution) to facilitate future studies.


### Data on PM5.2

#### Global Annual PM2.5 Grids from MODIS, MISR and SeaWiFS Aerosol Optical Depth (AOD) with GWR, v1 (1998 –2016)

To access the data set, click this [link](https://sedac.ciesin.columbia.edu/data/set/sdei-global-annual-gwr-pm2-5-modis-misr-seawifs-aod). The data consist of annual concentrations (micrograms per cubic meter) of ground-level fine particulate matter (PM2.5), with dust and sea-salt removed.

Spatial resolution: Global; Gridded at 0.01 degree * 0.01 degree (Note that analysis using this fine scale is not recommended. Users are encouraged to aggregate the fine-scaled data to perform analysis at larger spatial scales).

Temporal resolution: Annually (1998-2016)


#### MODIS Moderate Resolution Imaging Spectroradiometer

This dataset provides a rich colletion of data in the form of satellite images. While the dataset does not directly provide PM2.5/10 data, such data is represented by aerosol optical depth. The readers are encouraged to check out the [website](https://modis.gsfc.nasa.gov/data/) for more information due to its richness of data provided. 

The data are classified to multiple categories, including MODIS level 1 data (geolocation, cloud mask, and atmosphere products), MODIS land products, MODIS cryosphere products, and MODIS ocean color and sea surface temperature products. The aerosol data is located in the MODIS level 1. 

To access the data, click the [link](https://ladsweb.modaps.eosdis.nasa.gov/missions-and-measurements/science-domain/aerosol/).

Spatial resolution: Global; Gridded at 10km * 10km. Note that product with a spatial resolution of 3km * 3km is also provided which is beneficial for air quality analysis. 10km * 10km data are primarily used for climate analysis. Also note that preliminary analysis indicates that the 3 km product tends to be noiser than the 10 km product. Comparisons of the global mean AOD from the two products shows that the 3 km AOD is 0.01 to 0.02 higher over land. Over ocean, it was found that there was more very low AOD with the 3 km product (see [here](https://ladsweb.modaps.eosdis.nasa.gov/missions-and-measurements/products/MOD04_3K/)).

Temporal resolution: Daily (2000-01-01 to present).

Related papers

- Eric Yongchen Zou, 2021. Unwatched pollution: The effect of intermittent monitoring on air quality. American Economic Review. [Link](https://www.aeaweb.org/articles?id=10.1257/aer.20181346&&from=f)


#### Tracking Air Pollution in China

This website provides near real-time daily PM2.5 retrievals from multiple data sources in China, including ground measurements, satellite retrievals, dynamically updated emission inventories, operational chemical transport model simulations and other ancillary data. The research team used a two-stage machine learning model to develop the database. _Note that this website also provides ozone data_.

To access the data, click this [link](http://tapdata.org/)

- For PM2.5

  Spatial resolution: 10km * 10km in China

  Temporal resolution: Daily average (since 2000 in a timely manner)

  More information and citation: [link1](https://arxiv.org/ftp/arxiv/papers/2103/2103.06520.pdf) and [link2](https://www.sciencedirect.com/science/article/pii/S1352231020306555).

- For ozone

  Spatial resolution: 10km * 10km in China

  Temporal resolution: Maximum daily 8 h average (MDA8). Check this [page](https://www.asl-associates.com/cal8hr.htm) to see how to calculate the MDA8.

  More information and citation: [link](https://pubs.acs.org/doi/10.1021/acs.est.0c03098)



### Data on SO2


#### OMI/Aura Sulphur Dioxide (SO2) Total Column Daily L2 Global Gridded 0.125 degree x 0.125 degree V3 (OMSO2G)

To access the data set, click this [link](https://disc.gsfc.nasa.gov/datasets/OMSO2G_003/summary).

Spatial resolution: Global; Gridded at 0.125x0.125 degree. 

Temporal resolution: Daily. 


### Data on CO2 emissions

Traditionally, CO2 emissions could be calculated based on the consumption of primary energy (i.e. coal, crude oil, and natural gas) and their [carbon emission factors](https://www.ipcc.ch/site/assets/uploads/2019/12/03COP25_2019-Refinement.pdf). However, data on primary energy usage are available only at the province level. I occasionally see papers directly measuring CO2 emissions using novel methods (machine learning) and data (nighttime lights data), which I think is very interesting. 

It should be noted that the basic idea of the direct calculation is to run a regression of province-level emission (calculated using primary energy use) on nighttime light data and then use the estimated coefficients to predict emissions at finer scales (city level and county level). These novel carbon emission data can be directly used in empirical studies though I have not seen such application in the literature. 

I create a separate section in this post to collect those CO2 emission data sources to facilitate future studies. Researchers are recommended to read the paper first before they apply the associated data to their study. 

#### County-level emission estimated using nighttime light data

The [paper](https://www.nature.com/articles/s41597-020-00736-3) was published in Scientific Reports. The authors use nighttime light data obtained from two sources to estimate county-level carbon emissions from 1997-2017. 

The data can be accessed from [here](https://figshare.com/collections/County-level_CO2_emissions_and_sequestration_in_China/5136302/2)


#### City-level emission estimated using nighttime light data

This [paper](https://www.nature.com/articles/s41598-021-81754-y) was also published in Scientific Reports. Using nighttime light data, the paper estimates the city-level emission data from 1992-2017.







