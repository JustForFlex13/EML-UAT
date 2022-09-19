@isTest
private class OASErrorDetailsTest {
    @isTest
    private static void equalsSameInstance() {
        OASErrorDetails errorDetails1 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails2 = errorDetails1;
        OASErrorDetails errorDetails3 = new OASErrorDetails();
        OASErrorDetails errorDetails4 = errorDetails3;

        System.assert(errorDetails1.equals(errorDetails2));
        System.assert(errorDetails2.equals(errorDetails1));
        System.assert(errorDetails1.equals(errorDetails1));
        System.assert(errorDetails3.equals(errorDetails4));
        System.assert(errorDetails4.equals(errorDetails3));
        System.assert(errorDetails3.equals(errorDetails3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASErrorDetails errorDetails1 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails2 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails3 = new OASErrorDetails();
        OASErrorDetails errorDetails4 = new OASErrorDetails();

        System.assert(errorDetails1.equals(errorDetails2));
        System.assert(errorDetails2.equals(errorDetails1));
        System.assert(errorDetails3.equals(errorDetails4));
        System.assert(errorDetails4.equals(errorDetails3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASErrorDetails errorDetails1 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails2 = new OASErrorDetails();

        System.assertEquals(false, errorDetails1.equals('foo'));
        System.assertEquals(false, errorDetails2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASErrorDetails errorDetails1 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails2 = new OASErrorDetails();
        OASErrorDetails errorDetails3;

        System.assertEquals(false, errorDetails1.equals(errorDetails3));
        System.assertEquals(false, errorDetails2.equals(errorDetails3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASErrorDetails errorDetails1 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails2 = new OASErrorDetails();

        System.assertEquals(errorDetails1.hashCode(), errorDetails1.hashCode());
        System.assertEquals(errorDetails2.hashCode(), errorDetails2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASErrorDetails errorDetails1 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails2 = OASErrorDetails.getExample();
        OASErrorDetails errorDetails3 = new OASErrorDetails();
        OASErrorDetails errorDetails4 = new OASErrorDetails();

        System.assert(errorDetails1.equals(errorDetails2));
        System.assert(errorDetails3.equals(errorDetails4));
        System.assertEquals(errorDetails1.hashCode(), errorDetails2.hashCode());
        System.assertEquals(errorDetails3.hashCode(), errorDetails4.hashCode());
    }

    @isTest
    private static void maintainRenamedProperties() {
        OASErrorDetails errorDetails = new OASErrorDetails();
        Map<String, String> propertyMappings = errorDetails.getPropertyMappings();
        System.assertEquals('statusCode', propertyMappings.get('StatusCode'));
        System.assertEquals('correlationIdentifier', propertyMappings.get('CorrelationIdentifier'));
        System.assertEquals('transactionIdentifier', propertyMappings.get('TransactionIdentifier'));
        System.assertEquals('path', propertyMappings.get('Path'));
        System.assertEquals('code', propertyMappings.get('Code'));
        System.assertEquals('message', propertyMappings.get('Message'));
        System.assertEquals('validationError', propertyMappings.get('ValidationError'));
        System.assertEquals('exceptionMessage', propertyMappings.get('ExceptionMessage'));
        System.assertEquals('exceptionStackTrace', propertyMappings.get('ExceptionStackTrace'));
    }

    @isTest
    private static void defaultValuesPopulated() {
        OASErrorDetails errorDetails = new OASErrorDetails();
        System.assertEquals(new List<OASValidationError>(), errorDetails.validationError);
        System.assertEquals(null, errorDetails.statusCode);
        System.assertEquals(null, errorDetails.correlationIdentifier);
        System.assertEquals(null, errorDetails.transactionIdentifier);
        System.assertEquals(null, errorDetails.path);
        System.assertEquals(null, errorDetails.code);
        System.assertEquals(null, errorDetails.message);
        System.assertEquals(null, errorDetails.exceptionMessage);
        System.assertEquals(null, errorDetails.exceptionStackTrace);
    }
}