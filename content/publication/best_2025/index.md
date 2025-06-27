---
# Documentation: https://wowchemy.com/docs/managing-content/

title: 'Bioacoustic fundamental frequency estimation: a cross-species dataset and deep learning baseline'
subtitle: ''
summary: ''
authors:
- Paul Best
- admin
- Axel G. Ekström
- Bárbara Freitas
- Frants H. Jensen
- Arik Kershenbaum
- Adriano R. Lameira
- Kenna D. S. Lehmann
- Pavel Linhart
- Robert C. Liu
- Malavika Madhavan
- Andrew Markham
- Marie A. Roch
- Holly Root-Gutteridge
- Martin Šálek
- Grace Smith-Vidaurre
- Ariana Strandburg-Peshkin
- Megan R. Warren
- Matthew Wijers
- Ricard Marxer


tags:
- Fundamental frequency 
- vocalisation analysis 
- cross-species dataset
- deep learning

categories: []
date: '2025-06-02'
lastmod: 2025-06-02
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
publishDate: '2025-06-02'
publication_types: 
- '2'
abstract: The fundamental frequency (F0) is a key parameter for characterising structures in vertebrate vocalisations, for instance defining vocal repertoires and their variations at different biological scales (e.g. population dialects, individual signatures). However, the task is too laborious to perform manually, and its automation is complex. Despite significant advancements in the fields of speech and music for automatic F0 estimation, similar progress in bioacoustics has been limited. To address this gap, we compile and publish a benchmark dataset of over 250,000 calls from 14 taxa, each paired with ground truth F0 values. These vocalisations range from infra-sounds to ultra-sounds, from high to low harmonicity, and some include non-linear phenomena. Testing different algorithms on these signals, we demonstrate the potential of neural networks for F0 estimation, even for taxa not seen in training, or when trained without labels. Also, to inform on the applicability of algorithms to analyse signals, we propose spectral measurements of F0 quality which correlate well with performance. While current performance results are not satisfying for all studied taxa, they suggest that deep learning could bring a more generic and reliable bioacoustic F0 tracker, helping the community to analyse vocalisations via their F0 contours.

publication: '*Bioacoustics*'
url_pdf: uploads/best_et_al_2025.pdf
links:
- name: URL
  url: https://www.tandfonline.com/doi/full/10.1080/09524622.2025.2500380
- name: Supp Mat
  url: https://doi.org/10.5061/dryad.prr4xgxw8
- name: Repository
  url: https://github.com/mim-team/bioacoustic_F0_estimation
- name: Outline
  url: https://www.ricardmarxer.com/f0-bioacoustics/
---
