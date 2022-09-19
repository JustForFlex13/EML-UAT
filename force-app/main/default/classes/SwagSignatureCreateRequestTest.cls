@isTest
private class SwagSignatureCreateRequestTest {
    @isTest
    private static void equalsSameInstance() {
        SwagSignatureCreateRequest signatureCreateRequest1 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest2 = signatureCreateRequest1;
        SwagSignatureCreateRequest signatureCreateRequest3 = new SwagSignatureCreateRequest();
        SwagSignatureCreateRequest signatureCreateRequest4 = signatureCreateRequest3;

        System.assert(signatureCreateRequest1.equals(signatureCreateRequest2));
        System.assert(signatureCreateRequest2.equals(signatureCreateRequest1));
        System.assert(signatureCreateRequest1.equals(signatureCreateRequest1));
        System.assert(signatureCreateRequest3.equals(signatureCreateRequest4));
        System.assert(signatureCreateRequest4.equals(signatureCreateRequest3));
        System.assert(signatureCreateRequest3.equals(signatureCreateRequest3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        SwagSignatureCreateRequest signatureCreateRequest1 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest2 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest3 = new SwagSignatureCreateRequest();
        SwagSignatureCreateRequest signatureCreateRequest4 = new SwagSignatureCreateRequest();

        System.assert(signatureCreateRequest1.equals(signatureCreateRequest2));
        System.assert(signatureCreateRequest2.equals(signatureCreateRequest1));
        System.assert(signatureCreateRequest3.equals(signatureCreateRequest4));
        System.assert(signatureCreateRequest4.equals(signatureCreateRequest3));
    }

    @isTest
    private static void notEqualsUnlikeInstance() {
        SwagSignatureCreateRequest signatureCreateRequest1 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest2 = new SwagSignatureCreateRequest();

        System.assertEquals(false, signatureCreateRequest1.equals(signatureCreateRequest2));
        System.assertEquals(false, signatureCreateRequest2.equals(signatureCreateRequest1));
    }

    @isTest
    private static void notEqualsDifferentType() {
        SwagSignatureCreateRequest signatureCreateRequest1 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest2 = new SwagSignatureCreateRequest();

        System.assertEquals(false, signatureCreateRequest1.equals('foo'));
        System.assertEquals(false, signatureCreateRequest2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        SwagSignatureCreateRequest signatureCreateRequest1 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest2 = new SwagSignatureCreateRequest();
        SwagSignatureCreateRequest signatureCreateRequest3;

        System.assertEquals(false, signatureCreateRequest1.equals(signatureCreateRequest3));
        System.assertEquals(false, signatureCreateRequest2.equals(signatureCreateRequest3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        SwagSignatureCreateRequest signatureCreateRequest1 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest2 = new SwagSignatureCreateRequest();

        System.assertEquals(signatureCreateRequest1.hashCode(), signatureCreateRequest1.hashCode());
        System.assertEquals(signatureCreateRequest2.hashCode(), signatureCreateRequest2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        SwagSignatureCreateRequest signatureCreateRequest1 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest2 = SwagSignatureCreateRequest.getExample();
        SwagSignatureCreateRequest signatureCreateRequest3 = new SwagSignatureCreateRequest();
        SwagSignatureCreateRequest signatureCreateRequest4 = new SwagSignatureCreateRequest();

        System.assert(signatureCreateRequest1.equals(signatureCreateRequest2));
        System.assert(signatureCreateRequest3.equals(signatureCreateRequest4));
        System.assertEquals(signatureCreateRequest1.hashCode(), signatureCreateRequest2.hashCode());
        System.assertEquals(signatureCreateRequest3.hashCode(), signatureCreateRequest4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        SwagSignatureCreateRequest signatureCreateRequest = new SwagSignatureCreateRequest();
        System.assertEquals(new List<SwagSignatureSignerModel>(), signatureCreateRequest.signers);
        System.assertEquals(new List<SwagSignatureDocumentModel>(), signatureCreateRequest.documents);
        System.assertEquals(new List<String>(), signatureCreateRequest.finalDocCCeMails);
        System.assertEquals(new List<String>(), signatureCreateRequest.twoStepsRegistration);
        System.assertEquals(null, signatureCreateRequest.transacIdApplicationSource);
        System.assertEquals(null, signatureCreateRequest.transacCodeApplicationSource);
        System.assertEquals(null, signatureCreateRequest.transacDemandeurApplicationSource);
        System.assertEquals(null, signatureCreateRequest.transacCodePrestataireSignature);
        System.assertEquals(null, signatureCreateRequest.transacUrlWebHookApplicationSource);
        System.assertEquals(null, signatureCreateRequest.profile);
        System.assertEquals(null, signatureCreateRequest.mustContactFirstSigner);
        System.assertEquals(null, signatureCreateRequest.finalDocSent);
        System.assertEquals(null, signatureCreateRequest.finalDocRequesterSent);
        System.assertEquals(null, signatureCreateRequest.finalDocObserverSent);
        System.assertEquals(null, signatureCreateRequest.description);
        System.assertEquals(null, signatureCreateRequest.certificateType);
        System.assertEquals(null, signatureCreateRequest.language);
        System.assertEquals(null, signatureCreateRequest.handwrittenSignatureMode);
        System.assertEquals(null, signatureCreateRequest.chainingMode);
    }
}