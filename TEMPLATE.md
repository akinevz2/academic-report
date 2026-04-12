---
author: |
  Author Name
title: |
  Report Title
date: \today{}
geometry: margin=2cm
documentclass: article
classoption: twocolumn
papersize: a4
bibliography: |
  ./references.bib
header-includes: |
  \usepackage{fancyhdr}
  \pagestyle{fancy}
  \fancyhead[L]{ Report Title }
  \fancyhead[R]{Author Name}

  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
...

![TOC](./src/TOC.md)
