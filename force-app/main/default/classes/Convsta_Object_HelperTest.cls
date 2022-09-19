@isTest()
private class Convsta_Object_HelperTest {
    @testSetup
    static void setup(){
        Pays__c frenchCountry =                    TestObjectFactory.createPays();
        frenchCountry.Name =                       'France';
        frenchCountry.Code_Pays_2_caracteres__c =  'FR';
        insert frenchCountry;
        NAF__c naf =        TestObjectFactory.createNaf();
        naf.CODE_APE__c =   'TestNaf';
        insert naf;
        Account accFr = TestObjectFactory.createAccount(frenchCountry, naf);
        accFr.Name =                    'TestNameFR';
        accFr.SIRET__c =                '35315026100330';
        accFr.Adresse_Rue__c =          'TestAddress';
        accFr.Code_Postal__c =          '69000';
        accFr.Adresse_Ville__c =        'TestCity';
        accFr.Tranche_d_effectif__c =   '10 000 et plus';
        insert accFr;
        
        Contact etudiant =      TestObjectFactory.createContact(accFr);
        etudiant.FirstName =    'Etudiant';
        etudiant.LastName =     'EM';
        etudiant.Email =        'testEtudiant@test.com';
        insert etudiant;

        Contact tuteurEM =              TestObjectFactory.createContact(accFr);
        tuteurEM.FirstName =            'Tuteur';
        tuteurEM.LastName =             'EM';
        tuteurEM.Email =                'testTuteurEM@test.com';
        tuteurEM.Convsta_Tuteur_EM__c = true;
        insert tuteurEM;

        Pays__c foreignCountry =                    TestObjectFactory.createPays();
        foreignCountry.Name =                       'Espagne';
        foreignCountry.Code_Pays_2_caracteres__c =  'ES';
        insert foreignCountry;
        Account foreignAcc =            TestDataFactory.getAccount();
        foreignAcc.Name =               'ForeignAcc';
        foreignAcc.CodePays__c =        foreignCountry.Id;
        foreignAcc.Adresse_Ville__c =   'Madrid'; 
        insert foreignAcc;

        Contact respAdmin =     TestObjectFactory.createContact(foreignAcc);
        respAdmin.FirstName =   'Responsable';
        respAdmin.LastName =    'ADMINISTRATIF';
        respAdmin.Email=        'testRespAdmin@test.com';
        insert respAdmin;

        Contact tuteurEntreprise =      TestObjectFactory.createContact(foreignAcc);
        tuteurEntreprise.FirstName =    'Tuteur';
        tuteurEntreprise.LastName =     'ENTREPRISE';
        tuteurEntreprise.Email=         'testTuteurEntreprise@test.com';
        insert tuteurEntreprise;
    }

	// method to test when a student add a company who already exists in SF database
    @isTest static void frenchCompanyTest(){
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];

        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId                            = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Localisation_de_l_entreprise__c = 'En France';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        insert demande;

        Account accFr = [SELECT Name, CodePays__r.Code_Pays_2_caracteres__c, CODEAPE__r.CODE_APE__c, SIRET__c
                         FROM Account
                         WHERE Name = 'TestNameFR'];
        
        Convsta_Entreprise__c entreprise = [SELECT  Id, Nom_Entreprise__c, Pays2__c, Ville__c, 
                                                    SIRET__c, Adresse_Entreprise__c, Code_Postal__c, Tranche_effectif_etablissement__c, Code_NAF__c
                                            FROM    Convsta_Entreprise__c
                                            WHERE   MD_Demande__c = :demande.Id];
        entreprise.SIRET__c =                           accFr.SIRET__c;
        entreprise.Nom_Entreprise__c =                  'NewTestName';
        entreprise.Adresse_Entreprise__c =              'NewTestAddress';
        entreprise.Pays2__c =                           accFr.CodePays__r.Code_Pays_2_caracteres__c;
        entreprise.Code_Postal__c =                     '69100';
        entreprise.Ville__c =                           'NewTestCity';
        entreprise.Tranche_effectif_etablissement__c =  '10 000 et plus';
        entreprise.Code_NAF__c =                        accFr.CODEAPE__r.CODE_APE__c;
        update entreprise;

        Test.startTest();
        Convsta_object_helper.checkMatchingAccountAndContact(demande.id);
        Test.stopTest();

        accFr = [SELECT Name, Adresse_Rue__c
                 FROM Account
                 WHERE Id = :accFr.Id];
        // because the account already exists we just update some informations but not the name
        System.assertEquals('TestNameFR', accFr.Name);
        System.assertEquals('NEWTESTADDRESS', accFr.Adresse_Rue__c.toUpperCase());
    }
    
    // method to test when a student add a company who doesn't already exists in SF database
    @isTest static void frenchOtherCompanyTest(){
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];

        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId                            = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Localisation_de_l_entreprise__c = 'En France';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        insert demande;

        Account accFr = [SELECT Name, CodePays__r.Code_Pays_2_caracteres__c, CODEAPE__r.CODE_APE__c, SIRET__c
                         FROM Account
                         WHERE Name = 'TestNameFR'];
        
        Convsta_Entreprise__c entreprise = [SELECT  Id, Nom_Entreprise__c, Pays2__c, Ville__c, 
                                                    SIRET__c, Adresse_Entreprise__c, Code_Postal__c, Tranche_effectif_etablissement__c, Code_NAF__c
                                            FROM    Convsta_Entreprise__c
                                            WHERE   MD_Demande__c = :demande.Id];
        entreprise.SIRET__c =                           '12345678200010';//accFr.SIRET__c;
        entreprise.Nom_Entreprise__c =                  'NewTestName';
        entreprise.Adresse_Entreprise__c =              'NewTestAddress';
        entreprise.Pays2__c =                           accFr.CodePays__r.Code_Pays_2_caracteres__c;
        entreprise.Code_Postal__c =                     '69100';
        entreprise.Ville__c =                           'NewTestCity';
        entreprise.Tranche_effectif_etablissement__c =  '10 000 et plus';
        entreprise.Code_NAF__c =                        accFr.CODEAPE__r.CODE_APE__c;
        update entreprise;

        Test.startTest();
        Convsta_object_helper.checkMatchingAccountAndContact(demande.id);
        Test.stopTest();

        accFr = [SELECT Name
                 FROM Account
                 WHERE Id = :accFr.Id];
                        
        /*Account newAcc = [SELECT Name
                 FROM Account
                 WHERE Id = :demande.Convsta_Entreprise__c];*/
        
        // because the account did not already exists now we have two Account in the database
        System.assertEquals('TestNameFR', accFr.Name);
        //System.assertEquals('NewTestName', newAcc.Name);
    }
    
    @isTest static void foreignCompanyTest(){
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];

        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId                            =   APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Localisation_de_l_entreprise__c =   'A l\'étranger';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole'; 
        insert demande;

        Convsta_Entreprise__c entreprise = [SELECT  Id, Nom_Entreprise__c, Pays2__c, Ville__c
                                            FROM    Convsta_Entreprise__c
                                            WHERE   MD_Demande__c = :demande.Id];
                                            
        entreprise.Nom_Entreprise__c =                  'ForeignAcc';
        entreprise.Pays2__c =                           'ES';
        entreprise.Ville__c =                           'Madrid';
        entreprise.Guide_des_bonnes_pratiques__c =		true;
        update entreprise;

        Test.startTest();
        Convsta_Object_Helper.checkMatchingAccountAndContact(demande.Id);
        Test.stopTest();

        demande =  [SELECT Id, Convsta_Entreprise__c
                    FROM Case
                    LIMIT 1];
        Account foreignAcc =   [SELECT Id
                                FROM Account
                                WHERE Name = 'ForeignAcc'];
                                
        System.assertEquals(foreignAcc.Id, demande.Convsta_Entreprise__c);
    }

    @isTest static void checkMatchingAccountAndContactTest(){
        String phone = '0000000000';
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];

        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId                            = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Localisation_de_l_entreprise__c = 'En France';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        insert demande;        
        
        Account foreignAcc = [SELECT Id, Name, CodePays__r.Code_Pays_2_caracteres__c, CODEAPE__r.CODE_APE__c, Adresse_Ville__c, SIRET__c
                              FROM Account
                              WHERE Name = 'ForeignAcc'];
        demande.Convsta_Entreprise__c = foreignAcc.Id;

        Convsta_Entreprise__c entreprise = [SELECT  Id, Prenom_Signataire_Convention__c, Nom_Signataire_Convention__c, 
                                                    Email_Signataire_Convention__c, Telephone_Signataire_Convention__c
                                            FROM    Convsta_Entreprise__c
                                            WHERE   MD_Demande__c = :demande.Id];
        entreprise.Nom_Entreprise__c =                  foreignAcc.Name;
        entreprise.Pays2__c  =                          foreignAcc.CodePays__r.Code_Pays_2_caracteres__c;
        entreprise.Code_NAF__c =                        foreignAcc.CODEAPE__r.CODE_APE__c;
        entreprise.Ville__c  =                          foreignAcc.Adresse_Ville__c;
        entreprise.SIRET__c =                           foreignAcc.SIRET__c;
        entreprise.Prenom_Signataire_Convention__c =    'Responsable';
        entreprise.Nom_Signataire_Convention__c =       'ADMINISTRATIF';
        entreprise.Email_Signataire_Convention__c =     'newtest@test.com';
        entreprise.Telephone_Signataire_Convention__c = phone;
        update entreprise;
                        
        Convsta_Mission__c mission = [  SELECT  Id, Prenom_Tuteur_Entreprise__c, Nom_Tuteur_Entreprise__c, 
                                                Email_Tuteur_Entreprise__c, Telephone_Tuteur_Entreprise__c
                                        FROM    Convsta_Mission__c
                                        WHERE   MD_Demande__c = :demande.Id];
        mission.Prenom_Tuteur_Entreprise__c =   'Tuteur';
        mission.Nom_Tuteur_Entreprise__c=       'ENTREPRISE';
        mission.Email_Tuteur_Entreprise__c =    'newtest@test.com';
        mission.Telephone_Tuteur_Entreprise__c= phone;
        update mission;

        Test.startTest();
        Convsta_object_helper.checkMatchingAccountAndContact(demande.Id);
        Test.stopTest();

        Contact existingTuteur =   [SELECT      Id, Email, Phone, CreatedDate
                                    FROM        Contact
                                    WHERE       FirstName = 'Tuteur'
                                    AND         LastName  = 'ENTREPRISE'
                                    ORDER BY    CreatedDate DESC];
        Contact existingResp =     [SELECT      Id, Email, Phone, CreatedDate
                                    FROM        Contact
                                    WHERE       FirstName = 'Responsable'
                                    ORDER BY    CreatedDate  DESC];
        demande =                  [SELECT      Id, Responsable_administratif_entreprise__c, Convsta_Tuteur__c
                                    FROM        Case
                                    WHERE       Id = :demande.Id];

        System.assertEquals(entreprise.Email_Signataire_Convention__c,      existingResp.Email);
        System.assertEquals(entreprise.Telephone_Signataire_Convention__c,  existingResp.Phone);
        System.assertEquals(existingResp.Id, demande.Responsable_administratif_entreprise__c);

        System.assertEquals(mission.Email_Tuteur_Entreprise__c,     existingTuteur.Email);
        System.assertEquals(mission.Telephone_Tuteur_Entreprise__c, existingTuteur.Phone);
        System.assertEquals(existingTuteur.Id, demande.Convsta_Tuteur__c);
    }

    @isTest
    static void shareFileToCommunity(){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true; 

        Account acc = TestDataFactory.getAccount();
        Database.SaveResult sr = Database.insert(acc, dml);

        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];

        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId               = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c     = 'Convention de stage de l ecole';
        insert demande;

        ContentVersion contentVersion = new ContentVersion(
            Title = 'convention-00000000',
            PathOnClient = 'convention-00000000.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = demande.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'I';
        cdl.Visibility = 'InternalUsers';
        insert cdl;

        Test.startTest();
        Convsta_Object_Helper.shareFileToCommunity(demande.Id, documents[0].Id);
        Test.stopTest();

        demande = [SELECT Status, Convsta_Statut_Signature__c, Date_Reception_Convention__c FROM Case WHERE Id =:demande.Id];
        System.assertEquals(demande.Status, 'Convention signée');
        System.assertEquals(demande.Convsta_Statut_Signature__c, 'Signée');

        cdl = [SELECT ShareType, Visibility FROM ContentDocumentLink WHERE ContentDocumentId =:documents[0].Id AND LinkedEntityId =:demande.id];
        System.assertEquals(cdl.ShareType, 'V');
        System.assertEquals(cdl.Visibility, 'AllUsers');
    }
    @isTest
    static void testMappingFonction (){
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Commercial/Ventes'), 'Conseil Commercial/Ventes');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Direction Générale'), 'Directeur ou Conseil en Stratégie');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Enseignement/Education'), 'Professeur');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Etud/Recherche/Dévelop/Qualité'), 'Conseil Etudes/Recherche');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Finance/Gest./Adminis./Juridi.'), 'Consultant Finance/Gestion/Audit');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Marketing/Communication'), 'Conseil en Marketing');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Organisation/Systèmes d’Informations'), 'Conseil Organis./SI');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Production/Achats'), 'Responsable des Achats');
        system.assertEquals(Convsta_Object_Helper.mapFonctionContact('Ressources Humaines/Formation'), 'Conseil en Ress. Humaines/ Outplacement');
    }
    @isTest
    static void testUpdateEvalDocId(){
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];
        
        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId                            = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Localisation_de_l_entreprise__c = 'En France';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        insert demande;
        
        Convsta_Evaluation__c evaluation = TestObjectFactory.createEvaluation() ;
        evaluation.demande__c = demande.Id ;
        insert evaluation ;
        
        Test.startTest();
        ContentVersion contentVersion = new ContentVersion(
            Title = 'convention-00000000',
            PathOnClient = 'convention-00000000.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Convsta_Object_Helper.updateEvaluationDocumentId(evaluation.id, documents[0].Id);
        Test.stopTest();
        
        Case res = [SELECT Id, Convsta_EvaluationDocumentId__c FROM Case WHERE Id =: demande.id];
        System.assertEquals(documents[0].Id, res.Convsta_EvaluationDocumentId__c);
    }
    
    @isTest
    static void testEvalueeEvalId(){
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];
        
        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId                            = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Localisation_de_l_entreprise__c = 'En France';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        insert demande;
        
        Convsta_Evaluation__c evaluation = TestObjectFactory.createEvaluation() ;
        evaluation.demande__c = demande.Id ;
        insert evaluation ;
        
        Test.startTest();
        Convsta_Object_Helper.getCareerCenterQueue();
        Convsta_Object_Helper.evalSetEvaluee(evaluation.id);
        Test.stopTest();
        
        Convsta_Evaluation__c res = [SELECT Id, Statut__c FROM Convsta_Evaluation__c WHERE Id =: evaluation.id];
        System.assertEquals('Évaluée', res.Statut__c);
    }
    @isTest
    static void testDocAVerifier(){
        Contact etudiant = [SELECT Id
                            FROM Contact
                            WHERE FirstName = 'Etudiant'];
        
        Case demande = TestObjectFactory.createCase(etudiant);
        demande.RecordTypeId                            = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Convsta_Localisation_de_l_entreprise__c = 'En France';
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        insert demande;
        
        Test.startTest();
        Convsta_Object_Helper.caseSetDocumentAVerifier(demande.id, 'Autre');
        Test.stopTest();
        
        Case res = [SELECT Id, Convsta_Document_a_verifier__c, Convsta_Type_de_document__c FROM Case WHERE Id =: demande.id];
        System.assertEquals(true, res.Convsta_Document_a_verifier__c);
        System.assertEquals('Autre', res.Convsta_Type_de_document__c);
    }
}