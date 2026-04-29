## `generate_gantt.py`

```python
#!/usr/bin/env python3
"""Generate implementation-gantt-pre.png and implementation-gantt-post.png."""

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import date
import numpy as np

REPORT_DIR = "/workspaces/development/uni/2025-report/images"

PALETTE = [
    "#4e79a7", "#f28e2b", "#e15759", "#76b7b2",
    "#59a14f", "#edc948", "#b07aa1", "#ff9da7",
    "#9c755f", "#bab0ac",
]

def d(s):
    return date.fromisoformat(s)

def bar(ax, y, start, end, color, label, alpha=0.88):
    ax.barh(
        y, (d(end) - d(start)).days,
        left=mdates.date2num(d(start)),
        height=0.55, color=color, alpha=alpha,
        edgecolor="white", linewidth=0.6,
    )
    mid = mdates.date2num(d(start)) + (d(end) - d(start)).days / 2
    ax.text(mid, y, label, ha='center', va='center',
            fontsize=7.5, color='white', fontweight='bold', clip_on=True)

def milestone(ax, y, when, label, color):
    x = mdates.date2num(d(when))
    ax.plot(x, y, marker='D', markersize=7, color=color, zorder=5)
    ax.annotate(label, (x, y), textcoords="offset points",
                xytext=(5, 4), fontsize=7.5, color=color, fontweight='bold')

# -- PRE CHART: Report & presentation timeline --------------------------------

pre_rows = [
    # (label, start, end, colour_idx)
    ("Planning & Scoping",          "2025-08-01", "2025-09-15", 0),
    ("Background Research",         "2025-09-15", "2025-11-10", 1),
    ("Interim Report",              "2025-11-10", "2025-11-25", 2),
    ("Background Revision",         "2026-02-20", "2026-03-09", 3),
    ("Report Structure",            "2026-03-09", "2026-03-29", 4),
    ("Appendices & Revisions",      "2026-03-29", "2026-04-12", 5),
    ("Docs Restructure",            "2026-04-12", "2026-04-24", 6),
    ("Rewrite & Cleanup",           "2026-04-24", "2026-04-29", 7),
]

pre_milestones = [
    ("2025-11-17", "Interim report",      PALETTE[2]),
    ("2026-02-27", "Bkgd & motivation",   PALETTE[3]),
    ("2026-03-09", "Report structure",    PALETTE[4]),
    ("2026-04-12", "Appendix assets",     PALETTE[5]),
    ("2026-04-24", "Docs restructure",    PALETTE[6]),
    ("2026-04-26", "Rewrite finalised",   PALETTE[7]),
    ("2026-04-29", "Today",               "#e15759"),
]

fig, ax = plt.subplots(figsize=(11, 4.2))
ax.set_facecolor("#f9f9f9")
fig.patch.set_facecolor("white")

yticks = list(range(len(pre_rows)))
for i, (label, start, end, ci) in enumerate(pre_rows):
    bar(ax, i, start, end, PALETTE[ci % len(PALETTE)], label)

for when, label, color in pre_milestones:
    # draw a vertical dotted line
    ax.axvline(mdates.date2num(d(when)), color=color, linewidth=0.8,
               linestyle=':', alpha=0.6, zorder=2)

ax.set_yticks(yticks)
ax.set_yticklabels([r[0] for r in pre_rows], fontsize=9)
ax.xaxis.set_major_formatter(mdates.DateFormatter('%b %Y'))
ax.xaxis.set_major_locator(mdates.MonthLocator())
plt.xticks(rotation=35, ha='right', fontsize=8.5)
ax.set_xlim(
    mdates.date2num(d("2025-07-15")),
    mdates.date2num(d("2026-05-10")),
)
ax.set_ylim(-0.7, len(pre_rows) - 0.3)
ax.invert_yaxis()
ax.set_title("Report & Presentation Timeline", fontsize=12, fontweight='bold', pad=10)
ax.grid(axis='x', linestyle='--', alpha=0.4, zorder=0)
ax.spines[['top', 'right']].set_visible(False)

# today marker
ax.axvline(mdates.date2num(d("2026-04-29")), color='#e15759',
           linewidth=1.5, linestyle='-', alpha=0.9, zorder=6,
           label="Today (2026-04-29)")
ax.legend(loc='lower right', fontsize=8)

plt.tight_layout()
out = f"{REPORT_DIR}/implementation-gantt-pre.png"
plt.savefig(out, dpi=180, bbox_inches='tight')
plt.close()
print(f"Saved {out}")


# -- POST CHART: Implementation timeline --------------------------------------

post_rows = [
    ("Initial commit / setup",          "2026-02-16", "2026-03-12", 0),
    ("Core arch & tooling",             "2026-03-12", "2026-03-27", 1),
    ("Project knowledge / RAG",         "2026-03-22", "2026-03-31", 2),
    ("Tool infra consolidation",        "2026-03-27", "2026-04-01", 3),
    ("Frontend integration",            "2026-03-30", "2026-04-06", 4),
    ("Menu / service refactor",         "2026-04-05", "2026-04-08", 5),
    ("Stream WS + Ollama switching",    "2026-04-07", "2026-04-09", 6),
    ("RAFT inspection pipeline",        "2026-04-08", "2026-04-14", 7),
    ("Custom tool support merge",       "2026-04-14", "2026-04-15", 3),
    ("Source rewrite sprint",           "2026-04-24", "2026-04-27", 1),
    ("Tooling refactor / bench stab.",  "2026-04-26", "2026-04-29", 2),
]

post_milestones = [
    ("2026-02-16", "Initial commit",         PALETTE[0]),
    ("2026-03-30", "Multi-branch merge",     PALETTE[4]),
    ("2026-04-07", "Chat arch refactor",     PALETTE[5]),
    ("2026-04-08", "RAFT pipeline",          PALETTE[7]),
    ("2026-04-14", "Custom tools merged",    PALETTE[3]),
    ("2026-04-26", "Tooling refactor",       PALETTE[2]),
    ("2026-04-29", "Today",                  "#e15759"),
]

fig, ax = plt.subplots(figsize=(11, 5.2))
ax.set_facecolor("#f9f9f9")
fig.patch.set_facecolor("white")

yticks = list(range(len(post_rows)))
for i, (label, start, end, ci) in enumerate(post_rows):
    bar(ax, i, start, end, PALETTE[ci % len(PALETTE)], label)

for when, label, color in post_milestones:
    ax.axvline(mdates.date2num(d(when)), color=color, linewidth=0.8,
               linestyle=':', alpha=0.6, zorder=2)

ax.set_yticks(yticks)
ax.set_yticklabels([r[0] for r in post_rows], fontsize=9)
ax.xaxis.set_major_formatter(mdates.DateFormatter('%d %b'))
ax.xaxis.set_major_locator(mdates.WeekdayLocator(byweekday=0))
plt.xticks(rotation=35, ha='right', fontsize=8.5)
ax.set_xlim(
    mdates.date2num(d("2026-02-10")),
    mdates.date2num(d("2026-05-05")),
)
ax.set_ylim(-0.7, len(post_rows) - 0.3)
ax.invert_yaxis()
ax.set_title("Implementation Timeline (Feb - Apr 2026)", fontsize=12, fontweight='bold', pad=10)
ax.grid(axis='x', linestyle='--', alpha=0.4, zorder=0)
ax.spines[['top', 'right']].set_visible(False)

ax.axvline(mdates.date2num(d("2026-04-29")), color='#e15759',
           linewidth=1.5, linestyle='-', alpha=0.9, zorder=6,
           label="Today (2026-04-29)")
ax.legend(loc='lower right', fontsize=8)

plt.tight_layout()
out = f"{REPORT_DIR}/implementation-gantt-post.png"
plt.savefig(out, dpi=180, bbox_inches='tight')
plt.close()
print(f"Saved {out}")

```
