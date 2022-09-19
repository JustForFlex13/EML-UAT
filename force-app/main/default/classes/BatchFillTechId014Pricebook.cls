/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId014Pricebook implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Pricebook2 WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId014Pricebook ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Pricebook2> records){
        System.debug('--- Execute part BatchFillTechId014Pricebook ---');
        for (Pricebook2 pricebook : records) {
            pricebook.TECH_External_Id__c = pricebook.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId014Pricebook ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId015User());
        }
    }

}