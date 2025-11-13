package uk.ac.sussex.kn253.workbench.beans;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class Worksheet extends PanacheEntity {
    
    @Column
    String title;
    
    @Column
    QDTree<INote> notes;
}
