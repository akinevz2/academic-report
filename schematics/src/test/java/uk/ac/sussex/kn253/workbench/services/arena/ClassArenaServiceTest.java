package uk.ac.sussex.kn253.workbench.services.arena;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

public class ClassArenaServiceTest {
    
    class A {
        @Available
        void testMethodA() {
        }
    }

    class B {
        @Available
        void testMethodB() {
        }
        @Available
        void testMethodB2() {

        }
    }

    class C {
        void testMethodC() {

        }

        @Available
        void testMethodC2() {
            
        }
    }

    @Test
    void testGetAvailableMethods() {
        final var service = new ClassArenaService(A.class, B.class, C.class);

        final var methods = service.getAvailableMethods();
        assertEquals(4, methods.size());
    }

    @Test
    void testList() {
        final var service = new ClassArenaService(A.class, B.class, C.class);

        assertEquals(3, service.list().size());
    }
}
