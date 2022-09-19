@isTest 
public class BatchInitDejaEuPremiereOpportuniteTest
{
    static testMethod void uncheckDejaeupremiereopportunite() 
    {
        Account acc = TestDataFactory.getAccount();
        List<Contact> lCtc= new List<Contact>();
        for(Integer i=0;i<100;i++)
        {
            Contact ctc = TestObjectFactory.createContact(acc, 'Etudiant');
            ctc.Deja_eu_premiere_opportunite__c = true;
            lCtc.add(ctc);
        }
        for(Integer i=0;i<100;i++)
        {
            Contact ctc = TestObjectFactory.createContact(acc, 'Prospect Etudiant');
            ctc.Deja_eu_premiere_opportunite__c = true;
            lCtc.add(ctc);
        }
        
        insert lCtc;
        
        Test.startTest();

        BatchInitDejaEuPremiereOpportunite batch = new BatchInitDejaEuPremiereOpportunite();
        Database.executeBatch(batch); 
            
        Test.stopTest();

        lCtc = [SELECT Id, Deja_eu_premiere_opportunite__c
                FROM Contact
                WHERE RecordType.Name = 'Etudiant'
                AND RecordType.Name = 'Prospect Etudiant'];

        for(Contact ctc :lCtc)
        {
            System.assertEquals(false, ctc.Deja_eu_premiere_opportunite__c);
        }
    }
}