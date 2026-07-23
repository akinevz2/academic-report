# Introduction

This report investigates how locally hosted Large Language Models (LLMs) can be integrated into a software system for project inspection and repository analysis under practical engineering constraints. The implemented artefact, PDHD (Project Discovery and Hierarchical Data), combines a Quarkus backend, a web frontend, and tool-mediated interaction with local models to support filesystem exploration, file analysis, and project-level summarisation.

The work addresses two linked concerns. First, can a locally deployed LLM-assisted architecture produce useful, evidence-grounded project summaries without relying on hosted APIs? Second, how effective is agentic coding as a development workflow when measured against conventional software engineering concerns such as maintainability, validation effort, and operational reliability?

To evaluate these questions in a realistic setting, the system was built around local inference. Ollama was used as the model runtime, with an NVIDIA RTX 4070 (12 GB) and an NVIDIA RTX 3060 (12 GB) — 24 GB combined VRAM — defining the practical resource envelope for model selection and execution.

The report therefore treats LLMs in a dual role: as runtime components inside the application, and as development assistants during design and implementation. Rather than presenting only implementation progress, the report aims to evaluate the architecture and workflow against explicit objectives, constraints, and evidence.

## Research Questions

1. **Capability under local constraints.** What task-completion accuracy and response-latency profile does the PDHD agent achieve across bounded filesystem and project-inspection scenarios when running exclusively on local inference hardware?

2. **Reliability and maintainability of the dispatch architecture.** How do CDI-managed tool dispatch and transaction-scoped persistence affect tool-invocation reliability, argument-validation failure rates, and the maintainability of the system over iterative development?

3. **Scope and value of bounded agentic workflows.** To what extent do locally constrained, tool-visible agentic workflows deliver useful outcomes when the task scope is explicitly bounded by available hardware, model capability, and toolset design?

- [#objectives](./objectives.md)
- [#report-structure](./report-structure.md)
- [#overview](./overview/overview.md)
