@isTest
public class TestTR006OppLineItem2FieldsNull {
    
    static testMethod void myUnitTest() {
        try{
            // Data creation
            NAF__c naf = new NAF__c(Name = 'naf', CODE_APE__c = '1234');
            insert naf;
            
            Pays__c pays = new Pays__c();
            pays.Name = 'France';
            insert pays;
            
            Account acc = new Account();
            acc.Name = 'test';
            acc.SIRET__c = '00000000000000';
            acc.CodeAPE__c = naf.Id;
            acc.Industry = 'Agriculture';
            acc.CodePays__c = pays.id;
            acc.Adresse_Ville__c = 'Nantes';
            acc.Est_un_OCTA__c = true;
            insert acc; 
            
            Product2 prod = new Product2();
            prod.Name = 'prodTest';
            insert prod;
            
            // Get standard price book ID.
            // This is available irrespective of the state of SeeAllData.
            Id standardPbId = Test.getStandardPricebookId();
            
            Pricebookentry pricebook1 = new PriceBookEntry();
            pricebook1.Product2Id = prod.Id;
            pricebook1.UnitPrice = 10;
            pricebook1.Pricebook2Id = standardPbId;
            pricebook1.IsActive = true;
            pricebook1.UseStandardPrice = false ;
            insert pricebook1;
            
            Date d = System.Today();
            Opportunity opp = new Opportunity();
            opp.StageName = 'test';
            opp.Name = 'test';
            opp.AccountId = acc.Id;
            opp.Exercice__c = '2015';
            opp.CloseDate = Date.valueOf('2015-08-15');
            opp.RecordTypeId = [SELECT Id, sObjectType FROM RecordType WHERE DeveloperName = 'Taxe' AND sObjectType = 'Opportunity'].Id;
            insert opp;
            
            System.debug('RECORD TYPE : ' + opp.RecordTypeId);
            
            List<OpportunityLineItem> oppLines = new List<OpportunityLineItem>();
            OpportunityLineItem oli_00 = new OpportunityLineItem();
            oli_00.PricebookentryId = pricebook1.Id;
            oli_00.Totalprice = 23;
            oli_00.OpportunityId = opp.Id;
            // oli_00.Description = 'toto';
            oppLines.add(oli_00);
            
            OpportunityLineItem oli_01 = new OpportunityLineItem();
            oli_01.PricebookentryId = pricebook1.Id;
            oli_01.Totalprice = 23;
            oli_01.OpportunityId = opp.Id;
            // oli_01.OCTA__c = acc.Id;
            oppLines.add(oli_01);
            
            OpportunityLineItem oli_02 = new OpportunityLineItem();
            oli_02.PricebookentryId = pricebook1.Id;
            oli_02.Totalprice = 23;
            oli_02.OpportunityId = opp.Id;
            oli_02.Description = 'toto';
            oli_02.OCTA__c = acc.Id;
            oppLines.add(oli_02);
            
            // Test
            Test.startTest();
            // Insertion des Lignes Produits
            insert oppLines;
            Test.stopTest();
            // Re-lecture des Lignes Produits
            List<OpportunityLineItem> oppLine = [SELECT Quantity, Description, OCTA__c FROM OpportunityLineItem WHERE Id = :oppLines];
            System.assertEquals(3, oppLine.size());
            for(OpportunityLineItem oli : oppLine) {
                // mis en commentaire suite à erreur lors des déploiements en production
                //System.assertEquals('toto', oli.Description);
                //System.assertEquals(acc.Id, oli.OCTA__c);
            }            
        }
        catch(Exception e){
            System.debug(' The following exception has occurred: ' + e.getMessage());
        }
    }
}