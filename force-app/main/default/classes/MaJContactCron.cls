/*--------------------------------------------------------------------
-- - Purpose             : CRON to update the contact email
--                         Launch the MaJContactBatch batch
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 28/11/2017  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
global class MaJContactCron implements Schedulable {
    global void execute(SchedulableContext ctx) {        
        
        MaJContactBatch batch = new MaJContactBatch();
        Database.executeBatch(batch,10);        
    }    
}