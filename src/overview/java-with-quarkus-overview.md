# 2. Java with Quarkus - Overview {#overview}

## What is Quarkus?
Quarkus is a Kubernetes-native Java framework that provides a set of features optimized for containerized applications. It is built on top of the Java Virtual Machine (JVM) and is designed to deliver fast startup times and low memory footprint, making it ideal for microservices and cloud-native applications.

## Why Quarkus for This Project?
- **Performance**: Quarkus' GraalVM native image support allows our application to run efficiently in containerized environments.
- **Developer Productivity**: The framework's built-in features for REST APIs, CDI, and JPA reduce boilerplate code and accelerate development.
- **Integration with LLMs**: Quarkus' lightweight architecture makes it easier to integrate with LLM-powered components while maintaining scalability.

## Key Features Utilized
- **RESTEasy**: For building API endpoints that interact with the LLM backend.
- **SmallRye Config**: For managing configuration settings in a Kubernetes environment.
- **Panache**: Simplifies database interactions with minimal boilerplate code.

## TODO: Bring In From 92 Percent Report {#todo-overview-from-92}
- TODO: Add a "Requirement Analysis" subsection for the Quarkus stack decision.
- TODO: Split requirements into "Functional" and "Non-Functional" lists using the same structure as the source report.
- TODO: Add a "Deviations" subsection describing how this project departs from a standard Quarkus CRUD architecture.
- TODO: Add one table mapping requirements to concrete implementation evidence in this codebase.