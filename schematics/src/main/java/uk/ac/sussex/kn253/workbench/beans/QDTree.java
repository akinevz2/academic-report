package uk.ac.sussex.kn253.workbench.beans;

import java.util.List;

import uk.ac.sussex.kn253.workbench.beans.INote.Position;

public class QDTree<T extends INote> implements IQDTree<T> {

    private final Node<? extends T> root;

    public QDTree(final Node<? extends T> root) {
        this.root = root;
    }

    @Override
    public Node<? extends T> getRoot() {
        return this.root;
    }

    @Override
    public void insert(final T element) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'insert'");
    }

    @Override
    public void insert(final Node<? super T> node, final T element) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'insert'");
    }

    @Override
    public List<T> query(final double minX, final double minY, final double maxX, final double maxY) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'query'");
    }

    @Override
    public List<T> query(final Node<? super T> node, final double minX, final double minY, final double maxX,
            final double maxY) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'query'");
    }

    @Override
    public void split(final Node<? super T> node) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'split'");
    }

    @Override
    public Quadrant getQuadrant(final double x, final double y, final double centerX, final double centerY) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getQuadrant'");
    }

    @Override
    public boolean intersects(final Position center, final double minX, final double minY, final double maxX,
            final double maxY) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'intersects'");
    }
}
