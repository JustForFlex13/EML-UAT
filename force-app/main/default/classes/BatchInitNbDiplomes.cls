/*--------------------------------------------------------------------
-- - Purpose             : This batch initialize Compte Principal for each account of org for Mantis 606
--                         It's the first to call for a complete initialisation of nbDiplomes
--                         The test class is : BatchDiplomesTest
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 19/01/2017  T.CH  MODIS    1.0      Initialisation
--------------------------------------------------------------------*/
global class BatchInitNbDiplomes implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){        
    	return Database.getQueryLocator([
				SELECT 
				    Id,ParentId,
				    Parent.ParentId, 
				    Parent.Parent.ParentId,
				    Parent.Parent.Parent.ParentId,
				    Parent.Parent.Parent.Parent.ParentId,
				    Parent.Parent.Parent.Parent.Parent.ParentId
				FROM Account
				WHERE ParentId != null
    		]);
    }
	
    global void execute(Database.BatchableContext BC, List<Account> scope){        
        // Parcourir chaque filiale
		for (Account acc:scope){
            // Assigner le compte principal du compte
			acc.ComptePrincipal__c = this.setComptePrincipal(acc);
		}
		update scope;
	}
    
    global void finish(Database.BatchableContext BC){
		// Initialiser à 0 les compteurs de diplômés
        Database.executeBatch(new BatchInitFieldsNbDiplomes());
    }    
    
    private Id setComptePrincipal(Account acc){
        // Si le compte a un parent
    	if(acc.ParentId != null){
            // Si le parent du compte n'a pas de parent
    		if(acc.Parent.ParentId == null){
                // Le parent est le compte principal du compte
    			return acc.ParentId;
    		}else{
                // Sinon on recommence avec le parent du compte
				return this.setComptePrincipal(acc.Parent);
    		}
    	}
    	return null;
    }    
}