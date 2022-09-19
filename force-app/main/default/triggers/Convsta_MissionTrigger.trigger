trigger Convsta_MissionTrigger on convsta_Mission__c (before update) {
    Convsta_object_helper.handleTrigger(Trigger.new,trigger.isUpdate, trigger.isBefore);
}