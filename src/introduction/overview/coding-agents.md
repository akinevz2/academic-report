## Coding Agents

This subsection compares the coding-agent and local model tooling used during implementation, with attention to practical developer ergonomics, task fit, and observed operational constraints.

### VS Code Copilot

VS Code Copilot served as the primary development assistant in this project. It was used extensively to accelerate implementation tasks that would otherwise require repeated documentation cross-referencing, and it generally provided a comfortable and reasonably ergonomic workflow with usable default keybindings and acceptable agentic guardrails. Typical delegated work included rapid frontend React development, coordinated API updates across backend and frontend components, and ongoing documentation maintenance through markdown-oriented subagent workflows. In practice, the available token budget was a material constraint: the free tier was insufficient.

An explorative build-rewrite-analyse workflow implementation required the Copilot Pro Plus subscription.

### VS Code Copilot with Local Ollama Integration

VS Code Copilot connected to a local Ollama backend was evaluated for the same classes of tasks as standard Copilot usage. Although this setup reduced direct subscription cost, it depended on powering an auxiliary workstation for each session and did not provide adequate responsiveness for routine development. Once the higher Copilot subscription tier was adopted, the local integration path became functionally redundant for day-to-day work.

### Claude Code

Claude Code was tested through a local configuration approach in which the base URL was manually redirected to an Ollama instance. This setup was explored primarily for personal productivity tasks, including hardware-inventory maintenance and draft eBay listing generation, rather than core project delivery. The main observed limitation was context-window pressure relative to available workstation resources, which restricted usefulness despite a polished terminal interface.

### Ollama (Model Runtime)

Ollama functioned as a central model runtime for the application and, in some sessions, for agentic coding support. Model selection converged on Gemma4 because it offered a favorable speed profile while still supporting a large context window and CPU plus system-RAM offloading. Other attempted models included multiple Qwen3 sizes, glm-4.7-flash, gpt-oss, Qwen2.5-coder, Llama3.2, and Llama3.1. A consistent practical finding was that local inference quality and throughput depended strongly on careful model selection; a longer project timeline would likely have enabled a more rigorous benchmarking environment for direct model-to-model comparison.

### LM Studio

LM Studio was most effective as a question-answering interface in this workflow. Its development-server port mode, intended to expose the bundled model runner over the network, was constrained by binding behavior to localhost:11434, which prevented connections from the devcontainer and remote machines. Relative to msty.ai, its folder and conversation organization workflow was easier to use, though less feature-rich.

### msty.ai

msty.ai was also used primarily for question answering. It provided support for Ollama and llama.cpp, with explicit backend options across different GPU vendors and CPU execution. In this project context, these backend controls were not essential because the dedicated Ollama server already handled automatic GPU/CPU layer offloading across available processing units. Compared with other interfaces, msty.ai offered broad capability but a noisier, less developer-ergonomic user experience.
