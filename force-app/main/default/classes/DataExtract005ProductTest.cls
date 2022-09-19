/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract005ProductTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractProducts() {
        String objName = DataExtract005Product.OBJECT_NAME_PRODUCT;
        DataToExport dataExport = new DataToExport();

        DataExtract005Product de = new DataExtract005Product(new DataToExport());

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
        DataExtractObjectsUtilsTest.testIfRecordsToExport(DataExtract005Product.OBJECT_NAME_PRODUCT, de.dataExport);
    }
}