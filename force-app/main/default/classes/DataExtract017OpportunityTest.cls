/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract017OpportunityTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testSelectOpportunities() {
        String objName = DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY;

        List<Contact> contacts = [SELECT Id, TECH_External_Id__c FROM Contact];
        for (Contact c : contacts) {
            c.TECH_External_Id__c = c.Id;
        }
        update contacts;

        List<Account> accounts = [SELECT Id, TECH_External_Id__c FROM Account];
        for (Account a : accounts) {
            a.TECH_External_Id__c = a.Id;
        }
        update accounts;

        List<Opportunity> opportunities = [SELECT ID, TECH_External_Id__c FROM Opportunity];
        for (Opportunity opp : opportunities) {
            opp.TECH_External_Id__c = opp.Id;
            opp.Contact_central__c = contacts[0].Id;
            opp.AccountId = accounts[0].Id;
            opp.Exercice__c = String.valueOf(System.Today().year());
        }
        update opportunities;

        DataExtract017Opportunity de = new DataExtract017Opportunity(new DataToExport());

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testSelectedRecords(objName, de.dataExport);
    }

}