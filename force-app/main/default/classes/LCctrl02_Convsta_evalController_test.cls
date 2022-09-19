@isTest
public class LCctrl02_Convsta_evalController_test {
    @testSetup
    static void setup(){
        Id p = [select id from profile where name='Convsta community Login'].id;
        Id pEmpl = [select id from profile where name='EMPLOYABILITE'].id;
        Id pResp = [select id from profile where name='Responsable Pédagogique'].id;

        User thisUser = TestObjectFactory.createUser();
        ThisUser.UserRoleId = [Select Id From UserRole Where Name='EML'].id;
        insert thisUser;

  		System.RunAs(thisUser) {

        //getTableTuteurSignataireByRespTest--
        list<contact> ctcList = new list<Contact>();
        Contact ctc = TestDataFactory.getContact();
        ctc.Email_EM_Lyon__c = 'test@edu.emlyon.com';
        ctcList.add(ctc);
        Contact ctc2 = TestDataFactory.getContact();
        ctc2.Convsta_Tuteur_EM__c = true;
        ctc2.email = 'tuteur@yopmail.com';
        ctcList.add(ctc2);
        insert ctcList;
        list<user> userList = new list<User>();
        userList.add( new User(alias = 'test123', email='test@edu.emlyon.com',
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='FR',
                               localesidkey='en_US', profileid = p, country='France',IsActive =true,
                               ContactId = ctc.Id,
                               timezonesidkey='America/Los_Angeles', username='tester@noemail.com'));
        userList.add( new User(alias = 'test123', email='test123@noemail.com',
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='FR',
                               localesidkey='en_US', profileid = pEmpl, country='France',IsActive =true,
                               timezonesidkey='America/Los_Angeles', username='administratif@noemail.com'));
        userList.add( new User(alias = 'test123', email='test123@noemail.com',
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='FR',
                               localesidkey='en_US', profileid = presp, country='France',IsActive =true,
                               timezonesidkey='America/Los_Angeles', username='respPeda@noemail.com'));
        insert userList;
        CONVSTA_Table_Regles_Experience_Pro__c table = TestObjectFactory.createTable();
        table.Annee_application__c  =   '2019';
        table.Accessible_aux_etudiants__c = true;
        insert table;
        Pays__c paysref = new Pays__c(Name = 'Pays_Test01', Code_Pays_2_caracteres__c = 'US');
        insert paysref;
        insert new Etat__c( code_etat__c = 'CO',   code_pays__c = 'US', Name='Colorado');
        Account company = TestDatafactory.getAccount();
        company.Name = 'Company test';
        insert company;
        //postSignatureCreateTest
        Date startDate = Date.today();
        Date endDate = startDate.addDays(20);
        Case demande = TestDatafactory.getCaseWithSigners();
        demande.Convsta_DateStart__c = startDate;
        demande.Convsta_DateEnd__c = endDate;
        system.debug('inserted TEST demande : ' + demande);
        Contact student = [SELECT Id, Name FROM Contact WHERE id = :demande.ContactId];
        Contact tutor = [SELECT Id, Name FROM Contact WHERE Name = 'Tuteur ENTREPRISE'];
        student.FirstName = 'yoyoyoy';
        student.lastName = 'yoyoyoyo';
        update student;
        demande.ContactId = student.id;
        demande.Convsta_Entreprise__c = company.id;
        demande.Convsta_Tuteur__c = tutor.Id;
        insert demande;
        Contact evaluateur = TestDataFactory.getContact();
        evaluateur.email = 'evaluateur@yopmail.com';
        insert evaluateur;
        String fakeCryptedKey = 'fakeCryptedKey';
        Convsta_Evaluation__c evaluation = TestDataFactory.getEvaluation(demande.Id);
        evaluation.cle_cryptee__c = fakeCryptedKey;
        evaluation.Demande__c = demande.Id;
        evaluation.Evaluateur__c = evaluateur.id;
        insert evaluation;
        Convsta_Mission__c mission = TestDatafactory.getMission(demande.Id);
        insert mission;
        Convsta_Competence__c oneComp = new Convsta_Competence__c(
            Name = 'competence test',
            Label_fr__c = 'competence test fr',
            Label_En__c = 'competence test en',
            Evaluation__c = evaluation.Id,
            Famille_metiers__c = evaluation.Famille_competences_metier__c,
            type__c = '3Métier',
            Order__c = 0,
            rating__c = '4'
        );
        insert oneComp;
    }
}
    @isTest 
    static void getEvaluationFormDataTest(){
        Contact student = [SELECT Id, Name FROM Contact WHERE firstname = 'yoyoyoy'];
        Contact tutor = [SELECT Id, Name FROM Contact WHERE Name = 'Tuteur ENTREPRISE'];
        Account company = [SELECT id, Name FROM Account WHERE Name = 'Company test'];
        String fakeCryptedKey = 'fakeCryptedKey';
        Convsta_Evaluation__c evaluation = [SELECT id, Demande__c,Evaluateur__r.Name FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            String result = LCctrl02_Convsta_evaluationController.getEvaluationFormDataFromUrl(fakeCryptedKey, student.Name, tutor.Name, company.Name);
            LCctrl02_Convsta_evaluationController.FormData castedResult = (LCctrl02_Convsta_evaluationController.FormData) JSON.deserialize(result, LCctrl02_Convsta_evaluationController.FormData.class);
            System.assertEquals(student.Name, castedResult.studentName);
            System.assertEquals(evaluation.Evaluateur__r.Name, castedResult.tutorName);
            System.assertEquals(company.Name, castedResult.companyName);
            
            result = LCctrl02_Convsta_evaluationController.getEvaluationFormDataFromRecordId(evaluation.Id);
            castedResult = (LCctrl02_Convsta_evaluationController.FormData) JSON.deserialize(result, LCctrl02_Convsta_evaluationController.FormData.class);
            System.assertEquals(student.Name, castedResult.studentName);
            System.assertEquals(evaluation.Evaluateur__r.Name, castedResult.tutorName);
            System.assertEquals(company.Name, castedResult.companyName);
            
            result = LCctrl02_Convsta_evaluationController.getEvaluationFormDataFromRecordId(evaluation.Demande__c);
            castedResult = (LCctrl02_Convsta_evaluationController.FormData) JSON.deserialize(result, LCctrl02_Convsta_evaluationController.FormData.class);
            System.assertEquals(student.Name, castedResult.studentName);
            System.assertEquals(evaluation.Evaluateur__r.Name, castedResult.tutorName);
            System.assertEquals(company.Name, castedResult.companyName);
            Test.stopTest();
        }
    }
    @isTest 
    static void updateEvaluationCirconstancesTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Circonstances_du_stage__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        evaluation.Circonstances_du_stage__c = 'old circumstances';
        update evaluation;
        String evaluationId = evaluation.Id;
        String newCirconstances = 'new  circumstances';
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateEvaluationCirconstances(newCirconstances, evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c evaluationUpdated = [SELECT id, Circonstances_du_stage__c FROM Convsta_Evaluation__c WHERE Id = :evaluation.Id];
        System.assertEquals(newCirconstances, evaluationUpdated.Circonstances_du_stage__c);
    }
    @isTest 
    static void updateEvalCommEarlyMakerTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Commentaire_EarlyMaker__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        evaluation.Commentaire_EarlyMaker__c = 'old Early Maker Comm';
        update evaluation;
        String newEarlyMakerComm = 'new Early Maker Comm';
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateEvalCommEarlyMaker(newEarlyMakerComm, evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c evaluationUpdated = [SELECT id, Commentaire_EarlyMaker__c FROM Convsta_Evaluation__c WHERE Id = :evaluation.Id];
        System.assertEquals(newEarlyMakerComm, evaluationUpdated.Commentaire_EarlyMaker__c);
    } 
    @isTest 
    static void updateEvalCommComportTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Commentaire_Comportementales__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        evaluation.Commentaire_Comportementales__c = 'old Comportement Comm';
        update evaluation;
        String newComportComm = 'new Comportement Comm';
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateEvalCommComport(newComportComm, evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c evaluationUpdated = [SELECT id, Commentaire_Comportementales__c FROM Convsta_Evaluation__c WHERE Id = :evaluation.Id];
        System.assertEquals(newComportComm, evaluationUpdated.Commentaire_Comportementales__c);
    }
    @isTest 
    static void updateEvalCommMetiersTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Commentaire_Metiers__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        evaluation.Commentaire_Metiers__c = 'old Métier Comm';
        update evaluation;
        String newMetierComm = 'new Métier Comm';
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateEvalCommMetiers(newMetierComm, evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c evaluationUpdated = [SELECT id, Commentaire_Metiers__c FROM Convsta_Evaluation__c WHERE Id = :evaluation.Id];
        System.assertEquals(newMetierComm, evaluationUpdated.Commentaire_Metiers__c);
    }
    @isTest 
    static void updateEvalCommGlobalTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Commentaire_global__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        evaluation.Commentaire_global__c = 'old Global Comm';
        update evaluation;
        String newGlobalComm = 'new Global Comm';
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateEvalCommGlobal(newGlobalComm, evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c evaluationUpdated = [SELECT id, Commentaire_global__c FROM Convsta_Evaluation__c WHERE Id = :evaluation.Id];
        System.assertEquals(newGlobalComm, evaluationUpdated.Commentaire_global__c);
    }
    @isTest 
    static void updateEvalMetierFamilyTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Famille_competences_metier__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        evaluation.Famille_competences_metier__c = 'Ressources Humaines';
        update evaluation;
        Convsta_Competence__c oneComp = new Convsta_Competence__c(
            Name = 'temp comp metier family a',
            Label_fr__c = 'temp comp metier family a',
            Label_En__c = 'temp comp metier family a',
            Evaluation__c = evaluation.Id,
            Famille_metiers__c = 'Ressources Humaines', // old family
            type__c = '3Métier',
            Order__c = 0,
            rating__c = '2'
        );
        insert oneComp;
        String newEvalMetierFamily = 'Direction Générale';
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateEvalMetierFamily(newEvalMetierFamily, evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c updatedEvaluation = [SELECT id, Famille_competences_metier__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        List<Convsta_Competence__c> competences = [SELECT Id FROM Convsta_Competence__c];
        System.assertEquals(newEvalMetierFamily, updatedEvaluation.Famille_competences_metier__c);
        System.assertEquals(0, competences.size());
    }    
    @isTest 
    static void updateEvaluateurMarketingOptinTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Evaluateur__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        Contact evaluateur = [SELECT Id, HasOptedInOfEmail__c FROM Contact WHERE Id = :evaluation.Evaluateur__c LIMIT 1];
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateEvaluateurMarketingOptin(true, evaluateur.Id);
        }
        Contact updatedEvaluateur = [SELECT Id, HasOptedInOfEmail__c, HasOptedOutOfEmail, DateOptedInOfEmail__c, DateOptedOutOfEmail__c FROM Contact WHERE Id = :evaluation.Evaluateur__c LIMIT 1];
        System.assertEquals(true, updatedEvaluateur.HasOptedInOfEmail__c);
        System.assertEquals(false, updatedEvaluateur.HasOptedOutOfEmail);
        System.assertNotEquals(null, updatedEvaluateur.DateOptedInOfEmail__c);
        System.runAs(u) {
            LCctrl02_Convsta_evaluationController.updateEvaluateurMarketingOptin(false, evaluateur.Id);
        }
        updatedEvaluateur = [SELECT Id, HasOptedInOfEmail__c, HasOptedOutOfEmail, DateOptedInOfEmail__c, DateOptedOutOfEmail__c FROM Contact WHERE Id = :evaluation.Evaluateur__c LIMIT 1];
        System.assertEquals(false, updatedEvaluateur.HasOptedInOfEmail__c);
        System.assertEquals(true, updatedEvaluateur.HasOptedOutOfEmail);
        System.assertNotEquals(null, updatedEvaluateur.DateOptedOutOfEmail__c);
        Test.stopTest();
    }
    @isTest 
    static void updateGlobalRatingChangeTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Note_globale__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        evaluation.Note_globale__c = 12;
        update evaluation;
        String newGlobalRating = '7';
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            LCctrl02_Convsta_evaluationController.updateGlobalRatingChange(newGlobalRating, evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c updatedEvaluation = [SELECT id, Note_globale__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        System.assertEquals(Integer.valueOf(newGlobalRating), updatedEvaluation.Note_globale__c);
    }
    @isTest 
    static void validateEvaluationTest() {
        
        Test.setMock(
        HttpCalloutMock.class,
        new Convsta_WSHelperCursus_CalloutMockImpl()
        );
        Convsta_Evaluation__c evaluation = [SELECT id, Statut__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            SendConvstaEvaluationToCursus.cancelRunForTest =false;
            Test.startTest();
            LCctrl02_Convsta_evaluationController.validateEvaluation(evaluation.Id);
            Test.stopTest();
        }
        Convsta_Evaluation__c updatedEvaluation = [SELECT id, Statut__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        System.assertEquals('Évaluée', updatedEvaluation.Statut__c);
    }
    @isTest 
    static void formatDateForFrontTest() {
        Datetime dt = datetime.newInstance(2000, 12, 1, 12, 30, 2);
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            String formattedDate = LCctrl02_Convsta_evaluationController.formatDateForFront(dt);
            System.assertEquals('01/12/2000', formattedDate);
            Test.stopTest();
        }
    }
    @isTest 
    static void getPicklistValuesTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Statut__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        List<LCctrl02_Convsta_evaluationController.Eval_CompFamily_SelectOption> picklistValues = new List<LCctrl02_Convsta_evaluationController.Eval_CompFamily_SelectOption>();
        User u = [SELECT Id FROM User WHERE username='tester@noemail.com' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            picklistValues = LCctrl02_Convsta_evaluationController.getPicklistValues(evaluation, 'Statut__c');
            Test.stopTest();
        }
        System.assertEquals(true, picklistValues.size() != 0);
    }
    @isTest 
    static void wrappersTest() {
        Convsta_Evaluation__c evaluation = [SELECT id, Statut__c FROM Convsta_Evaluation__c WHERE cle_cryptee__c = 'fakeCryptedKey'];
        List<LCctrl02_Convsta_evaluationController.Eval_CompFamily_SelectOption> picklistValues = new List<LCctrl02_Convsta_evaluationController.Eval_CompFamily_SelectOption>();
        LCctrl02_Convsta_evaluationController.FormData formData = new LCctrl02_Convsta_evaluationController.FormData();
        formData.studentName = 'studentName';
        formData.tutorName = 'tutorName';
        formData.companyName = 'companyName';
        formData.missionTitle = 'missionTitle';
        formData.missionDate = 'missionDate';
        formData.currentEvaluation = evaluation;
        formData.evalCompFamillyPicklistValues = picklistValues;
        LCctrl02_Convsta_evaluationController.Eval_CompFamily_SelectOption pickListValue = new LCctrl02_Convsta_evaluationController.Eval_CompFamily_SelectOption();
        pickListValue.label = 'label';
        pickListValue.value = 'value';
    }
    @isTest 
    static void evalEvalueeTest() {
        List<AsyncApexJob> asyncJobList = [select id from AsyncApexJob];
        Test.setMock(
            HttpCalloutMock.class,
            new Convsta_WSHelperCursus_CalloutMockImpl()
        );
        EventBus.publish( new Convsta_evaluation_evaluee__e(
            evaluationId__c = null
            ));
        test.startTest();
        Test.getEventBus().deliver();
        List<AsyncApexJob> asyncJobAfterList = [select id from AsyncApexJob];
        system.assert(asyncJobList.size()<asyncJobAfterList.size(), 'no queueable added detected');
    }

    @isTest
    public static void testcreateEvalBackOffice(){
        CONVSTA_Table_Regles_Experience_Pro__c table = TestObjectFactory.createTable();
        table.A_evaluer__c = true;
        insert table;
        delete [select id from Convsta_Evaluation__c];
        Case demande = [SELECT id from case limit 1];
        demande.Convsta_Type_de_demande__c =                    'Stage';
        demande.Convsta_DateEnd__c =                            Date.today().addDays(28);
        demande.Convsta_Evaluation__c =                         null;
        demande.Convsta_Table_des_Regles_Experience_Pro__c =    table.Id;
        demande.Status =   'Convention signée';
        demande.Convsta_Responsable_Pedagogique__c		 =    UserInfo.getUserId();
        update demande;
                
        Test.startTest();
        LCctrl02_Convsta_evaluationController.createEvalBackOffice(demande.Id);
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Convsta_Evaluation__c WHERE Demande__c = :demande.Id]);
        System.assertEquals(1, [SELECT count() FROM Case WHERE Convsta_Evaluation__c != null]);
    }
}