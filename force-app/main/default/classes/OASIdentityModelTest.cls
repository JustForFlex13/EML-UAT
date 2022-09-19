@isTest
private class OASIdentityModelTest {
    @isTest
    private static void equalsSameInstance() {
        OASIdentityModel identityModel1 = OASIdentityModel.getExample();
        OASIdentityModel identityModel2 = identityModel1;
        OASIdentityModel identityModel3 = new OASIdentityModel();
        OASIdentityModel identityModel4 = identityModel3;

        System.assert(identityModel1.equals(identityModel2));
        System.assert(identityModel2.equals(identityModel1));
        System.assert(identityModel1.equals(identityModel1));
        System.assert(identityModel3.equals(identityModel4));
        System.assert(identityModel4.equals(identityModel3));
        System.assert(identityModel3.equals(identityModel3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASIdentityModel identityModel1 = OASIdentityModel.getExample();
        OASIdentityModel identityModel2 = OASIdentityModel.getExample();
        OASIdentityModel identityModel3 = new OASIdentityModel();
        OASIdentityModel identityModel4 = new OASIdentityModel();

        System.assert(identityModel1.equals(identityModel2));
        System.assert(identityModel2.equals(identityModel1));
        System.assert(identityModel3.equals(identityModel4));
        System.assert(identityModel4.equals(identityModel3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASIdentityModel identityModel1 = OASIdentityModel.getExample();
        OASIdentityModel identityModel2 = new OASIdentityModel();

        System.assertEquals(false, identityModel1.equals('foo'));
        System.assertEquals(false, identityModel2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASIdentityModel identityModel1 = OASIdentityModel.getExample();
        OASIdentityModel identityModel2 = new OASIdentityModel();
        OASIdentityModel identityModel3;

        System.assertEquals(false, identityModel1.equals(identityModel3));
        System.assertEquals(false, identityModel2.equals(identityModel3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASIdentityModel identityModel1 = OASIdentityModel.getExample();
        OASIdentityModel identityModel2 = new OASIdentityModel();

        System.assertEquals(identityModel1.hashCode(), identityModel1.hashCode());
        System.assertEquals(identityModel2.hashCode(), identityModel2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASIdentityModel identityModel1 = OASIdentityModel.getExample();
        OASIdentityModel identityModel2 = OASIdentityModel.getExample();
        OASIdentityModel identityModel3 = new OASIdentityModel();
        OASIdentityModel identityModel4 = new OASIdentityModel();

        System.assert(identityModel1.equals(identityModel2));
        System.assert(identityModel3.equals(identityModel4));
        System.assertEquals(identityModel1.hashCode(), identityModel2.hashCode());
        System.assertEquals(identityModel3.hashCode(), identityModel4.hashCode());
    }

    @isTest
    private static void maintainRenamedProperties() {
        OASIdentityModel identityModel = new OASIdentityModel();
        Map<String, String> propertyMappings = identityModel.getPropertyMappings();
        System.assertEquals('token', propertyMappings.get('Token'));
        System.assertEquals('userName', propertyMappings.get('UserName'));
        System.assertEquals('displayName', propertyMappings.get('DisplayName'));
        System.assertEquals('email', propertyMappings.get('Email'));
        System.assertEquals('claims', propertyMappings.get('Claims'));
    }

    @isTest
    private static void defaultValuesPopulated() {
        OASIdentityModel identityModel = new OASIdentityModel();
        System.assertEquals(new List<OASIdentityClaim>(), identityModel.claims);
        System.assertEquals(null, identityModel.token);
        System.assertEquals(null, identityModel.userName);
        System.assertEquals(null, identityModel.displayName);
        System.assertEquals(null, identityModel.email);
    }
}