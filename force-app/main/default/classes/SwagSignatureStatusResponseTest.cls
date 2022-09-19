@isTest
private class SwagSignatureStatusResponseTest {
    @isTest
    private static void equalsSameInstance() {
        SwagSignatureStatusResponse signatureStatusResponse1 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse2 = signatureStatusResponse1;
        SwagSignatureStatusResponse signatureStatusResponse3 = new SwagSignatureStatusResponse();
        SwagSignatureStatusResponse signatureStatusResponse4 = signatureStatusResponse3;

        System.assert(signatureStatusResponse1.equals(signatureStatusResponse2));
        System.assert(signatureStatusResponse2.equals(signatureStatusResponse1));
        System.assert(signatureStatusResponse1.equals(signatureStatusResponse1));
        System.assert(signatureStatusResponse3.equals(signatureStatusResponse4));
        System.assert(signatureStatusResponse4.equals(signatureStatusResponse3));
        System.assert(signatureStatusResponse3.equals(signatureStatusResponse3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        SwagSignatureStatusResponse signatureStatusResponse1 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse2 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse3 = new SwagSignatureStatusResponse();
        SwagSignatureStatusResponse signatureStatusResponse4 = new SwagSignatureStatusResponse();

        System.assert(signatureStatusResponse1.equals(signatureStatusResponse2));
        System.assert(signatureStatusResponse2.equals(signatureStatusResponse1));
        System.assert(signatureStatusResponse3.equals(signatureStatusResponse4));
        System.assert(signatureStatusResponse4.equals(signatureStatusResponse3));
    }

    @isTest
    private static void notEqualsUnlikeInstance() {
        SwagSignatureStatusResponse signatureStatusResponse1 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse2 = new SwagSignatureStatusResponse();

        System.assertEquals(false, signatureStatusResponse1.equals(signatureStatusResponse2));
        System.assertEquals(false, signatureStatusResponse2.equals(signatureStatusResponse1));
    }

    @isTest
    private static void notEqualsDifferentType() {
        SwagSignatureStatusResponse signatureStatusResponse1 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse2 = new SwagSignatureStatusResponse();

        System.assertEquals(false, signatureStatusResponse1.equals('foo'));
        System.assertEquals(false, signatureStatusResponse2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        SwagSignatureStatusResponse signatureStatusResponse1 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse2 = new SwagSignatureStatusResponse();
        SwagSignatureStatusResponse signatureStatusResponse3;

        System.assertEquals(false, signatureStatusResponse1.equals(signatureStatusResponse3));
        System.assertEquals(false, signatureStatusResponse2.equals(signatureStatusResponse3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        SwagSignatureStatusResponse signatureStatusResponse1 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse2 = new SwagSignatureStatusResponse();

        System.assertEquals(signatureStatusResponse1.hashCode(), signatureStatusResponse1.hashCode());
        System.assertEquals(signatureStatusResponse2.hashCode(), signatureStatusResponse2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        SwagSignatureStatusResponse signatureStatusResponse1 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse2 = SwagSignatureStatusResponse.getExample();
        SwagSignatureStatusResponse signatureStatusResponse3 = new SwagSignatureStatusResponse();
        SwagSignatureStatusResponse signatureStatusResponse4 = new SwagSignatureStatusResponse();

        System.assert(signatureStatusResponse1.equals(signatureStatusResponse2));
        System.assert(signatureStatusResponse3.equals(signatureStatusResponse4));
        System.assertEquals(signatureStatusResponse1.hashCode(), signatureStatusResponse2.hashCode());
        System.assertEquals(signatureStatusResponse3.hashCode(), signatureStatusResponse4.hashCode());
    }

    @isTest
    private static void maintainRenamedProperties() {
        SwagSignatureStatusResponse signatureStatusResponse = new SwagSignatureStatusResponse();
        Map<String, String> propertyMappings = signatureStatusResponse.getPropertyMappings();
        System.assertEquals('customId', propertyMappings.get('CustomId'));
        System.assertEquals('currentStatus', propertyMappings.get('CurrentStatus'));
        System.assertEquals('horodatageCurrentStatus', propertyMappings.get('HorodatageCurrentStatus'));
        System.assertEquals('signatairesStatus', propertyMappings.get('SignatairesStatus'));
    }

    @isTest
    private static void defaultValuesPopulated() {
        SwagSignatureStatusResponse signatureStatusResponse = new SwagSignatureStatusResponse();
        System.assertEquals(new List<SwagSignatureSignataireStatus>(), signatureStatusResponse.signatairesStatus);
        System.assertEquals(null, signatureStatusResponse.customId);
        System.assertEquals(null, signatureStatusResponse.currentStatus);
        System.assertEquals(null, signatureStatusResponse.horodatageCurrentStatus);
    }
}