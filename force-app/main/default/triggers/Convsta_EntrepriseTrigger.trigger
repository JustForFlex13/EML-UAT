trigger Convsta_EntrepriseTrigger on Convsta_Entreprise__c (before update) {
    Convsta_object_helper.handleTrigger(Trigger.new,trigger.isUpdate, trigger.isBefore);
}