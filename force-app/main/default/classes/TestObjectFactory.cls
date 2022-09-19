/*-------------------------------------------------------------------
-- - Purpose            : Helps to create objects records for TestDataFactory class 
--                        This class is used to create objects records faster
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- 17/04/2018  T.CH  MODIS       1.0      Initial version
-- 07/12/2018  T.CH  MODIS       1.1      Add unique field value for contact object creation (for duplicate rule)
-- 14/01/2019  T.CH  MODIS       1.2      Add Case creation
--------------------------------------------------------------------*/
public class TestObjectFactory {

    /************************ STANDARD OBJECTS ************************/
    /***************** Account *****************/
    public static Account createAccount(Pays__c pays, Naf__c naf){
        Account account = new Account();

        /************************ Standard Fields **********************/
        account.Name = 'TestName ' + String.valueOf(Math.random()*1000000);
        
        /************************ Custom Fields **********************/
        account.SIRET__c = '00000000000000';
        account.CodePays__c = pays.Id;
        account.Adresse_Ville__c = 'TestVille';
        account.CODEAPE__c = naf.Id;

        return account;
    }

    /***************** Case *****************/
    public static Case createCase(Contact contact){
        Case demande = new Case();

        /************************ Standard Fields **********************/
        demande.ContactId       = contact.Id;
        demande.Origin          = 'Web';
        demande.Status          = 'Brouillon en cours de saisie';
        
        return demande;
    }

    /***************** Contact *****************/
    public static Contact createContact(Account acc){
        Contact contact = new Contact();

        /************************ Standard Fields **********************/
        contact.LastName = 'TestLastName ' + String.valueOf(Math.random()*1000000);
        contact.FirstName = 'TestFirstName';
        contact.Adresse_Email_Personnelle__c = 'test' + String.valueOf(Math.random()*1000000) + '@test.com'; //for duplicate rule
        contact.Email_de_repli__c = 'test' + String.valueOf(Math.random()*1000000) + '@test.com'; //for duplicate rule
        contact.Email_EM_Lyon__c = 'test' + String.valueOf(Math.random()*1000000) + '@test.com'; //for duplicate rule
        contact.Email = 'test@test.com';
        contact.Phone ='0000000000';
        contact.Salutation = 'Mme';
        contact.AccountId = acc.Id;

        /************************ Custom Fields **********************/
        contact.Famille_Fonction__c = 'Autres';
        
        return contact;
    }
    
    public static Contact createContact(Account acc, String recordTypeName){
        Contact contact = createContact(acc);

        contact.RecordTypeId = APU_ApexUtils.getContactRecordTypeIdByName(recordTypeName);
        
        return contact;
    }
    
    public static Contact createContact(Account acc, String lastName, String firstName){
        Contact contact = createContact(acc);

        contact.LastName = lastName;
        contact.FirstName = firstName;
        
        return contact;
    }

    public static Contact createContact(String lastName, String firstName, Account acc,
                                        Boolean mailPro, Boolean mailPerso, Boolean mailLyon,
                                        String emailPro, String emailPerso, String emailLyon){
    
    	Contact contact = createContact(acc);

        /************************ Standard Fields **********************/
        contact.LastName = lastName;
        contact.FirstName = firstName;
                                            
        /************************ Custom Fields **********************/
        /*contact.Appliquer_l_e_mail_professionnel__c = mailPro;
        contact.Appliquer_l_e_mail_EM_Lyon__c = mailLyon;
        contact.Appliquer_l_e_mail_personnel__c = mailPerso;*/
        contact.Adresse_Email_Personnelle__c = emailPerso;
        contact.Email_de_repli__c = emailPro;
        contact.Email_EM_Lyon__c = emailLyon;
 
        return contact;
    }

    /***************** Opportunity *****************/
    public static Opportunity createOpportunity(Account acc, String recordTypeName){
        Opportunity opp = new Opportunity();
    	
        /************************ Standard Fields **********************/
        opp.Name = 'TestName ' + String.valueOf(Math.random()*1000000);
        opp.StageName = 'TestStageName';
        opp.CloseDate = Date.today().addMonths(1);       
        opp.AccountId = acc.Id;
        opp.RecordTypeId = APU_ApexUtils.getOpportunityRecordTypeIdByName(recordTypeName);
        
        /************************ Custom Fields **********************/
        opp.Exercice__c = String.valueOf(Date.today().year() + 1);
        opp.InterfaceExternalId__c= 'InterfaceId ' + System.currentTimeMillis() + String.valueOf(Math.random()*1000000);

        return opp;
    }

    public static Opportunity createOpportunity(Account acc, String recordTypeName, String stageName){
        Opportunity opp = createOpportunity(acc, recordTypeName);

        opp.StageName = stageName;

        return opp;
    }
    
    public static Opportunity createOpportunity(Account acc, String stageName, 
                                                Contact ctc, String recordTypeName, String name){
    	
        Opportunity opp = createOpportunity(acc, recordTypeName);

        /************************ Standard Fields **********************/
        opp.Name= name;
        opp.StageName = stageName;

        /************************ Custom Fields **********************/
        opp.Contact_central__c = ctc.Id;

        return opp;
    }

    public static List<Opportunity> createOpportunities(Account acc, String recordTypeName, Integer nbToCreate){
        List<Opportunity> lOpp  = new List<Opportunity>();
        for(Integer i=1; i<=nbToCreate; i++){
            lOpp.add(createOpportunity(acc, recordTypeName));
        }

        return lOpp;
    }

    /***************** Product2 *****************/
    public static Product2 createProduct2(){
        Product2 product2 = new Product2();

        /************************ Standard Fields **********************/
        product2.Name='TestName ' + String.valueOf(Math.random()*1000000);
        product2.isActive = true;

        return product2;
    }

    /***************** Pricebook2 *****************/
    public static Pricebook2 createPricebook2(){
        Pricebook2 pricebook2 = new Pricebook2();

        /************************ Standard Fields **********************/
        pricebook2.Name='TestName ' + String.valueOf(Math.random()*1000000);
        pricebook2.isActive = true;

        return pricebook2;
    }

    /***************** PricebookEntry *****************/
    public static PricebookEntry createPricebookEntryStandard(Id product2Id) {
        PricebookEntry pbe = new PricebookEntry();

        /************************ Standard Fields **********************/
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = product2Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;

        return pbe;
    }

    public static PricebookEntry createPricebookEntry(Product2 product2,Pricebook2 pricebook2){
        PricebookEntry pbe = new PricebookEntry();

        /************************ Standard Fields **********************/
        pbe.Pricebook2Id = pricebook2.Id;
        pbe.Product2Id = product2.Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;

        return pbe;
    }

    /***************** OpportunityLineItem *****************/
    public static OpportunityLineItem createOpportunityLineItem(Id oppId, Id product2Id, Id priceBookEntryId){
        OpportunityLineItem oppLine = new OpportunityLineItem();

        /************************ Standard Fields **********************/
        oppLine.Product2Id = product2Id;
        oppLine.OpportunityId = oppId;
        oppLine.PriceBookEntryId = priceBookEntryId;
        oppLine.InterfaceExternalId__c = System.currentTimeMillis() + String.valueOf(Math.random()*1000000);
        oppLine.Quantity=1.0;

        return oppLine;
    }
    
    /***************** User *****************/
    public static User createUser(String uniqueName){
        User user = new User();

        /************************ Standard Fields **********************/
        user.ProfileId = [SELECT Id FROM Profile LIMIT 1].Id;
        user.FirstName = uniqueName + String.valueOf(Math.random()*1000000);
        user.LastName = uniqueName + String.valueOf(Math.random()*1000000);
        user.Email = uniqueName + '@test.com';
        user.Username = uniqueName + String.valueOf(Math.random()*1000000) + '@test.com';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = uniqueName.substring(0,3);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        user.CommunityNickname = uniqueName + String.valueOf(Math.random()*1000000);

        return user;
    }

    public static User createUser(String uniqueName, String profileName){
        User user = createUser(uniqueName);

        /************************ Standard Fields **********************/
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id;

        return user;
    }

    public static User createUser(){        
        String uniqueName = 'TestUniqueName';
        String profileName = 'Administrateur système';
        return createUser(uniqueName, profileName);
    }
    
    /************************ CUSTOM OBJECTS ************************/
    /***************** Pays *****************/
    public static Pays__c createPays(){
        Pays__c pays = new Pays__c();

        /************************ Standard **********************/
        pays.Name='France';

        return pays;
    }

    /***************** Naf *****************/
    public static NAF__c createNaf(){
        NAF__c naf = new NAF__c();

        /************************ Standard **********************/
        naf.Name='TestName';
        naf.CODE_APE__c= String.valueOf(Math.random()*1000000).replaceAll('\\W','');

        return naf;
    }

    /***************** Diplôme *****************/
    public static Dipl_me__c createDiplome(Contact ctc){
        Dipl_me__c diplome = new Dipl_me__c();

        diplome.programme__c = 'MBA';
        diplome.Contact__c = ctc.Id;
        diplome.Promo_d_entr_e__c = String.valueOf(Date.today().year());
        diplome.Promo_de_sortie__c = String.valueOf(Date.today().year() + 1);
        diplome.Cycle__c = 'International MBA';

        return diplome;
    }

    /***************** Table de règles de stage *****************/
    public static CONVSTA_Table_Regles_Experience_Pro__c createTable(){
        CONVSTA_Table_Regles_Experience_Pro__c table = new CONVSTA_Table_Regles_Experience_Pro__c();

        table.Name =                    'Test';
        table.Programme__c =            'E2MS';
        table.Code_etude__c =           'E2MS2';
        table.Annee_application__c  =   String.valueOf(Date.today().year());
        table.Date_Demarrage_Au_Plus_Tot__c = date.today();

        return table;
    }
 
    /***************** Evaluation *****************/
    public static Convsta_Evaluation__c createEvaluation() {
        Convsta_Evaluation__c evaluation = new Convsta_Evaluation__c();
        evaluation.Cle_cryptee__c = 'fakeCryptedKey' ;
        evaluation.Circonstances_du_stage__c = 'fake circumstances' ;
        evaluation.Commentaire_Comportementales__c = 'fake comment behavior' ;
        evaluation.Commentaire_EarlyMaker__c = 'fake comment Early Maker'  ;
        evaluation.Commentaire_Metiers__c = 'fake comment Metiers';
        evaluation.Commentaire_global__c = 'fake comment global';
        evaluation.Famille_competences_metier__c = 'Ressources Humaines';
        evaluation.Note_globale__c = 10; 
        return evaluation;
    }
}