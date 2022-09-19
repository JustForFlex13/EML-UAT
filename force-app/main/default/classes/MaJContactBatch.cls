/*--------------------------------------------------------------------
-- - Purpose             : Batch to update the contact email
--                         If the contact data has been changed on the day of batch launch, call the MaJContactService apex class to update the contact email
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 28/11/2017  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
global class MaJContactBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Email, Appliquer_l_e_mail_professionnel__c, Appliquer_l_e_mail_EM_Lyon__c, ';
        query += 'Appliquer_l_e_mail_personnel__c, Adresse_Email_Personnelle__c, Email_de_repli__c, Email_EM_Lyon__c ';
        query += 'FROM Contact ';
        query += 'WHERE LastModifiedDate = TODAY';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> contacts){
       MaJContactService.updateContact(contacts);
    }
    
    global void finish(Database.BatchableContext BC){
    }    
}