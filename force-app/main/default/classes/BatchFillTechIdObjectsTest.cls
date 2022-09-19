/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 */

@IsTest
private class BatchFillTechIdObjectsTest {
/**
    Création de données
     */
    @testSetup static void createData() {

        List<Etat__c> etats = new List<Etat__c>{
                new Etat__c(),
                new Etat__c()
        };
        insert etats;

        
        List<Titre__c> titres = new List<Titre__c>{
                new Titre__c(Name = 'Titre_Test01'),
                new Titre__c(Name = 'Titre_Test02')
        };
        insert titres;

        List<NAF__c> nafs = new List<NAF__c>{
                new NAF__c(Name = 'NAF_Test01', CODE_APE__c = '010101010101'),
                new NAF__c(Name = 'NAF_Test02', CODE_APE__c = '020202020220')
        };
        insert nafs;
        
        List<Pays__c> pays = new List<Pays__c>{
                new Pays__c(Name = 'Pays_Test01'),
                new Pays__c(Name = 'Pays_Test02')
        };
        insert pays;

        List<Account> accounts = new List<Account>{
                new Account(Name = 'Account01',
                        CodePays__c = pays[0].Id,
                        Adresse_Ville__c = 'AdresseTest',
                        CodeAPE__c = nafs[0].Id,
                        SIRET__c = '73282932000074'),
                new Account(Name = 'Account02',
                        CodePays__c = pays[0].Id,
                        Adresse_Ville__c = 'AdresseTest',
                        CodeAPE__c = nafs[0].Id,
                        SIRET__c = '73282932000074')
        };
        insert accounts;

        List<Contact> contacts = new List<Contact>{
                new Contact(FirstName = 'Test',
                        LastName = '01',
                        Salutation = 'Mme'),
                new Contact(FirstName = 'Test',
                        LastName = '02',
                        Salutation = 'Mme')
        };
        insert contacts;

        List<Product2> products = new List<Product2>{
                new Product2(Name = 'Produit_Test01'),
                new Product2(Name = 'Produit_Test02')
        };
        insert products;

        List<Pricebook2> pricebook2s = new List<Pricebook2>{
                new Pricebook2(Name = 'Pricebook2_Test01'),
                new Pricebook2(Name = 'Pricebook2_Test02')
        };
        insert pricebook2s;

        List<D_partement__c> departements = new List<D_partement__c>{
                new D_partement__c(Name = 'Rhône', Code_d_partement__c = '69'),
                new D_partement__c(Name = 'Savoie', Code_d_partement__c = '73')
        };
        insert departements;

        List<Etablissement__c> etablissements = new List<Etablissement__c>{
                new Etablissement__c(Name = 'Etab_Test01'),
                new Etablissement__c(Name = 'Etab_Test02')
        };
        insert etablissements;

        List<Opportunity> opportunities = new List<Opportunity>{
                new Opportunity(Name = 'Opp_Test01',
                        StageName = 'Stage_Test01',
                        CloseDate = date.today()),
                new Opportunity(Name = 'Opp_Test02',
                        StageName = 'Stage_Test02',
                        CloseDate = date.today())
        };
        insert opportunities;

        List<Lead> leads = new List<Lead>{
                new Lead(lastname='Test01',
                        company='11',
                        Adresse_e_mail__c = 'test@Test1.fr'),
                new Lead(lastname='Test02',
                        company='11',
                        Adresse_e_mail__c = 'test@Test2.fr')
        };
        insert leads;

        List<Session__c> sessions = new List<Session__c>{
/*                new Session__c(),
                new Session__c()
 */                   
            	TestDataFactory.getSession(),
            	TestDataFactory.getSession()
        };
        insert sessions;

        Profile p = [SELECT Id FROM Profile WHERE Name='Utilisateur standard' OR Name='Standard User' LIMIT 1];

        List<User> users = new List<User>{
                new User(FirstName = 'UserTest01',
                        LastName = 'Test',
                        Username = 'Test1@testDataExtract.fr',
                        Alias = 'Test1',
                        Email = 'Testeur@test.fr',
                        CommunityNickname = 'Test01',
                        localesidkey='en_US',
                        emailencodingkey='UTF-8',
                        languagelocalekey='en_US',
                        TimeZoneSidKey='Europe/Paris',
                        ProfileId=p.Id),
                new User(FirstName = 'UserTest02',
                        LastName = 'Test',
                        Username = 'Test2@testDataExtract.fr',
                        Alias = 'Test2',
                        Email = 'Testeur@test.fr',
                        CommunityNickname = 'Test02',
                        localesidkey='en_US',
                        emailencodingkey='UTF-8',
                        languagelocalekey='en_US',
                        TimeZoneSidKey='Europe/Paris',
                        ProfileId=p.Id)
        };
        System.debug(users);
        insert users;
    }
    
    static testMethod void testBatchFillTechId001Account() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId001Account());
        Test.stopTest();

        testBatchs('Account');
    }

    static testMethod void testBatchFillTechId002Contact() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId002Contact());
        Test.stopTest();

        testBatchs('Contact');
    }

    static testMethod void testBatchFillTechId003Opportunity() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId003Opportunity());
        Test.stopTest();

        testBatchs('Opportunity');
    }

    static testMethod void testBatchFillTechId004Titre() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId004Titre());
        Test.stopTest();

        testBatchs('Titre__c');
    }

    static testMethod void testBatchFillTechId005Etablissement() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId005Etablissement());
        Test.stopTest();

        testBatchs('Etablissement__c');
    }

    static testMethod void testBatchFillTechId006Pays() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId006Pays());
        Test.stopTest();

        testBatchs('Pays__c');
    }

    static testMethod void testBatchFillTechId007Departement() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId007Departement());
        Test.stopTest();

        testBatchs('D_partement__c');
    }

    static testMethod void testBatchFillTechId008Lead() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId008Lead());
        Test.stopTest();

        testBatchs('Lead');
    }

    static testMethod void testBatchFillTechId009Naf() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId009Naf());
        Test.stopTest();

        testBatchs('NAF__c');
    }

    static testMethod void testBatchFillTechId011Etat() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId011Etat());
        Test.stopTest();

        testBatchs('Etat__c');
    }

    static testMethod void testBatchFillTechId012Product() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId012Product());
        Test.stopTest();

        testBatchs('Product2');
    }

    static testMethod void testBatchFillTechId013Session() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId013Session());
        Test.stopTest();

        testBatchs('Session__c');
    }

    static testMethod void testBatchFillTechId014Pricebook() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId014Pricebook());
        Test.stopTest();

        testBatchs('Pricebook2');
    }

    static testMethod void testBatchFillTechId015User() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId015User());
        Test.stopTest();

        testBatchs('User');
    }

    private static void testBatchs (String objName) {
        String query = 'SELECT ID, TECH_External_Id__c FROM ' + objName + ' WHERE TECH_External_Id__c != null LIMIT 150';
        List<SObject> objList = Database.query(query);
        System.debug('--- Test Batch for '+ objName + ' ---');

        for (SObject obj : objList) {
            System.debug('--- Id de l\' enregistrement : ' + obj.Id);
            System.debug('--- TECH_External_Id de l\' enregistrement : ' + String.valueOf( obj.get('TECH_External_Id__c') ));

            String techId = String.valueOf( obj.get('TECH_External_Id__c') );
            System.assertEquals(String.valueOf(obj.Id), techId);
        }
    }
}