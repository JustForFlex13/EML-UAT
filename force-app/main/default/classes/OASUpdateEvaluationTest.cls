@isTest
private class OASUpdateEvaluationTest {
    @isTest
    private static void equalsSameInstance() {
        OASUpdateEvaluation updateEvaluation1 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation2 = updateEvaluation1;
        OASUpdateEvaluation updateEvaluation3 = new OASUpdateEvaluation();
        OASUpdateEvaluation updateEvaluation4 = updateEvaluation3;

        System.assert(updateEvaluation1.equals(updateEvaluation2));
        System.assert(updateEvaluation2.equals(updateEvaluation1));
        System.assert(updateEvaluation1.equals(updateEvaluation1));
        System.assert(updateEvaluation3.equals(updateEvaluation4));
        System.assert(updateEvaluation4.equals(updateEvaluation3));
        System.assert(updateEvaluation3.equals(updateEvaluation3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASUpdateEvaluation updateEvaluation1 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation2 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation3 = new OASUpdateEvaluation();
        OASUpdateEvaluation updateEvaluation4 = new OASUpdateEvaluation();

        System.assert(updateEvaluation1.equals(updateEvaluation2));
        System.assert(updateEvaluation2.equals(updateEvaluation1));
        System.assert(updateEvaluation3.equals(updateEvaluation4));
        System.assert(updateEvaluation4.equals(updateEvaluation3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASUpdateEvaluation updateEvaluation1 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation2 = new OASUpdateEvaluation();

        System.assertEquals(false, updateEvaluation1.equals('foo'));
        System.assertEquals(false, updateEvaluation2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASUpdateEvaluation updateEvaluation1 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation2 = new OASUpdateEvaluation();
        OASUpdateEvaluation updateEvaluation3;

        System.assertEquals(false, updateEvaluation1.equals(updateEvaluation3));
        System.assertEquals(false, updateEvaluation2.equals(updateEvaluation3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASUpdateEvaluation updateEvaluation1 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation2 = new OASUpdateEvaluation();

        System.assertEquals(updateEvaluation1.hashCode(), updateEvaluation1.hashCode());
        System.assertEquals(updateEvaluation2.hashCode(), updateEvaluation2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASUpdateEvaluation updateEvaluation1 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation2 = OASUpdateEvaluation.getExample();
        OASUpdateEvaluation updateEvaluation3 = new OASUpdateEvaluation();
        OASUpdateEvaluation updateEvaluation4 = new OASUpdateEvaluation();

        System.assert(updateEvaluation1.equals(updateEvaluation2));
        System.assert(updateEvaluation3.equals(updateEvaluation4));
        System.assertEquals(updateEvaluation1.hashCode(), updateEvaluation2.hashCode());
        System.assertEquals(updateEvaluation3.hashCode(), updateEvaluation4.hashCode());
    }
}