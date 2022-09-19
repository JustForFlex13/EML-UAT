/*-------------------------------------------------------------------
-- - Purpose : This batch set Salutation of contacts who has M. to M
--             It's designed for Mantis 3681
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- 23/11/2017  T.CH  MODIS       1.0      Initial version
--------------------------------------------------------------------*/
global class BatchSalutation3681 implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        // Récupérer tous les comptes
        String query = 'SELECT Id, Salutation FROM contact WHERE Salutation = \'M.\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        Database.DMLOptions dml = new Database.DMLOptions();
		dml.DuplicateRuleHeader.AllowSave = true;
        
        for(Contact ctc :scope){
            ctc.Salutation = 'M';
        }
        
        Database.update(scope, dml);
	}
    
    global void finish(Database.BatchableContext BC){
    }
}