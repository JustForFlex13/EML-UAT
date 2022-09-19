@isTest
private class RefintSocieteRattachementModelTest {
    @isTest
    private static void equalsSameInstance() {
        RefintSocieteRattachementModel societeRattachementModel1 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel2 = societeRattachementModel1;
        RefintSocieteRattachementModel societeRattachementModel3 = new RefintSocieteRattachementModel();
        RefintSocieteRattachementModel societeRattachementModel4 = societeRattachementModel3;

        System.assert(societeRattachementModel1.equals(societeRattachementModel2));
        System.assert(societeRattachementModel2.equals(societeRattachementModel1));
        System.assert(societeRattachementModel1.equals(societeRattachementModel1));
        System.assert(societeRattachementModel3.equals(societeRattachementModel4));
        System.assert(societeRattachementModel4.equals(societeRattachementModel3));
        System.assert(societeRattachementModel3.equals(societeRattachementModel3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        RefintSocieteRattachementModel societeRattachementModel1 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel2 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel3 = new RefintSocieteRattachementModel();
        RefintSocieteRattachementModel societeRattachementModel4 = new RefintSocieteRattachementModel();

        System.assert(societeRattachementModel1.equals(societeRattachementModel2));
        System.assert(societeRattachementModel2.equals(societeRattachementModel1));
        System.assert(societeRattachementModel3.equals(societeRattachementModel4));
        System.assert(societeRattachementModel4.equals(societeRattachementModel3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        RefintSocieteRattachementModel societeRattachementModel1 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel2 = new RefintSocieteRattachementModel();

        System.assertEquals(false, societeRattachementModel1.equals('foo'));
        System.assertEquals(false, societeRattachementModel2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        RefintSocieteRattachementModel societeRattachementModel1 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel2 = new RefintSocieteRattachementModel();
        RefintSocieteRattachementModel societeRattachementModel3;

        System.assertEquals(false, societeRattachementModel1.equals(societeRattachementModel3));
        System.assertEquals(false, societeRattachementModel2.equals(societeRattachementModel3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        RefintSocieteRattachementModel societeRattachementModel1 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel2 = new RefintSocieteRattachementModel();

        System.assertEquals(societeRattachementModel1.hashCode(), societeRattachementModel1.hashCode());
        System.assertEquals(societeRattachementModel2.hashCode(), societeRattachementModel2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        RefintSocieteRattachementModel societeRattachementModel1 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel2 = RefintSocieteRattachementModel.getExample();
        RefintSocieteRattachementModel societeRattachementModel3 = new RefintSocieteRattachementModel();
        RefintSocieteRattachementModel societeRattachementModel4 = new RefintSocieteRattachementModel();

        System.assert(societeRattachementModel1.equals(societeRattachementModel2));
        System.assert(societeRattachementModel3.equals(societeRattachementModel4));
        System.assertEquals(societeRattachementModel1.hashCode(), societeRattachementModel2.hashCode());
        System.assertEquals(societeRattachementModel3.hashCode(), societeRattachementModel4.hashCode());
    }
}