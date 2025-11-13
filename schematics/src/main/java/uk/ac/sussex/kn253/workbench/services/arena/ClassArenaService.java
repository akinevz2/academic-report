package uk.ac.sussex.kn253.workbench.services.arena;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

import jakarta.inject.Singleton;

@Singleton
public class ClassArenaService {

    private final List<Class<?>> stored;

    public ClassArenaService() {
        this(new ArrayList<>());
    }

    public ClassArenaService(final List<Class<?>> store) {
        this.stored = store;
    }

    public ClassArenaService(final Class<?>... store) {
        this(List.of(store));
    }

    public void register(final Class<?> clazz) {
        this.stored.add(clazz);
    }

    public void unregister(final Class<?> clazz) {
        this.stored.remove(clazz);
    }

    public void unregister(final String className) {
        this.stored.removeIf(s -> className.equals(s.getName()));
    }

    public List<String> list() {
        return this.stored.stream().map(Class::getName).toList();
    }

    public List<Method> getAvailableMethods() {
        return this.stored.stream()
                .flatMap(
                        s -> Stream.of(s.getDeclaredMethods()).filter(
                                m -> m.getAnnotationsByType(Available.class).length > 0))
                .toList();
    }
}
