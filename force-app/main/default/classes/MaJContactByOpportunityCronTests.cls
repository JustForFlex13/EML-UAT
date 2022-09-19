/*
 * Test class
 * Test the CRON to update the owner and the Souhait_programme__c of a contact 
 */
@IsTest
public class MaJContactByOpportunityCronTests {

    @IsTest
    public static void cron_Test(){
        // Data
        DataTests data = TestDataFactory.get_4_OpportunitiesWithSameContact(MaJOpportunityServiceTests.RT_TAXE, MaJOpportunityServiceTests.RT_FORMATION_INITIALE, 'Relations Employeur');
        
        // DO
        Test.startTest();
        System.schedule('MaJContactByOpportunityCron', '0 0 3 * * ?', new MaJContactByOpportunityCron());          
        Test.stopTest();
    }
}