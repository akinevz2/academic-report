## Objectives

The project was originally scoped to develop a hardware resource governor capable of monitoring LLM server resource utilisation in real time. On closer examination, however, this design proved both redundant and unnecessarily complex: the functionality it would have provided closely mirrors what the host operating system already exposes through standard process and memory management interfaces. I therefore revised the scope to focus on the application layer, implementing instead an agentic web application with capabilities for filesystem exploration and file analysis.

This project is designed to explore the integration of LLMs into software architecture through a practical development process. The work combines implementation and analysis: I developed an LLM-integrated web application while examining how LLM-assisted development practices can be applied in day-to-day engineering work.

The objectives are structured as two interlocking strands. The first strand is technical delivery, specifically producing a working, deployable web application that interacts with LLM models. The second strand is evaluation, documenting and characterising the agentic coding workflow.

Building on these strands, the study also evaluates the quality and maintainability of LLM-generated code relative to developer intent, and reflects on the continuing role of traditional software engineering discipline when substantial parts of implementation are delegated to an AI system. Together, these objectives provide a focused basis for analysing both the benefits and the constraints of LLM use in practical engineering workflows.
