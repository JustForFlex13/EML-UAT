@isTest
private class SwagSignatureTransactionSignerTest {
    @isTest
    private static void equalsSameInstance() {
        SwagSignatureTransactionSigner signatureTransactionSigner1 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner2 = signatureTransactionSigner1;
        SwagSignatureTransactionSigner signatureTransactionSigner3 = new SwagSignatureTransactionSigner();
        SwagSignatureTransactionSigner signatureTransactionSigner4 = signatureTransactionSigner3;

        System.assert(signatureTransactionSigner1.equals(signatureTransactionSigner2));
        System.assert(signatureTransactionSigner2.equals(signatureTransactionSigner1));
        System.assert(signatureTransactionSigner1.equals(signatureTransactionSigner1));
        System.assert(signatureTransactionSigner3.equals(signatureTransactionSigner4));
        System.assert(signatureTransactionSigner4.equals(signatureTransactionSigner3));
        System.assert(signatureTransactionSigner3.equals(signatureTransactionSigner3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        SwagSignatureTransactionSigner signatureTransactionSigner1 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner2 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner3 = new SwagSignatureTransactionSigner();
        SwagSignatureTransactionSigner signatureTransactionSigner4 = new SwagSignatureTransactionSigner();

        System.assert(signatureTransactionSigner1.equals(signatureTransactionSigner2));
        System.assert(signatureTransactionSigner2.equals(signatureTransactionSigner1));
        System.assert(signatureTransactionSigner3.equals(signatureTransactionSigner4));
        System.assert(signatureTransactionSigner4.equals(signatureTransactionSigner3));
    }

    @isTest
    private static void notEqualsUnlikeInstance() {
        SwagSignatureTransactionSigner signatureTransactionSigner1 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner2 = new SwagSignatureTransactionSigner();

        System.assertEquals(false, signatureTransactionSigner1.equals(signatureTransactionSigner2));
        System.assertEquals(false, signatureTransactionSigner2.equals(signatureTransactionSigner1));
    }

    @isTest
    private static void notEqualsDifferentType() {
        SwagSignatureTransactionSigner signatureTransactionSigner1 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner2 = new SwagSignatureTransactionSigner();

        System.assertEquals(false, signatureTransactionSigner1.equals('foo'));
        System.assertEquals(false, signatureTransactionSigner2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        SwagSignatureTransactionSigner signatureTransactionSigner1 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner2 = new SwagSignatureTransactionSigner();
        SwagSignatureTransactionSigner signatureTransactionSigner3;

        System.assertEquals(false, signatureTransactionSigner1.equals(signatureTransactionSigner3));
        System.assertEquals(false, signatureTransactionSigner2.equals(signatureTransactionSigner3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        SwagSignatureTransactionSigner signatureTransactionSigner1 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner2 = new SwagSignatureTransactionSigner();

        System.assertEquals(signatureTransactionSigner1.hashCode(), signatureTransactionSigner1.hashCode());
        System.assertEquals(signatureTransactionSigner2.hashCode(), signatureTransactionSigner2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        SwagSignatureTransactionSigner signatureTransactionSigner1 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner2 = SwagSignatureTransactionSigner.getExample();
        SwagSignatureTransactionSigner signatureTransactionSigner3 = new SwagSignatureTransactionSigner();
        SwagSignatureTransactionSigner signatureTransactionSigner4 = new SwagSignatureTransactionSigner();

        System.assert(signatureTransactionSigner1.equals(signatureTransactionSigner2));
        System.assert(signatureTransactionSigner3.equals(signatureTransactionSigner4));
        System.assertEquals(signatureTransactionSigner1.hashCode(), signatureTransactionSigner2.hashCode());
        System.assertEquals(signatureTransactionSigner3.hashCode(), signatureTransactionSigner4.hashCode());
    }
}