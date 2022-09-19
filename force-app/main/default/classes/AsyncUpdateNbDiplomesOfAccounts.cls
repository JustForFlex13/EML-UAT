/*--------------------------------------------------------------------
-- - Purpose             : Queueable Job for UpdateAccounts to NbDiplome
--                         This method was in TR005ManageDiplomes and is called after insert and update on Contact
--                         TEST CLASS : TestTR005ManageDiplomes 
--
-- - Maintenance History :
--
-- Date         Name  Company  Version  Remarks
-- -----------  ----  -------  -------  ------------------------------
-- 18/01/2018   T.CH  MODIS    1.0      Creation
--------------------------------------------------------------------*/
public class AsyncUpdateNbDiplomesOfAccounts implements Queueable {
    private List<Id> lAccIds;

    public AsyncUpdateNbDiplomesOfAccounts(List<Id> lAccIdsParam){
        this.lAccIds = lAccIdsParam;
    }

    public void execute(QueueableContext context) {
        // Mettre à jour le nombre de diplomés de chaque compte
        TR005ManageDiplomes.updateAccounts(new Set<Id>(lAccIds));
        
        // Mettre à jour le nombre de diplômés du groupe de chaque compte
        TR005ManageDiplomes.updateGroupOfAccounts(new Set<Id>(lAccIds));   
    }    
}