/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 * Classe de test pour la classe DataExtract004Pays
 */

@IsTest
private class DataExtract004PaysTest {
    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractPays() {
        String objName = DataExtract004Pays.OBJECT_NAME_PAYS;

        DataExtract004Pays de = new DataExtract004Pays();

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}