/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract016CampaignTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractCampaigns() {
        String objName = DataExtract016Campaign.OBJECT_NAME_CAMPAIGN ;

        DataExtract016Campaign de = new DataExtract016Campaign(new DataToExport());

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}