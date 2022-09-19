@isTest
private class OASModeleRetourPhaseTest {
    @isTest
    private static void equalsSameInstance() {
        OASModeleRetourPhase modeleRetourPhase1 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase2 = modeleRetourPhase1;
        OASModeleRetourPhase modeleRetourPhase3 = new OASModeleRetourPhase();
        OASModeleRetourPhase modeleRetourPhase4 = modeleRetourPhase3;

        System.assert(modeleRetourPhase1.equals(modeleRetourPhase2));
        System.assert(modeleRetourPhase2.equals(modeleRetourPhase1));
        System.assert(modeleRetourPhase1.equals(modeleRetourPhase1));
        System.assert(modeleRetourPhase3.equals(modeleRetourPhase4));
        System.assert(modeleRetourPhase4.equals(modeleRetourPhase3));
        System.assert(modeleRetourPhase3.equals(modeleRetourPhase3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASModeleRetourPhase modeleRetourPhase1 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase2 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase3 = new OASModeleRetourPhase();
        OASModeleRetourPhase modeleRetourPhase4 = new OASModeleRetourPhase();

        System.assert(modeleRetourPhase1.equals(modeleRetourPhase2));
        System.assert(modeleRetourPhase2.equals(modeleRetourPhase1));
        System.assert(modeleRetourPhase3.equals(modeleRetourPhase4));
        System.assert(modeleRetourPhase4.equals(modeleRetourPhase3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASModeleRetourPhase modeleRetourPhase1 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase2 = new OASModeleRetourPhase();

        System.assertEquals(false, modeleRetourPhase1.equals('foo'));
        System.assertEquals(false, modeleRetourPhase2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASModeleRetourPhase modeleRetourPhase1 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase2 = new OASModeleRetourPhase();
        OASModeleRetourPhase modeleRetourPhase3;

        System.assertEquals(false, modeleRetourPhase1.equals(modeleRetourPhase3));
        System.assertEquals(false, modeleRetourPhase2.equals(modeleRetourPhase3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASModeleRetourPhase modeleRetourPhase1 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase2 = new OASModeleRetourPhase();

        System.assertEquals(modeleRetourPhase1.hashCode(), modeleRetourPhase1.hashCode());
        System.assertEquals(modeleRetourPhase2.hashCode(), modeleRetourPhase2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASModeleRetourPhase modeleRetourPhase1 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase2 = OASModeleRetourPhase.getExample();
        OASModeleRetourPhase modeleRetourPhase3 = new OASModeleRetourPhase();
        OASModeleRetourPhase modeleRetourPhase4 = new OASModeleRetourPhase();

        System.assert(modeleRetourPhase1.equals(modeleRetourPhase2));
        System.assert(modeleRetourPhase3.equals(modeleRetourPhase4));
        System.assertEquals(modeleRetourPhase1.hashCode(), modeleRetourPhase2.hashCode());
        System.assertEquals(modeleRetourPhase3.hashCode(), modeleRetourPhase4.hashCode());
    }
}