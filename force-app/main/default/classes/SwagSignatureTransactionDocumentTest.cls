@isTest
private class SwagSignatureTransactionDocumentTest {
    @isTest
    private static void equalsSameInstance() {
        SwagSignatureTransactionDocument signatureTransactionDocument1 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument2 = signatureTransactionDocument1;
        SwagSignatureTransactionDocument signatureTransactionDocument3 = new SwagSignatureTransactionDocument();
        SwagSignatureTransactionDocument signatureTransactionDocument4 = signatureTransactionDocument3;

        System.assert(signatureTransactionDocument1.equals(signatureTransactionDocument2));
        System.assert(signatureTransactionDocument2.equals(signatureTransactionDocument1));
        System.assert(signatureTransactionDocument1.equals(signatureTransactionDocument1));
        System.assert(signatureTransactionDocument3.equals(signatureTransactionDocument4));
        System.assert(signatureTransactionDocument4.equals(signatureTransactionDocument3));
        System.assert(signatureTransactionDocument3.equals(signatureTransactionDocument3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        SwagSignatureTransactionDocument signatureTransactionDocument1 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument2 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument3 = new SwagSignatureTransactionDocument();
        SwagSignatureTransactionDocument signatureTransactionDocument4 = new SwagSignatureTransactionDocument();

        System.assert(signatureTransactionDocument1.equals(signatureTransactionDocument2));
        System.assert(signatureTransactionDocument2.equals(signatureTransactionDocument1));
        System.assert(signatureTransactionDocument3.equals(signatureTransactionDocument4));
        System.assert(signatureTransactionDocument4.equals(signatureTransactionDocument3));
    }

    @isTest
    private static void notEqualsUnlikeInstance() {
        SwagSignatureTransactionDocument signatureTransactionDocument1 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument2 = new SwagSignatureTransactionDocument();

        System.assertEquals(false, signatureTransactionDocument1.equals(signatureTransactionDocument2));
        System.assertEquals(false, signatureTransactionDocument2.equals(signatureTransactionDocument1));
    }

    @isTest
    private static void notEqualsDifferentType() {
        SwagSignatureTransactionDocument signatureTransactionDocument1 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument2 = new SwagSignatureTransactionDocument();

        System.assertEquals(false, signatureTransactionDocument1.equals('foo'));
        System.assertEquals(false, signatureTransactionDocument2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        SwagSignatureTransactionDocument signatureTransactionDocument1 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument2 = new SwagSignatureTransactionDocument();
        SwagSignatureTransactionDocument signatureTransactionDocument3;

        System.assertEquals(false, signatureTransactionDocument1.equals(signatureTransactionDocument3));
        System.assertEquals(false, signatureTransactionDocument2.equals(signatureTransactionDocument3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        SwagSignatureTransactionDocument signatureTransactionDocument1 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument2 = new SwagSignatureTransactionDocument();

        System.assertEquals(signatureTransactionDocument1.hashCode(), signatureTransactionDocument1.hashCode());
        System.assertEquals(signatureTransactionDocument2.hashCode(), signatureTransactionDocument2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        SwagSignatureTransactionDocument signatureTransactionDocument1 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument2 = SwagSignatureTransactionDocument.getExample();
        SwagSignatureTransactionDocument signatureTransactionDocument3 = new SwagSignatureTransactionDocument();
        SwagSignatureTransactionDocument signatureTransactionDocument4 = new SwagSignatureTransactionDocument();

        System.assert(signatureTransactionDocument1.equals(signatureTransactionDocument2));
        System.assert(signatureTransactionDocument3.equals(signatureTransactionDocument4));
        System.assertEquals(signatureTransactionDocument1.hashCode(), signatureTransactionDocument2.hashCode());
        System.assertEquals(signatureTransactionDocument3.hashCode(), signatureTransactionDocument4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        SwagSignatureTransactionDocument signatureTransactionDocument = new SwagSignatureTransactionDocument();
        System.assertEquals(new List<SwagSignatureTransactionDocumentSign>(), signatureTransactionDocument.signatureFields);
        System.assertEquals(null, signatureTransactionDocument.documentType);
        System.assertEquals(null, signatureTransactionDocument.content);
        System.assertEquals(null, signatureTransactionDocument.url);
        System.assertEquals(null, signatureTransactionDocument.fileName);
    }
}