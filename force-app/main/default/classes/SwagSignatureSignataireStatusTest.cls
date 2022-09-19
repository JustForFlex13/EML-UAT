@isTest
private class SwagSignatureSignataireStatusTest {
    @isTest
    private static void equalsSameInstance() {
        SwagSignatureSignataireStatus signatureSignataireStatus1 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus2 = signatureSignataireStatus1;
        SwagSignatureSignataireStatus signatureSignataireStatus3 = new SwagSignatureSignataireStatus();
        SwagSignatureSignataireStatus signatureSignataireStatus4 = signatureSignataireStatus3;

        System.assert(signatureSignataireStatus1.equals(signatureSignataireStatus2));
        System.assert(signatureSignataireStatus2.equals(signatureSignataireStatus1));
        System.assert(signatureSignataireStatus1.equals(signatureSignataireStatus1));
        System.assert(signatureSignataireStatus3.equals(signatureSignataireStatus4));
        System.assert(signatureSignataireStatus4.equals(signatureSignataireStatus3));
        System.assert(signatureSignataireStatus3.equals(signatureSignataireStatus3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        SwagSignatureSignataireStatus signatureSignataireStatus1 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus2 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus3 = new SwagSignatureSignataireStatus();
        SwagSignatureSignataireStatus signatureSignataireStatus4 = new SwagSignatureSignataireStatus();

        System.assert(signatureSignataireStatus1.equals(signatureSignataireStatus2));
        System.assert(signatureSignataireStatus2.equals(signatureSignataireStatus1));
        System.assert(signatureSignataireStatus3.equals(signatureSignataireStatus4));
        System.assert(signatureSignataireStatus4.equals(signatureSignataireStatus3));
    }

    @isTest
    private static void notEqualsUnlikeInstance() {
        SwagSignatureSignataireStatus signatureSignataireStatus1 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus2 = new SwagSignatureSignataireStatus();

        System.assertEquals(false, signatureSignataireStatus1.equals(signatureSignataireStatus2));
        System.assertEquals(false, signatureSignataireStatus2.equals(signatureSignataireStatus1));
    }

    @isTest
    private static void notEqualsDifferentType() {
        SwagSignatureSignataireStatus signatureSignataireStatus1 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus2 = new SwagSignatureSignataireStatus();

        System.assertEquals(false, signatureSignataireStatus1.equals('foo'));
        System.assertEquals(false, signatureSignataireStatus2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        SwagSignatureSignataireStatus signatureSignataireStatus1 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus2 = new SwagSignatureSignataireStatus();
        SwagSignatureSignataireStatus signatureSignataireStatus3;

        System.assertEquals(false, signatureSignataireStatus1.equals(signatureSignataireStatus3));
        System.assertEquals(false, signatureSignataireStatus2.equals(signatureSignataireStatus3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        SwagSignatureSignataireStatus signatureSignataireStatus1 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus2 = new SwagSignatureSignataireStatus();

        System.assertEquals(signatureSignataireStatus1.hashCode(), signatureSignataireStatus1.hashCode());
        System.assertEquals(signatureSignataireStatus2.hashCode(), signatureSignataireStatus2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        SwagSignatureSignataireStatus signatureSignataireStatus1 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus2 = SwagSignatureSignataireStatus.getExample();
        SwagSignatureSignataireStatus signatureSignataireStatus3 = new SwagSignatureSignataireStatus();
        SwagSignatureSignataireStatus signatureSignataireStatus4 = new SwagSignatureSignataireStatus();

        System.assert(signatureSignataireStatus1.equals(signatureSignataireStatus2));
        System.assert(signatureSignataireStatus3.equals(signatureSignataireStatus4));
        System.assertEquals(signatureSignataireStatus1.hashCode(), signatureSignataireStatus2.hashCode());
        System.assertEquals(signatureSignataireStatus3.hashCode(), signatureSignataireStatus4.hashCode());
    }
}