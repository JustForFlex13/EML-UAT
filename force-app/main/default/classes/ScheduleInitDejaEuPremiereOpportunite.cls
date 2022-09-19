/*---------------------------------------------------------------------
-- - Purpose             : This Scheudlable class launch BatchUpdateOpportunities class for Mantis 4300
--						   This class is to schedule the 09/01/2018 02:00 (0 0 2 1 9 ? *)						
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 05/03/2018  T.CH  MODIS    1.0      Creation
---------------------------------------------------------------------*/
global class ScheduleInitDejaEuPremiereOpportunite implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
    	BatchUpdateOpportunities b = new BatchUpdateOpportunities();
      	database.executebatch(b);
    }
}