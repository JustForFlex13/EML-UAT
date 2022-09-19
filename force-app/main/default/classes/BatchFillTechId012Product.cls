/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId012Product implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Product2 WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId012Product ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Product2> records){
        System.debug('--- Execute part BatchFillTechId012Product ---');
        for (Product2 product : records) {
            product.TECH_External_Id__c = product.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId012Product ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId013Session());
        }
    }

}