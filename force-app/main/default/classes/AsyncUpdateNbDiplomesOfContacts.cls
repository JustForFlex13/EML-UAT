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
public class AsyncUpdateNbDiplomesOfContacts implements Queueable {
    private List<Contact> lCtc;

    public AsyncUpdateNbDiplomesOfContacts(List<Contact> lCtcParam){
        this.lCtc = lCtcParam;
    }

    public void execute(QueueableContext context) {
        Set<Id> sAcctIds = new Set<Id>(); // Set contenant les Ids des comptes concernés par la modification
        
        // Récupérer les Ids des comptes concernés par le changement dans un set pour l'unicité
        for(Contact ctc : lCtc){
            if(ctc.AccountId != null){
                sAcctIds.add(ctc.AccountId); 
            }    
        }
        
        // Mettre à jour le nombre de diplomés de chaque compte
        TR005ManageDiplomes.updateAccounts(sAcctIds);
        
        // Mettre à jour le nombre de diplômés du groupe de chaque compte
        TR005ManageDiplomes.updateGroupOfAccounts(sAcctIds);   
    }    
}