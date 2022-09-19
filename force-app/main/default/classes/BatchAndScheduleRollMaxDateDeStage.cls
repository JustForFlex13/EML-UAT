/*--------------------------------------------------------------------
-- - Purpose       : Ce batch sert à affecter pour chaque compte la derniere date de stage de ses Cases
--                   Il est programmé pour être lancé tous les jours à 04:00
--
-- - Maintenance History:
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  T.CH  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
global class BatchAndScheduleRollMaxDateDeStage implements Schedulable, Database.Batchable<sObject>{ 
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Convsta_roll_max_date_de_stage__c, (SELECT Id, Convsta_DateStart__c ' 
                                                                     +'FROM Cases ' 
                                                                     +'WHERE Type = \'Expérience professionnelle\' '
                                                                     +'AND Status = \'Expérience validée\' '
                                                                     +'ORDER BY Convsta_DateStart__c DESC '
                                                                     +'LIMIT 1) ' 
                      +'FROM Account';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext info, List<Account> scope){
        for(Account acc : scope){
            if(acc.Cases[0] != null){
                acc.Convsta_roll_max_date_de_stage__c = acc.Cases[0].Convsta_DateStart__c;
            }            
        }

        update scope;
    }  

    global void finish(Database.BatchableContext info){
    }

    global void execute(SchedulableContext scon) {
        Database.executeBatch(new BatchAndScheduleRollMaxDateDeStage());
    } 
}