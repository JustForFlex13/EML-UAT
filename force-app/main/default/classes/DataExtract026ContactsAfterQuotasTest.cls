/**
 * Created by Julie NGUYEN - Modis on 11/05/2017.
 */

@IsTest
private class DataExtract026ContactsAfterQuotasTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractContactsToBeExportedRelatedToMinimalQuotas() {
        String objName = DataExtract012Contact.OBJECT_NAME_CONTACT;

        DataToExport dataExport = new DataToExport();
        Set<Id> conIds = new Set<Id>();
        for (Contact c : [SELECT ID FROM Contact]) {
            conIds.add(c.Id);
        }

        dataExport.contactsToBeExportedRelatedToMinimalQuotas.addAll(conIds);

        DataExtract026ContactsAfterQuotas de = new DataExtract026ContactsAfterQuotas(dataExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }
}