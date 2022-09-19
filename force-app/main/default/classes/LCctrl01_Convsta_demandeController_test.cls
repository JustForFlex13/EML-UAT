@isTest
public class LCctrl01_Convsta_demandeController_test {
        @testSetup
    static void setup(){
        Id p = [select id from profile where name='Convsta community Login'].id;
        Id pEmpl = [select id from profile where name='EMPLOYABILITE'].id;
        Id pResp = [select id from profile where name='Responsable Pédagogique'].id;
           
        //getTableTuteurSignataireByRespTest--
        
        User thisUser = TestObjectFactory.createUser();
        ThisUser.UserRoleId = [Select Id From UserRole Where Name='EML'].id;
        insert thisUser;

  		System.RunAs(thisUser) {
        
        list<contact> ctcList = new list<Contact>();
        Contact ctc = TestDataFactory.getContact();
        ctc.Email_EM_Lyon__c = 'test@edu.emlyon.com';
        ctc.Code_Participant__c = '1';
        ctc.Code_tiers_contact__c = '1';
        ctcList.add(ctc);
        Contact ctc2 = TestDataFactory.getContact();
        ctc2.Convsta_Tuteur_EM__c = true;
        ctc2.email = 'tuteur@yopmail.com';
        ctc2.Code_Participant__c = '2';
        ctc2.Code_tiers_contact__c = '2';
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
        User respPeda = new User(alias = 'test123', email='test123@noemail.com',
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='FR',
                               localesidkey='en_US', profileid = presp, country='France',IsActive =true,
                               timezonesidkey='America/Los_Angeles', username='respPeda@noemail.com');
        userList.add( respPeda );
        
        insert userList;
        CONVSTA_Table_Regles_Experience_Pro__c table = new CONVSTA_Table_Regles_Experience_Pro__c();
        table.Name =                    'Test';
        table.Programme__c =            'E2MS';
        table.Code_etude__c =           'E2MS2';
        table.Annee_application__c  =   String.valueOf(Date.today().year());
        table.Annee_application__c  =   '2019';
        table.Accessible_aux_etudiants__c = true;
        table.Nom_Responsable_Pedagogique__c = respPeda.Id;
        insert table;
        
        Pays__c paysref = new Pays__c(Name = 'Pays_Test01', Code_Pays_2_caracteres__c = 'US');
        insert paysref;
        insert new Etat__c( code_etat__c = 'CO',   code_pays__c = 'US', Name='Colorado');
        //postSignatureCreateTest & createTuteurEntrepriseServer & createRespAdminServer
        Account acc = TestDataFactory.getAccount();
        insert acc;

        Case demande = TestDataFactory.getCaseWithSigners();
        demande.ContactId =ctc.id;
        demande.Convsta_Entreprise__c = acc.Id;
        insert demande;
        SYstem.debug([SELECT FIrstName, lastName, convsta_code_etudiant_EM__c,Code_Participant__c,Code_tiers_contact__c FROM CONTACT]);
        delete [SELECT Id FROM Convsta_Mission__c];
        delete [SELECT Id FROM Convsta_Entreprise__c];
        
        Convsta_Mission__c mission = TestDataFactory.getConvstaMission(demande.Id);
        mission.Famille_fonction__c = 'Commercial/Ventes';
        insert mission;
        Convsta_Entreprise__c entreprise = TestDataFactory.getConvstaEntreprise(demande.Id);
        entreprise.Famille_Fonction__c = 'Commercial/Ventes';
        insert entreprise;
          }
    }
    @isTest 
    static void getUserInfosTest(){
        user usr = [select id, username from user where username='tester@noemail.com' limit 1];
        
        system.runAs(usr) {
            system.assertNotEquals(null,LCctrl01_Convsta_demandeController.getUserInfos());
        }
    }
    @isTest 
    static void setDetailStatusSignatairesTest(){
        user usr = [select id, username from user where username='administratif@noemail.com' limit 1];
        Case demande = [select id from Case limit 1];
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetDetailStatusSignataires');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        system.runAs(usr) {
            LCctrl01_Convsta_demandeController.setDetailStatusSignataires(demande.Id);
        }
        Case demandeRes = [select id, Convsta_Statut_Signature__c from Case limit 1];
        system.assertNotEquals(null, demanderes.Convsta_Statut_Signature__c);
    }
    @isTest
    static void getRelatedFormsIdTest(){
        user usr = [select id, username from user where username='tester@noemail.com' limit 1];
        Case demande = [select id from Case limit 1];
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetDetailStatusSignataires');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        String returnStr;
        system.runAs(usr) { 
            returnStr = LCctrl01_Convsta_demandeController.getRelatedFormsId(demande.Id);
        }
        LCctrl01_Convsta_demandeController.caseShellStructure retCase = (LCctrl01_Convsta_demandeController.caseShellStructure)JSON.deserialize(returnStr, LCctrl01_Convsta_demandeController.caseShellStructure.class);
        system.assertNotEquals(null,retCase.infoPerso);
        system.assertNotEquals(null,retCase.maMission);
        system.assertNotEquals(null,retCase.monContrat);
        system.assertNotEquals(null,retCase.monEntreprise);
        Convsta_Entreprise__c entreprise = new Convsta_Entreprise__c(id=retcase.monEntreprise.id);
        entreprise.Convsta_Adresse_du_lieu_du_stage__c = '13 rue de montcul';
        entreprise.Pays2__c = 'US';
        entreprise.Secteur_Activite__c = 'Administration Publique';
        entreprise.Nom_Entreprise__c = 'YOYOYOYOYOConvstaCreate';
        entreprise.Adresse_Entreprise__c = '49 ruepasteur';
        entreprise.Code_Postal__c ='785545655';
        entreprise.Ville__c= 'sdsdsdf';
        entreprise.Etat__c = 'US.CO';
        entreprise.Prenom_Signataire_Convention__c ='test';
        entreprise.Nom_Signataire_Convention__c='test';
        entreprise.Email_Signataire_Convention__c='testsignataire@yopmail.com';
        entreprise.Fonction_Signataire_Convention__c='test';
        entreprise.Civilite_Signataire_Convention__c='M';
        entreprise.Telephone_Signataire_Convention__c='0698566';
        update entreprise; 
        //LCctrl01_Convsta_demandeController.createAccountServer(demande.id);
        //LCctrl01_Convsta_demandeController.createRespAdminServer(demande.id);
        //system.assertEquals(1, [select id from account where name ='YOYOYOYOYOConvstaCreate'].size());
        //system.assertEquals(1, [select id from contact where email ='testsignataire@yopmail.com'].size());
    }
    @isTest
    static void setCancelCaseTest(){
        user usr = [select id, username from user where username='tester@noemail.com' limit 1];
        Case demande = [select id from Case limit 1];
        system.runAs(usr) { 
            LCctrl01_Convsta_demandeController.setCancelCase(demande.Id);
        }
        Case demandeReturn = [select id,Status,Convsta_motif_d_annulation__c from Case limit 1];
        
        system.assertEquals('Brouillon annulé', demandeReturn.status);
        system.assertEquals('Annulation étudiant', demandeReturn.Convsta_motif_d_annulation__c);
    }
    /*
@isTest
static void setCancelCaseErrorTest(){
user usr = [select id, username from user where username='tester@noemail.com' limit 1];
Case demande = [select id from Case limit 1];
demande.Convsta_Date_de_premiere_soumission__c=date.today();
update demande;
system.runAs(usr) { 
LCctrl01_Convsta_demandeController.setCancelCase(demande.Id);
}
Case demandeReturn = [select id,Status,Convsta_motif_d_annulation__c from Case limit 1];

system.assertNotEquals('Brouillon annulé', demandeReturn.status);
system.assertNotEquals('Annulation étudiant', demandeReturn.Convsta_motif_d_annulation__c);
}*/
    @isTest
    static void createNewExperienceValidationTest(){
        Date datedebut = Date.newInstance(2020, 01, 01);
        user usr = [select id, username from user where username='tester@noemail.com' limit 1];
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetStudentResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        system.runAs(usr) { 
            
            LCctrl01_Convsta_demandeController.submitCaseServer(LCctrl01_Convsta_demandeController.createNewExperienceValidation('En France','Stage','Convention de stage de l ecole', datedebut));
        }
        system.assertEquals(2, [select id,Status,Convsta_motif_d_annulation__c from Case].size());
    }
    @isTest
    static void createNewExperienceValidationAnterieureNOKTest(){
        Date datedebut = Date.newInstance(2020, 01, 01);
        user usr = [select id, username from user where username='tester@noemail.com' limit 1];
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetStudentResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        system.runAs(usr) { 
            try{
                LCctrl01_Convsta_demandeController.submitCaseServer(LCctrl01_Convsta_demandeController.createNewExperienceValidation('En France','Validation_experience_anterieure','VIE', datedebut));
            }
            catch(Exception e){

            }
        }
        system.assertEquals(1, [select id,Status,Convsta_motif_d_annulation__c from Case].size());
    }
    @isTest
    static void getOpenCasetest(){
        
        user usr = [select id, username from user where username='tester@noemail.com' limit 1];
        Case demande = [select id from Case limit 1];
        demande.Convsta_Date_de_premiere_soumission__c=date.today();
        update demande;
        String returnStr;
        system.runAs(usr) { 
            returnStr = LCctrl01_Convsta_demandeController.getOpenCase();
        }
        system.assertNotEquals('', returnStr);
    }
    @isTest
    static void getOpenCaseTestNoCase(){
        
        user usr = [select id, username from user where username='tester@noemail.com' limit 1];
        Case demande = [select id from Case limit 1];
        demande.Status='Demande fermée';
        update demande;
        String returnStr;
        list<ContentDocumentLink> idReturnList;
        system.runAs(usr) { 
            returnStr = LCctrl01_Convsta_demandeController.getOpenCase();
            idReturnList = LCctrl01_Convsta_demandeController.getFileIdList(demande.id);
            LCctrl01_Convsta_demandeController.switchLanguage('en_US');
        }
        system.assertEquals('', returnStr);
        system.assertEquals('en_US', [select languagelocalekey from user where id = :usr.id limit 1].languagelocalekey);
        system.assertEquals(new list<ContentDocumentLink>(), idReturnList);
    }
    /*
@isTest
static void submitCaseServerTest(){

user usr = [select id, username from user where username='tester@noemail.com' limit 1];
Case demande = [select id,status from Case limit 1];
system.runAs(usr) { 
LCctrl01_Convsta_demandeController.submitCaseServer(demande.id);
}
Case demandeRes = [select id,status from Case limit 1];
system.assertNotEquals(demande.status, demandeRes.status);
}
*/
      @isTest
    static void createTuteurEntrepriseServer(){
        User usr = [select id, username from user where username='tester@noemail.com' limit 1];
        Case demande = [select id from Case limit 1];

        Test.startTest();
        System.runAs(usr){
            LCctrl01_Convsta_demandeController.createTuteurEntrepriseServer(demande.Id);
        }
        Convsta_Mission__c mission = [SELECT Nom_Tuteur_Entreprise__c FROM Convsta_Mission__c WHERE MD_Demande__c = :demande.Id LIMIT 1];
        System.assertEquals(1, [SELECT count() FROM Contact WHERE LastName = :mission.Nom_Tuteur_Entreprise__c]);
    }
    
    @isTest
    static void createRespAdminServer(){
        User usr = [select id, username from user where username='tester@noemail.com' limit 1];
        Case demande = [select id from Case WHERE Convsta_Type_de_demande__c = 'Stage' limit 1];

        Test.startTest();
        //System.runAs(usr){
            LCctrl01_Convsta_demandeController.createRespAdminServer(demande.Id);
        //}
        Convsta_Entreprise__c entreprise = [SELECT Nom_Signataire_Convention__c FROM Convsta_Entreprise__c WHERE MD_Demande__c = :demande.Id LIMIT 1];
        System.assertEquals(1, [SELECT count() FROM Contact WHERE LastName = :entreprise.Nom_Signataire_Convention__c]);
    }    
    @isTest
    static void createAccountServer(){
        //User usr = [select id, username from user where username='test123@noemail.com' limit 1];
        Case demande = [select id from Case WHERE Convsta_Type_de_demande__c = 'Stage' limit 1];

        Test.startTest();
        //System.runAs(usr){
            LCctrl01_Convsta_demandeController.createAccountServer(demande.Id);
        try{
            LCctrl01_Convsta_demandeController.createAccountServer(demande.Id);
        }
        catch(Exception e){
            system.debug('exception catched');
        }
        //}
        Convsta_Entreprise__c entreprise = [SELECT Nom_Entreprise__c FROM Convsta_Entreprise__c WHERE MD_Demande__c = :demande.Id LIMIT 1];
        System.assertEquals(1, [SELECT count() FROM Account WHERE name = :entreprise.Nom_Entreprise__c]);
    }
}