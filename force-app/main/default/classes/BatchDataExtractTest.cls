/**
 * Created by Julie NGUYEN - Modis on 15/03/2017.
 */

@IsTest
private class BatchDataExtractTest {

    static testMethod void sendsEmailOnBeginning() {
        Test.startTest();
        BatchDataExtract b = new BatchDataExtract();
        Database.executeBatch(b);
        Test.stopTest();

        // Vérification qu'un email a été envoyé
        System.assertEquals(BatchDataExtract.emailLimits, 1);
    }
}