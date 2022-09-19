@isTest 
public class BatchUpdateContactEmailCMTest 
{
    @testSetup static void setup(){
        Contact ctc = TestDataFactory.getContact();
        insert ctc;

        Campaign camp = new Campaign();
        camp.Name = 'Test';
        insert camp;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = camp.Id;
        cm.ContactId = ctc.Id;
        insert cm;
    }
    
    @isTest static void updateContactEmailCampaignMembersRepli(){
        CampaignMember cm = [SELECT Id
                             FROM CampaignMember
                             WHERE Campaign.Name = 'Test'];

        Contact ctc = [SELECT Id, Email_de_repli__c
                       FROM Contact];
        ctc.Email_de_repli__c = 'testRepli@test.com';
        update ctc;

        Test.startTest();

        BatchUpdateContactEmailCampaignMembers batch = new BatchUpdateContactEmailCampaignMembers(new List<Id>{cm.Id},
                                                                                                  'Email_de_repli__c',
                                                                                                  'Not Tested',
                                                                                                  'testSend@test.fr',
                                                                                                  'TestName');                                                                                                  
        Database.executeBatch(batch);

        Test.stopTest();

        Contact ctcFinal = [SELECT Id, Email, Email_de_repli__c
                            FROM Contact];
                            
        System.assertEquals(ctcFinal.Email_de_repli__c, ctcFinal.Email);
    }

    @isTest static void updateContactEmailCampaignMembersEMLyon(){
        CampaignMember cm = [SELECT Id, ContactId
                             FROM CampaignMember
                             WHERE Campaign.Name = 'Test'];

        Contact ctc = [SELECT Id, Email_EM_Lyon__c
                       FROM Contact];
        ctc.Email_EM_Lyon__c = 'testEMLyon@test.com';
        update ctc;

        Test.startTest();

        BatchUpdateContactEmailCampaignMembers batch = new BatchUpdateContactEmailCampaignMembers(new List<Id>{cm.Id},
                                                                                                  'Email_EM_Lyon__c',
                                                                                                  'Not Tested',
                                                                                                  'testSend@test.fr',
                                                                                                  'TestName');                                                                                                  
        Database.executeBatch(batch);

        Test.stopTest();

        Contact ctcFinal = [SELECT Id, Email, Email_EM_Lyon__c
                            FROM Contact];
                            
        System.assertEquals(ctcFinal.Email_EM_Lyon__c, ctcFinal.Email);
    }

    @isTest static void updateContactEmailCampaignMembersPersonnelle(){
        CampaignMember cm = [SELECT Id, ContactId
                             FROM CampaignMember
                             WHERE Campaign.Name = 'Test'];

        Contact ctc = [SELECT Id, Adresse_Email_Personnelle__c
                       FROM Contact];
        ctc.Adresse_Email_Personnelle__c = 'testPersonnelle@test.com';
        update ctc;

        Test.startTest();

        BatchUpdateContactEmailCampaignMembers batch = new BatchUpdateContactEmailCampaignMembers(new List<Id>{cm.Id},
                                                                                                  'Adresse_Email_Personnelle__c',
                                                                                                  'Not Tested',
                                                                                                  'testSend@test.fr',
                                                                                                  'TestName');                                                                                                  
        Database.executeBatch(batch);

        Test.stopTest();

        Contact ctcFinal = [SELECT Id, Email, Adresse_Email_Personnelle__c
                            FROM Contact];
                            
        System.assertEquals(ctcFinal.Adresse_Email_Personnelle__c, ctcFinal.Email);
    }

    @isTest static void updateContactEmailCampaignMembersPersonnelle2(){
        CampaignMember cm = [SELECT Id, ContactId
                             FROM CampaignMember
                             WHERE Campaign.Name = 'Test'];

        Contact ctc = [SELECT Id, Adresse_Email_Personnelle__c
                       FROM Contact];
        ctc.Adresse_Email_Personnelle__c = 'testPersonnelle@test.com';
        ctc.Email = null;
        update ctc;

        Test.startTest();

        BatchUpdateContactEmailCampaignMembers batch = new BatchUpdateContactEmailCampaignMembers(new List<Id>{cm.Id},
                                                                                                  'Not Tested',
                                                                                                  'Adresse_Email_Personnelle__c',
                                                                                                  'testSend@test.fr',
                                                                                                  'TestName');                                                                                                  
        Database.executeBatch(batch);

        Test.stopTest();

        Contact ctcFinal = [SELECT Id, Email, Adresse_Email_Personnelle__c
                            FROM Contact];
                            
        System.assertEquals(ctcFinal.Adresse_Email_Personnelle__c, ctcFinal.Email);
    }
}