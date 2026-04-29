# Cut Section Notes

Content worth preserving from sections 6 (Project Requirements) and 7 (Engineering at Home) before they are removed.

---

## From Section 6: Project Requirements

### Delivery Model paragraph

> Development followed an iterative LLM-assisted workflow in which requirements were refined alongside implementation. Each iteration defined expected tool behaviour, implemented or adjusted the relevant backend components, and validated outcomes through tests and runtime checks. Useful read-context was persisted into the project knowledge store across sessions, and stable backend interfaces were incrementally exposed to the frontend as they stabilised. This approach prioritised working software over upfront specification completeness, allowing constraints to be discovered and documented incrementally rather than assumed in advance.

**Where to add:** Results and Discussion — this belongs in the Discussion under methodology framing. It gives the reader context for _why_ the final build looks the way it does (iterative discovery, not upfront spec). Good fit alongside the honest acknowledgement of packaging-stage limitations.

---

### Expected Outcomes bullet list

- Reliable tool dispatch with explicit error and transaction boundaries
- Modular backend structure enabling isolated changes across functional areas
- Improved interaction efficiency through persistent context caching between sessions
- Clear integration boundaries between backend services and the frontend web UI
- Graceful handling of Ollama availability constraints in both development and deployment

**Where to add:** Project Architecture — either at the end of the Application Structure or Architectural Choices sections as a short "design targets" paragraph. Frames what the architecture was _trying_ to achieve before Results discusses what was actually delivered. Alternatively, fold into the abstract's second paragraph as a tighter list.

---

### Backend Selection Strategies (subsections 3.2.1–3.2.3)

All three subsections (Hardware Considerations, Software Stack Evaluation, Cost-Benefit Analysis) are **empty**. No content to preserve. Safe to delete entirely.

---

## From Section 7: Engineering at Home

### Practical Constraints in Home Setup

- Long assistant requests require higher timeout budgets than standard API calls.
- Large directories must be filtered to avoid expensive scans.
- Local resource limits can affect responsiveness during concurrent tool execution.
- Strict path validation is required to prevent accidental traversal outside project scope.

**Where to add:** Resource Requirements (5.6.2) — these are direct runtime constraints that belong alongside the VRAM/context-window discussion. Reword as prose rather than bullets. Specifically, the path validation and directory filter points are unique and currently unmentioned anywhere.

---

### Frontend Application Structure + Primary UI Areas

Entry point and application shell / reusable components / stateful hooks / API helper layer / type definitions and theme / top menu + modal panels / CWD navigation / file browser / chat panel / explorer canvas with floating windows.

**Where to add:** Project Architecture Package Map or Core Components (5.3.1) — the frontend structure is currently described only in terms of signals and dispatch. These specifics (hooks, API layer, canvas/floating windows) add concreteness. Good as a short paragraph or sub-bullet block under the frontend package entry.

---

### Operational Conventions

- Maintain explicit loading and error states in UI flows.
- Keep API responses strongly typed.
- Avoid path guessing in frontend logic; rely on backend-provided data.
- Use dedicated long-timeout paths for assistant calls.

**Where to add:** Architectural Choices (5.5) — these are design decisions with real rationale, not just operating procedure. The strong-typing and path-guessing points reinforce the "explicit contracts" theme of the backend. Could be folded into the Error and Signal Model or a short paragraph at the end of Architectural Choices.

---

### Development Workflow (numbered list)

The 5-step local workflow (start backend → frontend dev mode → test flows → validate contracts → build production) is **too generic** to be worth preserving verbatim. Skip it.

---

## Summary of Recommended Actions

| Content                                                 | Destination                                                    | Priority |
| ------------------------------------------------------- | -------------------------------------------------------------- | -------- |
| Delivery Model paragraph                                | Results and Discussion — Discussion subsection                 | High     |
| Expected Outcomes bullets                               | Project Architecture — Architectural Choices closing paragraph | Medium   |
| Practical Constraints (timeout, path, directory scan)   | Resource Requirements (5.6.2)                                  | High     |
| Frontend structure specifics (hooks, canvas, panels)    | Package Map / Core Components (5.3.1)                          | Medium   |
| Operational Conventions (strong typing, path contracts) | Architectural Choices (5.5)                                    | Low      |
| Backend Selection Strategies 3.2.1–3.2.3                | Delete — all empty                                             | —        |

---

## Additional Unique Points From docs/ Cross-Reference

These were checked against src and appear to be either missing or only partially covered.

### 1. End-to-end feature verification matrix (high value)

- **Source:** docs/frontend-feature-verification.md
- **Unique point:** as of 2026-04-10, only chat streaming and GitHub link opening were verified working; file preview/summarise and folder/project summarisation were blocked by missing backend route or websocket entrypoints.
- **Where to add:** Results and Discussion (validation evidence subsection).

### 2. Folder summary evidence leakage into user-facing UI

- **Source:** docs/known-issues.md, docs/session-3-issues.md
- **Unique point:** internal evidence headers from `read_folder_manifest` (for example, sampled evidence markers) were echoed by the model and surfaced in frontend summaries; this is a concrete UX regression with a clear root-cause chain.
- **Where to add:** Results and Discussion (limitations + remediation options).

### 3. Startup architecture simplification (Testcontainers/model pull removal)

- **Source:** docs/operation-summary-2026-04-09.md
- **Unique point:** startup path was explicitly simplified from auto-provisioning/model-pull behavior to health-check-only endpoint validation; this is a meaningful design deviation with strong evidence.
- **Where to add:** Results and Discussion (scope reduction/deviation), with a short cross-reference in Project Architecture.

### 4. File browser discoverability gaps with concrete effort estimates

- **Source:** docs/session-3-issues.md, docs/known-issues.md
- **Unique point:** parent directory entry rendered as a separate control and no visible "Explore/Open in Canvas" action in browser list; includes low/medium effort remediation estimates.
- **Where to add:** Results and Discussion (future work/usability gaps).

### 5. Error-visibility gap after exception refactor

- **Source:** docs/session-3-issues.md, docs/session-3-log.md
- **Unique point:** cache operations moved from null-return to exception semantics, but some failures remained debug-only and effectively invisible to end users.
- **Where to add:** Results and Discussion (observability limitations).

### 6. Quick-start/developer-guide/API contract docs gap

- **Source:** docs/known-issues.md
- **Unique point:** planned documentation deliverables (`quick-start.md`, `developer-guide.md`, API contract publication) are still absent; this is a concrete non-code deliverable gap.
- **Where to add:** Results and Discussion (non-functional deliverables and limitations).

### 7. Tool package design inspired by Copilot-style grouped capabilities

- **Source:** Author design intent (not yet documented in full in src).
- **Unique point:** the tool package was intended to mirror GitHub Copilot-style capability grouping, where tools are categorised into coherent sections and subagents can invoke a collection of related tools to produce a consolidated response rather than isolated single-tool outputs.
- **Where to add:** Project Architecture (Package Map / Core Components) as design rationale, plus a short reflection in Results and Discussion on what was achieved versus what remained partial in the final build.

**Suggested neutral phrasing:**

"A key design objective was to structure tools into grouped capability domains, enabling subagent-style orchestration of multiple related tool calls and aggregation of their outputs into a single coherent response. This approach was intended to improve discoverability, reduce prompt-level coupling to individual tool names, and better align the interaction model with established Copilot-style workflows."

### Notes on duplicates that were excluded

- Testcontainers/Ollama external dependency is already partly present in src/introduction/overview/java-with-quarkus.md and src/project-architecture/project-architecture.md.
- RAG/embeddings are already mentioned in src/project-architecture/project-architecture.md and src/project-architecture/resource-requirements.md.
- Multi-provider scope and host network constraints are already present in introduction/results sections.
