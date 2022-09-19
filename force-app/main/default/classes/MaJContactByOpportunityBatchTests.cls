/*
 * Test class
 * Test the batch to update the owner and the Souhait_programme__c of a contact
 */
@IsTest
public class MaJContactByOpportunityBatchTests {

    @IsTest
    public static void batch_Test(){
        // Data
        DataTests data = TestDataFactory.get_4_OpportunitiesWithSameContact(MaJOpportunityServiceTests.RT_FORMATION_INITIALE, MaJOpportunityServiceTests.RT_FORMATION_INITIALE, 'Relations Employeur');
        List<Opportunity> opps = [SELECT Id, Name, OwnerId, IsClosed, 
                           FORM_Exercice_en_cours__c, RecordTypeId, 
                           Opportunite_active__c,  Contact_central__c,
                           Contact_central__r.OwnerId, 
                           Contact_central__r.Souhait_programme__c 
                           FROM Opportunity];
        
        // DO
        Test.startTest();
        MaJContactByOpportunityBatch batch = new MaJContactByOpportunityBatch();
        DataBase.executeBatch(batch, 200);
        Test.stopTest();
        
        Contact contact = [SELECT Id, Souhait_programme__c FROM Contact WHERE Id = :opps.get(0).Contact_central__c];      
        
		// VERIFY
        System.assertEquals(opps.get(0).Name, contact.Souhait_programme__c);
    }
}