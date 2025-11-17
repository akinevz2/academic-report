# Project Specification

[](PROPOSAL.md)

The application architecture must be portable and based on web technologies to minimize the number of functions that need to be implemented from scratch. Reusing existing components is a priority, and leveraging established frameworks presents significant opportunities for efficient development.

## Architectural Principles

The application components must be well-decoupled such that they can be developed with minimal inter-dependency while maximizing cohesion. Extensibility planning must be considered at every design point, ensuring that components can be replaced or modified as needed without disrupting the overall system.

## Technical Requirements

The combined software suite needs to be easy to install, maintain, and repair. A scripting language is a suitable choice as long as it supports console user interface definition. Given the modular nature of the system, a managed systems language can be used to define a composition layer that integrates components seamlessly.

A database is required to cache requests, as initial prototype testing revealed significant latency issues that need to be addressed through proper caching mechanisms.

## User Experience

The project should be suitable for users across a broad spectrum of skill levels. It must be possible to use the application without requiring users to have complementary skills in software setup or configuration.

## Reliability and Standards

Reproducibility and idempotency should be core principles of the software project definition. A multi-repository approach should be adopted to increase portability and reduce component inter-dependency, allowing for independent development and deployment of individual modules.

## Accessibility and Inclusivity

The application must not favor one type of user over another. Technical users should be able to apply the software to a wide range of problems without design decisions that limit their capabilities. Advanced users should benefit from the architecture by being able to create extensions and customizations that enhance functionality.