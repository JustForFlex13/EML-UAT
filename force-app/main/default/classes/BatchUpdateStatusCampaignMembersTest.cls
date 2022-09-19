@isTest 
public class BatchUpdateStatusCampaignMembersTest 
{
    @testSetup static void setup(){
        Id recordTypeEtudiantId = APU_ApexUtils.getContactRecordTypeIdByName('Etudiant');
        Contact ctc = TestDataFactory.getContact();
        ctc.RecordTypeId = recordTypeEtudiantId;
        insert ctc;
        
        Campaign camp = new Campaign();
        camp.Name = 'Test';
        insert camp;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = camp.Id;
        cm.ContactId = ctc.Id;
        insert cm;
    }
    
    @isTest static void updateStatus(){
        CampaignMember cm = [SELECT Id
                             FROM CampaignMember
                             WHERE Campaign.Name = 'Test'];
        Test.startTest();
		
        BatchUpdateStatusCampaignMembers batch = new BatchUpdateStatusCampaignMembers(new List<Id>{cm.Id}, 'New');
        Database.executeBatch(batch); 
            
        Test.stopTest();
        
        cm = [SELECT Id, Status
              FROM CampaignMember
              WHERE Campaign.Name = 'Test'];
        
        System.assertEquals('Envoyé', cm.Status);
    }
}