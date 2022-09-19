/*--------------------------------------------------------------------
-- - Purpose           : Trigger on Task 
--            
-- Maintenance History :
--
-- Date         Name  Company  Version  Remarks 
-- -----------  ----  -------  -------  ------------------------------
-- 24/03/2017   J.NG  MODIS    1.0      Creation
--------------------------------------------------------------------*/
trigger TaskTrigger on Task (before insert, after insert) {
    if (PAD.canTrigger('TaskTriggerHandler')) {
        new TaskTriggerHandler().run();
    }
}