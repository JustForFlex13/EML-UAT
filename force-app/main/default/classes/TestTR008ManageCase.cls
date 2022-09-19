@isTest
public class TestTR008ManageCase {
    @testSetup
    static void setup(){
        CONVSTA_Table_Regles_Experience_Pro__c test = TestDataFactory.getTableReglesExperiencePro();
        insert test;
    }

    @isTest 
    static void isValidationPedagoAdmin(){
        Case demande = TestDataFactory.getCaseWithSigners();
        Contact ctc = [select id from contact limit 1];
        R_le__c role = new R_le__c(contact__c=ctc.id, Liste_r_le__c = 'SUIVEUR OU MAITRE DE STAGE');
        insert role;
        R_le__c role2 = new R_le__c(contact__c=ctc.id);
        insert role2;
        System.assertNotEquals(0, [select id from R_le__c where convsta_suiveur__c =true].size());
        demande.Convsta_Role_EMLYON__c = role.id;
        demande.Convsta_Verdict_Pedagogique__c = 'Demande Acceptée';
        demande.RecordTypeId =  APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');

        Test.startTest();
        insert demande;
        Test.stopTest();

        demande = [SELECT Convsta_Date_Validation_Pedagogique__c, Convsta_Date_assignation_au_gestionnaire__c,
                          Convsta_Validation_Pedagogique__c, OwnerId, Status
                   FROM Case];

        Group queue =  [SELECT Id
                       FROM Group WHERE 
                       DeveloperName = 'Convsta_En_attente_de_validation_admin'];

        System.assertNotEquals(null, demande.Convsta_Date_Validation_Pedagogique__c);
        System.assertNotEquals(null, demande.Convsta_Date_assignation_au_gestionnaire__c);

        System.assertEquals(true, demande.Convsta_Validation_Pedagogique__c);

        System.assertEquals(queue.Id, demande.OwnerId);
        System.assertEquals('Demande en cours de validation administrative', demande.Status);
    }

    @isTest 
    static void isDemandeSoumiseSansRP(){
        Case demande = TestDataFactory.getCaseWithSigners();
        demande.Status = 'Demande soumise';
        demande.Convsta_Table_des_Regles_Experience_Pro__c = [SELECT Id, Nom_Responsable_Pedagogique__c FROM CONVSTA_Table_Regles_Experience_Pro__c].Id;
        demande.RecordTypeId =  APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        
        Test.startTest();
        insert demande;
        Test.stopTest();

        demande = [SELECT Convsta_Date_Soumission_Demande__c,
                          OwnerId, Status
                   FROM Case];

        Group queue = [SELECT Id
                       FROM Group WHERE 
                       DeveloperName = 'Convsta_En_attente_de_validation_admin'];

        System.assertNotEquals(null, demande.Convsta_Date_Soumission_Demande__c);

        System.assertEquals(queue.Id, demande.OwnerId);
        System.assertEquals('Demande en cours de validation pédagogique', demande.Status);
    }
    
    @isTest 
    static void isDemandeSansRespAdminAvecRespPeda(){      
        CONVSTA_Table_Regles_Experience_Pro__c table = [SELECT Id, Nom_Responsable_Pedagogique__c FROM CONVSTA_Table_Regles_Experience_Pro__c];
        table.Nom_Responsable_Pedagogique__c = [select id from user where isActive=true and userType='Standard' limit 1].id;
        update table;
        
        Case demande = TestDataFactory.getCaseWithSigners();  
        demande.Convsta_Table_des_Regles_Experience_Pro__c = table.id;
        demande.Status = 'Demande soumise';
        demande.Convsta_Gestionnaire_en_charge__c = null;
        demande.Convsta_Validation_Pedagogique__c = true;
        demande.RecordTypeId =  APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        
        Test.startTest();
        insert demande;
        Test.stopTest();

        demande = [SELECT Convsta_Date_Soumission_Demande__c, Convsta_Date_assignation_au_gestionnaire__c,
                          OwnerId, Status
                   FROM Case];

        Group queue = [SELECT Id
                       FROM Group WHERE 
                       DeveloperName = 'Convsta_En_attente_de_validation_admin'];

        System.assertEquals('Demande en cours de validation pédagogique', demande.Status);
        System.assertNotEquals(null, demande.Convsta_Date_Soumission_Demande__c);

        System.assertEquals(queue.Id, demande.OwnerId);
    }
    
    @isTest 
    static void isDemandeSansRespAdminSansRespPeda(){
        CONVSTA_Table_Regles_Experience_Pro__c table = [SELECT Id, Nom_Responsable_Pedagogique__c FROM CONVSTA_Table_Regles_Experience_Pro__c];
        table.Nom_Responsable_Pedagogique__c = null;
        update table;
        
        Case demande = TestDataFactory.getCaseWithSigners();
        demande.Convsta_Table_des_Regles_Experience_Pro__c = table.id;
        demande.Status = 'Demande soumise';
        demande.Convsta_Gestionnaire_en_charge__c = null;
        demande.Convsta_Validation_Pedagogique__c = true;
        demande.RecordTypeId =  APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        
        Test.startTest();
        insert demande;
        Test.stopTest();

        demande = [SELECT Convsta_Date_Soumission_Demande__c, Convsta_Date_assignation_au_gestionnaire__c,
                          OwnerId, Status
                   FROM Case];

        Group queue = [SELECT Id
                       FROM Group WHERE 
                       DeveloperName = 'Convsta_En_attente_de_validation_admin'];

        System.assertEquals('Demande en cours de validation pédagogique', demande.Status);
        System.assertNotEquals(null, demande.Convsta_Date_Soumission_Demande__c);

        System.assertEquals(queue.Id, demande.OwnerId);
    }

    @isTest 
    static void isDemandeAvecRespAdminSansRespPeda(){
        CONVSTA_Table_Regles_Experience_Pro__c table = [SELECT Id, Nom_Responsable_Pedagogique__c FROM CONVSTA_Table_Regles_Experience_Pro__c];
        table.Nom_Responsable_Pedagogique__c = null;
        update table;
        
        Case demande = TestDataFactory.getCaseWithSigners();
        demande.Convsta_Table_des_Regles_Experience_Pro__c = table.id;
        demande.Status = 'Demande soumise';
        demande.Convsta_Gestionnaire_en_charge__c = UserInfo.getUserId();
        demande.Convsta_Validation_Pedagogique__c = true;
        demande.RecordTypeId =  APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        
        Test.startTest();
        insert demande;
        Test.stopTest();

        demande = [SELECT Convsta_Date_Soumission_Demande__c, Convsta_Date_assignation_au_gestionnaire__c,
                          OwnerId, Status
                   FROM Case];

        System.assertEquals('Demande en cours de validation administrative', demande.Status);
        System.assertNotEquals(null, demande.Convsta_Date_Soumission_Demande__c);

        System.assertEquals(UserInfo.getUserId(), demande.OwnerId);
    }
    
    @isTest
    static void testConvention() {
        Case demande = TestDataFactory.getCaseWithSigners();
        insert demande;

        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_postEsignCreatenewSign');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);
        demande.Convsta_Statut_Signature__c = 'Convention validée à émettre';
        update demande;
        Test.stopTest();

        demande = [SELECT Convsta_Statut_Signature__c FROM Case WHERE Id = :demande.Id];

        System.assertEquals('Convention en attente de signature', demande.Convsta_Statut_Signature__c);
    }

    @isTest static void testAvenant() {
        Case demande = TestDataFactory.getCaseWithSigners();
        insert demande;
        Case avenant = TestDataFactory.getCaseWithSigners();
        avenant.ParentId = demande.Id;
        insert avenant;

        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_postEsignCreateNewSign');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);
        avenant.Status = 'Avenant validé à émettre';
        avenant.Convsta_Statut_Signature__c = 'Avenant validé à émettre';
        update avenant;
        Test.stopTest();

        avenant = [SELECT Convsta_Statut_Signature__c FROM Case WHERE Id = :avenant.Id];

        System.assertEquals('Avenant en cours de signature', avenant.Convsta_Statut_Signature__c);
    }

    @isTest static void testCaseSharingUpdateRP() {
        Case demande = TestDataFactory.getCaseWithSigners();
        demande.Convsta_Validation_Pedagogique__c = true;
        insert demande;

        Profile p = [SELECT Id FROM Profile WHERE name LIKE '%Responsable%Pédagogique%'] ;

        User oldRP = [SELECT Id FROM User WHERE id !=: demande.OwnerId AND isActive = true AND ProfileId =: p.Id LIMIT 1] ;
        User newRP = [SELECT Id FROM User WHERE id !=: oldRP.Id AND id !=: demande.OwnerId AND isActive = true AND ProfileId =: p.Id LIMIT 1] ;

        Test.startTest();
        demande.Convsta_Responsable_Pedagogique__c = oldRP.Id ;
        update demande;
        demande.Convsta_Responsable_Pedagogique__c = newRP.Id ;
        update demande;
        Test.stopTest();

        String resAccess = '' ;
        String resUserId = '' ;

        for(CaseShare cs : [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel FROM CaseShare WHERE CaseID =: demande.Id]){
			if(cs.UserOrGroupId == newRP.Id){
				resAccess = cs.CaseAccessLevel ;
			}
            if(cs.CaseAccessLevel == 'Read'){
				resUserId = cs.UserOrGroupId ;
			}
		}

        System.assertEquals('Read', resAccess);
        System.assertEquals(newRP.Id, resUserId);
    }
}