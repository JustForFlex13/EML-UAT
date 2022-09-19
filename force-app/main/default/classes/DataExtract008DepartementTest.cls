/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract008DepartementTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractDepartements() {
        String objName = DataExtract008Departement.OBJECT_NAME_DEPARTEMENT;

        DataExtract008Departement de = new DataExtract008Departement();

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}