@isTest
private class OASUserAuthenticationRequestModelTest {
    @isTest
    private static void equalsSameInstance() {
        OASUserAuthenticationRequestModel userAuthenticationRequestModel1 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel2 = userAuthenticationRequestModel1;
        OASUserAuthenticationRequestModel userAuthenticationRequestModel3 = new OASUserAuthenticationRequestModel();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel4 = userAuthenticationRequestModel3;

        System.assert(userAuthenticationRequestModel1.equals(userAuthenticationRequestModel2));
        System.assert(userAuthenticationRequestModel2.equals(userAuthenticationRequestModel1));
        System.assert(userAuthenticationRequestModel1.equals(userAuthenticationRequestModel1));
        System.assert(userAuthenticationRequestModel3.equals(userAuthenticationRequestModel4));
        System.assert(userAuthenticationRequestModel4.equals(userAuthenticationRequestModel3));
        System.assert(userAuthenticationRequestModel3.equals(userAuthenticationRequestModel3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASUserAuthenticationRequestModel userAuthenticationRequestModel1 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel2 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel3 = new OASUserAuthenticationRequestModel();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel4 = new OASUserAuthenticationRequestModel();

        System.assert(userAuthenticationRequestModel1.equals(userAuthenticationRequestModel2));
        System.assert(userAuthenticationRequestModel2.equals(userAuthenticationRequestModel1));
        System.assert(userAuthenticationRequestModel3.equals(userAuthenticationRequestModel4));
        System.assert(userAuthenticationRequestModel4.equals(userAuthenticationRequestModel3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASUserAuthenticationRequestModel userAuthenticationRequestModel1 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel2 = new OASUserAuthenticationRequestModel();

        System.assertEquals(false, userAuthenticationRequestModel1.equals('foo'));
        System.assertEquals(false, userAuthenticationRequestModel2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASUserAuthenticationRequestModel userAuthenticationRequestModel1 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel2 = new OASUserAuthenticationRequestModel();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel3;

        System.assertEquals(false, userAuthenticationRequestModel1.equals(userAuthenticationRequestModel3));
        System.assertEquals(false, userAuthenticationRequestModel2.equals(userAuthenticationRequestModel3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASUserAuthenticationRequestModel userAuthenticationRequestModel1 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel2 = new OASUserAuthenticationRequestModel();

        System.assertEquals(userAuthenticationRequestModel1.hashCode(), userAuthenticationRequestModel1.hashCode());
        System.assertEquals(userAuthenticationRequestModel2.hashCode(), userAuthenticationRequestModel2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASUserAuthenticationRequestModel userAuthenticationRequestModel1 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel2 = OASUserAuthenticationRequestModel.getExample();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel3 = new OASUserAuthenticationRequestModel();
        OASUserAuthenticationRequestModel userAuthenticationRequestModel4 = new OASUserAuthenticationRequestModel();

        System.assert(userAuthenticationRequestModel1.equals(userAuthenticationRequestModel2));
        System.assert(userAuthenticationRequestModel3.equals(userAuthenticationRequestModel4));
        System.assertEquals(userAuthenticationRequestModel1.hashCode(), userAuthenticationRequestModel2.hashCode());
        System.assertEquals(userAuthenticationRequestModel3.hashCode(), userAuthenticationRequestModel4.hashCode());
    }
}