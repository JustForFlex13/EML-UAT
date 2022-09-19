/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 * Classe de test pour la classe DataExtract003Naf
 */

@IsTest
private class DataExtract003NafTest {
    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractNaf() {
        String objName = DataExtract003Naf.OBJECT_NAME_NAF;
        DataExtract003Naf de = new DataExtract003Naf();

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}