# Introduction

Effective software design often relies on iterative and incremental refinement of both code and text-based documentation.

However, untraditional workflows can fragment the code and thought process the developers construct while writing an application, requiring constant context switching between development environments, notetaking applications, and external tools.

A novel way to take notes with the help of LLMs (Large Language Models) is proposed, and we wish to make the process of interacting with the AI as deterministic as possible. We aim to expand on existing techniques by implementing a process of procedural validation, and aim to create an application that is able to aid the user in a predictable manner, harnessing the power of text transformers.

In previous years of study, I have produced `pagerts`, an application with behaviour similar to a web scraper. I was curious how its build process affected the runtime of the application. When installing it to the system repository it would somehow begin to exhibit correct behaviour, yet running it from the local installation folder it would perform like a highly unoptimised code.

To address the issue and produce the report document elaborating on the matter, which was only possible to produce through trial and error, I had to discover that the package was running effectively from system shared library path, yet when installed as a `node.js` package in a development folder it would have to call across multiple system boundaries in order to open the code necessary to function effectively.