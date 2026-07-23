---
author: |
  Kirill Nevzorov \
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
classoption: twocolumn,a4paper
papersize: a4
bibliography: |
  ./static/references.bib
header-includes: |
  \usepackage{fancyhdr}
  \usepackage{url}
  \usepackage{xcolor}
  \pagestyle{fancy}
  \fancyhead[L]{ Project Discovery and Hierarchical Data }
  \fancyhead[R]{181472 Kirill Nevzorov}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
  \raggedbottom
  \usepackage{ltabptch}
abstract: |
  This report presents the design and implementation of an LLM-powered developer assistant built with a Quarkus backend and a web frontend, and evaluates it through an agentic model analysis lens. The central value of the system lies in its workflow: enabling a developer to query project history, explore repository state, and interrogate git artefacts through a natural-language interface rather than through manual inspection of command output. Beyond workflow convenience, the project demonstrates that structuring project knowledge as hierarchically organised package-level data improves modularity and maintainability, making it easier to isolate responsibilities, evolve components incrementally, and reason about the implementation impact of new features across the codebase.

  The implementation applies conventional software engineering practices, including CDI-managed dispatch, transaction-scoped persistence, and iterative refinement through staged development and testing. Findings are interpreted as constrained engineering evidence, with emphasis on reliability, orchestration behavior, and failure patterns rather than universal benchmark claims.

  Determining the scope of the project depended on model selection, and model selection was itself constrained by which capabilities could realistically be implemented given resources and hardware available at each stage of development. The toolset was therefore scoped iteratively: features were admitted or deferred based on whether the chosen model — fixed at `gemma3:latest` with a 32 k-token context window — could exercise them reliably within the benchmark timeout budget (see Appendix: Evaluation Environment Specification and Appendix: Benchmark Scenarios). During the final implementation sprint, newer and more capable yet more compact models became available — including `devstral:latest`, `gemma4:e4b`, and `gpt-oss:20b` — whose reduced memory footprint would have permitted more aggressive parallelism and a broader default toolset. The arrival of these models mid-sprint is noted as a changing constraint that influenced what was practical to demonstrate within the submission window; the implications for future work are discussed in the conclusion. The final build represents a partial realisation of the intended system:

  Quarkus build-time CDI compilation introduced packaging-stage regressions, and the toolset remained constrained to a working subset reflecting both framework limitations and the model landscape at the time of implementation. The report therefore presents both the practical strength of bounded agentic workflows and an honest account of the remaining gap between intended design and delivered artefact.
...

[TOC](./src/TOC.md)
