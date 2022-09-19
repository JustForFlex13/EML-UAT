@isTest
public class BatchUpdateOpportunitiesTest
{
    @testSetup static void setup(){
        List<Opportunity> lOpp = new List<Opportunity>();
        Opportunity opp = new Opportunity();
        
        for(Integer i = 0; i<20; i++){
            opp = TestDataFactory.getOpportunity('Formation initiale');
            lOpp.add(opp);
        }
        
        insert lOpp;
    }
    
    @isTest static void testExecuteBatch(){
        Test.startTest();

        BatchUpdateOpportunities batch = new BatchUpdateOpportunities();
        Database.executeBatch(batch); 
            
        Test.stopTest();
    }
}