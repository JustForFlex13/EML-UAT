/**
 * Created by Julie NGUYEN - Modis on 27/03/2017.
 */

@IsTest
private class DataExtract018AccountLoopTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testDataTransfer() {
        List<Account> accounts = [SELECT Id, TECH_External_Id__c FROM Account];
        for (Account a : accounts) {
            a.TECH_External_Id__c = a.Id;
        }
        update accounts;

        List<Contact> contacts = [SELECT Id, TECH_External_Id__c FROM Contact];
        for (Contact c : contacts) {
            c.TECH_External_Id__c = c.Id;
        }
        update contacts;

        DataToExport dataToExport = new DataToExport();

        // Ajout de données à 'Process', dont accountsToProcess
        DataToExportTest.fillObjectsToProcess(dataToExport);

        DataExtract018AccountLoop de = new DataExtract018AccountLoop(dataToExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        // Vérification que accountsToProcess a été vidé au profit de accountsToExport
        System.assertEquals(dataToExport.accountsToProcess.size(), 0);
        System.assertEquals(dataToExport.accountsToExport.size(), [SELECT Id FROM Account].size());
    }
}