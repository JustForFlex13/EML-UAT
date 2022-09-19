/*---------------------------------------------------------------------
-- - Purpose           : Planification of BatchUpdateOpportunities execution for Mantis 4121
--                       Execution : 10/02/2018 at 02:00 (0 0 2 10 2 ? *)
--
-- Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 05/03/2018  T.CH  MODIS    1.0      Creation
---------------------------------------------------------------------*/
global class ScheduleUpdateOpportunities implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
    	BatchUpdateOpportunities b = new BatchUpdateOpportunities();
      	database.executebatch(b);
    }
}