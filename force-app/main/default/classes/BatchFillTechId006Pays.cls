/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId006Pays implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Pays__c WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId006Pays ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Pays__c> records){
        System.debug('--- Execute part BatchFillTechId006Pays ---');
        for (Pays__c pays : records) {
            pays.TECH_External_Id__c = pays.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId006Pays ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId007Departement());
        }
    }

}