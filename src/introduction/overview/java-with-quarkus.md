## Java with Quarkus

### Features Considered for Implementation

At the start of this project, I expected to explore a wider implementation space than what would eventually fit into the final report. I planned for support of multiple LLM providers, including internal Testcontainers-based options and external Ollama base-url based options, so that the system could stay usable under different runtime conditions. I also wanted to keep a native deployment path available for lower-footprint execution and to include workstation-oriented integration testing for real model and tool interactions.

During development I explored different higher-level usability goals, including nested menu and assistant session flow through declarative coding, clean entry and exit behavior, and predictable returns to parent contexts. In parallel, I focused on seeding the frontend codebase with strong design decisions, including packaging the Web UI as a React application with modules and a signals library implemented as separate logical packages.

### Key Libraries

The implementation stack is built on Quarkus extensions and complementary libraries. The following summarises the core runtime dependencies:

This produces the complete hierarchical view of transitive dependencies, pinned versions, and any convergence warnings. These libraries formed a practical foundation for implementing the planned capabilities within the Quarkus runtime model.
