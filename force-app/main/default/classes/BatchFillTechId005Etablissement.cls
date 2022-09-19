/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId005Etablissement implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Etablissement__c WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId005Etablissement ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Etablissement__c> records){
        System.debug('--- Execute part BatchFillTechId005Etablissement ---');
        for (Etablissement__c etablissement : records) {
            etablissement.TECH_External_Id__c = etablissement.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId005Etablissement ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId006Pays());
        }
    }

}