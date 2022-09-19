/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract014RoleTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractRoles() {
        String objName = DataExtract014Role.OBJECT_NAME_ROLE ;

        DataToExport dataExport = new DataToExport();
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract012Contact.OBJECT_NAME_CONTACT);
        DataExtract014Role de = new DataExtract014Role(dataExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}