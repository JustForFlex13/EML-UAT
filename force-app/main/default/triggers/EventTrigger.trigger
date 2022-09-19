/*------------------------------------------------------------------
-- - Purpose             : Trigger on Event
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -----------------------------
-- 23/03/2017  J.NG  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
trigger EventTrigger on Event (before insert, after insert) {
    if (PAD.canTrigger('EventTriggerHandler')) {
        new EventTriggerHandler().run();
    }
}