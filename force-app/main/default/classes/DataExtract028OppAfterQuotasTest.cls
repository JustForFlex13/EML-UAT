/**
 * Created by Julie NGUYEN - Modis on 11/05/2017.
 */

@IsTest
private class DataExtract028OppAfterQuotasTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractOpportunitiesToBeExportedRelatedToMinimalQuotas() {
        String objName = DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY;

        DataToExport dataExport = new DataToExport();
        Set<Id> oppIds = new Set<Id>();
        for (Opportunity o : [SELECT ID FROM Opportunity]) {
            oppIds.add(o.Id);
        }

        dataExport.opportunitiesToBeExportedRelatedToMinimalQuotas.addAll(oppIds);

        DataExtract028OpportunitiesAfterQuotas de = new DataExtract028OpportunitiesAfterQuotas(dataExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}