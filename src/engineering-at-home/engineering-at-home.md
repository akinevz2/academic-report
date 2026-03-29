# 7. Engineering at Home {#engineering-at-home}

This section documents the local engineering workflow used to develop and evaluate the project in a home-lab environment.

## Local Stack
- Java backend with Quarkus
- React 18 + TypeScript frontend
- Vite 5 for frontend build and development tooling
- Markdown rendering via react-markdown and remark-gfm

## Development Workflow
Typical local workflow:

1. Start backend services.
2. Run frontend development mode.
3. Test filesystem navigation and chat tool-calling flows.
4. Validate endpoint contracts and timeout behavior.
5. Build production assets and re-test integration.

## Frontend Application Structure
The frontend is organized into:

- Entry point and application shell
- Reusable visual components
- Stateful hooks for menu panels and file highlighting
- API helper layer for typed GET/POST calls
- Shared type definitions and theme styles

## Primary UI Areas
- Top menu and modal panels for runtime configuration
- Current working directory navigation
- File browser panel
- Assistant chat panel
- Explorer canvas with floating project windows

## Backend API Usage
Core endpoint groups exercised in local testing:

- Filesystem and project endpoints (cwd, directory listing, tree, file, raw file)
- Assistant endpoints (chat, one-shot requests, reset)
- Activity endpoints (tool activity stream)
- Configuration endpoints (runtime menu settings)

## Practical Constraints in Home Setup
- Long assistant requests require higher timeout budgets than standard API calls.
- Large directories must be filtered to avoid expensive scans.
- Local resource limits can affect responsiveness during concurrent tool execution.
- Strict path validation is required to prevent accidental traversal outside project scope.

## Operational Conventions
- Maintain explicit loading and error states in UI flows.
- Keep API responses strongly typed.
- Avoid path guessing in frontend logic; rely on backend-provided data.
- Use dedicated long-timeout paths for assistant calls.

## TODO: Bring In From 92 Percent Report {#todo-engineering-at-home-from-92}
- TODO: Add a subsection quantifying hardware and compute limits encountered during development.
- TODO: Add a subsection discussing local-vs-cloud trade-offs and the cost constraints that affected choices.
- TODO: Add concrete examples where limited compute changed the experimental plan or scope.
