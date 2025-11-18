## Database

Database management is delegated to Quarkus with H2 SQL flavor chosen for its ability to handle in-memory transactions efficiently.

### Database Selection

H2 was selected over SQLite due to:

- Better support for in-memory transactions
- Avoidance of file-lock exceptions common with SQLite
- Superior integration with Quarkus and Hibernate ORM

### Implementation Approach

**Hibernate Integration**: Exposes both statement- and class-object based interfaces, allowing prepared statements for increased configuration granularity.

**Quarkus Panache Library**: Enables simple object-oriented modeling of database structure through entity declarations that can be located using the repository design pattern.

### Database Schema

The database stores:

- Remote resources (URL and displayable labels)
- Viewed resources (URL, title, and references to remote resources)
- Hierarchical relationships between resources
- Cached extraction results for performance optimization

### Configuration

Database configuration is managed through Quarkus properties files, with connection parameters and transaction settings properly configured for optimal performance during both development and production environments.