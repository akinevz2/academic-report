### Backend

**graphbrowser** backend is implemented as a Quarkus application, which is a java framework specialised for building spring-compatible web applications.

Layers of the hierarchy are presented as nodes on a graph. They are termed "resources", and can be either remote or viewed.

Remote resources are represented as a simple tuple of url and a displayable label scraped from a viewed webpage.

Viewed resources are represented as a complex tuple of url, the resolved title property of the hypermedia object, and a list of references to remote resources in the document.

Code is organised into logical units by functionality: beans are plain java objects declaring encapsulation of state and attached behaviour, such as an external command line application runner. Config are parameters to the Quarkus context dependency injection framework defined as application-lifetime scoped producer beans. DTO entities represent data transfer objects acting as interface between output of the `pagerts` application and `graphbrowser`. Repository pattern is used to locate remote and viewed resources, which are stored adjacent as database-enabled entities.

```bash {#b caption="Backend Project Structure"}
graphbrowser/src/main/java
`-- ac
    `-- uk
        `-- sussex
            `-- kn253
                `-- graphbrowser
                    |-- beans
                    |-- config
                    |-- entities
                    |   |-- dto
                    |   |-- repositories
                    |   `-- resources
                    |-- exceptions
                    |-- resources
                    `-- services
```

The service layer defines compact units of computation that handle sanitising the user-provided input and the result of the extractor component.

`quarkus-quinoa` is the library of choice for packaging the frontend. Sources stored in `src/main/webui` are transformed and executed by the runner, and packaged into the native `META-INF` folder for release builds.

Application resources expose the service layer to the jaxrs web-request handlers so that they can be accessed on the same port as the frontend.

`src/main/resources/application.resources` set the Quarkus, database, logging, and any other runtime configuration.

`@ConfigProperty` annotation can be used to declare custom configuration path items on an interface.

Project build definition is created via `quarkus-cli`. 

## Backend

The backend component, named `graphbrowser`, is implemented as a Quarkus application, a Java framework specialized for building Spring-compatible web applications.

### Architecture Overview

The system represents hierarchical layers as nodes on a graph, with each layer termed a "resource." Resources can be either:

- **Remote resources**: Simple tuples of URL and displayable label scraped from viewed webpages
- **Viewed resources**: Complex tuples including URL, resolved title property, and list of references to remote resources

### Key Components

**Beans**: Plain Java objects that encapsulate state and behavior, such as external command line application runners.

**Configuration**: Parameters for the Quarkus context dependency injection framework defined as application-lifetime scoped producer beans.

**DTO Entities**: Data transfer objects that serve as interfaces between `pagerts` output and `graphbrowser` processing.

**Repository Pattern**: Used to locate remote and viewed resources, which are stored as database-enabled entities.

### Service Layer

The service layer handles:

- Input sanitization from user-provided data
- Processing results from the extractor component
- Data transformation for frontend consumption

### Frontend Integration

The `quarkus-quinoa` library packages the frontend. Sources stored in `src/main/webui` are transformed and executed by the runner, packaged into the native `META-INF` folder for release builds.

Application resources expose the service layer to JAX-RS web-request handlers, making them accessible on the same port as the frontend.

### Configuration

`src/main/resources/application.properties` sets Quarkus, database, logging, and other runtime configurations. The `@ConfigProperty` annotation enables custom configuration path items on interfaces.

The project build definition is created via `quarkus-cli`.