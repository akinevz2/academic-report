package uk.ac.sussex.kn253.workbench.beans;

import java.util.List;

import uk.ac.sussex.kn253.workbench.beans.INote.Position;
import uk.ac.sussex.kn253.workbench.beans.INote.Size;

public interface IQDTree<T> {
    public static final int MAX_POINTS_PER_QUADRANT = 4;

    public Node<? extends T> getRoot();

    public void insert(T element);

    public void insert(Node<? super T> node, T element);

    public List<T> query(double minX, double minY, double maxX, double maxY);

    public List<T> query(Node<? super T> node, double minX, double minY, double maxX, double maxY);

    public void split(Node<? super T> node);

    public Quadrant getQuadrant(double x, double y, double centerX, double centerY);

    public boolean intersects(Position center, double minX, double minY, double maxX, double maxY);

    public enum Quadrant {
        TOPLEFT(0), TOPRIGHT(1), BOTLEFT(2), BOTRIGHT(3);

        protected final int arrayIdx;

        private Quadrant(final int arrayIdx) {
            this.arrayIdx = arrayIdx;
        }
    }

    public record Node<T>(Position position, Size size, T element, List<Node<? super T>> childNodes) {
        boolean isLeaf() {
            return childNodes.isEmpty();
        }
    }

}
