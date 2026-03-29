# 6. Project Overview {#project-overview}

This project develops an LLM-powered software system using a Java/Quarkus backend and a web-based frontend. The engineering emphasis is on reliable tool-calling workflows where an LLM can issue structured operations against project files, inspect outputs, and iteratively refine implementation decisions.

## Scope {#project-overview-scope}
The implemented scope covers:

- Tool registration and dispatch
- Per-tool macro execution model
- Alias-to-canonical name resolution
- Error and transaction behavior
- Read-context caching into persistent project knowledge
- Frontend integration for file exploration and chat interaction

## System Modules
The backend groups functionality into modules:

- Explore: filesystem discovery, navigation, and path analysis
- Read: file and folder content reads
- Write: controlled output generation and persistence support
- Introspect: session and project manifest views

Each module contributes tool macros that implement single operations with explicit contracts.

## Delivery Model
Development follows an iterative LLM-assisted workflow:

1. Define constraints and expected tool behavior.
2. Implement or refine focused tool macros.
3. Validate through tests and runtime checks.
4. Persist useful read-context for later tool calls.
5. Expose stable backend interfaces to the frontend.

## Expected Outcomes
The architecture is intended to deliver:

- Deterministic tool dispatch under mixed alias usage
- Safer refactoring through low-coupling tool classes
- Improved interaction efficiency through context caching
- Clear integration boundaries between backend and frontend layers

## TODO: Bring In From 92 Percent Report {#todo-project-overview-from-92}
- TODO: Add a subsection listing major development challenges and how they were mitigated.
- TODO: Add a subsection on experiment or iteration method (what changed between versions and why).
- TODO: Add one subsection that records negative results or dead ends, not only successful decisions.
