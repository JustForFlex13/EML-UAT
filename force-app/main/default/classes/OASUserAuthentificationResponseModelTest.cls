@isTest
private class OASUserAuthentificationResponseModelTest {
    @isTest
    private static void equalsSameInstance() {
        OASUserAuthentificationResponseModel userAuthentificationResponseModel1 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel2 = userAuthentificationResponseModel1;
        OASUserAuthentificationResponseModel userAuthentificationResponseModel3 = new OASUserAuthentificationResponseModel();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel4 = userAuthentificationResponseModel3;

        System.assert(userAuthentificationResponseModel1.equals(userAuthentificationResponseModel2));
        System.assert(userAuthentificationResponseModel2.equals(userAuthentificationResponseModel1));
        System.assert(userAuthentificationResponseModel1.equals(userAuthentificationResponseModel1));
        System.assert(userAuthentificationResponseModel3.equals(userAuthentificationResponseModel4));
        System.assert(userAuthentificationResponseModel4.equals(userAuthentificationResponseModel3));
        System.assert(userAuthentificationResponseModel3.equals(userAuthentificationResponseModel3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASUserAuthentificationResponseModel userAuthentificationResponseModel1 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel2 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel3 = new OASUserAuthentificationResponseModel();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel4 = new OASUserAuthentificationResponseModel();

        System.assert(userAuthentificationResponseModel1.equals(userAuthentificationResponseModel2));
        System.assert(userAuthentificationResponseModel2.equals(userAuthentificationResponseModel1));
        System.assert(userAuthentificationResponseModel3.equals(userAuthentificationResponseModel4));
        System.assert(userAuthentificationResponseModel4.equals(userAuthentificationResponseModel3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASUserAuthentificationResponseModel userAuthentificationResponseModel1 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel2 = new OASUserAuthentificationResponseModel();

        System.assertEquals(false, userAuthentificationResponseModel1.equals('foo'));
        System.assertEquals(false, userAuthentificationResponseModel2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASUserAuthentificationResponseModel userAuthentificationResponseModel1 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel2 = new OASUserAuthentificationResponseModel();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel3;

        System.assertEquals(false, userAuthentificationResponseModel1.equals(userAuthentificationResponseModel3));
        System.assertEquals(false, userAuthentificationResponseModel2.equals(userAuthentificationResponseModel3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASUserAuthentificationResponseModel userAuthentificationResponseModel1 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel2 = new OASUserAuthentificationResponseModel();

        System.assertEquals(userAuthentificationResponseModel1.hashCode(), userAuthentificationResponseModel1.hashCode());
        System.assertEquals(userAuthentificationResponseModel2.hashCode(), userAuthentificationResponseModel2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASUserAuthentificationResponseModel userAuthentificationResponseModel1 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel2 = OASUserAuthentificationResponseModel.getExample();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel3 = new OASUserAuthentificationResponseModel();
        OASUserAuthentificationResponseModel userAuthentificationResponseModel4 = new OASUserAuthentificationResponseModel();

        System.assert(userAuthentificationResponseModel1.equals(userAuthentificationResponseModel2));
        System.assert(userAuthentificationResponseModel3.equals(userAuthentificationResponseModel4));
        System.assertEquals(userAuthentificationResponseModel1.hashCode(), userAuthentificationResponseModel2.hashCode());
        System.assertEquals(userAuthentificationResponseModel3.hashCode(), userAuthentificationResponseModel4.hashCode());
    }
}