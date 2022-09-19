/*-------------------------------------------------------------------
-- - Purpose : Helps to create data for test classes 
--             This class is used to create data faster
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- XX/XX/20XX  XXXX  XXXXXXXXXXX 1.0      Initial version
-- 19/12/2017  A.DO  MODIS       1.1      Add default test ...
-- 16/02/2018  T.CH  MODIS       1.2      Change name's methods
-- 17/04/2018  T.CH  MODIS		 2.0	  Use of TestObjectFactory class
-- 07/12/2018  T.CH  MODIS       2.1      Change createPays method on Name field for FIELD_INTEGRITY_EXCEPTION
--------------------------------------------------------------------*/
public class TestDataFactory {
    
    // Create a country and a naf
    // Return an account
    public static Account getAccount(){
        Pays__c pays = TestObjectFactory.createPays();
        insert pays;
        Naf__c naf = TestObjectFactory.createNaf();
        insert naf;
        
        Account acc = TestObjectFactory.createAccount(pays, naf);
        
        return acc;
    }
    
    // Create a country, a naf and an account
    // Return a contact 
    public static Contact getContact(){
        Account acc = TestDataFactory.getAccount();
        insert acc;
        
        Contact ctc = TestObjectFactory.createContact(acc);
        
        return ctc;
    }
    
    // Create an user, a country, a naf and an account
    // Return a list of 5 contacts
    public static List<Contact> getContacts(){
        Account account = TestDataFactory.getAccount();
        insert account;
        
        List<Contact> contacts = new List<Contact>();
        contacts.add(TestObjectFactory.createContact('lastName1', 'firstName', account, false, false, true, null, null, 'test1@test.com'));
        contacts.add(TestObjectFactory.createContact('lastName2', 'firstName', account, false, true, false, null, 'test2@test.com', null));
        contacts.add(TestObjectFactory.createContact('lastName3', 'firstName', account, true, false, false, 'test3@test.com', null, null));
        contacts.add(TestObjectFactory.createContact('lastName4', 'firstName', account, false, false, false, 'test4@test.com', null, null));
        contacts.add(TestObjectFactory.createContact('lastName5', 'firstName', account, false, false, false, null, 'test5@test.com', null));
        
        return contacts;
    }
    
    public static Opportunity getOpportunity(String recordTypeName){
        Account acc = getAccount();
        
        return TestObjectFactory.createOpportunity(acc, recordTypeName);
    }
    
    //------BACKUP
    /*
* Create an user, an country, an account, a contact and one opportunity
*/
    public static DataTests getOpportunityDataTests(String nameRT){
        DataTests data = new DataTests();
        
        data.user = TestObjectFactory.createUser();
        insert data.user;
        data.account = TestDataFactory.getAccount();
        insert data.account;
        data.contact = TestObjectFactory.createContact(data.account, 'lastName', 'firstName');
        insert data.contact;
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', data.contact, nameRT, 'opptest'));
        data.opps = opps;
        insert data.opps;
        
        return data;
    }
    
    // Return an user, an account, 3 contact and 3 opportunities with 3 different Record Type
    public static DataTests get_3_Opportunities(String nameRT1, String nameRT2, String nameRT3){
        DataTests data = new DataTests();
        
        data.user = TestObjectFactory.createUser();
        insert data.user;
        data.account = TestDataFactory.getAccount();
        insert data.account;
        Contact contact = TestObjectFactory.createContact(data.account, 'lastName', 'firstName');
        insert contact;
        Contact contact2 = TestObjectFactory.createContact(data.account, 'lastName2', 'firstName2');
        insert contact2;
        Contact contact3 = TestObjectFactory.createContact(data.account, 'lastName3', 'firstName3');
        insert contact3;
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', contact, nameRT1, 'opptest1'));        
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', contact2, nameRT2, 'opptest2'));        
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', contact3, nameRT3, 'opptest3'));        
        data.opps = opps;
        
        return data;
    }
    
    // Return an user, an account, a contact and 4 opportunities with 3 different Records Types     
    public static DataTests get_4_OpportunitiesWithSameContact(String nameRT1, String nameRT2, String nameRT3){
        DataTests data = new DataTests();
        
        data.user = TestObjectFactory.createUser();
        insert data.user;
        data.account = TestDataFactory.getAccount();
        insert data.account;
        data.contact = TestObjectFactory.createContact(data.account);
        insert data.contact;
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', data.contact, nameRT1, 'opptest1'));         
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', data.contact, nameRT2, 'opptest2'));
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', data.contact, nameRT3, 'opptest3')); 
        opps.add(TestObjectFactory.createOpportunity(data.account, 'Admis', data.contact, nameRT1, 'opptest4'));   
        data.opps = opps;
        insert data.opps;
        
        return data;
    }
    
    public static Case getCaseWithSigners(){
        Contact etudiant = TestDataFactory.getContact(); 
        etudiant.FirstName = 'TestFirstefzName2sqsdqsrgfqfs';
        etudiant.LastName = 'TestLastNafzeme3fqfsq';
        etudiant.Email = 'eusyfgqdhqldks@email.com';
        etudiant.convsta_code_etudiant_EM__c='12345678222';
        etudiant.Adresse_Email_Personnelle__c = 'fqsdfqzefqsfqsdqsdqdazdfqss@email.com';
        etudiant.Appliquer_l_e_mail_personnel__c = true;
        database.SaveResult sr = database.insert( etudiant, false);
        for(database.Error err: sr.getErrors()){
            system.debug(err.getFields()+' '+err.getMessage());
        }
        Contact respAdmin = TestDataFactory.getContact();
        respAdmin.FirstName = 'Responsable';
        respAdmin.LastName = 'ADMINISITRATIF';
        respAdmin.Email = 'test2@email.com';
        respAdmin.convsta_code_etudiant_EM__c='123456782221';
        insert respAdmin;
        
        Contact tuteur = TestDataFactory.getContact();
        tuteur.FirstName = 'Tuteur';
        tuteur.LastName = 'ENTREPRISE';
        tuteur.convsta_code_etudiant_EM__c='12345678222';
        tuteur.Email = 'test3@email.com';
        insert tuteur;
        
        Contact tuteurEM = TestDataFactory.getContact();
        tuteurEM.FirstName = 'Tuteur';
        tuteurEM.LastName = 'EM';
        tuteurEM.Email = 'test4@email.com';
        tuteurEM.convsta_code_etudiant_EM__c='12345678223';
        tuteurEM.Convsta_Tuteur_EM__c = true;
        insert tuteurEM;
        
        Case demande = TestObjectFactory.createCase(tuteurEm);
        demande.recordTypeId    = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience');
        demande.Responsable_administratif_entreprise__c = respAdmin.Id;
        demande.Convsta_Tuteur__c = tuteur.Id;
        demande.Convsta_Referent_pedagogique__c = tuteurEM.Id;
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c  = 'Convention de stage de l ecole';
        return demande;
    }

    public static CONVSTA_Table_Regles_Experience_Pro__c getTableReglesExperiencePro(){
        Contact respPeda = new Contact(
            lastName='aaaaRespPedaContact',
            FirstName='aaaaRespPedaContact',
            Email='aaa@aaa.dde',
            Convsta_Tuteur_EM__c = true,
            Email_Professionnel__c = 'aaa@aaa.dde',
            Appliquer_l_e_mail_professionnel__c = true);
        insert respPeda;
        CONVSTA_Table_Regles_Experience_Pro__c table = new CONVSTA_Table_Regles_Experience_Pro__c();
        table.Name =                    'Test';
        table.Programme__c =            'E2MS';
        table.Code_etude__c =           'E2MS2';
        table.Annee_application__c  =   '2019';
        table.Accessible_aux_etudiants__c = true;
        table.Date_Demarrage_Au_Plus_Tot__c = Date.newInstance(2020, 1, 1);
        table.Convsta_Tuteur_par_defaut__c = respPeda.Id;
        table.Nom_Responsable_Pedagogique__c = UserInfo.getUserId();
        return table;
    }

    public static convsta_Requis_au_diplome__c getRequisAuDiplome(){
        convsta_Requis_au_diplome__c requisAuDiplome = new convsta_Requis_au_diplome__c();
        requisAuDiplome.Programme__c = 'E2MS';
        requisAuDiplome.Annee_application__c = '2019';
        return requisAuDiplome;
    }
    public static Convsta_Mission__c getConvstaMission(Id caseId){
        Convsta_Mission__c mission = new Convsta_Mission__c();

        mission.Prenom_Tuteur_Entreprise__c = 'Tuteur FirstName';
        mission.Nom_Tuteur_Entreprise__c = 'Tuteur LastName';
        mission.Email_Tuteur_Entreprise__c = 'tuteur@testemail.com';
        mission.Civilite_Tuteur_Entreprise__c = 'M';
        mission.Tuteur_Entreprise__c = 'Tuteur Fonction';
        mission.MD_Demande__c = caseId;   
        mission.Telephone_Tuteur_Entreprise__c = '0000000000';
        mission.Famille_fonction__c = 'Commercial/Ventes';

        return mission;
    }

    public static Convsta_Entreprise__c getConvstaEntreprise(Id caseId){
        Convsta_Entreprise__c entreprise = new Convsta_Entreprise__c();

        entreprise.Prenom_Signataire_Convention__c = 'Signataire FirstName';
        entreprise.Nom_Signataire_Convention__c = 'Signataire LastName';
        entreprise.Email_Signataire_Convention__c = 'signataire@testemail.com';
        entreprise.Civilite_Signataire_Convention__c = 'M';
        entreprise.Fonction_Signataire_Convention__c = 'Signataire Fonction';
        entreprise.Famille_Fonction__c = 'Commercial/Ventes';
        entreprise.MD_Demande__c = caseId; 
        entreprise.Telephone_Signataire_Convention__c = '0000000000';
		entreprise.Adresse_Entreprise__c='yoyyo';
        entreprise.Pays2__c='US';
        entreprise.Nom_Entreprise__c ='emlyon';
        entreprise.Adresse_Entreprise__c ='4 rue du qutre';
        entreprise.Code_Postal__c='69007';
        entreprise.Ville__c='Lyon';
        entreprise.Secteur_Activite__c='Administration Publique';
		entreprise.SIRET__c='95950473900019';
        return entreprise;
    }


    public static Convsta_Evaluation__c getEvaluation(Id demandeId){
        Convsta_Evaluation__c evaluation = TestObjectFactory.createEvaluation();
        evaluation.Demande__c = demandeId;
        evaluation.Famille_competences_metier__c='Ressources Humaines';
        return evaluation;
    }
    
    public static Convsta_Mission__c getMission(Id demandeId) {
        Convsta_Mission__c mission = new Convsta_Mission__c(
            MD_Demande__c = demandeId,
            Titre_Mission__c = 'titre mission test',
            Convsta_Description_de_la_mission__c = 'description mission test'
        );
        return mission;
    }
    
    public static Product2 getProduct(){
        Product2 product = new Product2(
        Name = 'Nom produit',
        RecordTypeId = APU_ApexUtils.getProduct2RecordTypeIdByName('Autre')
        );
            return product;
    }
    
    public static Session__c getSession(){
        Product2 produit = TestDataFactory.getProduct();
        insert produit;
        
        Session__c session = new Session__c(
            Code_Agresso_Session_formation__c = 'code agr s',
            Code_agresso_for__c = 'code agrfor',
            Date_de_debut_de_session__c = System.today() + 5,
            Date_de_fin_de_session__c = System.today() + 15,
            Exercice_fiscale__c = 'SF-EF10',
            Lieu_ls__c = 'SF-LS10',
            Mode_apprentissage__c = 'SF-MA10',
            Name = 'Nomsession',
            Produits__c = produit.Id
        );
            return session;
    }
}