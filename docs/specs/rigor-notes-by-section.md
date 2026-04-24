# Rigor Notes by Section

Date: 2026-04-13
Scope reviewed: all top-level sections under src

## Coverage

- introduction
- background
- project-description
- project-architecture
- implementation-gantt
- results-and-discussion
- conclusion
- appendices

## Cross-cutting issues (highest priority)

1. Claims are often reasonable but not evidenced.

- Add quantitative evidence where possible: test counts, coverage, latency distributions, failure rates, sample sizes.
- Soften unsupported claims with explicit uncertainty language.

2. The report voice is often reflective/product-oriented rather than research-oriented.

- Reframe around research questions, methods, and findings.
- Move implementation diary content into methods/process notes.

3. Related work and current literature are underrepresented.

- Add a dedicated subsection in Background for current research.
- Tie architectural and workflow claims to published studies.

4. Results and discussion are mixed.

- Separate observed results from interpretation and recommendations.
- Add threats to validity and limitations explicitly.

5. Reproducibility artefacts are thin.

- Appendices should include evidence artefacts, not only screenshots.

## Section-specific notes

## Introduction

- Problem: reads as personal journey and product framing, with limited research framing.
- Add explicit research questions and contribution statements.
- Define key terms early (agentic coding, local inference, tool-calling workflow).
- Tie objectives to measurable outcomes.

## Background

- Problem: claims about LLM coding impact and industry momentum are mostly uncited.
- Add a short related-work subsection that distinguishes evidence from hype.
- Add known failure modes and limitations from literature (hallucination, tool misuse, context constraints).
- Add local-vs-hosted model trade-offs using citations.

## Project Description

- Problem: methodology currently reads as activity timeline, not method.
- Rewrite as method phases: design, implementation, evaluation.
- State assumptions, constraints, and out-of-scope boundaries.
- Add success criteria tied to objectives.

## Project Architecture

- Problem: many design choices are described but not justified against alternatives.
- Add rationale/tradeoff tables (for example Quarkus, SQLite, WebSocket streaming, tool dispatch).
- Remove or reclassify incomplete-implementation notes as limitations rather than architectural claims.
- Add evidence for reliability/maintainability claims or soften wording.

## Implementation Gantt

- Problem: currently descriptive/decorative.
- Add planned-vs-actual commentary and reasons for schedule shifts.
- Link milestones to specific deliverables and commits.
- Add brief reflection on what timeline patterns imply for project risk and planning.

## Results and Discussion

- Problem: strong qualitative narrative but weak empirical backing.
- Add a results table with metrics: test pass rate, failure categories, mean/P95 response latency, scenario success rate.
- Distinguish facts observed from interpretation.
- Add threats to validity: single environment, limited tool subset, dev-mode instability, evaluator bias.

## Conclusion

- Problem: over-generalized claims not tightly tied to reported results.
- Re-anchor to the objective/results matrix.
- Include what worked, what did not, and what remains unresolved.
- Keep future work concrete and prioritized.

## Appendices

- Problem: useful visuals but insufficient evidence artefacts.
- Add reproducibility appendix: configuration, API contracts, test summaries, logs, model settings.
- Add architecture diagrams with traceability to main text claims.
- Add captions and annotations for screenshots.

## Draft subsection to add now: current research

Recommended location: background/coding-with-llms.md
Suggested heading: Current research on LLM-assisted software engineering

Draft text:

Recent research in software engineering shows that large language models can improve developer throughput for selected tasks, but reliability and evaluation quality remain active concerns. Surveys in 2023-2026 report that LLM-based development is promising for code generation, explanation, and maintenance support, while also highlighting unresolved issues in correctness, reproducibility, and integration with established engineering workflows. Current evidence therefore supports a cautious position: LLM-assisted pipelines can be useful when grounded by explicit tool interfaces, retrieval context, and verification steps, but claims about productivity or quality should be tied to task-specific metrics rather than anecdotal performance. For this project, that research motivates two principles: first, grounding outputs in project evidence (retrieval plus tool results), and second, evaluating architecture choices with measurable outcomes such as reliability, latency, and failure mode frequency.

## Candidate citations to add (current research)

1. Large Language Models for Software Engineering: Survey and Open Problems (ICSE FOSE 2023). DOI: 10.1109/ICSE-FOSE59343.2023.00008
2. Large Language Models for Software Engineering: A Systematic Literature Review (ACM, 2024). DOI: 10.1145/3695988
3. Agentic Large Language Models, a Survey (JAIR, 2025). DOI: 10.1613/jair.1.18675
4. Investigating Retrieval Augmented Generation for LLM-Based Code Generation (FLLM 2025). DOI: 10.1109/FLLM67465.2025.11391177
5. From Code Generation to Software Testing: AI Copilot With Context-Based Retrieval-Augmented Generation (IEEE Software, 2025). DOI: 10.1109/MS.2025.3549628

Note: verify access and bibliographic metadata before final submission formatting.

## Fast execution plan (recommended)

1. Add the current-research subsection and 3-5 citations in Background.
2. Add one objective-to-metric table in Project Description.
3. Add one results evidence table in Results and Discussion.
4. Add one threats-to-validity subsection.
5. Expand appendices with reproducibility artefacts.
