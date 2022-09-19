@isTest
private class OASErrorResultTest {
    @isTest
    private static void equalsSameInstance() {
        OASErrorResult errorResult1 = OASErrorResult.getExample();
        OASErrorResult errorResult2 = errorResult1;
        OASErrorResult errorResult3 = new OASErrorResult();
        OASErrorResult errorResult4 = errorResult3;

        System.assert(errorResult1.equals(errorResult2));
        System.assert(errorResult2.equals(errorResult1));
        System.assert(errorResult1.equals(errorResult1));
        System.assert(errorResult3.equals(errorResult4));
        System.assert(errorResult4.equals(errorResult3));
        System.assert(errorResult3.equals(errorResult3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASErrorResult errorResult1 = OASErrorResult.getExample();
        OASErrorResult errorResult2 = OASErrorResult.getExample();
        OASErrorResult errorResult3 = new OASErrorResult();
        OASErrorResult errorResult4 = new OASErrorResult();

        System.assert(errorResult1.equals(errorResult2));
        System.assert(errorResult2.equals(errorResult1));
        System.assert(errorResult3.equals(errorResult4));
        System.assert(errorResult4.equals(errorResult3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASErrorResult errorResult1 = OASErrorResult.getExample();
        OASErrorResult errorResult2 = new OASErrorResult();

        System.assertEquals(false, errorResult1.equals('foo'));
        System.assertEquals(false, errorResult2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASErrorResult errorResult1 = OASErrorResult.getExample();
        OASErrorResult errorResult2 = new OASErrorResult();
        OASErrorResult errorResult3;

        System.assertEquals(false, errorResult1.equals(errorResult3));
        System.assertEquals(false, errorResult2.equals(errorResult3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASErrorResult errorResult1 = OASErrorResult.getExample();
        OASErrorResult errorResult2 = new OASErrorResult();

        System.assertEquals(errorResult1.hashCode(), errorResult1.hashCode());
        System.assertEquals(errorResult2.hashCode(), errorResult2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASErrorResult errorResult1 = OASErrorResult.getExample();
        OASErrorResult errorResult2 = OASErrorResult.getExample();
        OASErrorResult errorResult3 = new OASErrorResult();
        OASErrorResult errorResult4 = new OASErrorResult();

        System.assert(errorResult1.equals(errorResult2));
        System.assert(errorResult3.equals(errorResult4));
        System.assertEquals(errorResult1.hashCode(), errorResult2.hashCode());
        System.assertEquals(errorResult3.hashCode(), errorResult4.hashCode());
    }
}