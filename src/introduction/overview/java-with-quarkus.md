## Java with Quarkus

### Features Considered for Implementation

At the start of this project, I expected to explore a wider implementation space than what would eventually fit into the final report. I planned for support of multiple LLM providers, including internal Testcontainers-based options and external Ollama base-url based options, so that the system could stay usable under different runtime conditions. I also wanted to keep a native deployment path available for lower-footprint execution and to include workstation-oriented integration testing for real model and tool interactions.

During development I explored different higher-level usability goals, including nested menu and assistant session flow through declarative coding, clean entry and exit behavior, and predictable returns to parent contexts. In parallel, I focused on seeding the frontend codebase with strong design decisions, including packaging the Web UI as a React application with modules and a signals library implemented as separate logical packages.

### Key Libraries

- **Quarkus REST** (`quarkus-rest`): for building API endpoints.
- **SmallRye Config**: for runtime configuration.
- **Panache ORM** (`quarkus-hibernate-orm-panache`): for persistence-layer development.
- **LangChain4j** (`quarkus-langchain4j-ollama`, `langchain4j-ollama`, `langchain4j-http-client-jdk`): for LLM integration and orchestration.
- **Picocli** (`quarkus-picocli`): for command-line interfaces.
- **JLine**: for interactive terminal behavior.
- **Quarkus REST Client** (`quarkus-rest-client`): for outbound HTTP calls.
- **Quarkus WebSockets Next** (`quarkus-websockets-next`): for websocket streaming.
- **Quarkus REST Jackson** (`quarkus-rest-jackson`): for JSON serialization.
- **Quarkus Micrometer** (`quarkus-micrometer`): for telemetry and metrics.
- **Quarkus Arc** (`quarkus-arc`): for dependency injection.
- **Quarkus Agroal + SQLite JDBC** (`quarkus-agroal`, `quarkus-jdbc-sqlite`): for database connectivity and persistence.
- **Quarkus Quinoa** (`quarkus-quinoa`): for frontend build integration.
- **Testing stack** (`quarkus-junit`, `maven-surefire-plugin`, `maven-failsafe-plugin`): for unit and integration tests.

These libraries formed a practical foundation for turning planned capabilities into working features.
