/**
LastModifiedBy Mahmoud BECHAA 23/08/2016
test class creation and assert implementation
comments added
*/
@isTest()
public class AccountTriggerTest{
    
    static testMethod void TestAccountBeforeDelete(){
        
        // test du trigger before delete de l'objet Account
        
        test.startTest();
        //Data creation
        NAF__c naf = new NAF__c();
        naf.CODE_APE__c = 'AAAA';
        naf.Code_NACE__c = 'BBBB';
        naf.Secteur__c = 120;
        insert naf;
        
        Pays__c pays = new Pays__c();
        pays.Name = 'France';
        insert pays;
        
        Account acc1 = new Account(Name='AccTest1');
        acc1.SIRET__c  = '40483304800022';
        acc1.CodeAPE__c = naf.Id;
        acc1.CodePays__c = pays.id;
        acc1.Adresse_Ville__c = 'Nantes';
        insert acc1;
        
        Opportunity o1 = new Opportunity(StageName='Prospect probable',
                                         Name='test',
                                         AccountId=acc1.Id,
                                         Exercice__c='2015',
                                         CloseDate=Date.valueOf('2015-08-15'));
        insert o1;
        
        try {
            // suppression du compte
            delete acc1;
        } catch (Exception e) {
            // on teste que la suppression a bien levé le message d'erreur attendu
            String errorMessage='Vous ne pouvez pas supprimer ce compte car il contient des opportunités !';
            Boolean containsOpportunities = e.getMessage().indexOf(errorMessage)!=-1;
            system.assertEquals(containsOpportunities, true);
        }
        
        
    }
    
}