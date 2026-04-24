# Results and Discussion

This section evaluates implementation outcomes against the research questions and objective strands defined earlier in the report. The emphasis is on agentic model behavior under local runtime constraints: what was observed, what was measured, and which claims remain bounded by evidence gaps.

## Evaluation Lens

The analysis treats the system as a constrained engineering case study with four scenario classes:

1. Single-step retrieval workflows
2. Multi-step tool orchestration workflows
3. Error-recovery workflows
4. Runtime fallback workflows

Results are interpreted as implementation-specific evidence, not as universal model-performance claims.

## Key Findings

- Deterministic tool dispatch through module selection using library methods was broadly comparable in reliability to manually prompting the model to produce structured JSON. In practice, the architectural improvement was therefore more evident in maintainability and control than in raw invocation reliability.
- Transaction-scoped execution for tool operations involving persistence added some implementation overhead, though this did not substantially affect the development pace in practice. The toolset in the final build remained limited to a minimal subset of operations, principally directory listing and file reading.
- Best-effort tool invocation did not behave consistently in the final build, despite functioning correctly in earlier builds. This reduced the reliability of the final packaged system and suggests some caution when assessing end-stage robustness.
- Agentic productivity gains were strongest when tasks were bounded, tool-visible, and backed by explicit orchestration boundaries.

- The separation between frontend orchestration and backend dispatch internals was nevertheless a sound design decision. Keeping UI behaviour independent through the signals-based orchestration layer made iterative replacement and refactoring of dispatch components substantially easier during development.

## Evidence Matrix

| Analysis Focus                           | Current Evidence Strength | Notes                                                                                                                                   |
| ---------------------------------------- | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Dispatch determinism and maintainability | Moderate                  | Verified through implementation behavior and architecture outcomes; additional quantitative telemetry would strengthen reproducibility. |
| Persistence-linked tool execution        | Moderate                  | Behavior validated in test conditions; final build feature subset constrained full workflow coverage.                                   |
| Multi-step orchestration robustness      | Limited to Moderate       | Core path behavior observed, but broad scenario-level quantitative coverage remains incomplete.                                         |
| Error recovery behavior                  | Moderate                  | Integration issues and mitigation paths were observed repeatedly across development cycles.                                             |
| Runtime fallback behavior                | Limited                   | Functionality exists but requires broader scenario-level measurement for stronger claims.                                               |

## Quantitative Evaluation Targets

The following metrics define the substantial evaluation package for agentic analysis in this report:

| Metric                       | Relevance to Agentic Analysis                                            | Evidence Source                         |
| ---------------------------- | ------------------------------------------------------------------------ | --------------------------------------- |
| Task completion success rate | Measures practical workflow completion under bounded tool use            | Scenario runs and integration records   |
| Tool-call validity rate      | Measures whether model-invoked operations remain executable and coherent | Tool execution logs and dispatch traces |
| Retry or correction count    | Measures supervision burden and workflow friction                        | Session traces and development logs     |
| End-to-end latency (P50/P95) | Measures usability and orchestration overhead                            | Runtime telemetry and timing captures   |
| Failure taxonomy frequency   | Measures dominant reliability risks                                      | Error logs and categorized issue notes  |

## Discussion

The command-line interface pathway exposed a startup integration issue. The `@Inject` annotation, used to declare dependencies that the dependency container should supply, became unresolvable when `picocli` argument parsing was used as the application entry point, versus Quarkus-managed runtime entrypoint. This was addressed by invoking `picocli` parsing from within the `Quarkus.run` handler, ensuring that the CDI container was active.

The terminal user interface exhibited a similar failure mode. Initialising a `jline` terminal became unreliable under Maven's `quarkus:dev` launcher because Quarkus takes over standard input and output management and installs its own shutdown signal handler, which conflicted with `jline` assumptions system IO stream ownership. The intended full-screen submenu design, based on `jline` API for rendering and terminal clear capabilities, worked correctly in plain Java but could not be made stable under Quarkus runtime.

The primary source of API communication errors during development was container-level network address resolution. Because the application ran inside a devcontainer, Docker's virtual networking layer was interposed between the application and the host machine. On Windows Subsystem for Linux (WSL), `localhost` inside the container refers to a separate virtual machine rather than the host OS, which meant that unqualified references to `localhost:11434` would consistently fail to reach the Ollama instance running on the host.

From an agentic-analysis perspective, these incidents matter because they isolate where failure originates: orchestration logic, infrastructure integration, or runtime configuration. This separation improves diagnosis and helps prevent over-attribution of failures to model quality alone.

## Limitations

Implementing the software exclusively with the support of my homelab assistant proved more time-consuming than anticipated, in part because model selection under limited hardware was a practical constraint throughout.

Quarkus development-mode live reload also introduced intermittent instability: in some cases, recompiled build artefacts were not fully available on disk when a request was issued, requiring manual reload before normal operation resumed.

The instability introduced by continuous backend changes during rapid prototyping made a dedicated frontend dispatch abstraction necessary. Rather than wiring individual UI elements directly to `fetch` callbacks targeting specific endpoints, a callable object encapsulating a string identifier and its associated arguments was constructed at event time and dispatched from a single implementation point. This decoupled UI registration from backend routing, but it also highlighted a practical environment constraint: I was not aware of a usable Java API from Docker that could reliably expose the active container networking model for this setup, so endpoint resolution remained explicit and manual. The dispatcher therefore maintained a central mapping from string identifiers to backend routes as a mitigation strategy, but this still introduced maintenance overhead whenever routing changed.

## Threats to Validity

1. Construct validity: some desired metrics were not collected from the first implementation phase, so parts of the analysis depend on retrospective evidence.
2. Internal validity: iterative refactoring and environment instability may have influenced observed outcomes in ways not fully isolated from model behavior.
3. External validity: findings are specific to this hardware profile, local runtime setup, and bounded toolset; generalization should be made cautiously.
4. Reliability validity: repeated qualitative observations are strong for failure categories, but full scenario-level quantitative repetition remains incomplete.

## Testing and Evaluation

Unit testing was conducted throughout the development process using JUnit 5, with tests written alongside each feature as it was implemented rather than deferred to a later integration phase. Each test class was committed to version control as part of its associated feature branch, ensuring that the test suite evolved in step with the backend implementation and that the intended behaviour of each component remained independently verifiable.

The test suite covers the principal behavioural units of the Quarkus backend: tool dispatch resolution, persistence writes triggered by tool invocations, and context caching. Testing CDI-managed dispatch introduced some build-time complications, as Quarkus's build-time compilation model occasionally required explicit configuration to ensure that test-scope beans were correctly resolved during the test lifecycle. Despite these constraints, the resulting tests provided meaningful verification of core dispatch and persistence behaviour under controlled conditions.

For the agentic pivot, testing evidence is interpreted together with scenario-level workflow traces so that architectural claims can be evaluated against practical execution behavior instead of implementation intent alone.

## Future Work

Future research could explore:

1. Introducing typed tool responses alongside current LLM-friendly string outputs
2. Strengthening cache invalidation and freshness policies
3. Extending observability with per-tool latency and failure-rate metrics
4. Evaluating alternative dispatch strategies when module overlap increases

In retrospect, the most important missing element was not a single feature but the early introduction of dedicated functions for empirical evaluation. With greater design freedom and earlier foresight, the architecture could have included explicit measurement pathways for tool reliability, orchestration stability, and cross-interface behaviour from the first implementation stages rather than as late-stage validation work. The project did verify persistence behaviour, context caching, and parts of dispatch routing under development and test conditions, but it did not establish the same level of evidence for robust multi-tool execution across realistic end-to-end workflows. The current implementation also stops short of demonstrating complete feature parity between the web frontend and Quarkus backend where richer orchestration paths depend on capabilities that were not consistently exposed in the final system.

The next implementation priority is therefore to complete the substantial evaluation package by running a stable scenario suite, extracting metric summaries, and mapping each recommendation to measured weaknesses in reliability, latency, and recoverability.
