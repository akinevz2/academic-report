### Hosting

Quarkus implements a superset of graal-vm via the [mandrel library](https://quarkus.io/guides/building-native-image), a technology for compiling java code to native executables. Building with `native` profile produces a specialised binary with all unused symbols removed in the `build/` directory.

Resulting application binary can be declared within a Dockerfile so that the project can be hosted online, bringing a conclusion to the cycle of abstracting over components and interfaces. 

## Hosting

The application is designed for efficient deployment using native image compilation technology.

### Native Image Compilation

Quarkus implements a superset of GraalVM via the Mandrel library, enabling Java code compilation to native executables. Building with the `native` profile produces a specialized binary with all unused symbols removed in the `build/` directory.

### Containerization

The resulting application binary can be declared within a Dockerfile, enabling online hosting and deployment. This approach brings a conclusion to the cycle of abstracting over components and interfaces.

### Deployment Benefits

- **Lightweight Execution**: Native binaries provide faster startup times and reduced memory usage
- **Container Portability**: Docker packaging ensures consistent deployment across different environments
- **Scalable Infrastructure**: Enables easy hosting and scaling of the application
- **Reduced Dependencies**: Native compilation eliminates need for JVM runtime environments

### Production Readiness

The hosting approach ensures:

- Fast application startup
- Minimal resource consumption
- Easy deployment across various platforms
- Seamless integration with modern DevOps practices