/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@IsTest
private class DataExtract022EventTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractEvents() {
        String objName = DataExtract022Event.OBJECT_NAME_EVENT ;

        DataToExport dataExport = new DataToExport();

        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract012Contact.OBJECT_NAME_CONTACT);
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY);
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract018Account.OBJECT_NAME_ACCOUNT);
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract010Etat.OBJECT_NAME_ETAT);
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract019Lead.OBJECT_NAME_LEAD);
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract005Product.OBJECT_NAME_PRODUCT);
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract021Session.OBJECT_NAME_SESSION);

        DataExtract022Event de = new DataExtract022Event(dataExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}