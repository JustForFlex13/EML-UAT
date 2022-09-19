@isTest
private class Convsta_UserHandlerTest {
    @testSetup
    private static void testSetup() {
        
        User us =  TestObjectFactory.createUser();
        us.UserRoleId = [Select Id From UserRole Where Name='EML'].id;
        insert us;
        
        Account acc = TestDataFactory.getAccount();
        //acc.Name = 'Formation Initiale';
        acc.OwnerId = us.Id;
        insert acc;
        
        Contact ctc = TestObjectFactory.createContact(acc);
        ctc.Email_EM_Lyon__c = 'test@email.com';
        insert ctc;
        Contact ctc2 = TestObjectFactory.createContact(acc);
        ctc2.Email_EM_Lyon__c = 'test2@email.com';
        ctc2.LastName = 'aa';
        insert ctc2;
    }

    @isTest 
    private static void testInsert() {
        List<Account> lAcc = [SELECT Id FROM Account LIMIT 1];
        final Id samlSsoProviderId = '0LE000000000000';
        final Id communityId = '0DB000000000000';
        final Id portalId = '0DB000000000000';
        final String federationIdentifier = 'test@email.com';
        final Map<String, String> attributes = new Map<String, String> {
            'AccountId' => lAcc[0].Id
        };
        final String assertion = 'assertion';

        Test.startTest();
        Convsta_UserHandler handler = new Convsta_UserHandler();
        handler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
        Test.stopTest();

        List<User> u = [SELECT Email FROM User WHERE Email = 'test@email.com'];
        System.assertEquals(1, u.size());
    }
    @isTest 
    private static void testInsertChinois() {
        List<Account> lAcc = [SELECT Id FROM Account LIMIT 1];
        final Id samlSsoProviderId = '0LE000000000000';
        final Id communityId = '0DB000000000000';
        final Id portalId = '0DB000000000000';
        final String federationIdentifier = 'test2@email.com';
        final Map<String, String> attributes = new Map<String, String> {
            'AccountId' => lAcc[0].Id
        };
        final String assertion = 'assertion';

        Test.startTest();
        Convsta_UserHandler handler = new Convsta_UserHandler();
        handler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
        Test.stopTest();

        List<User> u = [SELECT Email FROM User WHERE Email = 'test2@email.com'];
        System.assertEquals(1, u.size());
    }
}