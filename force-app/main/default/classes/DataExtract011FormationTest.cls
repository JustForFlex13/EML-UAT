/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract011FormationTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractFormations() {
        String objName = DataExtract011Formation.OBJECT_NAME_FORMATION;

        DataToExport dataExport = new DataToExport();

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

        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract012Contact.OBJECT_NAME_CONTACT);

        DataExtract011Formation de = new DataExtract011Formation(dataExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }

}