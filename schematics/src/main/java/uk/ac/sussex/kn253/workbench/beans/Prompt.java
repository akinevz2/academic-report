package uk.ac.sussex.kn253.workbench.beans;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Entity;

@Entity
public class Prompt extends PanacheEntity {
    private final String innerText;
    private final int version;

    public Prompt(final String innerText, final int version) {
        this.innerText = innerText;
        this.version = version;
    }

    private Prompt prefix(final String text) {
        return new Prompt(text + innerText, version + 1);
    }

    private Prompt compose(final String text) {
        return new Prompt(innerText + text, version + 1);
    }

    @Override
    public String toString() {
        return this.innerText;
    }
}
