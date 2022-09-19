/*
 * Test class
 * Test the update the owner and the Souhait_programme__c of a contact
 */
@IsTest
public class MaJOpportunityServiceTests {
    
    public static final String RT_FORMATION_INITIALE = 'Formation initiale';
    private static final String RT_FORMATION_COURTE = 'Formation courte';
    public static final String RT_TAXE = 'Taxe';
    public static final ID FORMATION_INITIALE_ID = MaJOpportunityService.RECORD_TYPE_FOR_FI;

    
    @IsTest
    public static void updateOwnerContact_Test(){
        // Data 
        DataTests data = TestDataFactory.getOpportunityDataTests(RT_FORMATION_COURTE);
        Opportunity opp = [SELECT Id, Name, OwnerId, IsClosed, 
                           FORM_Exercice_en_cours__c, RecordTypeId, 
                           Opportunite_active__c,  Contact_central__c, 
                           Contact_central__r.OwnerId, 
                           Contact_central__r.Souhait_programme__c 
                           FROM Opportunity
                           WHERE ID = :data.opps.get(0).Id];
        
        Map<Id, Opportunity> mapContactIdToOldestOpp = new Map<Id, Opportunity>();
        mapContactIdToOldestOpp.put(opp.Contact_central__c, opp);
        
        // DO
        Boolean canUpdate = MaJOpportunityService.updateOwnerContact(opp.Contact_central__r, mapContactIdToOldestOpp);
        
		// VERIFY
		System.assertEquals(true, canUpdate);
        System.assertEquals(opp.OwnerId, opp.Contact_central__r.OwnerId);
    }
    
    @IsTest
    public static void updateProgrammeContact_Test(){
        // Data 
        DataTests data = TestDataFactory.getOpportunityDataTests(RT_FORMATION_INITIALE);
        Opportunity opp = [SELECT Id, Name, OwnerId, IsClosed, 
                           FORM_Exercice_en_cours__c, RecordTypeId, 
                           Opportunite_active__c,  Contact_central__c, 
                           Contact_central__r.OwnerId, 
                           Contact_central__r.Souhait_programme__c 
                           FROM Opportunity
                           WHERE ID = :data.opps.get(0).Id];
        
        Map<Id, Opportunity> mapContactIdToOldestOpp = new Map<Id, Opportunity>();
        mapContactIdToOldestOpp.put(opp.Contact_central__c, opp);

        // DO
        Boolean canUpdate = MaJOpportunityService.updateProgrammeContact(opp.Contact_central__r, mapContactIdToOldestOpp);
        
		// VERIFY
		System.assertEquals(true, canUpdate);
        System.assertEquals(opp.Name, opp.Contact_central__r.Souhait_programme__c);
    }
        
    @IsTest
    public static void updateContactByOpportunity_Test(){
        // Data 
        DataTests data = TestDataFactory.get_3_Opportunities(RT_FORMATION_INITIALE, RT_FORMATION_INITIALE, 'Relations Employeur');
        List<Opportunity> opps = [SELECT Id, Name, OwnerId, IsClosed, 
                           FORM_Exercice_en_cours__c, RecordTypeId, 
                           Opportunite_active__c,  Contact_central__c,
                           Contact_central__r.OwnerId, 
                           Contact_central__r.Souhait_programme__c 
                           FROM Opportunity];
        
        // DO
        MaJOpportunityService.updateContactByOpportunity(opps);
        
        List<Opportunity> oppsAfter = [SELECT Id, Name, OwnerId, RecordTypeId, RecordType.Name,
                           Contact_central__r.OwnerId, 
                           Contact_central__r.Souhait_programme__c 
                           FROM Opportunity];
        
		// VERIFY
        for(Opportunity opp: oppsAfter){
            if(opp.RecordType.Name == RT_FORMATION_INITIALE){
                System.assertEquals(opp.OwnerId, opp.Contact_central__r.OwnerId);
                System.assertEquals(opp.Name, opp.Contact_central__r.Souhait_programme__c);
            } else if (opp.RecordType.Name == RT_TAXE){
                System.assertEquals(opp.Name, opp.Contact_central__r.Souhait_programme__c);
            } else {
                System.assertEquals(null, opp.Contact_central__r.Souhait_programme__c);
            }        	
        }		
    }
    
    @IsTest
    public static void updateContactByOpportunityWithSameContact_Test(){
        // Data 
        DataTests data = TestDataFactory.get_4_OpportunitiesWithSameContact(RT_FORMATION_INITIALE, RT_FORMATION_INITIALE, 'Relations Employeur');
        List<Opportunity> opps = [SELECT Id, Name, OwnerId, IsClosed, 
                           FORM_Exercice_en_cours__c, RecordTypeId, 
                           Opportunite_active__c,  Contact_central__c,
                           Contact_central__r.OwnerId, 
                           Contact_central__r.Souhait_programme__c 
                           FROM Opportunity];
        
        // DO
        MaJOpportunityService.updateContactByOpportunity(opps);
        
        Contact contact = [SELECT Id, Souhait_programme__c FROM Contact WHERE Id = :opps.get(0).Contact_central__c];
        
		// VERIFY
        System.assertEquals(opps.get(0).Name, contact.Souhait_programme__c);
    }
    
    @IsTest
    public static void getMapContactIdToOldestOpp_Test(){
        // Data         
        DataTests data = TestDataFactory.get_4_OpportunitiesWithSameContact(RT_TAXE, RT_FORMATION_INITIALE, 'Relations Employeur');
        
        User user = TestObjectFactory.createUser('uniqueName');
        System.runAs(user) {
        	TestObjectFactory.createOpportunity(data.account, 'Admis', data.contact, 'Formation initiale', 'opptest5');          
        } 
        
        List<Opportunity> opps = [SELECT Id, Name, OwnerId, IsClosed, 
                           FORM_Exercice_en_cours__c, RecordTypeId, 
                           Opportunite_active__c,  Contact_central__c,
                           Contact_central__r.OwnerId, 
                           Contact_central__r.Souhait_programme__c 
                           FROM Opportunity];
        
        // DO
        Map<Id, Opportunity> mapContactToOpportunity = MaJOpportunityService.getMapContactIdToNewestOpp(opps);
        
		// VERIFY
		System.assertEquals(1, mapContactToOpportunity.size());
        System.assertEquals(opps.get(0).Id, mapContactToOpportunity.get(opps.get(0).Contact_central__c).Id);
    }
}