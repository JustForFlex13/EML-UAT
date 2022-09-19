/**
LastModifiedBy Sabri Dali 16/03/2016
test class correction and assert implementation
cooments added
*/
@isTest
private class TestTR002ManageOpportunityLineItem {

    @isTest static void myUnitTest() {

       //Data creation
       NAF__c naf = new NAF__c(Name='naf',CODE_APE__c='1234');
       insert naf;

       Pays__c pays = new Pays__c();
       pays.Name = 'France';
       insert pays;

       Account acc = new Account(Name='test');
       acc.SIRET__c='00000000000000';
       acc.CodeAPE__c=naf.Id;
       acc.Industry='Agriculture';
       acc.CodePays__c = pays.id;
       acc.Adresse_Ville__c = 'Nantes';
       insert acc;

       Contact contact= new Contact(AccountId=acc.Id,statut__c='Etudiant',FirstName='Asmae',LastName='Ettahiri',Salutation='Mme');
       insert contact;

       Product2 prod = new Product2(Name='prodTest');
       insert prod;

       // Get standard price book ID.
       // This is available irrespective of the state of SeeAllData.
       Id standardPbId = Test.getStandardPricebookId();

       Pricebookentry pricebook1= new PriceBookEntry(Product2Id=prod.Id, UnitPrice=10, Pricebook2Id=standardPbId, IsActive = true, UseStandardPrice = false);
       insert pricebook1;

       Date d = System.Today();
       Opportunity opp= new Opportunity(StageName='test',Name='test',Contact_central__c=contact.Id,AccountId=acc.Id,Exercice__c='2015',CloseDate=Date.valueOf('2015-08-15'));
       opp.CloseDate=Date.valueOf('2015-08-15');
       System.debug('#####CloseDate'+opp.CloseDate);
       insert opp;


       OpportunityLineItem oli = new OpportunityLineItem(PricebookentryId=pricebook1.Id, Totalprice=23, Quantity=2);
       oli.OpportunityId=opp.Id;

       //Test
       Test.startTest();
       insert oli;
       List<OpportunityLineItem> oppLine = [SELECT id,Name FROM OpportunityLineItem where OpportunityId=:opp.Id];
       System.assertEquals(oppLine.size(),1);
       Test.stopTest();
    }
    
    @isTest static void IncrementCompteurOppLine(){
        // Simuler Top Agresso ou Interface
        PAD.addTriggerBypass('TR006OppLineItem2FieldsNull');
      	PAD.addTriggerBypass('TR007Opp2FieldsNull');

        Account acc = TestDataFactory.getAccount();
        insert acc;
        
        List<Opportunity> oppList = new List<Opportunity>();
        // Met criteria
        Opportunity opp1 = TestObjectFactory.createOpportunity(acc, 'Formation courte', 'Pré inscrit');
        oppList.add(opp1);

        Opportunity opp2 = TestObjectFactory.createOpportunity(acc, 'Formation courte', 'Inscrit');
        oppList.add(opp2);

        Opportunity opp3 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Admis');
        oppList.add(opp3);

        Opportunity opp4 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Intégré');
        oppList.add(opp4);

        Opportunity opp5 = TestObjectFactory.createOpportunity(acc,  'Programme Long Diplômant', 'Candidat');
        oppList.add(opp5);

        // Don't met criteria
        Opportunity opp6 = TestObjectFactory.createOpportunity(acc, 'Formation courte', 'Prospect report');
        // validation rule
        opp6.Exercice_de_report__c = '2023'; 
        oppList.add(opp6);

        Opportunity opp7 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Prospect report');
        opp7.Exercice_de_report__c = '2023'; 
        oppList.add(opp7);

        // Met criteria
        Opportunity opp8 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Candidat');
        oppList.add(opp8);

        // Met criteria (opp line will contains Agresso)
        Opportunity opp9 = TestObjectFactory.createOpportunity(acc, 'Formation intra-entreprise');
        oppList.add(opp9);

        insert oppList;

        Product2 prod2 = TestObjectFactory.createProduct2();
        insert prod2;
        Pricebookentry pricebookentry= TestObjectFactory.createPricebookEntryStandard(prod2.Id);
        insert pricebookentry;

        List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
        for (Opportunity opp: oppList) { 
            oppLineList.add(TestObjectFactory.createOpportunityLineItem(opp.Id, prod2.Id, pricebookentry.Id));
        }

        // Set Agresso to see no change
        oppLineList[8].CodeAgresso_Poste_Opportunite__c = 'IEXX-XXXXXX';

        Test.startTest();
        insert oppLineList;
        update oppLineList[8]; // Simulate update on existing Agresso : no change
        Test.stopTest();

        oppLineList[0] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp1.Id];
        oppLineList[1] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp2.Id];
        oppLineList[2] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp3.Id];
        oppLineList[3] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp4.Id];
        oppLineList[4] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp5.Id];
        oppLineList[5] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp6.Id];
        oppLineList[6] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp7.Id];
        oppLineList[7] = [SELECT Id, Code_OLI__c FROM OpportunityLineItem WHERE OpportunityId = :opp8.Id];
        oppLineList[8] = [SELECT Id, CodeAgresso_Poste_Opportunite__c FROM OpportunityLineItem WHERE OpportunityId = :opp9.Id];

        // Incrementation
        System.assertEquals(oppLineList[0].Code_OLI__c + 1, oppLineList[1].Code_OLI__c);
        System.assertEquals(oppLineList[1].Code_OLI__c + 1, oppLineList[2].Code_OLI__c);
        System.assertEquals(oppLineList[2].Code_OLI__c + 1, oppLineList[3].Code_OLI__c);
        System.assertEquals(oppLineList[3].Code_OLI__c + 1, oppLineList[4].Code_OLI__c);

        // No incrementation
        System.assertEquals(null, oppLineList[5].Code_OLI__c);
        System.assertEquals(null, oppLineList[6].Code_OLI__c);
        
        // Incrementation
        System.assertEquals(oppLineList[4].Code_OLI__c + 1, oppLineList[7].Code_OLI__c);

        // No change on Agresso
        System.assertEquals('IEXX-XXXXXX', oppLineList[8].CodeAgresso_Poste_Opportunite__c);
        
        // Simuler Top Agresso ou Interface
        PAD.removeTriggerBypass('TR006OppLineItem2FieldsNull');
      	PAD.removeTriggerBypass('TR007Opp2FieldsNull');
    }

    @isTest static void attachSession() {
        // get Product RecordTypes 
        Id recordTypePackId = APU_ApexUtils.getProduct2RecordTypeIdByName('Pack');
        Id recordTypeModuleId = APU_ApexUtils.getProduct2RecordTypeIdByName('Module');
        
        //date creation
        NAF__c naf = new NAF__c(Name='naf',CODE_APE__c='1234');
        insert naf;
        
        Pays__c pays = new Pays__c();
        pays.Name = 'France';
        insert pays;
        
        Account acc = new Account(Name='test');
        acc.SIRET__c='00000000000000';
        acc.CodeAPE__c=naf.Id;
        acc.Industry='Agriculture';
        acc.CodePays__c = pays.id;
        acc.Adresse_Ville__c = 'Nantes';
        insert acc;
        
        Contact contact= new Contact(AccountId=acc.Id,statut__c='Etudiant',FirstName='Asmae',LastName='Ettahiri',Salutation='Mme');
        insert contact;
        
        Product2 prod = new Product2(Name='prodTest', RecordTypeId = recordTypeModuleId);
        insert prod;
        Product2 prod_module = new Product2(Name='prodTest', RecordTypeId = recordTypeModuleId);
        insert prod_module;
        
        Detail_pack__c dp= new Detail_pack__c(Pack__c=prod.Id,Composant__c=prod_module.Id);
        insert dp;
        
        Session__c ses_pack = new Session__c (Name = 'pack', Produits__c = prod.Id, 
                                              Code_agresso_for__c = '54983',
                                              Code_Agresso_Session_formation__c = 'codeAgr1',
                                              Date_de_debut_de_session__c = System.today() + 5,
            Date_de_fin_de_session__c = System.today() + 15,
            Exercice_fiscale__c = 'SF-EF10',
            Lieu_ls__c = 'SF-LS10',
            Mode_apprentissage__c = 'SF-MA10');
        insert ses_pack;
        
        Session__c ses_module = new Session__c (Name = 'module', Produits__c = prod_module.Id,  
                                                Code_agresso_for__c = '98456', 
                                                Code_Agresso_Session_formation__c = 'codeAgr2',
                                                Date_de_debut_de_session__c = System.today() + 5,
            Date_de_fin_de_session__c = System.today() + 15,
            Exercice_fiscale__c = 'SF-EF10',
            Lieu_ls__c = 'SF-LS10',
            Mode_apprentissage__c = 'SF-MA10');
        insert ses_module;
        
        Detail_pack_session__c dps = new Detail_pack_session__c(Composant_session__c=ses_module.Id,Pack_Session__c=ses_pack.id);
        insert dps;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id standardPB = Test.getStandardPricebookId();
        
        Pricebookentry pricebook1= new PriceBookEntry(Product2Id=prod.Id, UnitPrice=10, Pricebook2Id=standardPB, IsActive = true, UseStandardPrice = false);
        insert pricebook1;
        
        Pricebookentry pricebook2= new PriceBookEntry(Product2Id=prod_module.Id, UnitPrice=10, Pricebook2Id=standardPB, IsActive = true, UseStandardPrice = false);
        insert pricebook2;
        
        Date d = System.Today();
        Opportunity opp= new Opportunity(Pricebook2Id=standardPB,StageName='test',Name='test',Contact_central__c=contact.Id,AccountId=acc.Id,Exercice__c='2015',CloseDate=Date.valueOf('2015-08-15'));
        opp.CloseDate=Date.valueOf('2015-08-15');
        insert opp;        
        
        OpportunityLineItem oliModule = new OpportunityLineItem(PricebookentryId=pricebook2.Id, Totalprice=23, Quantity=2, Session_de_formation__c = ses_pack.Id, OpportunityId=opp.Id, Type_produit__c = 'Module');
        insert oliModule;
        PAD.removeTriggerHasRun('TR002ManageOpportunityLineItem');

        OpportunityLineItem oliPack = new OpportunityLineItem(PricebookentryId=pricebook1.Id, Totalprice=23, Quantity=2, Session_de_formation__c = ses_pack.Id, OpportunityId=opp.Id, Type_produit__c = 'Pack');
        
        // Test
        Test.startTest();
        insert oliPack;
        //Tester l'update
        
        List<OpportunityLineItem> lcontrolOppLI = [select id,Session_de_formation__c from OpportunityLineItem where OpportunityId =: opp.Id and Session_de_formation__c =:ses_module.id];
        System.assert(lcontrolOppLI!=null);
        
        Test.stopTest();
    }

    @isTest static void createOppLineItem(){
        //Get Product RecordType
        Id recordTypePackId = APU_ApexUtils.getProduct2RecordTypeIdByName('Pack');
        Id recordTypeModuleId = APU_ApexUtils.getProduct2RecordTypeIdByName('Module');

        Account acc = TestDataFactory.getAccount();
        insert acc;

        Contact contact= TestDataFactory.getContact();
        insert contact;

        Product2 prodPack = new Product2(Name='Produit Pack',Suiveur__c = UserInfo.getUserId(),RecordTypeId =recordTypePackId);
        insert prodPack;

        Product2 prodModule = new Product2(Name='Produit Module',RecordTypeId = recordTypeModuleId);
        insert prodModule;

        Detail_pack__c dp= new Detail_pack__c(Pack__c=prodPack.Id,Composant__c=prodModule.Id);
        insert dp;      

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id standardPB = Test.getStandardPricebookId();

        Pricebookentry pricebookPack= new PriceBookEntry(Product2Id=prodPack.Id, UnitPrice=10, Pricebook2Id=standardPB, IsActive = true, UseStandardPrice = false);
        insert pricebookPack;

        Pricebookentry pricebookModule= new PriceBookEntry(Product2Id=prodModule.Id, UnitPrice=10, Pricebook2Id=standardPB, IsActive = true, UseStandardPrice = false);
        insert pricebookModule;

        Date d = System.Today();
        Opportunity opp= new Opportunity(Pricebook2Id=standardPB ,StageName='test',Name='test',Contact_central__c=contact.Id,AccountId=acc.Id);
        opp.CloseDate=Date.today().addDays(1);
        insert opp;
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookentryId=pricebookPack.Id, Totalprice=23, Quantity=2,Product2Id =prodPack.Id);     
        
        //Test
        Test.startTest();   
        insert oli; 
        List<OpportunityLineItem> controlOppLI = [select id from OpportunityLineItem where OpportunityId =: opp.Id];
        System.assertEquals(2, controlOppLI.size());
        Test.stopTest();   
    }
}