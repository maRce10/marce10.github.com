---
# Documentation: https://wowchemy.com/docs/managing-content/

title: 'ohun: An R package for diagnosing and optimizing automatic sound event detection'

subtitle: ''
summary: ''
authors:
- admin
- Grace Smith-Vidaurre
- Gloriana Chaverri
- Juan C. Brenes
- Fabiola Chirino
- Jorge Elizondo-Calvo
- Alejandro Rico-Guevara

tags:
- animal vocalizations
- bioacoustics
- sound event detection

categories: []
date: '2023-07-10'
lastmod: 2023-04-28T11:33:34-06:00
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
publishDate: '2023-04-28T18:12:06.323542Z'
publication_types:
- '2'
abstract: 'Animal acoustic signals are widely used in diverse research areas due to the relative ease with which sounds can be registered across a wide range of taxonomic groups and research settings. However, bioacoustics research can quickly generate large data sets, which might prove challenging to analyse promptly. Although many tools are available for the automated detection of sounds, choosing the right approach can be difficult and only a few tools provide a framework for evaluating detection performance. Here, we present ohun, an R package intended to facilitate automated sound event detection. ohun provides functions to diagnose and optimize detection routines, compare performance among different detection approaches and evaluate the accuracy in inferring the temporal location of events. The package uses reference annotations containing the time position of target sounds in a training data set to evaluate detection routine performance using common signal detection theory indices. This can be done both with routine outputs imported from other software and detections run within the package. The package also provides functions to organize acoustic data sets in a format amenable to detection analyses. In addition, ohun includes energy-based and template-based detection methods, two commonly used automatic approaches in bioacoustics research. We show how ohun can be used to automatically detect vocal signals with case studies of adult male zebra finch Taenopygia gutata songs and Spixs disc-winged bat Thyroptera tricolor ultrasonic social calls. We also include examples of how to evaluate the detection performance of ohun and external software. Finally, we provide some general suggestions to improve detection performance.'
publication: '*Methods in Ecology and Evolution*'
url_pdf: uploads/araya-salas_et_al_2023.pdf
links:
- name: URL
  url: https://doi.org/10.1111/2041-210X.14170
- name: Supp Mat
  url: https://doi.org/10.6084/m9.figshare.21675692.v9
- name: Repository
  url: https://github.com/maRce10/ohun_paper_data
  
---
