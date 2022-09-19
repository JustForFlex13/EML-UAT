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
global class convsta_BatchSchedule_CreateEval implements Schedulable, Database.Batchable<sObject>{ 
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date limitDate = date.valueOf(Label.convsta_eval_generationLimit);
        return Database.getQueryLocator([
            SELECT Id, 
            Contact.Id, 
            Contact.Name, 
            Casenumber,
            Convsta_Referent_pedagogique__c, 
            Convsta_DateEnd__c,
            Convsta_Responsable_Pedagogique__c,
            Convsta_Tuteur__c
            FROM Case
            WHERE (Convsta_TypeContrat__c IN (
                'Convention de stage de l ecole',
                'Convention de stage de l\'entreprise') 
                OR (
                Convsta_TypeContrat__c IN ('Contrat de travail de l\'entreprise',
                    'VIE',
                    'Service_civique')
                AND Convsta_DateStart__c > :limitDate)) 
            AND Convsta_DateEnd__c <= NEXT_N_DAYS:28
            AND Convsta_Evaluation__c = null
            AND Convsta_Table_des_Regles_Experience_Pro__R.A_evaluer__c = true
        	AND convsta_ignore_eval__c =false
        	AND status='Convention signée']);
    }
    
    global void execute(Database.BatchableContext info, List<Case> scope){
        system.debug(scope);
        Convsta_Internship.createEval(scope);
    }  
    
    global void finish(Database.BatchableContext info){
    }
    
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new convsta_BatchSchedule_CreateEval(),1);
    } 
}