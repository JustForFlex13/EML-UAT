/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId007Departement implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM D_partement__c WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId007Departement ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<D_partement__c> records){
        System.debug('--- Execute part BatchFillTechId007Departement ---');
        for (D_partement__c departement : records) {
            departement.TECH_External_Id__c = departement.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId007Departement ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId008Lead());
        }
    }

}