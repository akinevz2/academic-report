## 1.1 Background and Motivation

The rapid maturation of large language models (LLMs) has opened new possibilities not only for the applications they power, but for the way software itself is built. Traditionally, developing a non-trivial application demands deep expertise across the full stack — architecture, implementation, testing, and deployment. Acquiring and applying that expertise is time-consuming, and the gap between a developer's intent and a working system can be substantial.

An emerging practice known as "vibe coding" addresses this gap by delegating the majority of the implementation work to an AI coding assistant. The developer retains responsibility for high-level design decisions, requirements, and evaluation, while the LLM generates the concrete code. This approach lowers the barrier to building complex systems and allows a single developer to move significantly faster than would otherwise be possible.

At the same time, local, open-weight LLMs such as Meta's Llama 3.2 have become practical tools for building end-user applications. Running inference locally removes reliance on external API providers, reduces latency, and gives developers full control over model behaviour. The challenge, then, is not merely choosing a model, but engineering a complete web application around it — and doing so using LLM-assisted development as the primary construction method.

This project sits at the intersection of these two trends: we build an LLM-powered web application while ourselves relying on an LLM (via GitHub Copilot) to do most of the building. The result is a self-referential case study that sheds light on both what vibe coding can produce and how LLM-integrated applications can be structured.
