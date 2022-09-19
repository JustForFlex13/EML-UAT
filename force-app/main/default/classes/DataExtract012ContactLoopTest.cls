/**
 * Created by Julie NGUYEN - Modis on 15/03/2017.
 */

@IsTest
private class DataExtract012ContactLoopTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testDataTransfer() {
        DataToExport dataToExport = new DataToExport();

        // Ajout de données à 'Process', dont contactsToProcess
        DataToExportTest.fillObjectsToProcess(dataToExport);

        DataExtract012ContactLoop de = new DataExtract012ContactLoop(dataToExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        // Vérification que contactsToProcess a été vidé au profit de contactsToExport
        System.assertEquals(dataToExport.contactsToProcess.size(), 0);
        System.assertEquals(dataToExport.contactsToExport.size(), [SELECT Id FROM Contact].size());
    }
}