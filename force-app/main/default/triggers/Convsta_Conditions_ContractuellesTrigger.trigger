trigger Convsta_Conditions_ContractuellesTrigger on Convsta_Conditions_Contractuelles__c (before update) {
    Convsta_object_helper.handleTrigger(Trigger.new,trigger.isUpdate, trigger.isBefore);

    List<Convsta_Conditions_Contractuelles__c> cccs = new List<Convsta_Conditions_Contractuelles__c>();
    for(Convsta_Conditions_Contractuelles__c ccc :Trigger.new){
        if ((ccc.Date_Debut__c != Trigger.oldMap.get(ccc.Id).Date_Debut__c)
        ||(ccc.Date_Fin__c != Trigger.oldMap.get(ccc.Id).Date_Fin__c)) {
          cccs.add(ccc);
        }
    }
    if (cccs.Size() != 0){
    TR010ManageConditionsContractuelles.changeTable(cccs[0]);
    }
}