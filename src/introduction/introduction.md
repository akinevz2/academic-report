# Introduction

In this project, I set out to build an application that interfaces directly with Large Language Models (LLMs), specifically a filesystem exploration assistant powered by locally-run models. The technical goal was paired with a personal engineering objective: to push my limits as a software developer by using LLM-powered agentic coding as a core development method rather than as a peripheral convenience.

My interest in local LLMs grew from hands-on experimentation on my gaming computer, where I quickly saw their practical capability. Instead of treating that experience as a one-off experiment, I used it as the starting point for a structured software engineering project that combines application feature delivery with methodological evaluation.

To support this work in a realistic environment, I built a local inference stack rather than relying on external hosted APIs. I installed Ollama to run a local AI server and invested in two NVIDIA RTX 3060 graphics cards, each with 12GB of VRAM, providing a combined 24GB memory budget for model execution.

This setup enabled me to evaluate a full dual-role workflow: LLMs as part of the application runtime, and LLMs as an active engineering assistant during design, implementation, and refinement. The report therefore examines both what was built and how this agentic development approach performed under practical constraints.

- [#objectives](./objectives.md)
- [#report-structure](./report-structure.md)
- [#overview](./overview/overview.md)
