/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId015User implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM User WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId015User ---');
        if (Test.isRunningTest()) {
            return Database.getQueryLocator(query + ' LIMIT 200');
        } else {
            return Database.getQueryLocator(query);
        }

    }

    global void execute(Database.BatchableContext bc, List<User> records){
        System.debug('--- Execute part BatchFillTechId015User ---');
        for (User user : records) {
            user.TECH_External_Id__c = user.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId015User ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId016Task(),1);
        }
    }

}