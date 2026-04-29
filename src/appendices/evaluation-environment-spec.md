## Evaluation Environment Specification

**Date:** 2026-04-14

---

### Baseline run – 2026-04-14 (initial)

```
Run date/time (ISO-8601): 2026-04-14T00:00:00Z
Host OS:                  Debian GNU/Linux 12 (bookworm) in dev-container
CPU model:                Intel i7 11700k
RAM (GB):                 DDR4 32GB 3600MHz
Java version:             21+
Quarkus version:          see pom.xml
LangChain4j version:      see pom.xml
Model name:               gemma4
Model variant/tag:        gemma4:latest
Model context window:     128k (default)
Model temperature:        0.5
Ollama version:           0.22.0
Ollama host:              ws-raretower:11434
pdhd.ollama.base-url:     http://ws-raretower:11434
pdhd.ollama.model-name:   gemma4:latest
Benchmark script version: scripts/benchlam/benchmark_ollama.py
Results file:             scripts/benchlam/results/ (CSV/MD/SQLite)
```

---

### Latest benchmark run - 2026-04-29 (backdated snapshot, approx midday)

```
Run date/time (ISO-8601): 2026-04-29T12:45:01Z (approx, backdated)
Run ID:                   20260429_124501_ff993b17
Host OS:                  Debian GNU/Linux 12 (bookworm) in dev-container
Backend host:             MINIFRIDGE
Inference host:           ws-raretower.local:11434
CPU model:                Intel i7 11700k
RAM (GB):                 DDR4 32GB 3600MHz
Java version:             21+
Quarkus version:          see pom.xml
LangChain4j version:      see pom.xml
Model set:                9 chat-capable Ollama models (comparative run)
Model context window:     default per model/runtime configuration
Model temperature:        0.5
Ollama version:           0.22.0
Ollama host:              ws-raretower.local:11434
pdhd.ollama.base-url:     http://ws-raretower.local:11434
Benchmark script version: scripts/benchlam/benchmark_ollama.py
Scenario spec:            scripts/benchlam/pdhd_test_cases.json
Results file:             scripts/benchlam/results/benchmark_results.sqlite
```

---
