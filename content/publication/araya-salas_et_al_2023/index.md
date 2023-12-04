---
# Documentation: https://wowchemy.com/docs/managing-content/

title: 'baRulho: an R package to quantify degradation in animal acoustic signals'
subtitle: ''
summary: ''
authors:
- admin
- Erin E. Grabarczyk, 
- Marcos Quiroz-Oliva
- Adrián García-Rodríguez
- Alejandro Rico-Guevara
tags:
- Animal behavior
- Sound degradation
- R packages
- Bioacoustics
categories: []
date: '2023-11-22'
lastmod: 2023-11-22
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
publishDate: '2023-11-22'
publication_types:
- '3'
abstract: Animal acoustic signals are shaped by selection to convey information based on their tempo, intensity, and frequency. However, sound degrades as it propagates over space and across physical obstacles (e.g., vegetation or infrastructure), which affects communication potential. Therefore, transmission experiments are designed to quantify change in signal structure in a given habitat by broadcasting and re-recording animal sounds at increasing distances. We introduce ‘baRulho’, an R package designed to simplify the implementation of sound transmission experiments. We highlight the package features with a case study testing the effects of habitat and acoustic structure on signal transmission. Synthesized sounds that varied in frequency, duration, and frequency and amplitude modulation were broadcast and re-recorded at five increasing distances in open and closed understory at the Bosque de Tlalpan, Mexico City. With this data, we showcase baRulho’s functions to prepare master sound files, annotate re-recorded test sounds, as well as to calculate and visualize measures that quantify degradation of acoustic signals in the time and frequency domain. Degradation measures in baRulho adequately quantified acoustic degradation, following predicted patterns of sound transmission in natural environments. Re-recorded signals degraded less in open habitats compared to closed habitats, with higher-frequency sounds exhibiting more degradation. Furthermore, frequency modulated sounds degraded to a greater extent than pure tones. The increased attenuation and reverberation observed in higher frequency sounds and closed habitats suggest that factors such as absorption and scattering by vegetation play significant roles in transmission patterns. The R package ‘baRulho’ provides an open-source, user-friendly suite of tools designed to facilitate analysis of animal sound degradation. Notably, it offers similar results to other sound analysis software but with significantly reduced processing time. Moreover, the package minimizes the potential for user error through automated test file annotation and verification procedures. We hope that baRulho can help enhance accessibility to transmission experiments within the research community, ultimately contributing to a deeper understanding of the ecological drivers of animal communication systems.
publication: '*BioRxiv*'
url_pdf: uploads/araya-salas_et_al_2023.pdf
links:
- name: URL
  url: https://www.biorxiv.org/content/10.1101/2023.11.22.568305v1
- name: Supp Mat
  url: https://doi.org/10.6084/m9.figshare.21559074.v3
- name: Repository
  url: https://github.com/maRce10/barulho_paper
- name: Presentation
  url: https://rstudio-pubs-static.s3.amazonaws.com/1123313_76c0b1820ca24b0c97fb2afa81b787f7.html
---
