/*------------------------------------------------------------------
-- - Purpose           : Trigger on Account
--            
-- Maintenance History :
--
-- Date         Name  Version  Remarks 
-- -----------  ----  -------  -------------------------------------
-- 07/02/2018   T.CH  1.0 	   Creation
--------------------------------------------------------------------*/
trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete) {
    if(Trigger.isBefore && Trigger.isInsert){
        if(PAD.canTrigger('Utils')){
        	// on crée une liste des départements en dehors de la boucle d'enregistrements
            List<D_partement__c> listDpt = [select id, Code_d_partement__c from D_partement__c];
            List<Account> listAcctNew = new List<Account>();
    
            for(integer i=0;i<Trigger.New.size();i++){
                listAcctNew.add(Trigger.New[i]); 
            }
    
            Utils.setDptAccount(listAcctNew);   
        }

        // Affecter le compte principal des comptes ajoutés
        // Parcourir tous les comptes insérés
        Set<Id> parentIds = new Set<Id>();
        for(account acc : Trigger.New){
            parentIds.add(acc.parentId);
        }
        Map<Id,Account> parentMap = new Map<Id,Account>([SELECT Id, ComptePrincipal__c, Nombre_de_contacts_dipl_m_s_groupe__c FROM Account WHERE Id IN: parentIds]);
        for(account acc : Trigger.New){
            if(acc.ParentId != null){
                // Si le parent a un compte principal
                if(parentMap.get(acc.ParentId).ComptePrincipal__c != null){
                    // Affecter le compte principal du parent 
                    // au compte principal du compte ajouté
                    acc.ComptePrincipal__c = parentMap.get(acc.ParentId).ComptePrincipal__c;
                } else {
                    // Affecter le parent
                    // au compte principal du compte ajouté
                    acc.ComptePrincipal__c = acc.ParentId;
                }
                // On affecte le nombre de diplômés du groupe avec celui de son parent
                acc.Nombre_de_contacts_dipl_m_s_groupe__c = parentMap.get( acc.ParentId ).Nombre_de_contacts_dipl_m_s_groupe__c;
            }
        }
    }// End Before Insert

    if(Trigger.isBefore && Trigger.isUpdate){
        if(PAD.canTrigger('Utils')){
        	// on crée une liste des départements en dehors de la boucle d'enregistrements
            List<D_partement__c> listDpt = [select id, Code_d_partement__c from D_partement__c];
            List<Account> listAcctNew = new List<Account>();
    
            for (integer i=0;i<Trigger.New.size();i++){  
                listAcctNew.add(Trigger.New[i]);   
            }    
            
            Utils.setDptAccount(listAcctNew);
        }            
        
        // Mettre à jour le compte principal des comptes modifiés
        // Récupérer les nouveaux parents des comptes modifiés
        Set<Id> parentIds = new Set<Id>();
        for (account acc : Trigger.New) if(acc.ParentId != Trigger.OldMap.get(acc.Id).ParentId){
            parentIds.add(acc.parentId);
        }        
        
        // Récupérer les comptes parents
        Map<Id,Account> parentMap = new Map<Id,Account>([SELECT Id, ComptePrincipal__c FROM Account WHERE Id IN: parentIds]);
        for (account acc : Trigger.New) {
            if (parentIds.size() >0) {
                // Si le compte a toujours un parent
                if (acc.ParentId != null){            
                    // Si le parent a un compte principal
                    if (parentMap.get(acc.ParentId).ComptePrincipal__c != null) {
                        // Affecter le compte principal du parent 
                        // au compte principal du compte ajouté
                        acc.ComptePrincipal__c = parentMap.get(acc.ParentId).ComptePrincipal__c;
                    } else {
                        // Affecter le parent
                        // au compte principal du compte ajouté
                        acc.ComptePrincipal__c = acc.ParentId;
                    }
                } else {
                    // Le compte devient compte principal (et n'en a donc pas)
                    acc.ComptePrincipal__c = null;
                }
            }	
        }
    }// End Before Update

    if(Trigger.isBefore && Trigger.isDelete){ 
        Set<Id> acctIds = new Set<Id>();
        Set<Id> undeletableIds = New Set<Id>();   
        
        String currentUrl = URL.getCurrentRequestUrl().toExternalForm() ;    
        
        for(Account acc : Trigger.Old){
            acctIds.add(acc.id);
        }
        
        for(Opportunity o : [select AccountId from Opportunity where AccountId  in:acctIds]){
            undeletableIds.add(o.AccountId);
        }
        
        for(Account acc : Trigger.Old){        
            // on vérifie à la fois si le compte en question figure dans la liste des comptes
            // possédants des opportunités et on vérifie également que l'on est pas en mode fusion de compte
            // en vérifiant que l'url appelée ne fait pas référence au module de fusion accmergewizard
            
            if(undeletableIds.contains(acc.Id) && !currentURL.contains('accmergewizard') ){
                acc.Name.addError('<span style="color:red;font-size:14px;"><b>Vous ne pouvez pas supprimer ce compte car il contient des opportunités !</b></span><p>Si vous souhaitez vraiment supprimer ce compte, veuillez d\'abord supprimer toutes les opportunités associées à ce compte.',false);
                return;
            }       
        }
        
        if(PAD.canTrigger('TR005ManageDiplomes')){
            Set<Id> sComptePrincipal = new Set<Id>();        

            // Mettre à jour les comptes principaux des hiérarchies où des comptes supprimés sont présents
            sComptePrincipal = TR005ManageDiplomes.updateHierarchyBeforeDelete(Trigger.OldMap);

            // Recalculer les nombres de diplômés pour tous les comptes concernés
        	TR005ManageDiplomes.updateGroupOfAccounts(sComptePrincipal);
        }
    }// End Before Delete

    if(Trigger.isAfter && Trigger.isUpdate){
        if (PAD.canTrigger('TR009PropagationHierarchie')){
            // Mettre à jour les comptes principaux des hiérarchies concernés par les comptes modifiés
            // Récupérer les comptes où le parent a été modifié
            Map<Id,Account> mpAccountsConcernes = new Map<Id,Account>();
            for (account acc : Trigger.New) if(acc.ParentId != Trigger.OldMap.get(acc.Id).ParentId){
                mpAccountsConcernes.put(acc.Id,acc);
            }
            
            // Mettre à jour les comptes principaux des comptes (et de leurs filiales)
            // On donne l'ancienne map pour retrouver la valeur de l'ancien compte principal
            if (mpAccountsConcernes.size() > 0){
                TR005ManageDiplomes.updateComptePrincipalAfterUpdate(Trigger.OldMap,mpAccountsConcernes);    
            }
        }            
        
        if (PAD.canTrigger('TR005ManageDiplomes')){
            // Calculer le nouveau nombre de diplomés des hiérarchies concernés par les comptes modifiés
            // Récupérer les anciens et nouveaux comptes principaux 
            List<Id> toCalculate = new List<Id>(); 
            for (account acc : Trigger.New){
                // Si le parent a changé
                if (acc.ParentId != Trigger.OldMap.get(acc.Id).ParentId) {
                    // Si le compte modifié est devenu compte principal
                    if (acc.ComptePrincipal__c == null){
                        // Ajouter ce compte principal a être recalculé
                        toCalculate.add(acc.Id);
                    } else {
                        // Ajouter son compte principâl à être recalculé
                        toCalculate.add(acc.ComptePrincipal__c);
                    }
                    
                    // Ajouter l'ancien compte principal à être recalculé
                    toCalculate.add(Trigger.OldMap.get(acc.Id).ComptePrincipal__c);
                }           
            }
            
            // Mettre à jour les anciens et nouveaux comptes principaux
            // pour actualiser les nombre de diplômés des groupes
            if (toCalculate.size() > 0) {
                TR005ManageDiplomes.updateDiplomesOfAccounts(toCalculate); 
            }
        }            
    }// End After Update   
}