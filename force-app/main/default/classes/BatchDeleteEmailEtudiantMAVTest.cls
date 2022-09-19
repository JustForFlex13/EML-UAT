@isTest 
public class BatchDeleteEmailEtudiantMAVTest
{
    static testMethod void clearEmailRepli() 
    {
        Contact ctc = TestDataFactory.getContact();
        ctc.RecordTypeId = APU_ApexUtils.getContactRecordTypeIdByName('Etudiant');
        ctc.Membre_vie__c = true;
        ctc.Email_de_repli__c = 'test@test.com';
        insert ctc;
        
        Test.startTest();

        BatchDeleteEmailProfessionnelEtudiantMAV batch = new BatchDeleteEmailProfessionnelEtudiantMAV();
        Database.executeBatch(batch); 
            
        Test.stopTest();
        
        ctc = [SELECT Id, Email_de_repli__c FROM Contact];
        
        System.assertEquals(null, ctc.Email_de_repli__c);
    }
}