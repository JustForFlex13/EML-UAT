/*--------------------------------------------------------------------
-- - Purpose             : This batch clear nbDiplomes fields for each account of org for Mantis 606
--                         The test class is : BatchDiplomesTest
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 12/05/2017  T.CH  MODIS    1.0      Initialisation
--------------------------------------------------------------------*/
global class BatchInitFieldsNbDiplomes implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        // Récupérer tous les comptes
        String query = 'SELECT Id, Nombre_de_contacts_dipl_m_s__c, Nombre_de_contacts_dipl_m_s_groupe__c FROM Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        // Initialiser les champs Nombre_de_contacts_dipl_m_s__c et Nombre_de_contacts_dipl_m_s_groupe__c
        TR005ManageDiplomes.initFields(scope);
	}
    
    global void finish(Database.BatchableContext BC){
        // Initialiser les compteurs de diplômés
        Database.executeBatch(new BatchCalculateNbDiplomes());
    }
}