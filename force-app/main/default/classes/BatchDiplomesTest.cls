@isTest
public class BatchDiplomesTest
{
    @testSetup static void setup(){
        Pays__c pays = new Pays__c();
        pays.Name = 'France';
        insert pays;
        
        // Créer et insérer un premier niveau de hiérarchie (COMPTE ULTIME)
        Account acc1_1 = new Account(Name='AccountTest1_1', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, SIRET__c='00000000000901');
        Account acc1_2 = new Account(Name='AccountTest1_2', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, SIRET__c='00000000000208');
        insert new List<Account>{acc1_1,acc1_2};
            
        // Créer et insérer un deuxième niveau de hiérarchie
        Account acc2_1 = new Account(Name='AccountTest2_1', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc1_1.Id, SIRET__c='00000000000802');
        Account acc3_1 = new Account(Name='AccountTest3_1', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc1_1.Id, SIRET__c='00000000000703');
        Account acc2_2 = new Account(Name='AccountTest2_2', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc1_2.Id, SIRET__c='00000000000109');
        Account acc3_2 = new Account(Name='AccountTest3_2', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc1_2.Id, SIRET__c='09010000000000');
        insert new List<Account>{acc2_1,acc3_1,acc2_2,acc3_2};
        
        // Créer et insérer un troisième niveau de hiérarchie
        Account acc4_1 = new Account(Name='AccountTest4_1', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc2_1.Id, SIRET__c='00000000000604');
        Account acc5_1 = new Account(Name='AccountTest5_1', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc2_1.Id, SIRET__c='00000000000505');
        Account acc6_1 = new Account(Name='AccountTest6_1', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc3_1.Id, SIRET__c='00000000000406');
        Account acc7_1 = new Account(Name='AccountTest7_1', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc3_1.Id, SIRET__c='00000000000307');
        Account acc4_2 = new Account(Name='AccountTest4_2', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc2_2.Id, SIRET__c='08020000000000');
        Account acc5_2 = new Account(Name='AccountTest5_2', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc2_2.Id, SIRET__c='07030000000000');
        Account acc6_2 = new Account(Name='AccountTest6_2', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc3_2.Id, SIRET__c='06040000000000');
        Account acc7_2 = new Account(Name='AccountTest7_2', Industry='Agriculture', Adresse_Ville__c = 'Marseille', 
                                     CodePays__c=pays.Id, ParentId = acc3_2.Id, SIRET__c='05050000000000');        
        insert new List<Account>{acc4_1,acc5_1,acc6_1,acc7_1,acc4_2,acc5_2,acc6_2,acc7_2};   
    }
    
    @isTest static void initNbDiplomes(){
        Test.startTest();

        BatchInitNbDiplomes batch = new BatchInitNbDiplomes();
        Database.executeBatch(batch); 
            
        Test.stopTest();
    }
}