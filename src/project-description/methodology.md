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

Rewrite checklist:

- [ ] Define the PDHD agent as the sole target under evaluation.
- [ ] State protocol scope in terms of PDHD runtime behavior, not coding-agent development workflow.
- [ ] Keep scenario classes aligned with the method phases above and data collection subsection below.
- [ ] Describe success/failure criteria that can be evidenced in §9.
- [ ] Use wording that supports reproducibility (inputs, process, outputs).

Kind supervisor note:

> This is a key credibility section. If you keep the subject of evaluation unambiguous from the first sentence, the rest of your argument becomes much easier to defend.

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
