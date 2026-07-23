## Methodology

The project follows a design-and-evaluation methodology tailored to a practical engineering artefact. The process combines implementation work with structured reflection on architectural outcomes and workflow behaviour, with specific emphasis on agentic model analysis under constrained local-runtime conditions.

### Phase 1: Problem Framing and Requirements

1. Define the project-inspection problem and constrain it to application-level workflows.
2. Specify functional goals (inspection, summarisation, persistence) and non-functional constraints (local inference, bounded resources, maintainability).
3. Establish a chapter-level evidence plan so claims in later sections are tied to observable artefacts and measurable workflow outcomes.

### Phase 2: Architecture and Implementation

1. Design a layered system with explicit boundaries between UI, orchestration, tool execution, and persistence.
2. Implement core features through iterative cycles using conventional engineering practices (modularisation, refactoring, and interface-focused design).
3. Use LLM-assisted development to accelerate drafting and exploration, while retaining human validation for integration decisions and failure containment.

### Phase 3: Integration and Verification

1. Validate end-to-end request flow across frontend, backend, tool dispatch, and model interaction.
2. Capture implementation issues and failure modes encountered during integration.
3. Refine architecture where necessary to improve clarity, maintainability, or operational stability.

### Phase 4: Evaluation and Reporting

1. Evaluate outcomes against the objective strands defined in the introduction.
2. Distinguish observed results from interpretation and recommendations.
3. Document limitations and threats to validity to bound the conclusions.

### Agentic Evaluation Protocol

The subject under evaluation is the PDHD agent at runtime: its ability to interpret natural-language task prompts, select and invoke the correct tools with valid arguments, and return a correct response within an acceptable latency budget. The evaluation does not assess the coding-assistant workflow used to build the system; it assesses the deployed system's behaviour under repeatable input conditions.

**Scenarios.** Eight task scenarios (S01–S08) were defined, spanning single-step retrieval (S01–S04), multi-step orchestration (S05–S06), web search integration (S07), and security boundary enforcement (S08). Full scenario definitions, including prompts, expected tool calls, and success criteria, are provided in Appendix: Benchmark Scenarios.

**Inputs and process.** Each scenario was submitted to the PDHD chat API as a fixed natural-language prompt with no prior context. Nine chat-capable Ollama models were evaluated. Each scenario was repeated twelve times per model to obtain stable accuracy and latency estimates. The model was switched via the PDHD runtime configuration API between model runs; no other system state was changed between repeats.

**Success and failure criteria.** A response was marked correct if it satisfied either a regex pattern match against a known-good answer or a positive verdict from an LLM-based answer evaluator. Latency was measured end-to-end from the PDHD chat API request to the final streamed token. Tool-level failure rates and argument-validation failures were captured from backend telemetry at run completion.

**Outputs.** Results were written to a SQLite database and summarised as per-model accuracy percentages, mean/P50/P95 latency, HTTP error rate, and a tool-level invocation and failure breakdown. The full environment specification — hardware, model versions, runtime configuration, and timeout budget — is provided in Appendix: Evaluation Environment Specification.

<!--
#### Core Metrics

The following metrics have been identified in a mindmap as of note and will be later reviewed across all scenario classes:

- **Prompt completion success rate**: whether prompts produce valid, usable completions
- **Tool-call metrics**: validity and correctness of emitted tool specifications
- **Retry count/rate**: frequency of correction or retry operations required per task
- **End-to-end latency of task completion**: total time from request to deliverable result
- **Failure kinds**: categorisation of failure modes (dispatch, runtime, network, integration)
- **Response latency (categorised)**:
  - _Instant_: sub-100ms responses
  - _Short wait_: 100ms–2s responses
  - _Long wait_: 2s–10s responses
  - _Complex reasoning_: 10s–60s responses (model thinking/deliberation)
  - _Timeout risk_: 60s+ responses (approaching timeout boundary)
- **Cross-host latency**: comparison of the same model's latency across different hardware configurations (24GB vs 16GB VRAM machines)
- **Accuracy heatmap by host**: per-host success rate breakdown to isolate resource-driven performance variation
-->

#### Data Collection and Interpretation

Evidence is assembled from test artefacts, integration logs, and implementation records, then interpreted as a constrained engineering case study rather than a universal benchmark. Where full quantitative coverage is unavailable, claims are explicitly bounded and supported by traceable qualitative evidence.

<!--
### Evaluation Perspective

The evaluation in this report is a constrained engineering case study rather than a controlled comparative experiment. Findings are interpreted as project-specific evidence about what worked, what failed, and which design choices appear robust under the implemented conditions.
-->
