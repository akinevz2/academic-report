---
author: |
  Kirill Nevzorov
  under supervision \
  of Prof. Christopher Buckley \
  University of Sussex \
  School of Engineering and Informatics
email: "kn253@sussex.ac.uk"
title: |
  Systems Engineering of LLM Workstation
date: \today{}
geometry: margin=2cm
documentclass: article
classoption: twocolumn, a4paper
papersize: a4
bibliography: |
  ./references.bib
header-includes: |
  \usepackage{fancyhdr}
  \usepackage{url}
  \pagestyle{fancy}
  \fancyhead[L]{ Systems Engineering of LLM Workstation }
  \fancyhead[R]{181472 Kirill Nevzorov}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
  \raggedbottom
abstract: |
  This report presents the design and implementation of an LLM-powered workstation application built with a Quarkus backend and a web frontend. Structured analysis of local project artifacts through a tool-calling workflow is created in which an LLM orchestrates exploration, reading, and summarization operations. Rather than treating LLM assistance as ad hoc code generation, the project applies conventional software engineering practices, including modular architecture, explicit interfaces, validation checks, and iterative refinement. The report documents the runtime architecture for tool dispatch, alias resolution, transaction-scoped execution, and read-context persistence, with attention to safety controls such as path validation and constrained filesystem traversal. Development and evaluation were conducted in a home-lab setting using off-the-shelf models and standard engineering tooling. The findings highlight practical trade-offs between development speed, maintainability, and robustness when integrating LLMs into software engineering workflows.
...

# Table of Contents
1. [Introduction](#introduction)
2. [Java with Quarkus - Overview](#overview)
3. [Coding with LLMs - Background](#background)
4. [LLM Powered Software - Software Architecture](#architecture)
5. [Project Description](#project-description)
6. [Project Overview](#project-overview)
7. [Engineering at Home](#engineering-at-home)
8. [Results and Discussion](#results-and-discussion)

[#introduction](./introduction/introduction.md)
[#overview](./overview/java-with-quarkus-overview.md)
[#background](./background/coding-with-llms-background.md)
[#architecture](./architecture/llm-powered-software-architecture.md)
[#project-description](./project-description/project-description.md)
[#project-overview](./project-overview/project-overview.md)
[#engineering-at-home](./engineering-at-home/engineering-at-home.md)
[#results-and-discussion](./results-and-discussion/results-and-discussion.md)