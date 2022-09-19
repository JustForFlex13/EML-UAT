/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract019LeadTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractLeads() {
        String objName = DataExtract019Lead.OBJECT_NAME_LEAD ;

        List<Lead> leads = [SELECT Id, TECH_External_Id__c FROM Lead];
        for (Lead l : leads) {
            l.TECH_External_Id__c = l.Id;
        }
        update leads;

        DataExtract019Lead de = new DataExtract019Lead(new DataToExport());

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
        DataExtractObjectsUtilsTest.testIfRecordsToExport(DataExtract019Lead.OBJECT_NAME_LEAD, de.dataExport);
    }
}