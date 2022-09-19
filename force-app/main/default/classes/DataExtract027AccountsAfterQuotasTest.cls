/**
 * Created by Julie NGUYEN - Modis on 11/05/2017.
 */

@IsTest
private class DataExtract027AccountsAfterQuotasTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractAccounsToBeExportedRelatedToMinimalQuotas() {
        String objName = DataExtract018Account.OBJECT_NAME_ACCOUNT;

        DataToExport dataExport = new DataToExport();
        Set<Id> accIds = new Set<Id>();
        for (Account a : [SELECT ID FROM Account]) {
            accIds.add(a.Id);
        }

        dataExport.accountsToBeExportedRelatedToMinimalQuotas.addAll(accIds);

        DataExtract027AccountsAfterQuotas de = new DataExtract027AccountsAfterQuotas(dataExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        List<ContentVersion> contentVersions = [SELECT ID, Title, FileExtension FROM ContentVersion];

        System.debug('-- TEST : contentVersions.size() : ' + contentVersions.size());

        for ( ContentVersion cv : contentVersions ) {
            System.debug('-- TEST ContentVersion Retrieved : ' + cv);
            System.assert(cv.Title.contains(objName));
            System.assertEquals(cv.FileExtension, 'csv');
            System.assertEquals(1, contentVersions.size());
        }
    }
}