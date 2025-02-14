---
# Documentation: https://wowchemy.com/docs/managing-content/

title: 'Quantifying degradation in animal acoustic signals with the R package baRulho'
subtitle: ''
summary: ''
authors:
- admin
- Erin E. Grabarczyk
- Marcos Quiroz-Oliva
- Adrián García-Rodríguez
- Alejandro Rico-Guevara

tags:
- Sound propagation
- Acoustic adaptation 
- acoustic adaptation
- animal communication
- attenuation
- sound transmission

categories: []
date: '2025-01-25'
lastmod: 2025-01-25
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
publishDate: '2025-01-25'
publication_types: 
- '2'
abstract: Animal acoustic signals are shaped by selection to convey information based on their tempo, intensity, and frequency. However, sound signals degrade as they transmit over space and across physical obstacles (e.g., vegetation or infrastructure), which affects communication potential. Therefore, propagation experiments are designed to quantify changes in signal structure in a given habitat by broadcasting and re-recording animal sounds at increasing distances. We introduce ‘baRulho’, an R package designed to simplify the implementation of sound propagation experiments. We highlight the package features with a case study testing the effects of habitat and acoustic structure on signal propagation, two common factors evaluated in such experiments. Synthesized sounds that varied in frequency, duration, and frequency and amplitude modulation were broadcast and re-recorded at five increasing distances in open and closed understory at the Bosque de Tlalpan, Mexico City. With this data, we showcase baRulho's functions to prepare master sound files, annotate re-recorded test sounds, as well as to calculate and visualize measures that quantify the degradation of acoustic signals in the time and frequency domain. Degradation measures in baRulho adequately quantified acoustic degradation, following predicted patterns of sound propagation in natural environments. Re-recorded signals degraded less in open understory compared to closed understory, with higher-frequency sounds exhibiting more degradation. Furthermore, frequency modulated sounds degraded to a greater extent than pure tones. The increased attenuation and reverberation observed in higher frequency sounds and closed habitats suggest that factors such as absorption and scattering by vegetation play significant roles in propagation patterns. The R package ‘baRulho’ provides an open-source, user-friendly suite of tools designed to facilitate the analysis of animal sound degradation. Notably, baRulho offers similar results to other sound analysis software but with significantly reduced processing time. Moreover, the package minimizes the potential for user error through automated test file annotation and verification procedures. We hope that baRulho can help enhance accessibility to propagation experiments within the research community, ultimately contributing to a deeper understanding of the ecological drivers of animal communication systems.

publication: '*Methods in Ecology and Evolution*'
url_pdf: https://besjournals.onlinelibrary.wiley.com/doi/epdf/10.1111/2041-210X.14481
links:
- name: URL
  url: https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.14481
- name: Supp Mat
  url: https://doi.org/10.6084/m9.figshare.21559074
- name: Repository
  url: https://github.com/maRce10/barulho_paper
- name: Review history
  url: https://www.webofscience.com/api/gateway/wos/peer-review/10.1111/2041-210X.14481
- name: Preprint
  url: https://www.biorxiv.org/content/10.1101/2023.11.22.568305v1
- name: Presentation
  url: https://rstudio-pubs-static.s3.amazonaws.com/1130250_d0d6643a30754e408155ab07f2e7bd07.html
---
