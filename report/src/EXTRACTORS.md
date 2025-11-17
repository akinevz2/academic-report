## Extractors

The extractor component, later renamed to `pagerts`, is a JavaScript/TypeScript-based module designed to extract hyperlink data from web pages. It implements the following specification:

> Given a URL input, produce an object in a schema-less format that communicates the contents of a document at a glance.

### Design Principles

The extractor is built with extensibility in mind to support rapid development while ensuring frontend compatibility. The implementation follows these key principles:

- **Interface Consistency**: The extractor behaves according to a consistent interface that allows it to be spawned from a managing runtime, such as a shell with output directed to standard output
- **Frontend Independence**: The system is designed so that frontend components will not break when new features are added to the set of properties to be presented to users
- **Performance Focus**: Designed for fast project turnaround while maintaining scalability

### Technical Implementation

The extractor leverages `jsdom` library, a pure-JavaScript implementation of web standards, chosen to comply with established browser software behavior. This ensures consistent document object model parsing across different environments.

The `pagerts` module is implemented as a pure TypeScript module that can be installed as a global system dependency through npm. It can be found at [akinevz0/pagerts](https://github.com/akinevz0/pagerts).

### Functionality

The extractor processes web documents and produces structured output containing:

- Hyperlink information
- Document metadata
- Resource relationships
- Hierarchical structure indicators

This data serves as the foundation for subsequent processing and visualization components.