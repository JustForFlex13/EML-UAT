/*---------------------------------------------------------------------
-- - Purpose             : This batch will init field Deja_eu_premiere_opportunite__c of Contact for Mantis 4300
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 05/03/2018  T.CH  MODIS    1.0      Creation
---------------------------------------------------------------------*/
global class BatchInitDejaEuPremiereOpportunite implements Database.Batchable<sObject>{

    private Id recordTypeEtudiantId = APU_ApexUtils.getContactRecordTypeIdByName('Etudiant');
    private Id recordTypeProspectEtudiantId = APU_ApexUtils.getContactRecordTypeIdByName('Prospect Etudiant');

    private String query = 'SELECT Id, Deja_eu_premiere_opportunite__c ' + 
                           'FROM Contact ' +
                           'WHERE RecordTypeId IN (\''+ recordTypeEtudiantId + '\', \'' + recordTypeProspectEtudiantId + '\') '+
                           'AND Deja_eu_premiere_opportunite__c = true';

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;

        for(Contact ctc :scope){
            ctc.Deja_eu_premiere_opportunite__c = false;
        }
        
        Database.update(scope, dml);
    }

    global void finish(Database.BatchableContext BC){
    }
}