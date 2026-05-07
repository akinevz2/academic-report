# Project Requirements

<!--This chapter defines the functional and non-functional requirements of the PDHD system, along with the development constraints that shaped what was implementable within the project timeframe. The chapter is structured as follows: the capability contract (the full spec-defined surface), the functional and non-functional requirements that govern how those capabilities operate, the hardware benchmarking methodology, and the deferred requirements that were scoped out of the implementation window.-->

<!--
## Capability Contract

The system's functionality is formally specified in `docs/spec/`, a folder containing prompt-driven specifications for each tool capability. The convention is that the title heading of every spec is a first-class prompt the system must satisfy — if the system cannot do so, the gap is a defect, not an omission.

### Capability Matrix

| #   | Capability         | Spec file               | Inputs                                                          | Expected Output                                                                               | Status      |
| --- | ------------------ | ----------------------- | --------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------- |
| 1   | Browse Directory   | `browse-directory.md`   | path, recursive, maxResults                                     | Structured list: type, name, sort order                                                       | Implemented |
| 2   | Read File          | `read-file.md`          | path, startLine, endLine, maxChars                              | Raw UTF-8 text with bounds                                                                    | Implemented |
| 3   | Write File         | `write-file.md`         | path, content, createParents, overwrite                         | Confirmation with absolute path and character count                                           | Implemented |
| 4   | Move/Rename        | `move-rename.md`        | source, destination, createParents, overwrite                   | Confirmation with resolved source and destination paths                                       | Implemented |
| 5   | Archive            | `archive.md`            | path, destination, format, includeHidden, overwrite             | Archive with entry/size statistics; rejection rules for recursive writes                      | Implemented |
| 6   | Summarise          | `summarise.md`          | path, projectId, entryUuid, persist, maxFiles, maxCharsPerFile  | FolderSummaryResponse with markdown summary                                                   | Implemented |
| 7   | Project Discovery  | `project-discovery.md`  | path, maxDepth, includeGithubOnly                               | List of discovered project roots (absolutePath, name, hasGit, remoteUrl, registeredProjectId) | Implemented |
| 8   | Path Analysis      | `path-analysis.md`      | path                                                            | Full metadata: type, exists, size, timestamps, permissions, children count, preview           | Implemented |
| 9   | Working Directory  | `working-directory.md`  | (get: none; set: path)                                          | Absolute path (get); confirmation (set)                                                       | Implemented |
| 10  | Project Knowledge  | `project-knowledge.md`  | projectId, note, tag (cache); projectId, tag, maxNotes (recall) | Cached receipt; or ordered list of notes                                                      | Implemented |
| 11  | Git Metadata       | `git-metadata.md`       | path, maxCommits, oneline (log); path (status); path (blame)    | Commit log entries; working-tree status; per-line blame                                       | Implemented |
| 12  | Semantic Search    | `semantic-search.md`    | query, projectId, maxResults, minScore                          | Ordered list of embedding chunks with score, sourcePath, text                                 | Implemented |
| 13  | Create Plan/Report | `create-plan-report.md` | type, projectId, path, title, overwrite                         | Persisted markdown document with required sections                                            | Implemented |
| 14  | Web Search         | `web-search.md`         | query, maxResults, summarise                                    | Synthesised results or raw snippets                                                           | Implemented |

**Total capabilities: 14.** All were defined in the spec folder before implementation. The implementation status column marks what reached the packaged build.

### Design Principles

These principles govern how capabilities interact and must be respected by every implementation:

1. **Prompt as contract** — if the system cannot satisfy a title-heading prompt, it is a defect.
2. **Fail loudly at boundaries** — every failure mode must surface a clear, actionable error message. Silent fallbacks are unacceptable.
3. **Absolute paths everywhere** — all path-handling capabilities resolve, normalise, and return absolute paths.
4. **Idempotent reads** — read, browse, summarise, and search operations must not mutate filesystem state.
5. **Minimal footprint writes** — write, move, archive, and knowledge-cache operations must write only to the location explicitly supplied. Implicit side-writes are prohibited unless documented.
-->

## Functional Requirements

### Model Selection and Tool-Calling Support

**Requirement**: The system was required to operate with a locally hosted model that natively supported tool-calling, within the constraints of available hardware.

**Rationale**: The system's core capability (automated repository inspection) depended on the model's ability to emit structured tool-call specifications. Models lacking native tool-calling support required manual parsing of model output, which introduced unreliability and eliminated the automation benefit that structured tool-calling provides.

**Implementation**: Model selection was an iterative process. Early iterations explored usage monitoring and accuracy verification approaches. The final selection used an evaluation harness measuring prompt accuracy and test-pass rate, with the model constrained to a VRAM budget that fits within a 24GB workstation configuration. The choice of a model capable of native tool-calling within this budget was itself a requirement — not an implementation detail — because without it the system could not function.

**Status**: Met. Qwen 3.6 provides native tool-calling support within the VRAM budget. Earlier iterations with Qwen 2.5 Coder required manual parsing, which was abandoned in favour of native tool-calling when the later model became available.

### Hardware Constraints and Multi-Host Benchmarking

**Requirement**: The benchmark evaluation was scoped to a single, fully specified hardware configuration, with any secondary-host data treated as supplementary material rather than primary evidence.

**Rationale**: Two physical machines were available for inference: a primary workstation with an NVIDIA RTX 4070 (12 GB) and an NVIDIA RTX 3060 (12 GB) (24 GB combined VRAM) and a secondary machine with a single GPU (16 GB VRAM). Cross-host comparison is desirable in principle, but the machines differ across too many uncontrolled variables — RAM speed (3200 MHz vs 3600 MHz), PCIe generation, single- vs dual-GPU topology, and the resulting differences in available model versions and context window budgets — to support controlled causal claims.

**Implementation**: All primary benchmark runs were executed on the 24 GB workstation (run `20260429_124501_ff993b17`), covering nine chat-capable Ollama models across eight scenarios with twelve repeats each. The inference host was `ws-raretower.local:11434`. Results are reported in §9 and the raw data is preserved in the benchmark SQLite database. Secondary-host data, if collected, is reserved for the appendix as a reference point only and is not used to draw conclusions.

**Status**: Met for the primary host. The full nine-model, eight-scenario evaluation suite has been executed and results recorded. Secondary-host comparison runs are out of scope for the primary analysis.

### Model Runtime Requirements

**Requirement**: The system was required to account for the resource constraints imposed by locally hosted inference, particularly GPU VRAM availability and context window budget.

**Rationale**: VRAM availability governed which models could be deployed. When a model's parameter count exceeded available GPU VRAM, Ollama performed partial offloading to system RAM, causing measurable degradation in token throughput (output tokens per second) — the primary usability metric for interactive developer tooling. Additionally, context window size was shared: conversation history, tool definitions, and retrieved knowledge competed for the same fixed token allocation, forcing architectural trade-offs.

**Implementation**: Model selection was constrained to a 24GB VRAM budget on the primary workstation. Token throughput was identified as the key usability metric: generation rates below an interactive threshold disrupted the feedback loop required for developer tools. Context window sizing required careful arbitration: injecting tool schemas at inference time consumed tokens, directly reducing capacity for conversation history and RAG-retrieved context. The system did not embed Ollama; it required externally provisioned access over the network, which had to be accounted for in both development and deployment environments.

**Status**: Met. The deployed model operates within the VRAM budget and maintains interactive token throughput. Context budgeting is explicitly managed in prompt construction.

### Development Environment RAM Requirements

**Requirement**: The development environment was required to be capable of running the full toolchain — Quarkus dev server, browser and devtools, Ollama instance, IDE/editor, and all build/test tooling — simultaneously on a machine with at least 64GB of RAM.

**Rationale**: This was identified as a constraint early in the project's lifecycle, before the academic work began. The development workload (Quarkus live reload, Ollama serving, browser devtools, IDE indexing, parallel build processes) consumed substantial main memory. A machine with only 32GB of RAM — while sufficient for a dedicated Ollama serving machine — is inadequate for development of this system in its entirety. This is a practical constraint on who can work on the project, not a limitation of the system itself.

**Implementation**: The Ollama serving machine (32GB RAM, 3600MHz) runs Ollama dedicated. The development machine (64GB RAM, 3200MHz) runs the full development workload: Quarkus, browser, IDE, and CI tooling. The 64GB requirement was confirmed during initial development and has been necessary throughout.

**Status**: Met. Project development has been conducted on a 64GB machine. No attempt was made to develop on a 32GB machine, as the constraint was known beforehand.

### Benchmarking and Verification Framework

**Requirement**: The system was required to provide the capability to run benchmarks — including JUnit/Quarkus integration tests, scenario-based evaluation, metric instrumentation, and repeated scenario runs — against which reliability and performance claims could be evidenced.

**Rationale**: Academic validity required measurable, repeatable evaluation. Without a benchmark framework, claims could not be distinguished from anecdote. The benchmarks were required to exercise all 14 capability specs as executable test cases, not as descriptive documents alone.

**Implementation**: Benchmarks are implemented as Java integration tests (JUnit + Quarkus) that exercise each tool capability from the spec folder. These tests are wired to the BenchLam harness (defined in `scripts/benchlam/`) which runs them as scenario-based evaluations, collecting pass/fail rates, latency distributions, and failure-category frequency. The multi-host capability described above allows cross-hardware comparison of model performance.

**Status**: Met. The full capability surface is covered by integration tests running in the benchmark harness.

### Testing and Verification

**Requirement**: The system was verified against its requirements through automated testing, including coverage of the full spec-defined capability surface and cross-model/machine comparison where relevant.

**Rationale**: Verification was a fundamental engineering requirement. Without it, functional correctness could not be established, and evaluation claims would lack foundation.

**Implementation**: The most time-consuming requirement to implement was the testing harness and verification pipeline. Many tests were partially delegated to the LLM coding agent. The multi-provider interface was explicitly deferred as out of scope — too much work to implement within the available time on top of other priorities.

**Status**: Partially met. Automated testing covers the capability surface defined in `docs/spec/`. Cross-model comparison is deferred due to the multi-provider interface not being implemented.

### Multi-Provider Support

**Requirement**: The system was required to support multiple LLM providers (local and remote) rather than being locked to a single backend.

**Rationale**: Vendor lock-in was a well-documented risk in LLM systems. Multi-provider support would have enabled portability and risk mitigation.

**Implementation**: Explicitly deferred during implementation because the added complexity would have exceeded the development time. This deferral is a deliberate scope management decision, not an oversight.

**Status**: Deferred. Out of scope for this implementation.

## Non-Functional Requirements

### Maintainability

**Requirement**: The system was designed to support incremental changes without cascading refactors, with clear boundaries between layers.

**Rationale**: The project's value lay not only in its features but in its structure as a research artefact. Maintainability ensured that the system could be inspected, modified, and understood by others who evaluated it.

**Implementation**: The architecture separates tool-dispatch from UI orchestration, and tool-dispatch from persistence. Each boundary is explicit in the package structure, making it possible to modify one layer without affecting others.

**Status**: Met. The layered architecture served its purpose during both initial implementation and later refactoring.

### Spec Boundary Management

**Requirement**: When using an autonomous or semi-autonomous code generator, the system was required to include mechanisms to keep generated code within the intended architectural boundaries.

**Rationale**: This is a requirement that emerged during development. Traditional projects have static requirements — the implementation produces one-time. When using an autonomous generator, scope becomes a continuous steering problem. The generator produces coherent output (to itself) rather than coherent output (to your spec). The requirement, therefore, was not just to define the system but to continuously constrain what the generator was permitted to implement.

The boundary between "what the spec allows" and "what the agent implements" was the hardest constraint to define during this project. Qwen 2.5 Coder lacked the instruction-following stability to implement autonomously; GPT-5.1 (Copilot) unlocked autonomous development but required explicit style and architecture steering to prevent drift. This revealed a key insight: when using an autonomous generator, scope was no longer a static requirement but a dynamic control problem.

**Status**: Met. Explicit constraints were documented and the generator was steered through iterative re-specification rather than through autonomous completion of the entire codebase. The capability spec folder (`docs/spec/`) and its conversion to Java integration tests is itself a boundary-management mechanism: the specs were the contract the generator was required to honour, and the tests were the verification that it did.

<!--
## Deferred Requirements

The following requirements were scoped out of the implementation window:

- **DR-1: Multi-provider interface** — the added complexity exceeds the available time on top of other priorities
- **DR-2: Automated project completion estimation** — the system can document scope but does not infer completion percentages or maturity scores
- **DR-3: Embedded model for local semantic indexing** — the semantic search capability requires a separate embedding model pipeline that was not implemented
-->
