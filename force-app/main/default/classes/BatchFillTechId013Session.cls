/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId013Session implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Session__c WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId013Session ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Session__c> records){
        System.debug('--- Execute part BatchFillTechId013Session ---');
        for (Session__c session : records) {
            session.TECH_External_Id__c = session.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId013Session ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId014Pricebook());
        }
    }

}