/**
 * Created by Julie NGUYEN - Modis on 08/03/2017.
 * Classe servant au remplissage du champ TECH_External_Id__c
 * Sa classe de test est : TestBatchFillTechIdObjects
 */

global class BatchFillTechId004Titre implements Database.Batchable<sObject> {
    String query = 'SELECT Id FROM Titre__c WHERE Tech_External_Id__c = null';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId004Titre ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Titre__c> records){
        System.debug('--- Execute part BatchFillTechId004Titre ---');
        for (Titre__c titre : records) {
            titre.TECH_External_Id__c = titre.Id;
        }
        Database.update(records, false);
    }

    global void finish(Database.BatchableContext bc){
        System.debug('--- END BatchFillTechId004Titre ---');
        if(!Test.isRunningTest()){
            Database.executeBatch(new BatchFillTechId005Etablissement());
        }
    }

}