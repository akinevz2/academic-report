## 1.3 Report Structure

This report is organised into six main chapters, followed by appendices:

**Chapter I: Introduction** provides the background and motivation for this project, defines the scope and objectives, and outlines the structure of the report.

**Chapter II: Foundations of LLM Systems** establishes the theoretical groundwork by examining large language model architectures, distinguishing between inference and training workloads, characterising LLM workload requirements in terms of latency, throughput, and resource utilisation, and identifying key system integration challenges.

**Chapter III: Architectural Patterns and Design** explores the design space for LLM serving systems, covering inference serving architectures (single model, multi-model ensembles, and model routing), backend selection strategies (hardware, software stack, and cost-benefit considerations), query management and optimisation techniques (queuing, caching, and batch processing), and scalability patterns.

**Chapter IV: Practical Implementation Considerations** addresses the engineering aspects of deploying LLM systems, including infrastructure and deployment (containerisation, cloud vs. on-premise, resource provisioning), monitoring and observability (metrics, error handling, logging), and security and access control.

**Chapter V: Research Findings and Analysis** presents the results of our exploration, including evaluations of LLM routers and load balancers (with specific focus on the llama.cpp ecosystem and Ollama architecture), system design tradeoffs (cost vs. performance, complexity vs. maintainability, flexibility vs. stability), and lessons learned.

**Chapter VI: Conclusion and Future Work** summarises the key findings, provides recommendations for implementation, and identifies areas for further research.

**Appendices** include code examples and snippets, system diagrams and architecture charts, and research resources and references.
