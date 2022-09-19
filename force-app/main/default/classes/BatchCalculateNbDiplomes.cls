/*--------------------------------------------------------------------
-- - Purpose             : This batch execute initialisation of nbDiplomes for each account of org for Mantis 606
--                         The test class is : BatchDiplomesTest
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 18/01/2017  T.CH  MODIS    1.0      Initialisation
--------------------------------------------------------------------*/
global class BatchCalculateNbDiplomes implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        // Récupérer tous les comptes
        String query = 'SELECT Id FROM Account';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){
        // Mettre à jour le nombre de diplômés présents dans chaque compte
        TR005ManageDiplomes.updateDiplomesOfAccounts(new List<Id>(new Map<Id,Account>(scope).keySet()));
	}

    global void finish(Database.BatchableContext BC){
    }
}