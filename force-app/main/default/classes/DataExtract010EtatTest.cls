/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract010EtatTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractEtats() {
        String objName = DataExtract010Etat.OBJECT_NAME_ETAT;
        DataExtract010Etat de = new DataExtract010Etat(new DataToExport());

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
        DataExtractObjectsUtilsTest.testIfRecordsToExport(DataExtract010Etat.OBJECT_NAME_ETAT, de.dataExport);
    }
}