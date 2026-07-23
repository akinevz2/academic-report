# Overview

This section introduces the core technologies used in the project and clarifies how they were combined into a practical development workflow. The setup is presented in two parts: the developer environment and the LLM environment.

The developer environment is centered on Visual Studio Code, with Debian running under WSL as the primary host context for day-to-day implementation work. Developer environment and tooling is managed through Docker with devcontainers to keep dependencies consistent and reproducible across sessions.

Ollama, LM Studio, and msty.ai model servers on the homelab workstation were evaluated for integration with editor-based assistants including VS Code Copilot and Claude Code. These tools proved essential for rapidly developing features and estimating feasibility within available project time.

Heavy use of terminal scripting combined with Vim-style keybindings and Makefile workflow served as an additional productivity factor in this setup within Visual Studio Code. These made the workflow strongly keyboard-driven: routine tasks such as running builds, restructuring files, searching project-wide text, and iterating on report output could be executed with minimal context switching. In practice, this interaction style reduced friction during frequent edit-build-review cycles and supported faster iteration when coordinating code changes, tooling commands, and documentation updates.

[#coding-agents](./coding-agents.md)

## Vim

Vim-style editing was central to this workflow, supported by custom keybindings: `Ctrl-A` (rebind of `Shift-A`), `Ctrl-B` (terminal management), `Ctrl-G` (file management), and `Ctrl-I`/`Alt-I` (agent management). These mappings made routine typing and editing operations significantly more fluid and reduced interruption during implementation.

VS Code Copilot also integrated effectively as inline autocomplete. Useful suggestions and refactoring actions were commonly accepted directly with a `Tab` keypress, avoiding repeated navigation to the refactoring menu. However, suggestions occasionally lagged behind developer input, despite offering faster iteration than manual refactoring approaches.

[#java-with-quarkus](./java-with-quarkus.md)
[#professional-considerations](./professional-considerations.md)

## Findings and Achievements

This project pursued higher-order workflow capabilities through a specification-as-documentation approach rather than isolated endpoint implementations. The implementation applied functional programming principles, test-driven development practices, and Git-based Agile workflows to realise menu-driven interaction models, modular tool orchestration across exploration, reading, writing, introspection, and persistent project knowledge management, alongside Retrieval-Augmented Generation with reproducible results.

The application stack supports practical reliability and governance features, including transactional execution boundaries, explicit error pathways, telemetry-backed observability, and compatibility handling for evolving tool interfaces.

On the frontend, it supports progressive frontend integration for browsing, summarisation, and activity tracing, with discoverability and UX gaps easier to identify and address iteratively. Overall, a platform that could be refined continuously under real development constraints was produced.

Investigation of Quarkus capabilities showed promise for iterative design, though some features—automated model provisioning, fallback startup paths, startup-time REST client wiring, and strict config mapping—proved reliable only under specific conditions. This required a more cautious approach based on explicit validation, fail-fast behavior, and incremental compatibility adjustments.
