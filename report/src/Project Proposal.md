---
author: "Kirill Nevzorov"
email: "kn253@sussex.ac.uk"
title: |
    Project Proposal for PC16:\linebreak{}
    "Web browsing using hierarchy visualisation"
date: \today{}
geometry: margin=2cm
header-includes: |
    \usepackage{fancyhdr}
    \pagestyle{fancy}
    \fancyhead[L]{Project Proposal for PC16}
    \fancyhead[R]{181472 Kirill Nevzorov}
    \fancyfoot[C]{\thepage}
    \renewcommand{\headrulewidth}{0.4pt}
...

- **Student Name:** 
    : Kirill Nevzorov

- **Student Number:**
    : 181472

- **Course:**
    : Computer Science

- **Email address:**
    : kn253@sussex.ac.uk

- **Project title:**
    : Web browsing using hierarchy visualisation

- **Supervisor:**
    : Prof. Peter Cheng

### Introduction

:::columns

Websites are largely hierarchical network structure.  Humans easily understand hierarchies.  
Effective visualisations of hierarchical structures exist.

However, typical web browsers hide the hierarchical structure of websites, which negatively impacts their usability. This project seek to design, build and test a web browser tool that exploits hierarchy visualisations as a core mode of navigation.

:::

Key challenges include: what information to show at each node; how to dynamically reveal and hide parts of the hierarchy; how to support lookahead down the hierarchy. The usability of the interface will be compared to traditional web browsers.

## Aims

I aim to develop a package and a software artefact. These will work in tandem to provide decompositions of a website as a link tree graph. A library of code will be produced that will aid in extracting the structure of a website in a portable data interchange format, as well as a software one can run on their desktop computer to navigate the produced structure. Making this software into a single package will allow for this project accessible for users and other developers.
 
The software will put an emphasis on navigating the structure using the keyboard. This tool should aid in visualising hierarchical information normally hidden by markup, and empower traversal of this information by human agents.

For evaluation of successful presentation, a system will be produced that allows rapidly prototyping the interface and comparing the results. Screen capture will be automated to perform snapshots of the interface at various stages of development. A simple suite of deeply linked pages will be used to test the performance of the tool.

## Goals 

- The implementation will consist of:
    - a browser wrapper component,
    - a page link-tree decomposition component,
    - a visulisation display component.
- This project will need to employ the Electron Framework.
- An ECS framework can be used to manage the state of the application. 

## Objectives and Timeline

- investigate (week4):
  - visualisation tools and techniques available online
  - performance and developer ergonomic workflows for rapid prototyping
- compose a Docker development image for code dependency management (week5)
- produce a CI/CD workflow to enable testing of the code (week7)
- develop a package that produces a set of links in an interchangeable format (week10)
- develop an application that consumes a data structure to produce a graphical visualisation (week14)
- analyse and document the process of evolution of the UI (week16)

### Optional Objectives

- publish the specification of the data format for public use
- package the application using Electron for desktop use
- integrate an LLM in order to describe the data produced
- decorate the nodes in the graph with dynamic information from the LLM
- add developer-centric functionality to the project
  - analyse the load times of the pages
  - analyse the accessibility of the links
  - procure insights on how a user might navigate the website

## Terminology

Link Tree

: is a page that visually represents the set of pages that are traversable on a given website in an accessible manner using a graph structure. This enable a mouse/keyboard-agnostic traversal method to aid in navigation of the website.

CI/CD

: is continuous integration / development environment that enables automation of project code soundness verification. Code can be uploaded to a repository configured with CI/CD and automatically trigger a remote build that can check for regressions, functionality, and performance.

LLM

: is an AI model for analysis and transformation of textual data. Commonly used as conversational agents, this tool can allow us to convert data between various formats. We can employ one as a post-processing step in order to extract summaries of some structure within a website.

## Deliverables

- Project Plan
- Critical Path Analysis
- Requirements Documentation
- Time Estimates & Projections
- Test Plan
- Software Repository
- User Documentation

## Relevance

This project will allow me to improve my skills by using technologies that I expect to be useful in the future.
Building a browser is a complex task that requires lots of pre-existing knowledge of web development practices.

By integrating with Chromium I will learn to build desktop applications the modern way, building on my background of Java Swing and JavaFX. I will also practice using modern tooling such as Vite and TypeScript.

By building a complete application package I will improve my practices as a software developer. I will solidify my understanding of the software development lifecycle, usage of git and GitHub, and practice using GitHub Actions to set up a CI/CD pipeline.

\pagebreak{}

## Resources 

There are many packages that achieve functionality that can be useful in this application.

Vis-Network

: https://www.npmjs.com/package/vis-network

V-Network-Graph

: https://www.npmjs.com/package/v-network-graph

ECS Libraries

: https://www.webgamedev.com/code-architecture/ecs

Electron

: https://www.electronjs.org/docs/latest/

## Constraints

1. Keyboard constraint

    : The application should be keyboard accessible. This will be achieved by adding keyboard accelerators to functions in the application. The navigation page should also have proper focus management set up.

2. Modality constraint

    : The features of the UI must be accessible without the use of a mouse. This entails the reliance on menus. Every menu should be accessible via a keyboard shortcut.

3. Accessibility constraint

    : The application should override and implement as much functionality as possible within existing tools. Standard keyboard shortcuts should be used to navigate the application. Existing tooling should be invoked such that the application does not need end user configuration in order to function.

## Bibliography

- https://dl.acm.org/doi/abs/10.1145/882082.882094
- https://guides.lib.k-state.edu/c.php?g=181742&p=1197430
- https://news.ycombinator.com/item?id=41132095
- https://ieeexplore.ieee.org/abstract/document/4271965
- https://ieeexplore.ieee.org/abstract/document/1173148
- https://dev.to/dubisdev/creating-your-first-tauri-app-with-react-a-beginners-guide-3eb2
- https://www.electronjs.org/docs/latest/api/base-window
- https://www.electronjs.org/docs/latest/tutorial/ipc