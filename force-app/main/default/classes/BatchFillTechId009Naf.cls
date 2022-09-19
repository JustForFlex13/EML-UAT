/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId009Naf implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM NAF__c WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId009Naf ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<NAF__c> records){
        System.debug('--- Execute part BatchFillTechId009Naf ---');
        for (NAF__c naf : records) {
            naf.TECH_External_Id__c = naf.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId009Naf ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId011Etat());
        }
    }

}