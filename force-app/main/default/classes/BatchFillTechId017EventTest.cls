/**
 * Created by Julie NGUYEN - Modis on 22/03/2017.
 */

@IsTest
private class BatchFillTechId017EventTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testUpdateFields() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId017Event());
        Test.stopTest();

        testTaskBatch();
    }


    static testMethod void sendsEmail() {
        Test.startTest();
        BatchFillTechId017Event b = new BatchFillTechId017Event();
        Database.executeBatch(b);
        Test.stopTest();

        // Vérification qu'un email a été envoyé
        System.assertEquals(BatchFillTechId017Event.emailLimits, 1);
    }

    private static void testTaskBatch () {
        String query = 'SELECT ID, WhatId, WhoId, TECH_External_What_Id__c, TECH_External_Who_Id__c FROM Event LIMIT 150';
        List<Event> events = Database.query(query);
        System.debug('--- Test Batch for Event ---');

        for (Event event : events) {
            System.debug('--- TECH_External_What_Id__c de l\' enregistrement : ' + String.valueOf( event.get('TECH_External_What_Id__c') ));
            System.debug('--- WhatId de l\' enregistrement : ' + event.WhatId );
            System.debug('--- TECH_External_Who_Id__c de l\' enregistrement : ' + String.valueOf( event.get('TECH_External_Who_Id__c') ));
            System.debug('--- WhoId de l\' enregistrement : ' + event.WhoId );

            String techWhatId = String.valueOf( event.get('TECH_External_What_Id__c') );
            String techWhotId = String.valueOf( event.get('TECH_External_Who_Id__c') );
            System.assertEquals(String.valueOf(event.WhatId), techWhatId);
            System.assertEquals(String.valueOf(event.WhoId), techWhotId);
        }
    }

}