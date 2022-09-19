/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId003Opportunity implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Opportunity WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId003Opportunity ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> records){
        System.debug('--- Execute part BatchFillTechId003Opportunity ---');
        for (Opportunity opp : records) {
            opp.TECH_External_Id__c = opp.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId003Opportunity ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId004Titre());
        }
    }

}