/*---------------------------------------------------------------------
-- - Purpose           : Trigger on Opportunity 
--            
-- Maintenance History :
--
-- Date         Name  Company  Version  Remarks 
-- -----------  ----  -------  -------  --------------------------------
-- 19/01/2018   T.CH  MODIS    1.0      Creation
-- 29/01/2018   A.DO  MODIS    1.1      Move checkIncrementCompteurOPPT Before Update -> After Update
-- 12/03/2018   T.CH  MODIS    1.2      Check change on ownerId to Interface (Mantis 4793)
-- 29/03/2018   T.CH  MODIS    1.3      Check change on StageName and Account.Name (Mantis 5086)
--------------------------------------------------------------------  */
trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete) {
    if (Trigger.isBefore && Trigger.isInsert){
        if (PAD.canTrigger('TR007Opp2FieldsNull')) {
            TR007Opp2FieldsNull.initOpportunity(Trigger.new);
        }
        TR003ManageOpportunities.checkIncrementCompteurOPPT(Trigger.New, false);
    
    } // End BeforeInsert
    
    if (Trigger.isAfter && Trigger.isInsert) {
        Set<Id> sContactCentralIds = new Set<Id>();
        List<Opportunity> oppToUpdateContacts = new List<Opportunity>();  
        List<Opportunity> oppToUpdateContactsRole = new List<Opportunity>();
        Id RecordTypeFundraisingB2CId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Fundraising B2C');
        
        for (Opportunity o: trigger.new){
            // Récupérer les opportunités avec un contact central
            if (o.Contact_central__c != null){
                sContactCentralIds.add(o.Contact_central__c);
                oppToUpdateContactsRole.add(o);
            }
            
            // Récupérer les opportunités B2C conclues sans contact
            if (    o.recordTypeID == RecordTypeFundraisingB2CId
                &&  o.stageName == 'Conclu'
                &&  o.Contact_central__c != null) {                    
                    oppToUpdateContacts.add(o);
                }
        }
        
        if (!sContactCentralIds.isEmpty())
        {
            if(PAD.canTrigger('TR003ManageOpportunities')){
                TR003ManageOpportunities.UpdateOppsNumber(sContactCentralIds);
                TR003ManageOpportunities.AutomaticConvertLeads(Trigger.NewMap);
            }
            
        }
        
        if (!oppToUpdateContacts.isEmpty() && PAD.canTrigger('AsyncUpdateContact')){
            AsyncUpdateContact AsyncUpdateContactJob = new AsyncUpdateContact(oppToUpdateContacts);
            ID jobAsyncUpdateContactID = System.enqueueJob(AsyncUpdateContactJob);
        }
    }// End AfterInsert
    
    if (Trigger.isBefore && Trigger.isUpdate){
        User usr_Interface = [SELECT Id, Name FROM User where Name = 'Interface'];
        // Si Interface écrase des valeurs, les réaffecter
        // for(Opportunity opp :Trigger.new){
        //     if(opp.OwnerId == usr_Interface.Id){
        //         if(opp.OwnerId != Trigger.oldMap.get(opp.Id).OwnerId){
        //         	opp.OwnerId = Trigger.oldMap.get(opp.Id).OwnerId;       
        //         }
        //         if(opp.Account.Name != Trigger.oldMap.get(opp.Id).Account.Name){
        //         	opp.Account.Name = Trigger.oldMap.get(opp.Id).Account.Name;       
        //         }
        //         if(opp.StageName != Trigger.oldMap.get(opp.Id).StageName){
        //         	opp.StageName = Trigger.oldMap.get(opp.Id).StageName;       
        //         }
        //     }
        // }        
        
        List<Opportunity> lOpp = new List<Opportunity>();
        String oldOwnerId;
        
        // cette partie de trigger n'est utilisé que lorsque l'on est en mode saisie manuelle
        // elle ne s'exécute pas pour les traitements en rafale exécutés sur un tableau
        // d'enregistrements
        if (Trigger.new.size() == 1){
            for(Opportunity o: Trigger.New){
                
                oldOwnerId = Trigger.oldMap.get(o.ID).ownerId;
                
                if (o.OwnerId != Trigger.oldMap.get(o.ID).ownerId){
                    lOpp.add(o);                
                }
                
                // Si l'user est Top Agresso ET que le nouveau statut commercial est Clos (Perdu) ET que la case "A désactivé son intérêt" est coché
                if(UserInfo.getName() == 'Top AGRESSO' && o.StageName == 'Clos (Perdu)' && o.A_d_sactiv_son_int_r_t__c == true)
                {
                    // Renseigner le motif de fermeture
                    o.Motif_de_fermeture__c = 'Abandon';
                }
            }        
        }
        
        if (PAD.canTrigger('TR003ManageOpportunities')) {            
            // Mettre à jour le compteur du code agresso des opportunités
            TR003ManageOpportunities.checkIncrementCompteurOPPT(Trigger.New, false);
            PAD.removeTriggerHasRun('TR003ManageOpportunities'); // Pour permettre MàJ des oppline en OpportunityAfterUpdate
            
            if (lOpp.size() == 1){
                TR003ManageOpportunities.checkOwnerIdChange(lOpp, oldOwnerId);
            }
        }
    }// End BeforeUpdate
    
    if (Trigger.isAfter && Trigger.isUpdate){
        Id RecordTypeFundraisingB2CId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Fundraising B2C');
        Set<Id> sContactCentralIds = new Set<Id>();
        List<Opportunity> oppToUpdateContacts = new List<Opportunity>();
        
        for (Opportunity o: Trigger.new) {
            // On vérifie si l'opportunité en cours de modification ne possède pas de rôle contact central   
            if (o.Contact_central__c != null) {                
                // Si elle n'en possède pas on l'ajoute au tableau afin de MàJ les nbOpp du contact
                sContactCentralIds.add(o.Contact_central__c);
            }
            
            if (   (o.recordTypeID == RecordTypeFundraisingB2CId)
                || (Trigger.oldMap.get(o.Id).recordTypeID == RecordTypeFundraisingB2CId) 
                && (o.stageName== 'Conclu' || trigger.oldMap.get(o.Id).stageName=='Conclu'))
            {
                oppToUpdateContacts.add(o);                
            }
        }
        
        if(PAD.canTrigger('TR003ManageOpportunities')){
            if(!sContactCentralIds.isEmpty()) {
                TR003ManageOpportunities.UpdateOppsNumber(sContactCentralIds);
            }
        }
        
        if (!oppToUpdateContacts.isEmpty() && PAD.canTrigger('AsyncUpdateContact')){
            AsyncUpdateContact AsyncUpdateContactJob = new AsyncUpdateContact(oppToUpdateContacts);
            ID jobAsyncUpdateContactID = System.enqueueJob(AsyncUpdateContactJob);
        }
        List<Opportunity> opps = [SELECT Id, Name, OwnerId, IsClosed, FORM_Exercice_en_cours__c, RecordTypeId, Opportunite_active__c, 
        Contact_central__c, Contact_central__r.OwnerId, Contact_central__r.Souhait_programme__c 
        FROM Opportunity 
        WHERE Id IN :Trigger.New ];
        MaJOpportunityService.updateContactByOpportunity(opps);
    }// End AfterUpdate
    
    if(Trigger.isAfter && Trigger.isDelete)
    {
        if(PAD.canTrigger('TR003ManageOpportunities')){
            Set<Id> sContactCentralIds = new Set<Id>();
            
            for(Opportunity o: Trigger.old){            
                if (o.Contact_central__c != null){
                    sContactCentralIds.add(o.Contact_central__c );
                }
            }
            
            if(!sContactCentralIds.isEmpty()){   
                TR003ManageOpportunities.UpdateOppsNumber(sContactCentralIds);
            }
        }        
    }// End AfterDelete
}