package uk.ac.sussex.kn253.workbench.resources;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@ApplicationScoped
@Path("/prompt")
public class PromptResource {
    
    @GET
    public String helloQuery() {
        return "Hello world";
    }
    
}