@isTest
private class OASIdentityClaimTest {
    @isTest
    private static void equalsSameInstance() {
        OASIdentityClaim identityClaim1 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim2 = identityClaim1;
        OASIdentityClaim identityClaim3 = new OASIdentityClaim();
        OASIdentityClaim identityClaim4 = identityClaim3;

        System.assert(identityClaim1.equals(identityClaim2));
        System.assert(identityClaim2.equals(identityClaim1));
        System.assert(identityClaim1.equals(identityClaim1));
        System.assert(identityClaim3.equals(identityClaim4));
        System.assert(identityClaim4.equals(identityClaim3));
        System.assert(identityClaim3.equals(identityClaim3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASIdentityClaim identityClaim1 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim2 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim3 = new OASIdentityClaim();
        OASIdentityClaim identityClaim4 = new OASIdentityClaim();

        System.assert(identityClaim1.equals(identityClaim2));
        System.assert(identityClaim2.equals(identityClaim1));
        System.assert(identityClaim3.equals(identityClaim4));
        System.assert(identityClaim4.equals(identityClaim3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASIdentityClaim identityClaim1 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim2 = new OASIdentityClaim();

        System.assertEquals(false, identityClaim1.equals('foo'));
        System.assertEquals(false, identityClaim2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASIdentityClaim identityClaim1 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim2 = new OASIdentityClaim();
        OASIdentityClaim identityClaim3;

        System.assertEquals(false, identityClaim1.equals(identityClaim3));
        System.assertEquals(false, identityClaim2.equals(identityClaim3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASIdentityClaim identityClaim1 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim2 = new OASIdentityClaim();

        System.assertEquals(identityClaim1.hashCode(), identityClaim1.hashCode());
        System.assertEquals(identityClaim2.hashCode(), identityClaim2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASIdentityClaim identityClaim1 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim2 = OASIdentityClaim.getExample();
        OASIdentityClaim identityClaim3 = new OASIdentityClaim();
        OASIdentityClaim identityClaim4 = new OASIdentityClaim();

        System.assert(identityClaim1.equals(identityClaim2));
        System.assert(identityClaim3.equals(identityClaim4));
        System.assertEquals(identityClaim1.hashCode(), identityClaim2.hashCode());
        System.assertEquals(identityClaim3.hashCode(), identityClaim4.hashCode());
    }

    @isTest
    private static void maintainRenamedProperties() {
        OASIdentityClaim identityClaim = new OASIdentityClaim();
        Map<String, String> propertyMappings = identityClaim.getPropertyMappings();
        System.assertEquals('r_type', propertyMappings.get('type'));
    }

    @isTest
    private static void defaultValuesPopulated() {
        OASIdentityClaim identityClaim = new OASIdentityClaim();
        System.assertEquals(new Map<String, String>(), identityClaim.properties);
        System.assertEquals(null, identityClaim.r_type);
        System.assertEquals(null, identityClaim.originalIssuer);
        System.assertEquals(null, identityClaim.issuer);
        System.assertEquals(null, identityClaim.valueType);
        System.assertEquals(null, identityClaim.value);
    }
}