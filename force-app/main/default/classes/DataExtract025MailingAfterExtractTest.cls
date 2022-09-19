/**
 * Created by Julie NGUYEN - Modis on 16/03/2017.
 */

@IsTest
private class DataExtract025MailingAfterExtractTest {

    static testMethod void sendsEmailOnBeginning() {
        Test.startTest();
        System.enqueueJob(new DataExtract025MailingAfterExtract());
        Test.stopTest();

        // Vérification qu'un email a été envoyé
        System.assertEquals(DataExtract025MailingAfterExtract.emailLimits, 1);
    }
}