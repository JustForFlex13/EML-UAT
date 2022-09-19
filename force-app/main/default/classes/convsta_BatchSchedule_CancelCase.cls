/*--------------------------------------------------------------------
-- - Purpose            : Ce batch sert à créer les évaluations des demandes concernées.
--                        Il se lance tous les jours de la semaine à 18h : 0 0 18 ? * MON-FRI * 
--
-- - Maintenance History:
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  T.CH  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
global with sharing class convsta_BatchSchedule_CancelCase implements Schedulable, Database.Batchable<sObject>{
    private Integer nbDays;
    global convsta_BatchSchedule_CancelCase(){
        nbDays=Integer.valueOf(Label.Convsta_caseExpiration);
    }
    global convsta_BatchSchedule_CancelCase(Integer nbDaysIn){
        nbDays=nbDaysIn;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date expirationDate = System.today() - nbDays;
        return Database.getQueryLocator([
            SELECT Id
            FROM Case
            WHERE Convsta_Type_de_demande__c = 'Stage'
            AND (Status='Brouillon en cours de saisie'
            OR Status='Demande de complément d’information')
            AND LastModifiedDate < :expirationDate
            ]);
    }
    
    global void execute(Database.BatchableContext info, List<Case> scope){
        for(Case cse:scope){
            cse.Status = 'Brouillon expiré';
        }
        database.update( scope,false);
    }  
    
    global void finish(Database.BatchableContext info){
    }
    
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new convsta_BatchSchedule_CancelCase(),1);
    } 
}