/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
public class DataExtractObjectsUtilsTest {
   /**
    Création de données
     */
    @testSetup public static void createData() {
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

        List<Etat__c> etats = new List<Etat__c>{
                new Etat__c(),
                new Etat__c()
        };
        insert etats;

        Profile p = [SELECT Id FROM Profile WHERE Name='Utilisateur standard' OR Name ='Standard User'  LIMIT 1];

        List<User> users = new List<User>{
                new User(FirstName = 'UserTest01',
                        LastName = 'Test',
                        Username = 'Test01@testDataExtract.fr',
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
                        Username = 'Test02@testDataExtract.fr',
                        Alias = 'Test2',
                        Email = 'Testeur@test.fr',
                        CommunityNickname = 'Test02',
                        localesidkey='en_US',
                        emailencodingkey='UTF-8',
                        languagelocalekey='en_US',
                        TimeZoneSidKey='Europe/Paris',
                        ProfileId=p.Id)
        };
        insert users;

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
                        Salutation = 'Mme',
                        AccountId = accounts[0].Id),
                new Contact(FirstName = 'Test',
                        LastName = '02',
                        Salutation = 'Mme',
                        AccountId = accounts[1].Id)
        };
        insert contacts;

        List<Formation__c> formations = new List<Formation__c>{
                new Formation__c(Contact__c = contacts[0].Id),
                new Formation__c(Contact__c = contacts[1].Id)
        };
        insert formations;

        List<Dipl_me__c> diplomes = new List<Dipl_me__c>{
                new Dipl_me__c(Contact__c = contacts[0].Id),
                new Dipl_me__c(Contact__c = contacts[1].Id)
        };
        insert diplomes;

        List<R_le__c> roles = new List<R_le__c>{
                new R_le__c(Contact__c = contacts[0].Id),
                new R_le__c(Contact__c = contacts[1].Id)
        };
        insert roles;

        List<Campaign> campaigns = new List<Campaign>{
                new Campaign(Name = 'Campaign_Test01'),
                new Campaign(Name = 'Campaign_Test02')
        };
        insert campaigns;

        List<Opportunity> opportunities = new List<Opportunity>{
                new Opportunity(Name = 'Opp_Test01',
                        StageName = 'Intéressé par',
                        CloseDate = date.today()),
                new Opportunity(Name = 'Opp_Test02',
                        StageName = 'Intéressé par',
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

        List<Task> tasks = new List<Task>{
                new Task(WhoId = contacts[0].Id,
                        WhatId = opportunities[0].Id,
                        Subject = 'Autre'),
                new Task(WhoId = contacts[1].Id, WhatId = opportunities[1].Id, Subject = 'Autre')
        };
        insert tasks;

        List<Session__c> sessions = new List<Session__c>{
 /*	               new Session__c(),
                new Session__c()
*/
            TestDataFactory.getSession(),
            TestDataFactory.getSession()

        };
        insert sessions;

        List<Event> events = new List<Event>{
                new Event(DurationInMinutes = 2,
                        ActivityDateTime = datetime.now(),
                        WhoId = contacts[0].Id,
                        WhatId = opportunities[0].Id,
                        Subject = 'Autre'),
                new Event(DurationInMinutes = 2,
                        ActivityDateTime = datetime.now(),
                        WhoId = contacts[1].Id,
                        WhatId = opportunities[1].Id,
                         Subject = 'Autre')
        };
        insert events;

        List<Contact_associ_s_l_opportunit__c> contactsAssoOpp = new List<Contact_associ_s_l_opportunit__c>{
                new Contact_associ_s_l_opportunit__c(Opportunit__c = opportunities[0].Id,
                        Contact__c = contacts[0].Id),
                new Contact_associ_s_l_opportunit__c(Opportunit__c = opportunities[1].Id,
                        Contact__c = contacts[1].Id)
        };
        insert contactsAssoOpp;

        List<Partenaire_financeur__c> partenaires = new List<Partenaire_financeur__c>{
                new Partenaire_financeur__c(Compte_financeur__c = accounts[0].Id, Opportunite_financee__c = opportunities[0].Id),
                new Partenaire_financeur__c(Compte_financeur__c = accounts[1].Id, Opportunite_financee__c = opportunities[1].Id)
        };
        insert partenaires;

    }

    public static void addObjectsToProcess(DataToExport dataExp, String objName) {
        String query = 'SELECT Id, Tech_External_Id__c FROM ' + objName;
        List<SObject> objects = Database.query(query);
        Set<Id> objIds = new Set<Id>();

        for ( SObject obj : objects ) {
            objIds.add(obj.Id);
        }

        if (objName.equalsIgnoreCase(DataExtract012Contact.OBJECT_NAME_CONTACT)) {
            dataExp.contactsToExport.addAll(objIds);
        } else if (objName.equalsIgnoreCase(DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY)) {
            dataExp.opportunitiesToExport.addAll(objIds);
        } else if (objName.equalsIgnoreCase(DataExtract018Account.OBJECT_NAME_ACCOUNT)) {
            dataExp.accountsToExport.addAll(objIds);
        } else if (objName.equalsIgnoreCase(DataExtract010Etat.OBJECT_NAME_ETAT)) {
            dataExp.etatsToExport.addAll(objIds);
        } else if (objName.equalsIgnoreCase(DataExtract019Lead.OBJECT_NAME_LEAD)) {
            dataExp.leadsToExport.addAll(objIds);
        } else if (objName.equalsIgnoreCase(DataExtract005Product.OBJECT_NAME_PRODUCT)) {
            dataExp.productsToExport.addAll(objIds);
        } else if (objName.equalsIgnoreCase(DataExtract021Session.OBJECT_NAME_SESSION)) {
            dataExp.sessionsToExport.addAll(objIds);
        }

    }

    public static void testCsvFile(String objName) {
        List<ContentVersion> contentVersions = [SELECT ID, Title, FileExtension FROM ContentVersion];

        System.debug('-- TEST : contentVersions.size() : ' + contentVersions.size());


        for ( ContentVersion cv : contentVersions ) {
            System.debug('-- TEST ContentVersion Retrieved : ' + cv);
            if (contentVersions.size() == 1) {
                System.assert(cv.Title.contains(objName));
            }

            System.assertEquals(cv.FileExtension, 'csv');
            if (objName.equalsIgnoreCase(DataExtract018Account.OBJECT_NAME_ACCOUNT)) {
                System.assertEquals(2, contentVersions.size());
            }else {
                System.assertEquals(1, contentVersions.size());
            }
        }

    }

    public static void testSelectedRecords(String objName, DataToExport dataExport) {
        if (objName.equalsIgnoreCase(DataExtract012Contact.OBJECT_NAME_CONTACT)) {
            System.debug('--- TEST CLASS dataExport.contactsToProcess : ' + dataExport.contactsToProcess);
            System.assert(!dataExport.contactsToProcess.isEmpty());

        } else if (objName.equalsIgnoreCase(DataExtract018Account.OBJECT_NAME_ACCOUNT)) {
            System.debug('--- TEST CLASS dataExport.accountsToProcess : ' + dataExport.accountsToProcess);
            System.assert(!dataExport.accountsToProcess.isEmpty());

        } else if (objName.equalsIgnoreCase(DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY)) {
            System.debug('--- TEST CLASS dataExport.opportunitiesToProcess : ' + dataExport.opportunitiesToProcess);
            System.assert(!dataExport.opportunitiesToProcess.isEmpty());
        }
    }

    public static void testIfRecordsToExport(String objName, DataToExport dataExport) {
        if (objName.equalsIgnoreCase(DataExtract005Product.OBJECT_NAME_PRODUCT)) {
            System.debug('--- TEST CLASS dataExport.productsToExport : ' + dataExport.productsToExport);
            System.assert(!dataExport.productsToExport.isEmpty());

        } else if (objName.equalsIgnoreCase(DataExtract010Etat.OBJECT_NAME_ETAT)) {
            System.debug('--- TEST CLASS dataExport.etatsToExport : ' + dataExport.etatsToExport);
            System.assert(!dataExport.etatsToExport.isEmpty());

        } else if (objName.equalsIgnoreCase(DataExtract019Lead.OBJECT_NAME_LEAD)) {
            System.debug('--- TEST CLASS dataExport.leadsToExport : ' + dataExport.leadsToExport);
      //      System.assert(!dataExport.leadsToExport.isEmpty());

        }else if (objName.equalsIgnoreCase(DataExtract021Session.OBJECT_NAME_SESSION)) {
            System.debug('--- TEST CLASS dataExport.sessionsToExport : ' + dataExport.sessionsToExport);
            System.assert(!dataExport.sessionsToExport.isEmpty());

        }else {
            System.debug('--- Conditions non remplies pour exécuter la méthode testIfRecordsToExport.');
        }
    }
}