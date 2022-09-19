/**
 * Created by Julie NGUYEN - Modis on 15/03/2017.
 */

@IsTest
private class DataExtract012ContactAfterLoopTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractContacts() {
        DataToExport dataToExport = new DataToExport();

        // Ajout de données à exporter
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataToExport, DataExtract012Contact.OBJECT_NAME_CONTACT);

        DataExtract012ContactAfterLoop deAfterLoop = new DataExtract012ContactAfterLoop(dataToExport);

        Test.startTest();
        deAfterLoop.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(DataExtract012Contact.OBJECT_NAME_CONTACT);
    }
}