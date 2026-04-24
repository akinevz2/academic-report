# Project Description

Software repositories often contain enough implementation evidence to infer project purpose, maturity, and likely next steps, yet this evidence is distributed across files and difficult to inspect quickly. PDHD (Project Discovery and Hierarchical Data) was designed as a project-inspection system to address this problem by combining filesystem exploration, tool-mediated analysis, and LLM-assisted summarisation.

The chapter frames PDHD as both an implemented software artefact and a constrained engineering study. The implementation context is intentionally practical: local model execution, limited hardware, and incremental integration into a real development workflow. Within those boundaries, the project contributes a structured approach to repository analysis that emphasises explicit tool boundaries, persisted project knowledge, and evidence-grounded output generation.

The following sections define scope and methodology so that subsequent architecture and results chapters can be interpreted against clear boundaries rather than retrospective narrative.

- [#scope](./scope.md)
- [#methodology](./methodology.md)
