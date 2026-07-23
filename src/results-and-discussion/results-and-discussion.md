# Results and Discussion

This section evaluates implementation outcomes against the research questions and objective strands defined earlier in the report. The emphasis is on agentic model behavior under local runtime constraints: what was observed, what was measured, and which claims remain bounded by evidence gaps.

<!--
## Evaluation Lens

The analysis treats the system as a constrained engineering case study with four scenario classes:

1. Single-step retrieval workflows
2. Multi-step tool orchestration workflows
3. Error-recovery workflows
4. Runtime fallback workflows

Results are interpreted as implementation-specific evidence, not as universal model-performance claims.
-->

[#benchmark-evaluation](./findings-and-graphs.md)

## Key Findings

- Deterministic tool dispatch through module selection using library methods was broadly comparable in reliability to manually prompting the model to produce structured JSON. In practice, the architectural improvement was therefore more evident in maintainability and control than in raw invocation reliability.
- Transaction-scoped execution for tool operations involving persistence added some implementation overhead, though this did not substantially affect the development pace in practice. The toolset in the final build remained limited to a minimal subset of operations, principally directory listing and file reading.
- Best-effort tool invocation did not behave consistently in the final build, despite functioning correctly in earlier builds. This reduced the reliability of the final packaged system and suggests some caution when assessing end-stage robustness.
- Agentic productivity gains were strongest when tasks were bounded, tool-visible, and backed by explicit orchestration boundaries.

- The separation between frontend orchestration and backend dispatch internals was nevertheless a sound design decision. Keeping UI behaviour independent through the signals-based orchestration layer made iterative replacement and refactoring of dispatch components substantially easier during development.

<!--
## Evidence Matrix

| Analysis Focus                           | Current Evidence Strength | Notes                                                                                                                                   |
| ---------------------------------------- | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Dispatch determinism and maintainability | Moderate                  | Verified through implementation behavior and architecture outcomes; additional quantitative telemetry would strengthen reproducibility. |
| Persistence-linked tool execution        | Moderate                  | Behavior validated in test conditions; final build feature subset constrained full workflow coverage.                                   |
| Multi-step orchestration robustness      | Limited to Moderate       | Core path behavior observed, but broad scenario-level quantitative coverage remains incomplete.                                         |
| Error recovery behavior                  | Moderate                  | Integration issues and mitigation paths were observed repeatedly across development cycles.                                             |
| Runtime fallback behavior                | Limited                   | Functionality exists but requires broader scenario-level measurement for stronger claims.                                               |
-->

<!--
## Quantitative Evaluation Targets

The following metrics define the substantial evaluation package for agentic analysis in this report:

| Metric                       | Relevance to Agentic Analysis                                            | Evidence Source                         |
| ---------------------------- | ------------------------------------------------------------------------ | --------------------------------------- |
| Task completion success rate | Measures practical workflow completion under bounded tool use            | Scenario runs and integration records   |
| Tool-call validity rate      | Measures whether model-invoked operations remain executable and coherent | Tool execution logs and dispatch traces |
| Retry or correction count    | Measures supervision burden and workflow friction                        | Session traces and development logs     |
| End-to-end latency (P50/P95) | Measures usability and orchestration overhead                            | Runtime telemetry and timing captures   |
| Failure taxonomy frequency   | Measures dominant reliability risks                                      | Error logs and categorized issue notes  |
-->

## Discussion

The findings above confirm the pattern described in the Key Findings: agentic capability was most reliable when tasks were bounded to single-step tool invocations with no-argument or low-argument tools. The universal success on S08 and the universal failure on S01 and S07 reflect, respectively, a well-enforced constraint boundary and two systematic evaluation mismatches rather than tool execution failures. The high variance on S05 (multi-step exploration) is consistent with the architectural observation that multi-step orchestration reliability depends on argument construction quality, which the telemetry confirms as the dominant failure mode.

The code-stability issues observed throughout the development lifecycle — build-time CDI resolution failures, runtime model-switch race conditions, and end-stage tool dispatch regressions — had a measurable effect on evaluation confidence. The benchmark was run against the final packaged build rather than a controlled reference snapshot, meaning that any instability in the packaged system is reflected in the accuracy and latency measurements. The 38.54% accuracy recorded for `llama3.1:latest` against 54.17% in an earlier isolated single-model run (run `20260429_115226`) suggests that the system state at benchmark time was not fully stable for that model, and the results should be interpreted with this caveat.

## Limitations

The two-machine deployment introduced several environmental constraints on measurement reliability. A wired network connection between MINIFRIDGE and WS-RARETOWER was required for stable inference traffic; any link instability would have introduced spurious latency spikes indistinguishable from model or system behaviour. Power profile and hibernation timeout configuration on both workstations were also a prerequisite: an unattended sleep transition on either host during a multi-hour batch run would have corrupted the run silently. These constraints were managed in practice, but they were not formally verified before each run, and their potential influence on the observed P95 outliers cannot be fully discounted.

A more significant process limitation was that benchmark runs were not collected during iterative development. Continuous measurement across implementation phases would have provided a longitudinal view of how system changes affected model accuracy and latency, making it possible to attribute regressions to specific commits rather than treating the final-build results as a point-in-time snapshot. The absence of this data means the Discussion section relies partly on retrospective comparison between isolated runs rather than a continuous evidence record.

One further uncontrolled variable was model cold-start behaviour on the Ollama host. When the benchmark script cycled to a new model, Ollama was required to load that model's weights into VRAM before the first inference request could be served. Scenarios executed immediately after a model load may therefore have recorded slightly higher latency than they would have with the model already resident and warmed in VRAM. This effect was not isolated or corrected for in the current results, and represents a small but non-zero source of latency skew across the per-model P50 and P95 figures.

From a process perspective, the evaluation scope is bounded by what was feasible on local hardware within the project timeline. The eight-scenario suite covers core functional categories but does not include error-recovery workflows or runtime fallback paths as distinct scenarios. The twelve-repeat design provides stable P50 estimates but limited P95 resolution; a broader repeat count would reduce the influence of individual high-latency outliers. Finally, one model (`qwen3.6:latest`) was excluded from comparative analysis due to an infrastructure failure during the run, reducing the effective comparative sample to eight models.

## Testing and Evaluation

Unit testing is the correct approach to conducting thorough development process. Ensuring that the test suite evolved in step with the backend implementation and that the intended behaviour of each component remained independently verifiable, a sub-repository (folder committed under the main repository) was used to keep track of specification and instructions to the coding agent, in order to generate a set of structurally sound tests.

The test suite covers mostly the Quarkus backend, as most of the issues were observed associated with it: tool dispatch resolution, persistence writes triggered by tool invocations, and context caching. Testing CDI-managed dispatch introduced some build-time complications, as Quarkus's build-time compilation model occasionally required explicit configuration to ensure that test-scope beans were correctly resolved during the test lifecycle. Despite these constraints, the resulting tests provided meaningful verification of core dispatch and persistence behaviour under controlled conditions.

## Future Work

Future research could explore:

1. Introducing typed tool responses alongside current LLM-friendly string outputs
2. Strengthening cache invalidation and freshness policies
3. Extending observability with per-tool latency and failure-rate metrics
4. Evaluating alternative dispatch strategies when module overlap increases
5. Parametrising the system prompt and user query messages with session-level meta-context — such as the current working directory, open file paths, and shallow file-level intelligence — injected at request time. The universal S01 failure (Get CWD returned 0% accuracy across all nine models) suggests that this class of information is not reliably inferred from the tool schema alone; making it explicit in the prompt would remove the inference burden entirely and is likely to improve performance on any task where ambient workspace state is a precondition for correct tool use.

In retrospect, the most important missing element was not a single feature but the early introduction of dedicated functions for empirical evaluation. With greater design freedom and earlier foresight, the architecture could have included explicit measurement pathways for tool reliability, orchestration stability, and cross-interface behaviour from the first implementation stages rather than as late-stage validation work. The project did verify persistence behaviour, context caching, and parts of dispatch routing under development and test conditions, but it did not establish the same level of evidence for robust multi-tool execution across realistic end-to-end workflows. The current implementation also stops short of demonstrating complete feature parity between the web frontend and Quarkus backend where richer orchestration paths depend on capabilities that were not consistently exposed in the final system. These findings were discovered experimentally through rigorous planning and development of a substantial software project, which revealed multiple interesting key points in the specific mechanism of action of the investigated systems.

Future work should prioritise establishing empirical measurement pathways from the outset of the project, rather than focusing on carefully pivoting to a more lucrative project specification. Maintaining rigorous documentation and research log should be high priority.
