trigger Convsta_informations_personnellesTrigger on Convsta_informations_personnelles__c (before update) {
    Convsta_object_helper.handleTrigger(Trigger.new,trigger.isUpdate, trigger.isBefore);
}