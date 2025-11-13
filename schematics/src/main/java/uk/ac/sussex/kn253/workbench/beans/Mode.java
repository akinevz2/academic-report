package uk.ac.sussex.kn253.workbench.beans;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import io.vertx.core.json.JsonObject;
import jakarta.persistence.Entity;

@Entity
public class Mode extends PanacheEntity {
    String name;

    String description;

    JsonObject metadata;
}
