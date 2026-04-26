# REPORT.md — Rewrite Instructions

After completing each task, output only: "✓ Task N complete" and nothing else unless blocked.
Apply all changes to the markdown source files. Do not alter any section not listed here.

---

## Tasks

### Task 3 — Abstract

Partial rewrite.

### Task 6 — §1.2 Objectives

Restructure as a subsection. Content must reflect the final two sections of the report and the
contents of the appendices.

### Task 7 — §8 Implementation Timeline

Add the following note at the top of the section, in bold red:

> **⚠ USER ACTION REQUIRED: Immediately after benchmark completion and finalisation of the
> PDHD code repository, request the agent to regenerate all Mermaid diagrams in this section.**

### Task 8 — §9 Results and Discussion (opening paragraph only)

Rewrite the section introduction carefully to reflect that development is still in progress and
that §8 Implementation Timeline will receive further additions. Do not overclaim completeness.

### Task 10 — §9.2 Key Findings

Stub out. Replace all content with the following note, in bold red:

> **⚠ PRIORITY 1 — ADDRESS THIS SECTION FIRST DURING REWRITE.**

### Task 16 — §9.9 Future Work

Alter to reflect that the specification of tools, models, application configuration, application
state, and expected output definitions were only weakly stabilised during early phases of
implementation, due to the explorative nature of developing a plan and requirements gathering
spanning the majority of early development cycles.

### Task 21 — §4.2.5.1 Scenario Classes

Fold content into §4.2 Methodology. Remove §4.2.5.1 as a standalone subsection.

### Task 22 — §11.3 A. System Diagrams and Architecture Charts

Label the existing tool execution sequence diagram as a prototype. Append a new placeholder
diagram section for the reworked tool-calling and message history mechanism, clearly marked
for later completion.

### Task 26 — §11.1 [-] Prompt Format Note: Observed Critical Usage Pattern

Comment out the entire section. Add the following note immediately above the commented block,
in bold red:

> **NOTE: PRIORITY 3 — Must be addressed by the user on the completion of all noted rewrites without aid.**
