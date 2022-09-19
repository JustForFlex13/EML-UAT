@isTest
private class OASUpdateStageTest {
    @isTest
    private static void equalsSameInstance() {
        OASUpdateStage updateStage1 = OASUpdateStage.getExample();
        OASUpdateStage updateStage2 = updateStage1;
        OASUpdateStage updateStage3 = new OASUpdateStage();
        OASUpdateStage updateStage4 = updateStage3;

        System.assert(updateStage1.equals(updateStage2));
        System.assert(updateStage2.equals(updateStage1));
        System.assert(updateStage1.equals(updateStage1));
        System.assert(updateStage3.equals(updateStage4));
        System.assert(updateStage4.equals(updateStage3));
        System.assert(updateStage3.equals(updateStage3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASUpdateStage updateStage1 = OASUpdateStage.getExample();
        OASUpdateStage updateStage2 = OASUpdateStage.getExample();
        OASUpdateStage updateStage3 = new OASUpdateStage();
        OASUpdateStage updateStage4 = new OASUpdateStage();

        System.assert(updateStage1.equals(updateStage2));
        System.assert(updateStage2.equals(updateStage1));
        System.assert(updateStage3.equals(updateStage4));
        System.assert(updateStage4.equals(updateStage3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASUpdateStage updateStage1 = OASUpdateStage.getExample();
        OASUpdateStage updateStage2 = new OASUpdateStage();

        System.assertEquals(false, updateStage1.equals('foo'));
        System.assertEquals(false, updateStage2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASUpdateStage updateStage1 = OASUpdateStage.getExample();
        OASUpdateStage updateStage2 = new OASUpdateStage();
        OASUpdateStage updateStage3;

        System.assertEquals(false, updateStage1.equals(updateStage3));
        System.assertEquals(false, updateStage2.equals(updateStage3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASUpdateStage updateStage1 = OASUpdateStage.getExample();
        OASUpdateStage updateStage2 = new OASUpdateStage();

        System.assertEquals(updateStage1.hashCode(), updateStage1.hashCode());
        System.assertEquals(updateStage2.hashCode(), updateStage2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASUpdateStage updateStage1 = OASUpdateStage.getExample();
        OASUpdateStage updateStage2 = OASUpdateStage.getExample();
        OASUpdateStage updateStage3 = new OASUpdateStage();
        OASUpdateStage updateStage4 = new OASUpdateStage();

        System.assert(updateStage1.equals(updateStage2));
        System.assert(updateStage3.equals(updateStage4));
        System.assertEquals(updateStage1.hashCode(), updateStage2.hashCode());
        System.assertEquals(updateStage3.hashCode(), updateStage4.hashCode());
    }
}