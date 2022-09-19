/*--------------------------------------------------------------------
-- - Purpose             : CRON to update the owner and the Souhait_programme__c of a contact 
--                         Launch the MaJContactByOpportunityBatch batch
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 28/11/2017  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
global class MaJContactByOpportunityCron implements Schedulable {
    global void execute(SchedulableContext ctx) {        
        
        MaJContactByOpportunityBatch batch = new MaJContactByOpportunityBatch();
        Database.executeBatch(batch,10);        
    }    
}