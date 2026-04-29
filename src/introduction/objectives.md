## Objectives

The project objectives are organised into two strands: technical delivery and workflow evaluation. The initial scope was revised from low-level resource governance to application-level project inspection so that the implementation effort remained aligned with the report's central research questions.

### Strand A: Technical Delivery

The technical objectives define what the PDHD system must be capable of demonstrating under local runtime constraints. Each objective corresponds to a capability group that is measurable through the benchmark suite (see Appendix: Benchmark Scenarios) and evidenced in §9.

1. **Single-step retrieval capability.** Demonstrate reliable completion of bounded single-step tasks — working directory query, project listing, directory enumeration, and file reading — with a measurable task-completion accuracy across repeated runs.
2. **Multi-step orchestration capability.** Demonstrate that the system can chain tool calls across a multi-step folder exploration scenario, with accuracy and failure rates reported per scenario.
3. **Security boundary enforcement.** Demonstrate that out-of-project file access is consistently blocked by the system regardless of model or prompt, with 100% enforcement across all evaluated models.
4. **Tool dispatch reliability.** Measure argument-validation failure rates and tool-invocation error distributions across the full model set, using runtime telemetry captured from the Quarkus backend.

### Strand B: Workflow Evaluation

1. Characterise how agentic coding affected implementation speed, structure, and rework.
2. Evaluate whether generated outputs remained aligned with developer intent and engineering constraints.
3. Identify limitations and failure patterns that constrained reliability.
