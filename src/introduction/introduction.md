# Introduction

This report investigates how locally hosted Large Language Models (LLMs) can be integrated into a software system for project inspection and repository analysis under practical engineering constraints. The implemented artefact, PDHD (Project Discovery and Hierarchical Data), combines a Quarkus backend, a web frontend, and tool-mediated interaction with local models to support filesystem exploration, file analysis, and project-level summarisation.

The work addresses two linked concerns. First, can a locally deployed LLM-assisted architecture produce useful, evidence-grounded project summaries without relying on hosted APIs? Second, how effective is agentic coding as a development workflow when measured against conventional software engineering concerns such as maintainability, validation effort, and operational reliability?

To evaluate these questions in a realistic setting, the system was built around local inference. Ollama was used as the model runtime, with two NVIDIA RTX 3060 GPUs (24GB combined VRAM) defining the practical resource envelope for model selection and execution.

The report therefore treats LLMs in a dual role: as runtime components inside the application, and as development assistants during design and implementation. Rather than presenting only implementation progress, the report aims to evaluate the architecture and workflow against explicit objectives, constraints, and evidence.

## Research Questions

1. To what extent can a local LLM-assisted system generate grounded and practically useful project-inspection outputs?
2. Which architectural decisions most strongly affect reliability and maintainability in tool-calling LLM workflows?
3. What benefits and limitations emerge when agentic coding is used as a primary development method?

- [#objectives](./objectives.md)
- [#report-structure](./report-structure.md)
- [#overview](./overview/overview.md)
