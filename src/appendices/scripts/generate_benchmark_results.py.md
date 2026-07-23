## `generate_benchmark_results.py`

```python
#!/usr/bin/env python3
"""
Generate benchmark result graphs for the 2025 PDHD evaluation report.
Run with: /workspaces/development/uni/2025-report/graphs/venv/bin/python generate_benchmark_results.py
"""

import sqlite3
import os
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import seaborn as sns
from pathlib import Path

# -- Paths ----------------------------------------------------------------------
DB_PATH = "/workspaces/development/uni/2025-project/pdhd/scripts/benchlam/results/benchmark_results.sqlite"
RUN_ID  = "20260429_124501_ff993b17"
OUT_DIR = Path(__file__).parent

# -- Style ----------------------------------------------------------------------
sns.set_theme(style="whitegrid", font_scale=1.0)
PALETTE = sns.color_palette("muted")

# Short display labels for model names
MODEL_LABELS = {
    "devstral:latest":             "devstral",
    "gemma4:latest":               "gemma4",
    "glm-4.7-flash:latest":        "glm-4.7-flash",
    "llama3.1:8b":                 "llama3.1:8b",
    "llama3.1:8b-instruct-q4_K_M": "llama3.1:8b-inst-q4",
    "llama3.1:latest":             "llama3.1:fp16",
    "qwen3.6:27b-q4_K_M":          "qwen3.6:27b-q4",
    "qwen3.6:35b-a3b-q4_K_M":      "qwen3.6:35b-moe-q4",
    "qwen3.6:latest":              "qwen3.6:fp16†",
}

# Short scenario IDs
SCENARIO_LABELS = {
    "S01 - Get current working directory":              "S01\nGet CWD",
    "S02 - List open projects":                         "S02\nList Projects",
    "S03 - List directory contents":                    "S03\nList Dir",
    "S04 - Read a known file":                          "S04\nRead File",
    "S05 - Multi-step folder exploration":              "S05\nFolder Explore",
    "S06 - Summarise a source file":                    "S06\nSummarise",
    "S07 - Web search integration":                     "S07\nWeb Search",
    "S08 - Out-of-project file access (security boundary)": "S08\nSecurity",
}

# -- Data Loading ---------------------------------------------------------------
conn = sqlite3.connect(DB_PATH)

# Per-model summary
summary_rows = conn.execute("""
    SELECT
        model_name,
        tests_run,
        ROUND(avg_accuracy * 100, 2)          AS accuracy_pct,
        ROUND(avg_latency / 1000.0, 2)        AS avg_latency_s,
        ROUND(p50_latency / 1000.0, 2)        AS p50_latency_s,
        ROUND(p95_latency / 1000.0, 2)        AS p95_latency_s,
        http_error_rate
    FROM benchmark_model_summary
    WHERE run_id = ?
    ORDER BY accuracy_pct DESC
""", (RUN_ID,)).fetchall()

# Per-scenario per-model accuracy
scenario_rows = conn.execute("""
    SELECT
        model_name,
        test_case,
        COUNT(*)                                                      AS total,
        SUM(CASE WHEN correctness_score >= 1 THEN 1 ELSE 0 END)      AS passed,
        ROUND(100.0 * SUM(CASE WHEN correctness_score >= 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS accuracy_pct
    FROM benchmark_results
    WHERE run_id = ?
    GROUP BY model_name, test_case
    ORDER BY model_name, test_case
""", (RUN_ID,)).fetchall()

conn.close()

# Build structures
models_ordered = [r[0] for r in summary_rows]
accuracy       = {r[0]: r[2] for r in summary_rows}
avg_lat        = {r[0]: r[3] for r in summary_rows}
p50_lat        = {r[0]: r[4] for r in summary_rows}
p95_lat        = {r[0]: r[5] for r in summary_rows}
http_err       = {r[0]: r[6] for r in summary_rows}

# Scenario matrix  {model: {scenario: accuracy_pct}}
scenarios_set = sorted(set(r[1] for r in scenario_rows))
scenario_matrix = {m: {} for m in models_ordered}
for model, scenario, total, passed, acc in scenario_rows:
    scenario_matrix[model][scenario] = acc

# -- Figure 1: Overall Accuracy by Model ---------------------------------------
fig1, ax1 = plt.subplots(figsize=(10, 5))

labels  = [MODEL_LABELS.get(m, m) for m in models_ordered]
accs    = [accuracy[m] for m in models_ordered]
colours = [PALETTE[0] if http_err[m] < 0.1 else '#cccccc' for m in models_ordered]

bars = ax1.bar(labels, accs, color=colours, edgecolor='white', linewidth=0.8, width=0.6)

for bar, val in zip(bars, accs):
    ax1.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.8,
             f'{val:.1f}%', ha='center', va='bottom', fontsize=9)

ax1.set_ylabel("Accuracy (%)", fontsize=11)
ax1.set_title("Overall Accuracy by Model\n(8 scenarios × 12 repeats = 96 tests per model)", fontsize=12)
ax1.set_ylim(0, 65)
ax1.tick_params(axis='x', labelsize=9)

# Legend for anomalous model
grey_patch = mpatches.Patch(color='#cccccc', label='† Connection failure during run (qwen3.6:fp16)')
ax1.legend(handles=[grey_patch], fontsize=8, loc='upper right')

fig1.tight_layout()
fig1.savefig(OUT_DIR / "benchmark_accuracy_by_model.png", dpi=150, bbox_inches='tight')
plt.close(fig1)
print("Saved: benchmark_accuracy_by_model.png")

# -- Figure 2: Latency by Model (avg, P50, P95) --------------------------------
# Exclude qwen3.6:latest from latency chart (data corrupted by 503s)
models_lat = [m for m in models_ordered if http_err[m] < 0.1]
labels_lat = [MODEL_LABELS.get(m, m) for m in models_lat]
avg_vals   = [avg_lat[m] for m in models_lat]
p50_vals   = [p50_lat[m] for m in models_lat]
p95_vals   = [p95_lat[m] for m in models_lat]

x = np.arange(len(models_lat))
w = 0.28

fig2, ax2 = plt.subplots(figsize=(11, 5))
b1 = ax2.bar(x - w, avg_vals, width=w, label='Mean',  color=PALETTE[0], edgecolor='white')
b2 = ax2.bar(x,      p50_vals, width=w, label='P50',   color=PALETTE[1], edgecolor='white')
b3 = ax2.bar(x + w,  p95_vals, width=w, label='P95',   color=PALETTE[2], edgecolor='white')

ax2.set_xticks(x)
ax2.set_xticklabels(labels_lat, fontsize=9)
ax2.set_ylabel("Latency (s)", fontsize=11)
ax2.set_title("Response Latency by Model — Mean, P50, P95\n(excludes qwen3.6:fp16 due to mid-run connection failure)", fontsize=12)
ax2.legend(fontsize=9)

fig2.tight_layout()
fig2.savefig(OUT_DIR / "benchmark_latency_by_model.png", dpi=150, bbox_inches='tight')
plt.close(fig2)
print("Saved: benchmark_latency_by_model.png")

# -- Figure 3: Per-Scenario Accuracy Heatmap -----------------------------------
# Build 2D matrix: rows=models (ordered by overall acc), cols=scenarios
# Exclude qwen3.6:latest from heatmap (503s distort S04-S08 cells)
models_hm   = [m for m in models_ordered if http_err[m] < 0.1]
labels_hm   = [MODEL_LABELS.get(m, m) for m in models_hm]
scenario_short = [SCENARIO_LABELS.get(s, s) for s in scenarios_set]

matrix = np.array([
    [scenario_matrix[m].get(s, 0.0) for s in scenarios_set]
    for m in models_hm
])

fig3, ax3 = plt.subplots(figsize=(11, 5))
cmap = sns.color_palette("YlOrRd", as_cmap=True)
im = ax3.imshow(matrix, aspect='auto', cmap=cmap, vmin=0, vmax=100)

ax3.set_xticks(range(len(scenarios_set)))
ax3.set_xticklabels(scenario_short, fontsize=9)
ax3.set_yticks(range(len(models_hm)))
ax3.set_yticklabels(labels_hm, fontsize=9)
ax3.set_title("Per-Scenario Accuracy (%) by Model", fontsize=12)

for i, model in enumerate(models_hm):
    for j, scenario in enumerate(scenarios_set):
        val = scenario_matrix[model].get(scenario, 0.0)
        colour = 'white' if val > 60 else 'black'
        ax3.text(j, i, f'{val:.0f}', ha='center', va='center', fontsize=8, color=colour)

plt.colorbar(im, ax=ax3, label='Accuracy (%)', shrink=0.8)
fig3.tight_layout()
fig3.savefig(OUT_DIR / "benchmark_scenario_heatmap.png", dpi=150, bbox_inches='tight')
plt.close(fig3)
print("Saved: benchmark_scenario_heatmap.png")

# -- Figure 4: Tool Failure Rates from Telemetry -------------------------------
tool_data = [
    ("analyze_path\n(WORKSPACE)",      144,  63,  63),
    ("change_working_dir\n(WORKSPACE)", 33,  32,  32),
    ("listDirectoryContents\n(WORKSPACE)", 221, 42, 42),
    ("readFile\n(READ_FILE)",           149,  77,   0),
    ("searchWeb\n(WEB_SEARCH)",         111,   0,   0),
    ("getCurrentWorkingDir\n(WORKSPACE)", 840, 0,   0),
    ("getOpenProjectDirs\n(WORKSPACE)", 838,   0,   0),
]
tool_names   = [d[0] for d in tool_data]
invocations  = [d[1] for d in tool_data]
failures     = [d[2] for d in tool_data]
arg_fails    = [d[3] for d in tool_data]

x4 = np.arange(len(tool_names))
w4 = 0.35

fig4, ax4 = plt.subplots(figsize=(12, 5))
b4a = ax4.bar(x4 - w4/2, invocations, width=w4, label='Total Invocations', color=PALETTE[0], edgecolor='white')
b4b = ax4.bar(x4 + w4/2, failures,    width=w4, label='Failures (incl. arg-validation)', color=PALETTE[3], edgecolor='white')

ax4.set_xticks(x4)
ax4.set_xticklabels(tool_names, fontsize=8)
ax4.set_ylabel("Count", fontsize=11)
ax4.set_title("Tool Invocations vs. Failures Across All Models\n(run total: 2,383 invocations, 215 failures — 9.0% failure rate)", fontsize=12)
ax4.legend(fontsize=9)

fig4.tight_layout()
fig4.savefig(OUT_DIR / "benchmark_tool_failures.png", dpi=150, bbox_inches='tight')
plt.close(fig4)
print("Saved: benchmark_tool_failures.png")

print("\nAll graphs generated successfully.")

```
