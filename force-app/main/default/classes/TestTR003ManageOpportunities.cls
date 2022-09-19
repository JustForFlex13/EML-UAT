/*-------------------------------------------------------------------
-- - Purpose       : Test class for TR003ManageOpportunities
--
-- Maintenance History:
--
-- Date        Name  Version  Remarks
-- ----------  ----  -------  ---------------------------------------
-- ??????????  ????  1.0
-- 04/01/2018  T.CH  1.1
-- 17/01/2018  A.DO  1.2      Fixe duplicate & corection
-- 19/01/2018  A.DO  1.3      Add tests for AssignOwnerId and setup()
-- 17/01/2020  E.BE  1.4      correct createUser
--------------------------------------------------------------------  */
@isTest()
private class TestTR003ManageOpportunities {

    @isTest static void IncrementCompteurOPPT(){
        // Simuler Top Agresso ou Interface
        PAD.addTriggerBypass('TR006OppLineItem2FieldsNull');
      	PAD.addTriggerBypass('TR007Opp2FieldsNull');
        
        Account acc = TestDataFactory.getAccount();
        insert acc;

        // Met criteria
        Opportunity opp1 = TestObjectFactory.createOpportunity(acc, 'Formation courte', 'Pré inscrit');

        Opportunity opp2 = TestObjectFactory.createOpportunity(acc, 'Formation courte', 'Inscrit');

        Opportunity opp3 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Admis');
        
        Opportunity opp4 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Intégré');
        
        Opportunity opp5 = TestObjectFactory.createOpportunity(acc,  'Programme Long Diplômant', 'Candidat');
    

        // Don't met criteria
        Opportunity opp6 = TestObjectFactory.createOpportunity(acc, 'Formation courte', 'Prospect report');
        // validation rule
        opp6.Exercice_de_report__c = '2022'; 
        Opportunity opp7 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Prospect report');
        // validation rule
        opp7.Exercice_de_report__c = '2022';
        // Met criteria
        Opportunity opp8 = TestObjectFactory.createOpportunity(acc, 'Programme Long Diplômant', 'Candidat');

        // Met criteria (opp line will contains Agresso)
        Opportunity opp9 = TestObjectFactory.createOpportunity(acc, 'Formation intra-entreprise');
        opp9.Code_Agresso_Opportunit__c = 'IEXX-XXXXXX';

        Test.startTest();
        insert new List<Opportunity>{opp1, opp2, opp3, opp4, opp5, opp6, opp7, opp8, opp9};
        update opp9; // Simulate update on existing Agresso : no change
        Test.stopTest();
    
        opp1 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp1.Id];
        opp2 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp2.Id];
        opp3 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp3.Id];
        opp4 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp4.Id];
        opp5 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp5.Id];
        opp6 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp6.Id];
        opp7 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp7.Id];
        opp8 = [SELECT Id, Compteur_OPPT__c FROM Opportunity WHERE Id = :opp8.Id];
        opp9 = [SELECT Id, Code_Agresso_Opportunit__c FROM Opportunity WHERE Id = :opp9.Id];

        // Incrementation
        System.assertEquals(opp1.Compteur_OPPT__c + 1, opp2.Compteur_OPPT__c);
        System.assertEquals(opp2.Compteur_OPPT__c + 1, opp3.Compteur_OPPT__c);
        System.assertEquals(opp3.Compteur_OPPT__c + 1, opp4.Compteur_OPPT__c);
        System.assertEquals(opp4.Compteur_OPPT__c + 1, opp5.Compteur_OPPT__c);

        // No incrementation
        System.assertEquals(null, opp6.Compteur_OPPT__c);
        System.assertEquals(null, opp7.Compteur_OPPT__c);

        // Incrementation
        System.assertEquals(opp5.Compteur_OPPT__c + 1, opp8.Compteur_OPPT__c);

        // No change on Agresso
        System.assertEquals('IEXX-XXXXXX', opp9.Code_Agresso_Opportunit__c);

        // Simuler Top Agresso ou Interface
        PAD.removeTriggerBypass('TR006OppLineItem2FieldsNull');
      	PAD.removeTriggerBypass('TR007Opp2FieldsNull');
    }

    @isTest static void UpdateOppsNumber() {
    	Account acc = TestDataFactory.getAccount();
        insert acc;

        // Détermination de l'exercice actuel
        Date endExerciceDate = Date.newinstance(System.Today().year(), 8, 31);
        Date actualDate = Date.today();
        Integer actualExercice = 0;
        if(actualDate>endExerciceDate){
            actualExercice = actualDate.year() + 1;
        }else{
            actualExercice = actualDate.year();
        }

        Contact contact1= new Contact(AccountId=acc.Id,
                                      statut__c='Etudiant',
                                      FirstName='Contact1',
                                      LastName='Contact1',
                                      Salutation='Mme',
                                      Famille_Fonction__c='Autres',
                                      Nombre_opportunit_s__c = '0',
                                      Nombre_opportunites_sur_criteres__c = '0',
                                      nb_SIP_en_cours__c = 0
                                     );
        insert contact1;

        // Opp pour nb total
        Opportunity opp1= new Opportunity(StageName='Sollicité',
                                       Name='test1',
                                       Contact_central__c=contact1.Id,
                                       AccountId=acc.Id,
                                       Exercice__c='2016',
                                       CloseDate=Date.valueOf('2017-08-31'),
                                       InterfaceExternalId__c = 'InterfaceExternalID1',
                                       Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00'));

        // Opp pour nb En cours
        Opportunity opp2= new Opportunity(StageName='Intéressé par',
                                       Name='test2',
                                       Contact_central__c=contact1.Id,
                                       AccountId=acc.Id,
                                       Exercice__c='2016',
                                       CloseDate=Date.valueOf('2017-08-31'),
                                       InterfaceExternalId__c = 'InterfaceExternalID2',
                                       Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00'));
        
        // Opp pour nb En cours sur l'exercice en cours
        Opportunity opp3= new Opportunity(StageName='Sollicité',
                                       Name='test3',
                                       Contact_central__c=contact1.Id,
                                       AccountId=acc.Id,
                                       Exercice__c=String.valueOf(actualExercice),
                                       CloseDate=Date.valueOf('2017-08-31'),
                                       InterfaceExternalId__c = 'InterfaceExternalID3',
                                       Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00'));

        // Opp pour nb Conseillers
        Opportunity opp4= new Opportunity(StageName='Prospect chaud',
                                       Name='test4',
                                       Contact_central__c=contact1.Id,
                                       AccountId=acc.Id,
                                       Exercice__c='2016',
                                       CloseDate=Date.valueOf('2017-08-31'),
                                       InterfaceExternalId__c = 'InterfaceExternalID4',
                                       Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00'));

        // Opp pour nb Conseillers sur l'exercice en cours
        Opportunity opp5= new Opportunity(StageName='Prospect chaud',
                                       Name='test5',
                                       Contact_central__c=contact1.Id,
                                       AccountId=acc.Id,
                                       Exercice__c=String.valueOf(actualExercice),
                                       CloseDate=Date.valueOf('2017-08-31'),
                                       InterfaceExternalId__c = 'InterfaceExternalID5',
                                       Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00'));

        // opp pour nb En cours et Conseillers sur l'exercice en cours
        Opportunity opp6= new Opportunity(StageName='Intérêt Supplémentaire',
                                       Name='test6',
                                       Contact_central__c=contact1.Id,
                                       AccountId=acc.Id,
                                       Exercice__c=String.valueOf(actualExercice),
                                       CloseDate=Date.valueOf('2017-08-31'),
                                       InterfaceExternalId__c = 'InterfaceExternalID6',
                                       Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00'));
        
        insert new List<Opportunity>{opp1, opp2, opp3, opp4, opp5, opp6};

        Test.startTest();
        TR003ManageOpportunities.UpdateOppsNumber(new Set<Id>{contact1.Id});
        Test.stopTest();

        contact1 = [SELECT Id, Nombre_opportunit_s__c, Nombre_opportunites_sur_criteres__c, nb_SIP_en_cours__c
                    FROM Contact
                    WHERE FirstName =:'Contact1'];

        // Test du nombre total d'opportunité 
        System.assertEquals(6, Integer.valueOf(contact1.Nombre_opportunit_s__c));

        // Test du nombre total d'opportunité 
        System.assertEquals(2, Integer.valueOf(contact1.Nombre_opportunites_sur_criteres__c));

        // Test du nombre total d'opportunité 
        System.assertEquals(2, contact1.nb_SIP_en_cours__c);
    }
    
    /*
    @isTest static void UpdateOppsNumberProfesionnel() {
        Account acc = TestDataFactory.getAccount();
        insert acc;
        
        Contact con = TestObjectFactory.createContact(acc, 'Professionnel');
        con.Nombre_opportunites_sur_criteres__c='0';
        insert con;        
        
        Id recordTypeFormationCourteId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation courte');
        Id recordTypeFormationLongDiplomantId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Programme Long Diplômant');
        
        List<Opportunity> oppList = TestObjectFactory.createOpportunities(acc, 'Formation courte', 20);
        
        for (Opportunity opp: oppList) {
            if (Math.random() > 0.5) {
                opp.RecordTypeId = recordTypeFormationCourteId;
            } else {
                opp.RecordTypeId = recordTypeFormationLongDiplomantId;          
            }
            opp.Contact_central__c = con.Id;
            opp.ExerciceNum_ro__c=''+Date.today().year();
            opp.CloseDate=Date.valueOf('2017-08-31');
            opp.Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00');
            opp.StageName = 'Intéressé par';
        }
        
        List<Opportunity> oppList2 = TestObjectFactory.createOpportunities(acc, 'Formation courte', 20);
        
        for (Opportunity opp: oppList2) {
            if (Math.random() > 0.5) {
                opp.RecordTypeId = recordTypeFormationCourteId;
            } else {
                opp.RecordTypeId = recordTypeFormationLongDiplomantId;          
            }
            opp.Contact_central__c = con.Id;
            opp.Exercice__c='2013';
            opp.ExerciceNum_ro__c='2000';
            opp.CloseDate=Date.valueOf('2017-08-31');
            opp.Date_de_mise__c = DateTime.valueOf('2017-08-31 10:00:00');
            opp.StageName = 'Intéressé par 2';
        }
        
        oppList.addall(oppList2);        
        insert oppList;
        
        Test.startTest();
        try {
            TR003ManageOpportunities.UpdateOppsNumber(new Set<Id>{con.Id});
        } catch (Exception e) {
            System.debug('find Exception');
            System.debug(e);
        }
        Test.stopTest();
        
        Contact conCheck = [SELECT Id, Nombre_opportunites_sur_criteres__c FROM Contact WHERE Id = :con.Id];
        System.assertEquals('20', conCheck.Nombre_opportunites_sur_criteres__c);
    }*/

    @isTest static void CheckOwnerIdChangeAdmin(){
        User usrOld = TestObjectFactory.createUser('OldUser');
        insert usrOld;
        
        User usrNew = TestObjectFactory.createUser('NewUser');
        insert usrNew;
        
        Opportunity opp = TestDataFactory.getOpportunity('Formation initiale');
        opp.OwnerId = usrOld.Id;
        insert opp;
        PAD.removeTriggerHasRun('TR003ManageOpportunities'); // Pour permettre appel dans l'update

        Profile p = [SELECT Id FROM Profile WHERE Name='Administrateur système'];
        User usrRunAs = TestObjectFactory.createUser('UserRun');
        usrRunAs.ProfileId = p.Id;
        insert usrRunAs;

        System.runAs(usrRunAs){
            Test.startTest();
            opp.OwnerId = usrNew.Id;
            update opp;
            Test.stopTest();
        }

        // Nothing to test
    }

    @isTest static void CheckOwnerIdChange(){
        UserRole usrOldRole = [SELECT Id
                                FROM UserRole
                                WHERE DeveloperName = 'EML'];
        UserRole usrNewRole = [SELECT Id
                                FROM UserRole
                                WHERE DeveloperName = 'Direction_Entreprise'];

        User usrOld = TestObjectFactory.createUser('OldUser','EML');
        usrOld.UserRoleId = usrOldRole.Id;
        insert usrOld;        
        User usrNew = TestObjectFactory.createUser('NewUser','EML');
        usrNew.UserRoleId = usrNewRole.Id;
        insert usrNew;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'BDD'];      

        User usrRunAs = TestObjectFactory.createUser('UserRun');
        usrRunAs.ProfileId = p.Id;
        insert usrRunAs;

        System.runAs(usrRunAs){            
            Opportunity opp = TestDataFactory.getOpportunity('Formation courte');
            opp.OwnerId = usrOld.Id;
            insert opp;
            PAD.removeTriggerHasRun('TR003ManageOpportunities'); // Pour permettre appel dans l'update
        
            Test.startTest();
            try{
                opp.OwnerId = usrNew.Id;
                update opp;
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Le propriétaire actuel de l\'opportunité  et le nouveau propriétaire doivent avoir le même rôle !');
                System.AssertEquals(expectedExceptionThrown, true);
            } 
            Test.stopTest();
        }
    }

    @isTest static void CheckUserRoleIdChange(){
        UserRole usrOldRole = [SELECT Id
                               FROM UserRole
                               WHERE DeveloperName = 'EML'];
        UserRole usrNewRole = [SELECT Id
                               FROM UserRole
                               WHERE DeveloperName = 'Direction_Entreprise'];

        User usrOld = TestObjectFactory.createUser('OldUser','EML');
        usrOld.UserRoleId = usrOldRole.Id;
        insert usrOld;        
        User usrNew = TestObjectFactory.createUser('NewUser','EML');
        usrNew.UserRoleId = usrOldRole.Id;
        insert usrNew;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'BDD'];      

        User usrRunAs = TestObjectFactory.createUser('UserRun');
        usrRunAs.ProfileId = p.Id;
        usrRunAs.UserRoleId = usrNewRole.Id;
        insert usrRunAs;

        System.runAs(usrRunAs){            
            Opportunity opp = TestDataFactory.getOpportunity('Formation courte');
            opp.OwnerId = usrOld.Id;
            insert opp;
            PAD.removeTriggerHasRun('TR003ManageOpportunities'); // Pour permettre appel dans l'update
        
            Test.startTest();
            try{
                opp.OwnerId = usrNew.Id;
                update opp;
            }catch(Exception e){
                System.debug('eGetMessage: ' + e.getMessage());
                Boolean expectedExceptionThrown =  e.getMessage().contains('Vous ne pouvez pas réaffecter une opportunité qui n\'est pas dans votre pôle !');
                System.AssertEquals(expectedExceptionThrown, true);
            } 
            Test.stopTest();
        }
    }    

    @isTest static void CreateContactRole(){
        //Data creation
        Test.startTest();

        Product2 prod = new Product2(Name='prodTest', Suiveur__c = UserInfo.getUserId());
        Product2 prod2 = new Product2(Name='prodTest', Suiveur__c = null);
        insert new List<Product2>{prod,prod2};

        Pricebookentry pricebook1= new PriceBookEntry(Product2Id=prod.Id, UnitPrice=10, Pricebook2Id=Test.getStandardPricebookId(), IsActive = true, UseStandardPrice = false);
        Pricebookentry pricebook2= new PriceBookEntry(Product2Id=prod2.Id, UnitPrice=10, Pricebook2Id=Test.getStandardPricebookId(), IsActive = true, UseStandardPrice = false);
        insert new List<Pricebookentry>{pricebook1,pricebook2};

        Account acc = TestDataFactory.getAccount();
        insert acc;

        final Contact contact= new Contact(AccountId=acc.Id,
                                           statut__c='Professionnel',
                                           FirstName='Mahmoud',
                                           LastName='BECHAA',
                                           Salutation='M',
                                           Famille_Fonction__c='Autres');
        try{
          insert contact;
        }catch(DmlException dmle){
          System.debug('The following exception has occurred: ' + dmle.getMessage());
        }
        final Opportunity opp= new Opportunity(StageName='Prospect probable',
                                               Name='test',
                                               Contact_central__c=contact.Id,
                                               AccountId=acc.Id,
                                               Exercice__c='2015',
                                               CloseDate=Date.valueOf('2015-08-15'),
                                               InterfaceExternalId__c = 'blabla',
                                               Date_de_mise__c = DateTime.valueOf('2014-12-01 10:00:00'));


        try{
            insert opp;
        }catch(DmlException dmle){
            System.debug('The following exception has occurred: ' + dmle.getMessage());
        }

        final OpportunityLineItem opLine = new OpportunityLineItem(OpportunityId = opp.Id,
                                                                   InterfaceExternalId__c='blabla',
                                                                   PricebookentryId=pricebook1.Id,
                                                                   Totalprice=10,
                                                                   Quantity = 1);

        try{
            insert opLine;
        }catch(DmlException dmle){
            System.debug('The following exception has occurred: ' + dmle.getMessage());
        }
        final Opportunity opp2 = new Opportunity(StageName='Prospect probable',
                                                 Name='test',
                                                 Contact_central__c=contact.Id,
                                                 AccountId=acc.Id,
                                                 Exercice__c='2015',
                                                 CloseDate=Date.valueOf('2015-08-15'),
                                                 InterfaceExternalId__c = 'blabla2',
                                                 Date_de_mise__c = DateTime.now());


        try{
            insert opp2;
        }catch(DmlException dmle)
        {
            System.debug('The following exception has occurred: ' + dmle.getMessage());
        }


        final OpportunityLineItem opLine2 = new OpportunityLineItem(OpportunityId = opp2.Id,
                                                                    InterfaceExternalId__c='blabla2',
                                                                    PricebookentryId=pricebook1.Id,
                                                                    Totalprice=10,
                                                                    Quantity = 1);

        try{
            insert opLine2;
        }catch(DmlException dmle)
        {
            System.debug('The following exception has occurred: ' + dmle.getMessage());
        }

        Opportunity opp3 = new Opportunity(StageName='Prospect probable',
                                           Name='test',
                                           Contact_central__c=null,// No contact central
                                           AccountId=acc.Id,
                                           Exercice__c='2015',
                                           CloseDate=Date.valueOf('2015-08-15'),
                                           InterfaceExternalId__c = 'blabla3',
                                           Date_de_mise__c = DateTime.now());

        try{
            insert opp3;
        } catch(DmlException dmle)
        {
            System.debug('The following exception has occurred: ' + dmle.getMessage());
        }
        final OpportunityLineItem opLine3 = new OpportunityLineItem(OpportunityId = opp3.Id,
                                                                    InterfaceExternalId__c='blabla3',
                                                                    PricebookentryId=pricebook2.Id,
                                                                    Totalprice=10,
                                                                    Quantity = 1);

        Set<Id> idContacts = new Set<Id>();
        idContacts.add(contact.Id);
        List<Contact> contacts = new List<Contact>();
        contacts.add(contact);
        List<Opportunity> opportunities = New List<Opportunity>();
        OpportunityContactRole role = new OpportunityContactRole();

        opportunities.add(opp);
        opportunities.add(opp2);
        opportunities.add(opp3);
        if(contacts.size() > 0 && opportunities.size() > 0)
        {
            for (Opportunity oppo: opportunities)
            {
                for (Contact cont : contacts)
                {
                    role.ContactId = cont.id;
                    role.IsPrimary = true;
                    role.OpportunityId = oppo.id;
                    role.Role = 'Contact central';
                }
            }
        }
        insert role;

        Test.stopTest();
    }
}