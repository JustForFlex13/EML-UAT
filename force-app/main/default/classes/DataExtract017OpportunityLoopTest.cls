/**
 * Created by Julie NGUYEN - Modis on 15/03/2017.
 */

@IsTest
private class DataExtract017OpportunityLoopTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testDataTransfer() {
        DataToExport dataToExport = new DataToExport();

        List<Account> accounts = [SELECT Id, TECH_External_Id__c FROM Account];
        for (Account a : accounts) {
            a.TECH_External_Id__c = a.Id;
        }
        update accounts;

        List<Contact> contacts = [SELECT Id, TECH_External_Id__c FROM Contact];
        for (Contact c : contacts) {
            c.TECH_External_Id__c = c.Id;
            c.AccountId = accounts[0].Id;
        }
        update contacts;

        List<Opportunity> opportunities = [SELECT Id, AccountId, Contact_central__c FROM Opportunity];
        for (Opportunity o : opportunities) {
            o.TECH_External_Id__c = o.Id;
            o.AccountId = accounts[0].Id;
            o.Contact_central__c = contacts[0].Id;            
            o.Exercice__c = String.valueOf(System.Today().year());
        }
        update opportunities;

        // Ajout de données à 'Process', dont opportunitiesToProcess
        DataToExportTest.fillObjectsToProcess(dataToExport);

        DataExtract017OpportunityLoop de = new DataExtract017OpportunityLoop(dataToExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        // Vérification que opportunitiesToProcess a été vidé au profit de opportunitiesToExport
        System.assertEquals(dataToExport.opportunitiesToProcess.size(), 0);
        System.assertEquals(dataToExport.opportunitiesToExport.size(), [SELECT Id FROM Contact].size());
    }
}