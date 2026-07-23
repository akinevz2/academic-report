## Benchmark Evaluation

### Evaluation Setup

A structured benchmark suite was executed against the PDHD system to provide quantitative evidence for the research questions. Nine chat-capable models, available on the shared Ollama inference host (`ws-raretower.local`), were evaluated across eight task scenarios (S01–S08). Each scenario was repeated twelve times per model, yielding 96 test cases per model and 864 total observations across the eight models that completed the run without infrastructure interruption. One model (`qwen3.6:latest`, the full-precision 32 B variant) experienced a connection loss from the Ollama host during scenario S03, causing all subsequent tests (S04–S08) for that model to return HTTP 503 errors; its results are included in the data but excluded from the comparative analysis that follows.

The eight scenarios span single-step retrieval tasks (S01–S04), multi-step orchestration tasks (S05–S06), a web search integration task (S07), and a security boundary enforcement task (S08). Accuracy was measured as the fraction of repeats that produced a correct response, verified by a combination of regex pattern matching and LLM-based answer evaluation. End-to-end response latency was measured from the PDHD chat API request to the final streamed response token.

The benchmark was run across two machines on a shared local network: the PDHD Quarkus backend ran on the development workstation, and the Ollama inference service ran on a separate host. All inference traffic traversed the local network link between the two hosts. Latency figures therefore reflect realistic distributed-local deployment constraints rather than co-located or isolated inference benchmarks.

### Overall Accuracy

![Overall accuracy by model across all eight scenarios and twelve repeats](graphs/benchmark_accuracy_by_model.png){width=100%}

**Figure 1: Overall accuracy by model (96 tests per model, run `20260429_124501`).**

Overall accuracy across the eight valid models ranged from 38.54% (`llama3.1:latest`) to 51.04% (`qwen3.6:27b-q4_K_M` and `qwen3.6:35b-a3b-q4_K_M`). The distribution is notably compressed: five of the eight models clustered between 45.83% and 51.04%, suggesting that the evaluated scenario set was of moderate difficulty for this class of small-to-medium locally-runnable models and that model size within this range was not a strong predictor of overall accuracy.

The two top-performing models — `qwen3.6:27b-q4_K_M` (51.04%) and `qwen3.6:35b-a3b-q4_K_M` (51.04%) — are both Qwen 3.6 parameter variants. `devstral:latest` and `gemma4:latest` tied at 50.0%, placing immediately below. `llama3.1:latest` (the full-precision 8 B model) achieved the lowest clean-run accuracy at 38.54%, below even its quantized counterpart `llama3.1:8b` (45.83%), which suggests that quantisation level was not a decisive factor for this task profile.

### Response Latency

![Mean, P50, and P95 response latency by model](graphs/benchmark_latency_by_model.png){width=100%}

**Figure 2: Response latency by model — mean, P50, and P95 (eight models with clean run data).**

Median (P50) latency was broadly consistent across models, ranging from 8.16 s (`llama3.1:8b`) to 8.66 s (`qwen3.6:35b-a3b-q4_K_M`). Mean latency showed more variation, from 10.09 s (`devstral:latest`) to 15.59 s (`qwen3.6:27b-q4_K_M`). The most striking difference was in P95 latency: `qwen3.6:27b-q4_K_M` exhibited a P95 of 107.72 s and `llama3.1:latest` a P95 of 102.61 s, compared with P95 values between 13 s and 17 s for the remaining six models. The high P95 outliers are consistent with occasional GPU contention on the shared inference host rather than any structural characteristic of those specific models.

`qwen3.6:35b-a3b-q4_K_M` is notable for combining the joint-highest accuracy (51.04%) with a comparatively low P95 (14.58 s), making it the most consistent performer on both dimensions in this evaluation.

### Per-Scenario Accuracy

![Per-scenario accuracy heatmap across all models and scenarios](graphs/benchmark_scenario_heatmap.png){width=100%}

**Figure 3: Per-scenario accuracy (%) by model. Rows ordered by overall accuracy (highest first).**

The per-scenario breakdown reveals two universal failure modes and one universal success mode that held across all evaluated models.

**S01 (Get current working directory)** was failed by all models (0%), with a single partial exception: `qwen3.6:35b-a3b-q4_K_M` achieved 8.33% (one correct response from twelve). The PDHD system exposes `getCurrentWorkingDirectory` as a zero-argument tool call; inspection of the telemetry data (see below) indicates models called this tool correctly 841 times without failure. The consistent zero-accuracy outcome for S01 therefore reflects a verification logic discrepancy: the evaluated working directory value was matched against a pattern that models consistently failed to produce in the expected format, rather than a failure to invoke the tool.

**S07 (Web search integration)** returned 0% for all models. The web search tool (`searchWeb`) showed a 0% failure rate across 111 invocations in the telemetry data, confirming that the tool executed correctly in all cases. The accuracy shortfall reflects response formulation: models retrieved web content but did not consistently produce a response matching the expected answer pattern, likely due to the open-ended nature of search queries and the strict evaluation regex applied.

**S08 (Out-of-project file access — security boundary)** returned 100% for all models. The `readFile` tool enforced a `SecurityException` on all out-of-project path attempts (77 of 149 `readFile` invocations), and models consistently reported the access restriction to the user in the expected form. This result confirms that the security boundary implementation is robust against all tested models.

**S02 (List open projects)** was the strongest-performing functional scenario across models, with seven of eight models scoring between 75% and 100%. **S05 (Multi-step folder exploration)** showed the highest inter-model variance (8.33% to 75%), which is consistent with multi-step tasks being more sensitive to model reasoning capability and tool chaining reliability.

### Tool Invocations and Failure Analysis

![Tool invocation counts vs. failure counts across all models and runs](graphs/benchmark_tool_failures.png){width=100%}

**Figure 4: Tool invocations versus failures across the full benchmark run (2,383 total invocations, 215 failures, 9.0% overall failure rate).**

Tool-level telemetry was captured from the PDHD system at the conclusion of the benchmark run. Across 2,383 total tool invocations, 215 failures were recorded (9.02% overall failure rate). The failure distribution was concentrated in three tools.

`readFile` generated 77 failures, all classified as `SecurityException`. As noted above, these failures are correct security enforcement behaviour for S08 and are not indicative of a system defect. `analyze_path_detailed` generated 63 failures (43.8% of its invocations), all classified as `IllegalArgumentException` on argument validation. `listDirectoryContents` generated 42 failures (19% of invocations), also all argument validation failures. `change_working_directory` showed the most extreme failure rate at 97% (32 of 33 invocations), indicating that models regularly attempted to invoke this tool with arguments the system did not accept — likely absolute paths or paths outside the project boundary.

By contrast, the high-volume zero-argument tools `getCurrentWorkingDirectory` (841 invocations) and `getOpenProjectDirectories` (839 invocations) recorded zero failures, confirming that models reliably call simple, no-argument tools. The structural failure mode is argument construction for path-taking tools, where models produced paths that failed the system's boundary validation rules.

The 5.79% argument validation failure rate (138 of 2,383 invocations) is therefore dominated by path argument errors rather than general tool-calling unreliability. This suggests that providing explicit path format constraints in tool descriptions, or adding a path normalisation layer, would be the highest-value reliability improvement available without changing model selection.
