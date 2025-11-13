package uk.ac.sussex.kn253.workbench.beans;

public interface INote {
    Position getPosition();

    Size getSize();
    
    public record Position(double x, double y) {
    };

    public record Size(double x, double y) {

    }
}
