/*--------------------------------------------------------------------
-- - Purpose             : Trigger on Diplome
--            
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  -------------------------------
-- 06/12/2017  A.DO  MODIS    1.0      Creation
--------------------------------------------------------------------*/
trigger DiplomeTrigger on Dipl_me__c (before insert, after insert, before update, after update, before delete) {
    if (PAD.canTrigger('TH_DiplomeTriggerHandler')) {
        new TH_DiplomeTriggerHandler().run();
    }
}