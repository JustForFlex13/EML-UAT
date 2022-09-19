/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId008Lead implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Lead WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId008Lead ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Lead> records){
        System.debug('--- Execute part BatchFillTechId008Lead ---');
        for (Lead lead : records) {
            lead.TECH_External_Id__c = lead.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId008Lead ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId009Naf());
        }
    }

}