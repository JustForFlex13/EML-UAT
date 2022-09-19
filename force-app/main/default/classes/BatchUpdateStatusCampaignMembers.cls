global class BatchUpdateStatusCampaignMembers implements 
Database.Batchable<sObject> {
    
    global final List<Id> listIdToUpdate;
    global final String status;
    List<CampaignMember> listcmToUpdateAllDB = new List<CampaignMember>();
    
    global BatchUpdateStatusCampaignMembers(List<Id> p_listIdToUpdate, String p_status) {
        listIdToUpdate = p_listIdToUpdate;
        status = p_status;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Date_chargement_VF__c, LastModifiedDate, Status FROM CampaignMember WHERE Id IN :listIdToUpdate';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CampaignMember> scope){
        Database.DMLOptions dml = new Database.DMLOptions();
		dml.DuplicateRuleHeader.AllowSave = true; 
        
        for(CampaignMember cm : scope){
            cm.Date_chargement_VF__c =  cm.LastModifiedDate;
            cm.Status = status;
            listcmToUpdateAllDB.add(cm);
        }
        
        Database.update(listcmToUpdateAllDB,dml);
        
    }
    
    global void finish(Database.BatchableContext BC){
        //Envoi de mail inutile car le batch de mise à jour de mail est plus long, donc le finish de ce dernier suffit
    }
}