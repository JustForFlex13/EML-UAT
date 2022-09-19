/*-------------------------------------------------------------------
-- - Purpose : This class is used to schedule the setDetails StatusSignatures with a batch
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- 05/02/2019  T.CH  MODIS       1.0      Initial version
--------------------------------------------------------------------*/
global class Convsta_SetDetailsSignatairesSchedulable implements Schedulable, Database.Batchable<sObject>, Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Convsta_eSign_ExtId__c, Convsta_eSign_Errors__c,Convsta_Detail_statut_signataire__c FROM Case WHERE (Status = \'Convention en attente de signature\' OR Status = \'Avenant en cours de signature\') and Convsta_Statut_Signature__c !=\'Traité manuellement\' and Convsta_Statut_Signature__c !=\'Expirée\' and Convsta_Statut_Signature__c !=\'Annulé\' and Convsta_Statut_Signature__c !=\'Annulée\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Case> scope){
        List<Case> caseList = new List<Case>();
        for(Case demande :scope){
            caseList.add(Convsta_WS_Helper.setDetailStatusSignataires(demande,false));           
        }
        update caseList;
    }   
    
    global void finish(Database.BatchableContext BC){
    }
    
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new Convsta_SetDetailsSignatairesSchedulable(),1);
    }
}