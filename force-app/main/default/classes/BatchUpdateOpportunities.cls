/*---------------------------------------------------------------------
-- - Purpose           : This batch simulate an update call on Opportunity without changes
--
-- Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 09/02/2018  T.CH  MODIS    1.0      Creation
---------------------------------------------------------------------*/
global class BatchUpdateOpportunities implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id FROM Opportunity');
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        
        Database.update(scope, dml);
    }

   global void finish(Database.BatchableContext BC){
   }
}