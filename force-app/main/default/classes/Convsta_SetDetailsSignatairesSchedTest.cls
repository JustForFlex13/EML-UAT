@isTest
public class Convsta_SetDetailsSignatairesSchedTest {
    @testSetup
    static void setup(){
        Case demande = TestDataFactory.getCaseWithSigners();
        demande.Status = 'Convention en attente de signature';
        insert demande;    
    }

    @isTest 
    static void testBatch(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetDetailStatusSignataires');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        Database.executeBatch(new Convsta_SetDetailsSignatairesSchedulable());
        Test.stopTest();

        Case demande = [SELECT Convsta_Detail_statut_signataire__c FROM Case];
        System.assertNotEquals(null,demande.Convsta_Detail_statut_signataire__c);
    }

    @isTest
    static void testSchedule(){
    	Test.startTest();        

		Convsta_SetDetailsSignatairesSchedulable schedule = new Convsta_SetDetailsSignatairesSchedulable();
        String sch = '0 0 * * * ?'; //Each hours
        System.schedule('Test Launch Check', sch, schedule);    
             
        Test.stopTest();
    }
}