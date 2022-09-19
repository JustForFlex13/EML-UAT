@isTest
public class Convsta_WS_HelperTest {
    @testSetup
    static void setup(){
    //getTableTuteurSignataireByRespTest--
        Contact ctc = TestDataFactory.getContact();
        ctc.Email_EM_Lyon__c = 'test@edu.emlyon.com';
        insert ctc;
		
        CONVSTA_Table_Regles_Experience_Pro__c table = TestDataFactory.getTableReglesExperiencePro();
        table.Anterieur__c = true;
        insert table;
        
        convsta_Requis_au_diplome__c requisAuDiplome = TestDataFactory.getRequisAuDiplome();
        insert requisAuDiplome;
        
        //postSignatureCreateTest
        Case demande = TestDatafactory.getCaseWithSigners();
        insert demande;

        //getTableTuteurSignataireByRespTest
        table.Code_etude_Annee_suivante__c =  'E2MS3';
        table.Ann_e_suivante__c =       false;
        table.Date_Demarrage_Au_Plus_Tot__c = Date.newInstance(2020, 7, 1);
        update table;

        CONVSTA_Table_Regles_Experience_Pro__c table2 = new CONVSTA_Table_Regles_Experience_Pro__c();
        table2.Name =                    'TestAnneeSuivante';
        table2.Programme__c =            'E2MS';
        table2.Code_etude__c =           'E2MS3';
        table2.Code_etude_Annee_suivante__c =  'E2MS4';
        table2.Ann_e_suivante__c =       true;
        table2.Annee_application__c  =   '2019';
        table2.Accessible_aux_etudiants__c = true;
        table2.Date_Demarrage_Au_Plus_Tot__c = Date.newInstance(2021, 7, 1);
        insert table2;
    }
    @isTest 
    static void getTableTuteurSignataireByRespTest(){
        Date d1 = Date.newInstance(2021, 01, 01);
        String typetest = 'Validation_experience_anterieure';
 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetStudentResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        Convsta_WS_Helper.getTableTuteurSignataire('test@edu.emlyon.com', typetest, d1);
        Test.stopTest();
    
        //Only code coverage
    }

    @isTest 
    static void doPostSignatureCreateConventionTest(){
        Case demande =[SELECT Id,Convsta_Langue__c,Convsta_eSign_ExtId__c,CaseNumber,
                           Convsta_Tuteur__r.Email,
                           Convsta_Tuteur__r.LastName,
                           Convsta_Tuteur__r.FirstName,
                           Convsta_Tuteur__c,
                           Responsable_administratif_entreprise__r.Email,
                           Responsable_administratif_entreprise__r.LastName,
                           Responsable_administratif_entreprise__r.FirstName,
                           Responsable_administratif_entreprise__c,
                           Contact.Email,
                           Contact.LastName,
                           Contact.FirstName,
                           Contact.Id,
                           Convsta_Signataire_delegue__r.Email,
                           Convsta_Signataire_delegue__r.FirstName,
                           Convsta_Signataire_delegue__r.LastName,
                           Convsta_Signataire_delegue__c,
                           Convsta_Referent_pedagogique__r.Email,
                           Convsta_Referent_pedagogique__r.FirstName,
                           Convsta_Referent_pedagogique__r.LastName,
                           Convsta_Referent_pedagogique__c,
                       	   Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c
                       FROM Case 
                       LIMIT 1];

        eSign_Configuration__mdt eSignConf = Convsta_WS_Helper.getESignConf();
        SwagSignatureSignerModel respAdmin = Convsta_WS_Helper.makeSigner(demande.Responsable_administratif_entreprise__c,eSignConf,false);
        String respAdminEmail = [SELECT Email_Signataire_Convention__c FROM Convsta_Entreprise__c WHERE MD_Demande__c = :demande.Id LIMIT 1].Email_Signataire_Convention__c;
        respAdmin.emailAddress = respAdminEmail;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_postEsignCreateNewSign');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/plain');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        Convsta_WS_Helper.doPostSignatureCreateConvention(demande, respAdmin, eSignConf);
        Test.stopTest();

        //Only code coverage
    }

    @isTest 
    static void doPostSignatureCreateConventionTestAutoSignRP(){
        system.debug('Modis YGA - doPostSignatureCreateConventionTestAutoSignRP - Test Convsta_WS_Helper AutoSign Chantal POTY') ;
        CONVSTA_Table_Regles_Experience_Pro__c tbrExPro = new CONVSTA_Table_Regles_Experience_Pro__c() ;
		tbrExPro.OwnerId = UserInfo.getUserId() ;	
		tbrExPro.Name = 'bba3' ;
		tbrExPro.Accessible_aux_etudiants__c = true ;
		tbrExPro.Afficher_logo_Paul_Bocuse__c = false ;
		tbrExPro.Code_etude__c = 'BBA3' ;
		tbrExPro.Nom_Responsable_Pedagogique__c = UserInfo.getUserId() ;	
		tbrExPro.Programme__c = 'BBA' ;
		tbrExPro.Anterieur__c = true ;
		tbrExPro.Suiveur_requis__c = false ;
		tbrExPro.Ne_pas_faire_signer_le_resp_pedagogique__c = true ;
        insert tbrExPro ;

        Case demandeToUpdate =[SELECT Id,
                           Convsta_Table_des_Regles_Experience_Pro__c
                       FROM Case 
                       LIMIT 1];

        demandeToUpdate.Convsta_Table_des_Regles_Experience_Pro__c = tbrExPro.Id ;  
        update demandeToUpdate ;

        Case demande =[SELECT Id,Convsta_Langue__c,Convsta_eSign_ExtId__c,CaseNumber,
                           Convsta_Tuteur__r.Email,
                           Convsta_Tuteur__r.LastName,
                           Convsta_Tuteur__r.FirstName,
                           Convsta_Tuteur__c,
                           Responsable_administratif_entreprise__r.Email,
                           Responsable_administratif_entreprise__r.LastName,
                           Responsable_administratif_entreprise__r.FirstName,
                           Responsable_administratif_entreprise__c,
                           Contact.Email,
                           Contact.LastName,
                           Contact.FirstName,
                           Contact.Id,
                           Convsta_Signataire_delegue__r.Email,
                           Convsta_Signataire_delegue__r.FirstName,
                           Convsta_Signataire_delegue__r.LastName,
                           Convsta_Signataire_delegue__c,
                           Convsta_Referent_pedagogique__r.Email,
                           Convsta_Referent_pedagogique__r.FirstName,
                           Convsta_Referent_pedagogique__r.LastName,
                           Convsta_Referent_pedagogique__c,
                           Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c
                       FROM Case 
                       WHERE Id =: demandeToUpdate.Id
                       LIMIT 1];         

        eSign_Configuration__mdt eSignConf = Convsta_WS_Helper.getESignConf();
        SwagSignatureSignerModel respAdmin = Convsta_WS_Helper.makeSigner(demande.Responsable_administratif_entreprise__c,eSignConf,false);
        String respAdminEmail = [SELECT Email_Signataire_Convention__c FROM Convsta_Entreprise__c WHERE MD_Demande__c = :demande.Id LIMIT 1].Email_Signataire_Convention__c;
        respAdmin.emailAddress = respAdminEmail;

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Convsta_WSHelper_CalloutMockImpl());

        Test.startTest();
        Convsta_WS_Helper.doPostSignatureCreateConvention(demande, respAdmin, eSignConf);
        Test.stopTest();

        //Only to check the request sended when the case is autosigned with C. POTY's signature
    }

    @isTest 
    static void doPostSignatureCreateConventionTestRequireSignRP(){
        system.debug('Modis YGA - doPostSignatureCreateConventionTestRequireSignRP - Test Convsta_WS_Helper le RP doit signer') ;
        CONVSTA_Table_Regles_Experience_Pro__c tbrExPro = new CONVSTA_Table_Regles_Experience_Pro__c() ;
		tbrExPro.OwnerId = UserInfo.getUserId() ;	
		tbrExPro.Name = 'bba3' ;
		tbrExPro.Accessible_aux_etudiants__c = true ;
		tbrExPro.Afficher_logo_Paul_Bocuse__c = false ;
		tbrExPro.Code_etude__c = 'BBA3' ;
		tbrExPro.Nom_Responsable_Pedagogique__c = UserInfo.getUserId() ;	
		tbrExPro.Programme__c = 'BBA' ;
		tbrExPro.Anterieur__c = true ;
		tbrExPro.Suiveur_requis__c = false ;
		tbrExPro.Ne_pas_faire_signer_le_resp_pedagogique__c = false ;
        insert tbrExPro ;

        Case demandeToUpdate =[SELECT Id,
                           Convsta_Table_des_Regles_Experience_Pro__c
                       FROM Case 
                       LIMIT 1];

        demandeToUpdate.Convsta_Table_des_Regles_Experience_Pro__c = tbrExPro.Id ;  
        update demandeToUpdate ;

        Case demande =[SELECT Id,Convsta_Langue__c,Convsta_eSign_ExtId__c,CaseNumber,
                           Convsta_Tuteur__r.Email,
                           Convsta_Tuteur__r.LastName,
                           Convsta_Tuteur__r.FirstName,
                           Convsta_Tuteur__c,
                           Responsable_administratif_entreprise__r.Email,
                           Responsable_administratif_entreprise__r.LastName,
                           Responsable_administratif_entreprise__r.FirstName,
                           Responsable_administratif_entreprise__c,
                           Contact.Email,
                           Contact.LastName,
                           Contact.FirstName,
                           Contact.Id,
                           Convsta_Signataire_delegue__r.Email,
                           Convsta_Signataire_delegue__r.FirstName,
                           Convsta_Signataire_delegue__r.LastName,
                           Convsta_Signataire_delegue__c,
                           Convsta_Referent_pedagogique__r.Email,
                           Convsta_Referent_pedagogique__r.FirstName,
                           Convsta_Referent_pedagogique__r.LastName,
                           Convsta_Referent_pedagogique__c,
                           Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c
                       FROM Case 
                       WHERE Id =: demandeToUpdate.Id
                       LIMIT 1];         

        eSign_Configuration__mdt eSignConf = Convsta_WS_Helper.getESignConf();
        SwagSignatureSignerModel respAdmin = Convsta_WS_Helper.makeSigner(demande.Responsable_administratif_entreprise__c,eSignConf,false);
        String respAdminEmail = [SELECT Email_Signataire_Convention__c FROM Convsta_Entreprise__c WHERE MD_Demande__c = :demande.Id LIMIT 1].Email_Signataire_Convention__c;
        respAdmin.emailAddress = respAdminEmail;



        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Convsta_WSHelper_CalloutMockImpl());

        Test.startTest();
        Convsta_WS_Helper.doPostSignatureCreateConvention(demande, respAdmin, eSignConf);
        Test.stopTest();

        //Only to check the request sended when the case requires RP's signature
    }
    
    @isTest 
    static void doPostSignatureCreateAvenantTest(){
        Case demande =[SELECT Id,Convsta_Langue__c,Convsta_eSign_ExtId__c,CaseNumber, ParentId,
                           Convsta_Tuteur__r.Email,
                           Convsta_Tuteur__r.LastName,
                           Convsta_Tuteur__r.FirstName,
                           Convsta_Tuteur__c,
                           Responsable_administratif_entreprise__r.Email,
                           Responsable_administratif_entreprise__r.LastName,
                           Responsable_administratif_entreprise__r.FirstName,
                           Responsable_administratif_entreprise__c,
                           Contact.Email,
                           Contact.LastName,
                           Contact.FirstName,
                           Contact.Id,
                           Convsta_Signataire_delegue__r.Email,
                           Convsta_Signataire_delegue__r.FirstName,
                           Convsta_Signataire_delegue__r.LastName,
                           Convsta_Signataire_delegue__c,
                           Convsta_Referent_pedagogique__r.Email,
                           Convsta_Referent_pedagogique__r.FirstName,
                           Convsta_Referent_pedagogique__r.LastName,
                           Convsta_Referent_pedagogique__c
                       FROM Case 
                       LIMIT 1];
        eSign_Configuration__mdt eSignConf = Convsta_WS_Helper.getESignConf();
        SwagSignatureSignerModel respAdmin = Convsta_WS_Helper.makeSigner(demande.Responsable_administratif_entreprise__c,eSignConf,false);
        String respAdminEmail = [SELECT Email_Signataire_Convention__c FROM Convsta_Entreprise__c WHERE MD_Demande__c = :demande.Id LIMIT 1].Email_Signataire_Convention__c;
        respAdmin.emailAddress = respAdminEmail;

        Contact etudiant = [SELECT Id, LastName, FirstName FROM Contact WHERE Id = :demande.Contact.Id];
        Case avenant = TestObjectFactory.createCase(etudiant);
        avenant.recordtypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Convsta_Avenant').getRecordTypeId();
        avenant.ParentId = demande.Id;
        insert avenant;
        avenant = [SELECT Id,Convsta_Langue__c,Convsta_eSign_ExtId__c,CaseNumber, ParentId,
                           Convsta_Tuteur__r.Email,
                           Convsta_Tuteur__r.LastName,
                           Convsta_Tuteur__r.FirstName,
                           Convsta_Tuteur__c,
                           Responsable_administratif_entreprise__r.Email,
                           Responsable_administratif_entreprise__r.LastName,
                           Responsable_administratif_entreprise__r.FirstName,
                           Responsable_administratif_entreprise__c,
                           Contact.Email,
                           Contact.LastName,
                           Contact.FirstName,
                           Contact.Id,
                           Convsta_Signataire_delegue__r.Email,
                           Convsta_Signataire_delegue__r.FirstName,
                           Convsta_Signataire_delegue__r.LastName,
                           Convsta_Signataire_delegue__c,
                           Convsta_Referent_pedagogique__r.Email,
                           Convsta_Referent_pedagogique__r.FirstName,
                           Convsta_Referent_pedagogique__r.LastName,
                           Convsta_Referent_pedagogique__c
                       FROM Case 
                       WHERE Id = :avenant.Id
                       LIMIT 1];

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_postEsignCreateNewSign');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/plain');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        Convsta_WS_Helper.doPostSignatureCreateAvenant(avenant, respAdmin, eSignConf);
        Test.stopTest();

        //Only code coverage
    }

    @isTest
    static void setDetailStatusSignatairesTest(){
        Case demande =[SELECT Id, Convsta_Langue__c, Convsta_eSign_ExtId__c, CaseNumber, Convsta_Detail_statut_signataire__c,
               Convsta_Tuteur__r.Email,
               Convsta_Tuteur__r.LastName,
               Convsta_Tuteur__r.FirstName,
               Convsta_Tuteur__c,
               Responsable_administratif_entreprise__r.Email,
               Responsable_administratif_entreprise__r.LastName,
               Responsable_administratif_entreprise__r.FirstName,
               Responsable_administratif_entreprise__c,
               Contact.Email,
               Contact.LastName,
               Contact.FirstName,
               Contact.Id,
               Convsta_Signataire_delegue__r.Email,
               Convsta_Signataire_delegue__r.FirstName,
               Convsta_Signataire_delegue__r.LastName,
               Convsta_Signataire_delegue__c,
               Convsta_Referent_pedagogique__r.Email,
               Convsta_Referent_pedagogique__r.FirstName,
               Convsta_Referent_pedagogique__r.LastName,
               Convsta_Referent_pedagogique__c
               FROM Case 
               LIMIT 1];

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetDetailStatusSignataires');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        Convsta_WS_Helper.setDetailStatusSignataires(demande,true);
        Test.stopTest();

        //Only code coverage
    }
    
    @isTest 
    static void getDocumentsignedTest(){
        Case demande =[SELECT Id,Convsta_Langue__c,Convsta_eSign_ExtId__c,CaseNumber,
                           Convsta_Tuteur__r.Email,
                           Convsta_Tuteur__r.LastName,
                           Convsta_Tuteur__r.FirstName,
                           Convsta_Tuteur__c,
                           Responsable_administratif_entreprise__r.Email,
                           Responsable_administratif_entreprise__r.LastName,
                           Responsable_administratif_entreprise__r.FirstName,
                           Responsable_administratif_entreprise__c,
                           Contact.Email,
                           Contact.LastName,
                           Contact.FirstName,
                           Contact.Id,
                           Convsta_Signataire_delegue__r.Email,
                           Convsta_Signataire_delegue__r.FirstName,
                           Convsta_Signataire_delegue__r.LastName,
                           Convsta_Signataire_delegue__c,
                           Convsta_Referent_pedagogique__r.Email,
                           Convsta_Referent_pedagogique__r.FirstName,
                           Convsta_Referent_pedagogique__r.LastName,
                           Convsta_Referent_pedagogique__c,
                       	   Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c,
                       	   Convsta_eSign_Errors__c,
                       	   ParentId
                       FROM Case 
                       LIMIT 1];

        eSign_Configuration__mdt eSignConf = Convsta_WS_Helper.getESignConf();
        SwagSignatureSignerModel respAdmin = Convsta_WS_Helper.makeSigner(demande.Responsable_administratif_entreprise__c,eSignConf,false);
        String respAdminEmail = [SELECT Email_Signataire_Convention__c FROM Convsta_Entreprise__c WHERE MD_Demande__c = :demande.Id LIMIT 1].Email_Signataire_Convention__c;
        respAdmin.emailAddress = respAdminEmail;
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_postEsignCreateNewSign');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/plain');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        Convsta_WS_Helper.getSignedDocument(demande);
        Test.stopTest();

        //Only code coverage
    }
    
    @isTest
    static void doCallEsignCallBack(){
        Case demande =[SELECT Id, CreatedDate
                       FROM Case 
                       LIMIT 1];
        
        RestRequest req = new RestRequest() ;
        req.addParameter('caseId', demande.id) ;
        req.addParameter('hashCode', String.valueOf(Convsta_eSignCallback.hashCode(demande)));
        
        RestResponse res = new RestResponse() ;
        
        RestContext.request  = req;
    	RestContext.response = res;
        
        Test.startTest();
        Convsta_eSignCallback.doget() ;
        Test.stopTest();
    }
    @isTest
    static void testGetStatus(){
        system.assertEquals('Convention en attente de signature', Convsta_WS_Helper.statusFromWsStatus('ready'), 'wrong status returned');
        system.assertEquals('Signée', Convsta_WS_Helper.statusFromWsStatus('completed'), 'wrong status returned');
        system.assertEquals('Expirée', Convsta_WS_Helper.statusFromWsStatus(null), 'wrong status returned');
        system.assertEquals('Annulée', Convsta_WS_Helper.statusFromWsStatus('canceled'), 'wrong status returned');
    }
}