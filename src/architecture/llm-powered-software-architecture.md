# 4. LLM Powered Software - Software Architecture {#architecture}

## System Overview
The software architecture uses a layered tool-calling model for LLM-driven engineering workflows. The implementation combines a Quarkus backend, modular tool-dispatch components, and a React-based frontend. The design prioritizes maintainability, safety controls, and predictable runtime behavior under iterative LLM interaction.

## Architectural Pattern
The runtime follows a modular command-dispatch architecture:

1. A service-level dispatcher selects a module that can handle a requested tool.
2. Each module delegates execution to a registry of single-purpose tool macros.
3. Each macro validates arguments and performs one cohesive behavior.

This combines plugin-style extensibility at module level with command-style isolation at tool-operation level.

## Core Components
- Tool service entry point with transactional execution boundaries
- Tool modules for capability grouping (explore, read, write, introspect)
- Macro registry for canonical-name and alias resolution
- Tool macro implementations as single-responsibility operations
- Read-context persistence support for caching discovered project knowledge

## Execution Flow
Given a tool execution request, the backend:

1. Selects the first module that can handle the tool name.
2. Parses JSON tool arguments.
3. Resolves aliases/keyphrases to canonical tool names.
4. Executes the matching macro.
5. Returns a string result to the calling LLM runtime.

## Naming and Compatibility
Canonical tool names are used internally, while aliases and legacy keyphrases are retained for backward compatibility with older prompts and conversation state. Name resolution is normalized through lowercase/trim preprocessing before lookup.

## Error and Failure Model
The error model is intentionally explicit and LLM-readable:

- Unknown tool errors for unsupported names
- Invalid argument errors for parse failures
- Tool execution failures for runtime exceptions

Tools may additionally return domain-specific messages for path validation and file-access failures.

## Persistence and Context Caching
Tool execution is transaction-scoped, and read-oriented operations persist context into project knowledge storage. Cached entries include file contents, path summaries, detailed path analyses, and folder snapshots. Cache persistence is best-effort so the primary tool response is preserved even when cache writes fail.

## Security and Robustness Controls
- Path traversal protection for project-scoped operations
- Directory existence/type validation before recursive traversal
- Ignore rules for high-cost trees such as .git, node_modules, target, and build
- Output truncation and sampling to limit context volume and token overhead

## Integration with Frontend
The architecture exposes REST endpoints used by the frontend for file navigation, content retrieval, chat operations, and runtime activity inspection. This separation keeps UI orchestration independent from backend tool-dispatch internals.

## Design Trade-Offs
The macro-per-operation design increases class count but improves local testability and safer refactoring. String-oriented tool input/output is practical for LLM interaction, though less type-safe for non-LLM clients.

## TODO: Bring In From 92 Percent Report {#todo-architecture-from-92}
- TODO: Add a dedicated subsection on event-driven coordination analogous to the source report's event-system discussion.
- TODO: Add an explicit "Inversion of Control" subsection that describes dependency-injection constraints in this project context.
- TODO: Add one diagram showing component/module communication and where coupling is intentionally accepted.
- TODO: Add an "Alternatives" subsection comparing current architecture with at least two credible alternatives and rationale for rejection.