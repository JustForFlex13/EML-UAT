@isTest 
public class BatchSalutation3681Test 
{
    @testSetup static void setup(){
        Contact ctc = TestDataFactory.getContact();
        ctc.Salutation = 'M.';
        insert ctc;
    }
    
    @isTest static void updateSalutation(){
        Contact ctc = [SELECT Id
                       FROM Contact];
        update ctc;

        Test.startTest();

        BatchSalutation3681 batch = new BatchSalutation3681();                                                                                                  
        Database.executeBatch(batch);

        Test.stopTest();

        Contact ctcFinal = [SELECT Salutation
                            FROM Contact];
                            
        System.assertEquals('M', ctcFinal.Salutation);
    }
}