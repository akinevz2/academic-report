## Objectives

The project objectives are organised into two strands: technical delivery and workflow evaluation. The initial scope was revised from low-level resource governance to application-level project inspection so that the implementation effort remained aligned with the report's central research questions.

### Strand A: Technical Delivery

Rewrite checklist:

- [ ] Reframe Strand A around benchmarkable capabilities rather than implementation deliverables.
- [ ] Define capability groups that match the functional sections in §5 and evidence in §9.
- [ ] State that the final report goal is a benchmark collection under one Agentic capability umbrella.
- [ ] Keep objectives testable and measurable, not aspirational.
- [ ] Preserve consistency with Strand B wording and scope.

Kind supervisor note:

> You already have a solid objective structure. Shift Strand A from "what was built" to "what must be proven" and the whole chapter will read as much more academically rigorous.

### Strand B: Workflow Evaluation

1. Characterise how agentic coding affected implementation speed, structure, and rework.
2. Evaluate whether generated outputs remained aligned with developer intent and engineering constraints.
3. Identify limitations and failure patterns that constrained reliability.

### Objective-to-Evidence Mapping

| Objective                            | Evidence expected in report                                         | Primary indicators                                               |
| ------------------------------------ | ------------------------------------------------------------------- | ---------------------------------------------------------------- |
| Deployable local LLM-assisted system | Architecture description, integration notes, and runnable workflow  | End-to-end scenario completion under local runtime constraints   |
| Reliable bounded tool-calling        | Tool execution examples, observed failures, and mitigation strategy | Tool-call validity, categorized failure frequency                |
| Persistent project knowledge         | Storage design, retrieval workflow, and recall examples             | Successful retrieval and reuse across repeated analysis runs     |
| Evaluate agentic coding process      | Development reflections tied to concrete implementation episodes    | Retry/correction burden, workflow friction patterns              |
| Assess quality and maintainability   | Discussion of rework, simplification, and boundary enforcement      | Boundary clarity, regression profile, maintainability trade-offs |
| Identify constraints and limitations | Explicit limitations and threats-to-validity sections               | Bounded-claim statements tied to environment and sampling limits |
