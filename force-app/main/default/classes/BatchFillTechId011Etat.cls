/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId011Etat implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Etat__c WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId011Etat ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Etat__c> records){
        System.debug('--- Execute part BatchFillTechId011Etat ---');
        for (Etat__c etat : records) {
            etat.TECH_External_Id__c = etat.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId011Etat ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId012Product());
        }
    }

}