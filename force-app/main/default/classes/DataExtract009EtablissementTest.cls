/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract009EtablissementTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractEtablissements() {
        String objName = DataExtract009Etablissement.OBJECT_NAME_ETABLISSEMENT;
        DataExtract009Etablissement de = new DataExtract009Etablissement();

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}