/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_SIS_Evaluation_methodsTrigger on SIS_Evaluation_methods__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(SIS_Evaluation_methods__c.SObjectType);
}