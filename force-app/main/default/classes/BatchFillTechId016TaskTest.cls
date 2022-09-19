/**
 * Created by Julie NGUYEN - Modis on 22/03/2017.
 */

@IsTest
private class BatchFillTechId016TaskTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testUpdateFields() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch(new BatchFillTechId016Task());
        Test.stopTest();

        testTaskBatch();
    }

    private static void testTaskBatch () {
        String query = 'SELECT ID, WhatId, WhoId, TECH_External_What_Id__c, TECH_External_Who_Id__c FROM Task LIMIT 150';
        List<Task> tasks = Database.query(query);
        System.debug('--- Test Batch for Task ---');

        for (Task task : tasks) {
            System.debug('--- TECH_External_What_Id__c de l\' enregistrement : ' + String.valueOf( task.get('TECH_External_What_Id__c') ));
            System.debug('--- WhatId de l\' enregistrement : ' + task.WhatId );
            System.debug('--- TECH_External_Who_Id__c de l\' enregistrement : ' + String.valueOf( task.get('TECH_External_Who_Id__c') ));
            System.debug('--- WhoId de l\' enregistrement : ' + task.WhoId );

            String techWhatId = String.valueOf( task.get('TECH_External_What_Id__c') );
            String techWhotId = String.valueOf( task.get('TECH_External_Who_Id__c') );
            System.assertEquals(String.valueOf(task.WhatId), techWhatId);
            System.assertEquals(String.valueOf(task.WhoId), techWhotId);
        }
    }
}