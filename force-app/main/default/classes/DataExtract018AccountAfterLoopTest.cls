/**
 * Created by Julie NGUYEN - Modis on 27/03/2017.
 */

@IsTest
private class DataExtract018AccountAfterLoopTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractAccounts() {
        DataToExport dataToExport = new DataToExport();

        // Ajout de données à exporter
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataToExport, DataExtract018Account.OBJECT_NAME_ACCOUNT);

        DataExtract018AccountAfterLoop deAfterLoop = new DataExtract018AccountAfterLoop(dataToExport);

        Test.startTest();
        deAfterLoop.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(DataExtract018Account.OBJECT_NAME_ACCOUNT);
    }
}