---
author: |
  Kirill Nevzorov
  under supervision \
  of Prof. Christopher Buckley \
  University of Sussex \
  School of Engineering and Informatics
email: "kn253@sussex.ac.uk"
title: |
  Project Discovery and Hierarchical Data
date: \today{}
geometry: margin=2cm
documentclass: article
classoption: a4paper
papersize: a4
bibliography: |
  ./references.bib
header-includes: |
  \usepackage{fancyhdr}
  \usepackage{url}
  \usepackage{xcolor}
  \hypersetup{
    colorlinks=true,
    linkcolor=black,
    urlcolor=blue,
    citecolor=black,
    linktoc=all
  }
  \pagestyle{fancy}
  \fancyhead[L]{ Project Discovery and Hierarchical Data }
  \fancyhead[R]{181472 Kirill Nevzorov}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
  \raggedbottom
abstract: |
  This report presents the design and implementation of an LLM-powered developer assistant built with a Quarkus backend and a web frontend. The central value of the system lies in its workflow: enabling a developer to query project history, explore repository state, and interrogate git artefacts through a natural-language interface rather than through manual inspection of command output. Beyond workflow convenience, the project demonstrates that structuring project knowledge as hierarchically organised package-level data improves modularity and maintainability, making it easier to isolate responsibilities, evolve components incrementally, and reason about the implementation impact of new features across the codebase.

  The implementation applies conventional software engineering practices, including CDI-managed dispatch, transaction-scoped persistence, and iterative refinement through staged development and testing. The final build represents a partial realisation of the intended system: Quarkus build-time CDI compilation introduced packaging-stage regressions, and the toolset remained constrained to a minimal working subset. The report therefore presents both the practical strength of the workflow and architecture-level design choices, and an honest account of the remaining gap between the intended design and the delivered artefact.
...

\pagebreak{}

[#introduction](./introduction/introduction.md)
[#background](./background/background.md)
[#project-description](./project-description/project-description.md)
[#project-architecture](./project-architecture/project-architecture.md)
[#implementation-gantt](./implementation-gantt.md)
[#results-and-discussion](./results-and-discussion/results-and-discussion.md)
[#conclusion](./conclusion/conclusion.md)
[#appendices](./appendices/appendices.md)
