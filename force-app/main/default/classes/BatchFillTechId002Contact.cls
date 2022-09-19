/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId002Contact implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Contact WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId002Contact ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Contact> records){
        System.debug('--- Execute part BatchFillTechId002Contact ---');
        for (Contact contact : records) {
            contact.TECH_External_Id__c = contact.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId002Contact ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId003Opportunity());
        }
    }

}