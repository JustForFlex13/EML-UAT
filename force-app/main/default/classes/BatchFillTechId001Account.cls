/*--------------------------------------------------------------------
-- - Purpose             : Classe servant au remplissage du champ TECH_External_Id__c
--                         Il en est de même pour toutes les classes commençant par  BatchFillTechId
--                         Sa classe de test est : BatchFillTechIdObjectsTest
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 08/03/2017  J.NG  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
global class BatchFillTechId001Account implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Account WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId001Account ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> records){
        System.debug('--- Execute part BatchFillTechId001Account ---');
        for (Account account : records) {
            account.TECH_External_Id__c = account.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId001Account ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId002Contact());
        }
    }
}