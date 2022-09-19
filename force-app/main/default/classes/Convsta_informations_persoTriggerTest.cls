@isTest
public class Convsta_informations_persoTriggerTest {
    @isTest
    public static void test(){
        Case demande = TestDataFactory.getCaseWithSigners();
        insert demande;
        
        Convsta_informations_personnelles__c information = new Convsta_informations_personnelles__c(MD_Demande__c = demande.Id);
        insert information;
                
		information.Nom__c = 'Test';        
        update information;
        
        //Only code coverage
    }
}