# Overview

> The project structure is outlined in the order of implementation.

The project is structured around three core components that work together to provide webpage hierarchy visualization capabilities. Each component serves a distinct purpose while maintaining loose coupling through well-defined interfaces.

## Component Architecture

### 1. Extractor
The extractor represents the first component of the system, functioning as a web-adjacent tool specialized in hyperlink extraction rather than content scraping. This component acts as the primary ingress point for web data and can operate completely standalone with minimal prerequisites. Its design focuses on extracting hyperlinks and their relationships, providing structured output that can be redirected and consumed by subsequent components in the pipeline.

### 2. Runner
The runner serves as the pipeline coordinator between the extractor and the frontend. It processes the extracted data through a service layer that handles database caching, exception management, and data forwarding to the final endpoint. This component ensures reliable data flow and error handling throughout the processing chain.

### 3. Frontend
The frontend focuses on user interaction and presentation, operating as a web-based interface that consumes processed data from the backend. While the backend includes frontend source code as a subproject, the frontend's primary responsibility is defining user interaction models and presenting hierarchical web structures in an accessible format.

## Implementation Approach

This architecture emphasizes modularity and separation of concerns, with each component designed to be independently deployable while working seamlessly together. The extractor's specialized focus on hyperlink extraction drives the overall design language, ensuring compatibility and consistency across the entire system.