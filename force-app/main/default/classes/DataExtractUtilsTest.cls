/**
 * Created by Julie NGUYEN - Modis on 07/03/2017.
 */

@IsTest
private class DataExtractUtilsTest {

    @testSetup static void createData() {
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0 ; i < 50 ; i++) {
            Contact c = new Contact(
                    FirstName = 'Test ' + i,
                    LastName = 'Test ' + i,
                    Email = 'Test' + i + '@mail.com',
                    Salutation = 'Mme'
            );
            contacts.add(c);
        }
        insert contacts;
    }

    static testMethod void testconvertSetToString() {
        // Création de données
        Set<Id> idsToConvert = new Set<Id>{'906F000000096YPIAY','906F000000096YPIAZ','906F000000096YPIAW'};

        String idsConverted = DataExtractUtils.convertSetToString(idsToConvert);

        System.assertEquals(idsConverted, '(\'906F000000096YPIAY\',\'906F000000096YPIAZ\',\'906F000000096YPIAW\')');
        System.assert(idsConverted.contains(','));
        System.assert(idsConverted.contains('('));
        System.assert(idsConverted.contains(')'));
    }

    static testMethod void testExtractAllFieldsToCSV() {
        String objectName = 'Contact';
        Integer numberOfRecords = 50;
        String fileNumber = '01';
        Set<Id> contactsIds = new Set<Id>();
        Set<String> fieldToKeep = new Set<String> {'Email'};
        Set<String> fieldToRemove = new Set<String> {'Salutation'};
        String clause = ' WHERE FirstName = \'Test%\' ';

        List<Contact> contactsRetrieved = [SELECT ID FROM Contact];
        for (Contact ctc : contactsRetrieved) {
            contactsIds.add(ctc.Id);
        }

        Test.startTest();
        // Tests des différentes extractions
        DataExtractUtils.extractAllFieldsToCSV(fileNumber, objectName, numberOfRecords);
        DataExtractUtils.extractAllFieldsSpecificRecordsToCSV(fileNumber, objectName, contactsIds);
        DataExtractUtils.extractAllFieldWithSpecificWhereClause(fileNumber, objectName, clause);
        Test.stopTest();

        // Vérification du titre des fichiers csv, de leur extension
        List<ContentVersion> contentVersions = [SELECT ID, Title, FileExtension FROM ContentVersion];
        for ( ContentVersion cv : contentVersions ) {
            System.assert(cv.Title.contains(objectName));
            System.assertEquals(cv.FileExtension, 'csv');
        }
    }

    static testMethod void testSpecificFields() {
        String objectName = 'Contact';
        Integer numberOfRecords = 200;
        String fileNumber = '01';
        Set<Id> contactsIds = new Set<Id>();
        Set<String> fieldToKeep = new Set<String> {'Email'};
        Set<String> fieldToRemove = new Set<String> {'Salutation'};
        String clause = ' WHERE FirstName = \'Test%\' ';

        List<Contact> contactsRetrieved = [SELECT ID FROM Contact];
        for (Contact ctc : contactsRetrieved) {
            contactsIds.add(ctc.Id);
        }

        Test.startTest();
        DataExtractUtils.extractSpecificFieldsToCSV(fileNumber, objectName, fieldToKeep, numberOfRecords);
        DataExtractUtils.extractSpecificFieldsAndRecordsToCSV(fileNumber, objectName, fieldToKeep, contactsIds);
        DataExtractUtils.extractSpecificRecordsHandlingLookupsToCSV(fileNumber, fileNumber, objectName, contactsIds,
                fieldToRemove);
        Test.stopTest();

        // Vérification du titre des fichiers csv, de leur extension
        List<ContentVersion> contentVersions = [SELECT ID, Title, FileExtension FROM ContentVersion];
        for ( ContentVersion cv : contentVersions ) {
            System.assert(cv.Title.contains(objectName));
            System.assertEquals(cv.FileExtension, 'csv');
        }
    }

    static testMethod void testExtractIdsFromRecords() {
        Integer nbOfRecords = 10;
        String objectName = 'Contact';
        Set<Id> idsRetrieved = new Set<Id>();

        Test.startTest();
        idsRetrieved = DataExtractUtils.extractIdsFromSpecificRecords(objectName, null, nbOfRecords);
        Test.stopTest();

        System.assertEquals(idsRetrieved.size(), nbOfRecords);
    }
}