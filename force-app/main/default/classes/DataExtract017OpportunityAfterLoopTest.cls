/**
 * Created by Julie NGUYEN - Modis on 15/03/2017.
 */

@IsTest
private class DataExtract017OpportunityAfterLoopTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractOpportunities() {
        DataToExport dataToExport = new DataToExport();

        // Ajout de données à exporter
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataToExport, DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY);

        DataExtract017OpportunityAfterLoop deAfterLoop = new DataExtract017OpportunityAfterLoop(dataToExport);

        Test.startTest();
        deAfterLoop.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY);
    }
}