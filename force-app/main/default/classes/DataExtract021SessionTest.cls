/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@isTest
private class  DataExtract021SessionTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractSessions() {
        String objName = DataExtract021Session.OBJECT_NAME_SESSION ;

        List<Session__c> sessions = [SELECT Id, TECH_External_Id__c FROM Session__c];
        for (Session__c s : sessions) {
            s.TECH_External_Id__c = s.Id;
        }
        update sessions;

        DataExtract021Session de = new DataExtract021Session(new DataToExport());

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
        DataExtractObjectsUtilsTest.testIfRecordsToExport(DataExtract021Session.OBJECT_NAME_SESSION, de.dataExport);
    }
}