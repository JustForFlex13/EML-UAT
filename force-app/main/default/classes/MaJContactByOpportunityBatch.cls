/*--------------------------------------------------------------------
-- - Purpose             : Batch to update the owner and the Souhait_programme__c of a contact 
--                         If an opportunity data has been changed on the day of batch launch, call the MaJOpportunityService apex class to update the contact data
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 28/11/2017  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
global class MaJContactByOpportunityBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, OwnerId, IsClosed, FORM_Exercice_en_cours__c, RecordTypeId, Opportunite_active__c, ';
        query += 'Contact_central__c, Contact_central__r.OwnerId, Contact_central__r.Souhait_programme__c ';
        query += 'FROM Opportunity ';
        query += 'WHERE LastModifiedDate = TODAY';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> opps){
       MaJOpportunityService.updateContactByOpportunity(opps);
    }
    
    global void finish(Database.BatchableContext BC){
    }    
}