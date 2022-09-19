/**
 * Created by Julie NGUYEN - Modis on 21/03/2017.
 * Classe servant au remplissage des champs TECH_External_What_Id__c et TECH_External_Who_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId016Task implements Database.Batchable<sObject> {
    String query = 'SELECT WhoId, WhatId ' +
            'FROM Task ' +
            'WHERE (Tech_External_Who_Id__c = null AND Tech_External_What_Id__c = null) ' +
            'AND (WhoId != null OR WhatId != null)';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId016Task ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Task> records){
        System.debug('--- Execute part BatchFillTechId016Task ---');
        for (Task task : records) {
            System.debug('---PARAM task : ' + task);
            // Remplissage du champ TECH_External_What_Id__c
            if (task.WhatId != null) {
                System.debug('---PARAM task.WhatId : ' + task.WhatId);
                task.TECH_External_What_Id__c = task.WhatId;
            }

            // Remplissage du champ TECH_External_Who_Id__c
            if (task.WhoId != null) {
                System.debug('---PARAM task.WhoId : ' + task.WhoId);
                task.TECH_External_Who_Id__c = task.WhoId;
            }
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId016Task ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId017Event(),1);
        }
    }

}