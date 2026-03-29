## 1.2 Project Scope and Objectives

The project has two interlocking objectives: building a functional LLM-integrated web application, and documenting the process of building it through vibe coding.

**The application** targets end-users who wish to interact with a locally-running language model through a web interface. The backend is powered by Meta's Llama 3.2, run via Ollama, and exposes a conversational interface over HTTP. The frontend provides a clean chat UI accessible from a browser. The scope covers the full development lifecycle: requirements, architecture, implementation, and basic evaluation.

**The development process** is conducted using off-the-shelf AI coding models available under a GitHub Copilot subscription — specifically GitHub Copilot in agent mode within VS Code. No custom or fine-tuned coding models are used. The developer (the author) applies traditional software engineering practices — requirements analysis, system decomposition, iterative refinement — but writes minimal code by hand, instead directing the AI assistant through natural language prompts.

The objectives are:

1. To produce a working, deployable web application that interacts with Llama 3.2.
2. To characterise the vibe coding workflow: what works well, where friction arises, and what supervision is required.
3. To evaluate the quality and maintainability of LLM-generated code relative to the developer's intent.
4. To reflect on the role of traditional software engineering discipline when implementation is substantially delegated to an AI.
