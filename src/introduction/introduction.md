# Introduction

This report investigates how locally hosted Large Language Models (LLMs) can be integrated into a software system for project inspection and repository analysis under practical engineering constraints. The implemented artefact, PDHD (Project Discovery and Hierarchical Data), combines a Quarkus backend, a web frontend, and tool-mediated interaction with local models to support filesystem exploration, file analysis, and project-level summarisation.

The work addresses two linked concerns. First, can a locally deployed LLM-assisted architecture produce useful, evidence-grounded project summaries without relying on hosted APIs? Second, how effective is agentic coding as a development workflow when measured against conventional software engineering concerns such as maintainability, validation effort, and operational reliability?

To evaluate these questions in a realistic setting, the system was built around local inference. Ollama was used as the model runtime, with two NVIDIA RTX 3060 GPUs (24GB combined VRAM) defining the practical resource envelope for model selection and execution.

The report therefore treats LLMs in a dual role: as runtime components inside the application, and as development assistants during design and implementation. Rather than presenting only implementation progress, the report aims to evaluate the architecture and workflow against explicit objectives, constraints, and evidence.

## Research Questions

> Following the framing of LLMs in a dual role as both runtime component and development assistant, this section previously posed three research questions covering the practical utility of local LLM-assisted project inspection without hosted APIs, the architectural drivers of reliability in tool-calling workflows, and the tradeoffs of agentic coding as a primary development method; the questions as written reflected the original dual-scope rather than the final report's primary focus on benchmarking the PDHD agent's capabilities against a defined set of tool-callable operations.

- [#objectives](./objectives.md)
- [#report-structure](./report-structure.md)
- [#overview](./overview/overview.md)
