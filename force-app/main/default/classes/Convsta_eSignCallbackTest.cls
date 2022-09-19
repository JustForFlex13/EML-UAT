@isTest
public class Convsta_eSignCallbackTest {
    @testSetup 
    static void setup(){
        Contact etudiant                        = TestDataFactory.getContact(); 
        etudiant.FirstName                      = 'TestFirstName';
        etudiant.LastName                       = 'TestLastName';
        etudiant.Email   = 'test@email.com';
        insert etudiant;
        
        Case demande = TestObjectFactory.createCase(etudiant);
        demande.recordTypeId            = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_eSign_ExtId__c  = 'TestExtId';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        demande.Convsta_Date_Validation_Administrative__c = DateTime.now().addYears(-4);
        demande.Convsta_Detail_statut_signataire__c = 'CUI Hongjia signed '+demande.Convsta_Date_Validation_Administrative__c+'\n YIK hoi ready \n'+
            'YIK Hoi waiting \nMAJ 14/01/2020 17:01:06';
        insert demande;
    }
    @isTest 
    static void test(){
        Test.startTest();
        Case casetest =[select id, createdDate FROM case where Convsta_eSign_ExtId__c  = 'TestExtId' limit 1 ];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('caseId', casetest.id);
        req.addParameter('hashCode', String.valueOf(Convsta_eSignCallback.hashCode(casetest)));
        req.requestURI = '/signRequest?caseId='+casetest.id+'&hashCode='+Convsta_eSignCallback.hashCode(casetest);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Convsta_eSignCallback.doGet();
        
        Test.stopTest();
        Case demande = [SELECT  Id, Convsta_Statut_Signature__c, Convsta_Derniere_Maj_Signature__c
                        FROM    Case
                        WHERE   Convsta_eSign_ExtId__c = 'TestExtId'];
        system.debug(RestContext.response.responseBody.toString());
        System.assert(RestContext.response.responseBody.toString().contains('eSign CallBack'));
    }
    @isTest 
    static void testRelanceKO(){
        eSign_Configuration__mdt conf = Convsta_WS_Helper.getESignConf();
        Decimal nbJourAvantSansEffet = conf.nbJoursAvantRelance__c*conf.nbMaxRelance__c;
        Case casetest =[select id, createdDate FROM case where Convsta_eSign_ExtId__c  = 'TestExtId' limit 1 ];
        caseTest.Convsta_Detail_statut_signataire__c = 'CUI Hongjia signed '+dateTime.now().addDays(-Integer.valueOf(nbJourAvantSansEffet))+'\n YIK hoi ready \n'+
            'YIK Hoi waiting \nMAJ 14/01/2020 17:01:06';
        update caseTest;
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('caseId', casetest.id);
        req.addParameter('relance', '1');
        req.addParameter('hashCode', String.valueOf(Convsta_eSignCallback.hashCode(casetest)));
        req.requestURI = '/signRequest?caseId='+casetest.id+'&hashCode='+Convsta_eSignCallback.hashCode(casetest)+'&relance=1';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Convsta_eSignCallback.doGet();
        
        Test.stopTest();
        Case demande = [SELECT  Id, Convsta_Statut_Signature__c, Convsta_Derniere_Maj_Signature__c
                        FROM    Case
                        WHERE   Convsta_eSign_ExtId__c = 'TestExtId'];
        system.debug(RestContext.response.responseBody.toString());
        system.assertEquals('Relance sans effet', demande.Convsta_Statut_Signature__c, 'statut incorrect');
        System.assert(RestContext.response.responseBody.toString().contains('eSign CallBack'));
    }
    @isTest 
    static void testRelanceOk(){
        system.debug('testRelanceOk');
        Test.startTest();
        Case casetest =[select id, createdDate FROM case where Convsta_eSign_ExtId__c  = 'TestExtId' limit 1 ];
        caseTest.Convsta_Detail_statut_signataire__c = 'CUI Hongjia signed '+dateTime.now()+'\n YIK hoi ready \n'+
            'YIK Hoi waiting \nMAJ 14/01/2020 17:01:06';
        update caseTest;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('caseId', casetest.id);
        req.addParameter('relance', '1');
        req.addParameter('hashCode', String.valueOf(Convsta_eSignCallback.hashCode(casetest)));
        req.requestURI = '/signRequest?caseId='+casetest.id+'&hashCode='+Convsta_eSignCallback.hashCode(casetest)+'&relance=1';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Convsta_eSignCallback.doGet();
        
        Test.stopTest();
        Case demande = [SELECT  Id, Convsta_Statut_Signature__c, Convsta_Derniere_Maj_Signature__c
                        FROM    Case
                        WHERE   Convsta_eSign_ExtId__c = 'TestExtId'];
        system.debug(RestContext.response.responseBody.toString());
        system.assertNotEquals('Relance sans effet', demande.Convsta_Statut_Signature__c, 'statut incorrect');
        System.assert(RestContext.response.responseBody.toString().contains('eSign CallBack'));
    }
    
    @isTest static void testFail(){
        Test.startTest();
        Case casetest =[select id, createdDate FROM case where Convsta_eSign_ExtId__c  = 'TestExtId' limit 1 ];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        
        req.addParameter('caseId', casetest.id);
        req.requestURI = '/signRequest?caseId='+casetest.id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Convsta_eSignCallback.doGet();
        
        Test.stopTest();
        
        system.debug(RestContext.response.responseBody.toString());
        System.assert(RestContext.response.responseBody.toString().contains('eSign CallBack'));
    }
}