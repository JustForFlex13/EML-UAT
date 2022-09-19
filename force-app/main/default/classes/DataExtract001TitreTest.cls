/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 * Classe de test pour la classe DataExtract001Titre
 */

@IsTest
private class DataExtract001TitreTest {
    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractTitres() {
        String objName = DataExtract001Titre.OBJECT_NAME_TITRE;
        DataExtract001Titre de = new DataExtract001Titre();

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}