@isTest
private class SwagSignatureTransactionDocumentSignTest {
    @isTest
    private static void equalsSameInstance() {
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField1 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField2 = signatureTransactionDocumentSignatureField1;
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField3 = new SwagSignatureTransactionDocumentSign();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField4 = signatureTransactionDocumentSignatureField3;

        System.assert(signatureTransactionDocumentSignatureField1.equals(signatureTransactionDocumentSignatureField2));
        System.assert(signatureTransactionDocumentSignatureField2.equals(signatureTransactionDocumentSignatureField1));
        System.assert(signatureTransactionDocumentSignatureField1.equals(signatureTransactionDocumentSignatureField1));
        System.assert(signatureTransactionDocumentSignatureField3.equals(signatureTransactionDocumentSignatureField4));
        System.assert(signatureTransactionDocumentSignatureField4.equals(signatureTransactionDocumentSignatureField3));
        System.assert(signatureTransactionDocumentSignatureField3.equals(signatureTransactionDocumentSignatureField3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField1 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField2 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField3 = new SwagSignatureTransactionDocumentSign();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField4 = new SwagSignatureTransactionDocumentSign();

        System.assert(signatureTransactionDocumentSignatureField1.equals(signatureTransactionDocumentSignatureField2));
        System.assert(signatureTransactionDocumentSignatureField2.equals(signatureTransactionDocumentSignatureField1));
        System.assert(signatureTransactionDocumentSignatureField3.equals(signatureTransactionDocumentSignatureField4));
        System.assert(signatureTransactionDocumentSignatureField4.equals(signatureTransactionDocumentSignatureField3));
    }

    @isTest
    private static void notEqualsUnlikeInstance() {
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField1 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField2 = new SwagSignatureTransactionDocumentSign();

        System.assertEquals(false, signatureTransactionDocumentSignatureField1.equals(signatureTransactionDocumentSignatureField2));
        System.assertEquals(false, signatureTransactionDocumentSignatureField2.equals(signatureTransactionDocumentSignatureField1));
    }

    @isTest
    private static void notEqualsDifferentType() {
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField1 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField2 = new SwagSignatureTransactionDocumentSign();

        System.assertEquals(false, signatureTransactionDocumentSignatureField1.equals('foo'));
        System.assertEquals(false, signatureTransactionDocumentSignatureField2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField1 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField2 = new SwagSignatureTransactionDocumentSign();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField3;

        System.assertEquals(false, signatureTransactionDocumentSignatureField1.equals(signatureTransactionDocumentSignatureField3));
        System.assertEquals(false, signatureTransactionDocumentSignatureField2.equals(signatureTransactionDocumentSignatureField3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField1 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField2 = new SwagSignatureTransactionDocumentSign();

        System.assertEquals(signatureTransactionDocumentSignatureField1.hashCode(), signatureTransactionDocumentSignatureField1.hashCode());
        System.assertEquals(signatureTransactionDocumentSignatureField2.hashCode(), signatureTransactionDocumentSignatureField2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField1 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField2 = SwagSignatureTransactionDocumentSign.getExample();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField3 = new SwagSignatureTransactionDocumentSign();
        SwagSignatureTransactionDocumentSign signatureTransactionDocumentSignatureField4 = new SwagSignatureTransactionDocumentSign();

        System.assert(signatureTransactionDocumentSignatureField1.equals(signatureTransactionDocumentSignatureField2));
        System.assert(signatureTransactionDocumentSignatureField3.equals(signatureTransactionDocumentSignatureField4));
        System.assertEquals(signatureTransactionDocumentSignatureField1.hashCode(), signatureTransactionDocumentSignatureField2.hashCode());
        System.assertEquals(signatureTransactionDocumentSignatureField3.hashCode(), signatureTransactionDocumentSignatureField4.hashCode());
    }
}