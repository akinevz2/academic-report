# Project Architecture

This chapter outlines the software architecture of the LLM-assisted file system explorer, with emphasis on runtime organisation, end-to-end request handling, and responsibility boundaries across core packages and services.

## Application Structure

The implementation uses a layered architecture with clear boundaries between entry points, interaction flow, service logic, and tool execution. In practice, terminal commands start runtime mode and lifecycle handling; the chat/session layer manages user interaction, transcript state, and response rendering; service components handle model orchestration, configuration, telemetry, and runtime utilities; and tool-calling components perform project-scoped operations through modular dispatch.

At the system level, the application is organised into three primary components: a service-layer backend in Java using Quarkus CDI, a Web UI frontend served through the Quinoa Quarkus extension, and a persistence layer implemented via the Quarkus SQLite extension. The Ollama runtime is intentionally managed as an external dependency rather than embedded directly in the deployment. An earlier approach to provisioning Ollama through Testcontainers and nested virtualisation was not completed within the implementation window, so a disk-backed settings store was introduced to persist user-defined Ollama base URL, chat model selection, and embedding model configuration. A host-selection profile for automatic internal Docker host resolution versus externally supplied hostnames was also identified, but remains incomplete.

## End-to-End Runtime Flow

Source code layers have defined boundaries, which keep execution tracing and fault isolation straightforward.
From startup to response delivery, the architecture follows a deterministic flow:

1. The application boots and initializes core runtime dependencies.
2. A user request enters through CLI or Web UI pathways.
3. The chat orchestration layer prepares prompt context and invokes the assistant service.
4. Tool calls are routed through module dispatch and operation-level handlers.
5. Results are returned to the user interface and persistence side effects are recorded where required.
6. Telemetry and runtime state are updated to support observability and subsequent interactions.
7. Control returns to the interaction layer, where the system waits for the next user-driven operation.
8. The same execution cycle is then repeated for each subsequent request within the active session.

## Package Map

| Package                          | Responsibility                                                       |
| -------------------------------- | -------------------------------------------------------------------- |
| `ac.uk.sussex.kn253`             | Defines the application entry point                                  |
| `ac.uk.sussex.kn253.menu`        | Implements terminal interaction, menu navigation                     |
| `ac.uk.sussex.kn253.commands`    | Defines command handlers and CLI command wiring                      |
| `ac.uk.sussex.kn253.services`    | Provides application-level orchestration services                    |
| `ac.uk.sussex.kn253.services.ai` | Implements AI-specific orchestration and model interaction services  |
| `ac.uk.sussex.kn253.resources`   | Exposes REST resources for interfacing with Web UI                   |
| `ac.uk.sussex.kn253.repository`  | Encapsulates persistence entities and database access operations     |
| `ac.uk.sussex.kn253.ollama`      | Implements client integrations for communication with Ollama APIs    |
| `ac.uk.sussex.kn253.tools`       | Contains assistant-invoked tool implementations                      |
| `ac.uk.sussex.kn253.events`      | Defines event records that support decoupled inter-component signals |
| `ac.uk.sussex.kn253.websocket`   | Handles WebSocket messaging for real-time assistant communication    |

### Core Components

**Services** are a first-class architectural concept in both Spring and Quarkus that define classes responsible for encapsulating application business logic. Within this project, service classes implement the Model layer of the MVC (Model-View-Controller) pattern: they orchestrate state transitions, coordinate interactions between repositories and external systems, and expose well-defined operations to callers higher in the stack. Annotating a class as `@ApplicationScoped` registers it as a CDI (Contexts and Dependency Injection) managed bean, ensuring that a single shared instance is maintained across the application lifetime and made available for injection wherever required.

**Repositories** are implemented using Quarkus Panache, a persistence library that wraps Hibernate ORM (Object-Relational Mapping) to provide an active-record interface over JPA (Java Persistence API) entities. Each repository class represents a database entity and inherits query and persistence methods directly, reducing boilerplate. Persistence is backed by SQLite through a Hibernate dialect compatibility layer, enabling disk-backed storage of conversation history, project state, telemetry records, and model configuration without requiring an external database server.

**Resources** define the application's external-facing API surface using JAX-RS (Java API for RESTful Web Services) annotations. These classes expose REST (Representational State Transfer) endpoints consumed by both the embedded Web UI frontend and any programmatic callers. Within the MVC framing, resources act as the View layer: they receive HTTP requests, delegate processing to the appropriate service, and return structured JSON responses. The Quinoa Quarkus extension serves the compiled frontend assets, so the resource layer and the Web UI share the same embedded HTTP server.

**Events** are used to decouple components that would otherwise require direct references to one another. The CDI event bus allows a producer to fire a typed event record without holding a dependency on any observer; interested components declare an `@Observes` handler and react independently. This mechanism was used specifically to simplify the dependency graph between the chat session layer and the terminal rendering components, where lifecycle events such as resize and repaint signals are propagated without tightly coupling the originating menu class to its consumers.

**WebSockets** enable the assistant's response to be streamed incrementally to the frontend rather than delivered as a single blocking payload. Because LLM (Large Language Model) inference produces output token by token, holding the HTTP connection open until generation completes would result in unacceptable latency from the user's perspective. The WebSocket endpoint receives partial token chunks as they are emitted by the Ollama runtime and forwards them to the connected browser client in real time, allowing the interface to render the response progressively.

**Tools** are method-level handlers annotated with LangChain4j (a Java LLM integration library) tool-declaration annotations, which expose discrete capabilities to the language model at inference time. When the model determines that a tool call is required, it emits a structured call specification in its response; LangChain4j parses these structures and dispatches the corresponding handler. Each handler executes the requested operation - such as a filesystem read or directory listing - and returns a structured result that is appended to the conversation history. Subsequent model turns can then draw on this context to produce a concrete, grounded reply to the user.

**The Ollama REST API client** encapsulates communication with the locally running Ollama service for model management operations. Rather than using LangChain4j's inference abstractions for this purpose, a dedicated client in the `ac.uk.sussex.kn253.ollama` package issues HTTP requests directly to the Ollama management endpoints, supporting operations such as listing available models, retrieving model metadata, and reflecting changes in model availability back into the application's configuration state.

**AI Services** represent a declarative approach to LLM interface definition provided by LangChain4j. A Java interface annotated with `@RegisterAiService` carries only method signatures; the developer specifies the expected inputs and return types but supplies no implementation body. At runtime, LangChain4j uses the Java Reflection API to generate a concrete proxy implementation that handles prompt construction, model invocation, and response binding automatically. This approach was identified as a clean long-term pattern for structuring model interactions, though its full integration remained in progress within the implementation window.

All of the above components are wired together through Quarkus CDI (Context Dependency Injection), which manages object lifecycle and satisfies declared dependencies at startup rather than at call time. Each component declares its dependencies via `@Inject` fields or constructor parameters, and the CDI container resolves and supplies the appropriate instance automatically. Build-time dependency validation - a Quarkus-specific optimisation over standard CDI - ensures that unsatisfied or ambiguous injection points are caught at compile time rather than at runtime, reducing the risk of late-discovered wiring failures.

## Services Layer

| Service                    | Primary Role                                                               |
| -------------------------- | -------------------------------------------------------------------------- |
| `TerminalLifecycleService` | Manages terminal provisioning, startup sequencing, and controlled shutdown |
| `AssistantService`         | Orchestrates LLM dialogue flow and coordinates tool invocation bridging    |
| `ModelConfigService`       | Persists and retrieves model configuration state                           |
| `OllamaManagementService`  | Manages local Ollama model lifecycle operations                            |
| `TelemetryService`         | Captures runtime metrics and tracks model and tool calls                   |
| `WorkingDirectoryService`  | Maintains project working-directory context for scoped operations          |
| `WebUiService`             | Manages embedded Web UI initialisation and lifecycle control               |
| `RuntimeManagementService` | Provides runtime control utilities, including shutdown handling            |

## Architectural Choices

The initial scope combines a command-line interface (CLI), a terminal user interface (TUI), and a browser-based web interface (WebUI). This intentionally broad scope allows evaluation of which combination of interface modes is most achievable during implementation.

Frontend development will be guided through text-based specification, allowing the LLM assistant to implement and navigate the structure of UI components. Ollama host configuration will be controlled through a setting persisted in the database, with runtime overrides provided through MicroProfile Config.

### Error and Signal Model

Configuration settings will be hydrated from the backend. Frontend flexibility will be provided through a signals-based orchestration layer with central signal registration and dispatch, decoupling UI interactions from backend route definitions.

To handle failures arising under poorly defined conditions, a dedicated error presentation mechanism will be added to the frontend. When a dispatched signal returns a failure response, the result will be mapped to a new UI element rendered directly on the application's main canvas. Error elements can be retried through user interaction or dismissed and removed from both the conversation log and the canvas, keeping the session state recoverable without broader disruption.

### Persistence and Context Caching

Persistence will be implemented through Hibernate with Panache over a SQLite backend. Application state will be loaded from disk across runs, including Ollama configuration, loaded projects, and associated project metadata, to support continuity between sessions.

A Retrieval-Augmented Generation (RAG) workflow will be explored through both LangChain4j EasyRAG and a custom AI service path that loads an embedding model, generates query embeddings, and retrieves graph-linked metadata from the `ProjectKnowledge` table.

- [#system-integration](./system-integration.md)

## AI/LLM Powered Software

- [#llm-powered-software](./llm-powered-software.md)
