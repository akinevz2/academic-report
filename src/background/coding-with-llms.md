## The Role of LLMs in Software Development

LLMs can support software development by translating intent into explanations, structured documentation, and code. Their value in modern engineering work can be seen in the shift from repetitive drafting toward evaluation, integration, and quality control activities.

Within that framing, two related modes are useful to distinguish. In LLM-assisted development, the developer remains the primary decision-maker and uses models to draft code, investigate errors, write documentation, and propose refactorings. Agentic development extends this approach by allowing the model to execute bounded multi-step tasks, such as planning actions, invoking tools, and iterating toward a defined objective under human supervision. Together, these modes can shorten iteration cycles and expand exploratory capacity, while increasing the need for validation, architectural discipline, and constraint-aware decision making.

### Key Capabilities of LLMs in Coding

- **Code Generation**: LLMs can draft snippets, components, and implementation skeletons from requirements.
- **Debugging Assistance**: They can propose fault hypotheses, explain error traces, and suggest candidate fixes.
- **Documentation**: They can accelerate production of comments, API notes, and technical summaries.
- **Refactoring Support**: They can suggest structural changes that improve readability and maintainability.

When applied in bulk, these operations can often outperform a purely human approach, as the AI model can approach problems from multiple endpoints at the same time, or perform remote edits by transforming batches of files while the developer remains focused on the current problem scope.

Caution is needed when LLM tooling is less accurate than the specification the developer provides, as it happens with any software. A key symptom is having to rework large amounts of quickly generated code with loosely specified intent, remove unnecessary abstractions, and unpack overly verbose documentation.

### Integration with Engineering Workflows

In practical workflows, these capabilities are often delivered through editor assistants, CLI agents, and service integrations that operate during active development. Tools such as GitHub Copilot can provide real-time suggestions, while more agentic systems can execute multi-step tasks across files and tools under developer control.

### Current Research on LLM-Assisted Software Engineering

Recent software engineering literature reports that LLM-assisted development can improve throughput in selected tasks, but that reliability, evaluation quality, and reproducibility remain unresolved concerns in many practical settings [@Fan_2023; @Hou_2024]. The current consensus is therefore cautious rather than absolute: these systems are most effective when used with explicit constraints, verification steps, and measurable quality criteria instead of anecdotal performance claims.

Recent work on agentic systems further suggests that multi-step tool use introduces additional coordination and control challenges, especially when systems move from single-turn drafting into workflow-level automation [@Plaat_2025]. For code-focused pipelines, retrieval-augmented approaches are increasingly studied as a way to ground generation in repository context and reduce unsupported outputs [@Kivroglou_2025; @Wang_2025].

For this report, the focus is on how reliably the output can be integrated into disciplined software engineering processes without reducing verification, maintainability, or accountability.
