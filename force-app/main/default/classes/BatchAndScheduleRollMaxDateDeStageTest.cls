@isTest private class BatchAndScheduleRollMaxDateDeStageTest {
    @testSetup
    static void setup(){
        Account acc1 = TestDataFactory.getAccount();
        acc1.Name = 'Account 1';
        insert acc1;

        Contact ctc = TestObjectFactory.createContact(acc1);
        insert ctc;
        Case case1_older = new Case(Subject = 'Older case 1', 
                                    AccountId = acc1.Id, 
                                    recordTypeId    = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience'),
                                    Convsta_DateStart__c = Date.newInstance(2000, 01, 13),
                                    Type = 'Expérience professionnelle',
                                    Status = 'Expérience validée',
                                    Convsta_Type_de_demande__c = 'Stage',
                                    Convsta_TypeContrat__c  = 'Convention de stage de l ecole',
                                    contactid= ctc.id);
        insert case1_older;

        Case case1_last = new Case(Subject = 'Last case 1', 
                                   recordTypeId    = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience'),
                                   AccountId = acc1.Id, 
                                   Convsta_DateStart__c = Date.newInstance(2000, 01, 14),
                                    Type = 'Expérience professionnelle',
                                    Status = 'Expérience validée',
                                   Convsta_Type_de_demande__c = 'Stage',
                                   Convsta_TypeContrat__c  = 'Convention de stage de l ecole',
                                   contactid= ctc.id);
        insert case1_last;
        case1_last.Subject = 'Last case 1';
        update case1_last;


        Account acc2 = TestDataFactory.getAccount();
        acc2.Name = 'Account 2';
        insert acc2;

        Case case2_older = new Case(Subject = 'Older case 2', 
                                    AccountId = acc2.Id, 
                                    Convsta_DateStart__c = Date.newInstance(2000, 01, 13),
                                    Type = 'Expérience professionnelle',
                                    Status = 'Expérience validée',
                                   Convsta_Type_de_demande__c = 'Stage',
                                   Convsta_TypeContrat__c  = 'Convention de stage de l ecole',
                                    recordTypeId = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience'),
                                    contactid= ctc.id);
        insert case2_older;

        Case case2_last = new Case(Subject = 'Last case 2', 
                                    AccountId = acc2.Id, 
                                    Convsta_DateStart__c = Date.newInstance(2000, 01, 14),
                                    Type = 'Expérience professionnelle',
                                    Status = 'Expérience validée',
                                   Convsta_Type_de_demande__c = 'Stage',
                                   Convsta_TypeContrat__c  = 'Convention de stage de l ecole',
                                    recordTypeId = APU_ApexUtils.getCaseRecordTypeIdByDeveloperName('Convsta_Validation_d_experience'),
                                    contactid= ctc.id);
        insert case2_last;
        case2_last.Subject = 'Last case 2';
        update case2_last;

    }

    @isTest static void testBatch(){
        Test.startTest();
        BatchAndScheduleRollMaxDateDeStage batch = new BatchAndScheduleRollMaxDateDeStage();
        Database.executeBatch(batch);
        Test.stopTest();

        Account acc1 = [SELECT Id, Convsta_roll_max_date_de_stage__c
                        FROM Account
                        WHERE Name = 'Account 1'];
        Case lastCase1 = [SELECT Id, Convsta_DateStart__c
                          FROM Case
                          WHERE Subject = 'Last case 1'];
        System.assertEquals(lastCase1.Convsta_DateStart__c, acc1.Convsta_roll_max_date_de_stage__c);

        Account acc2 = [SELECT Id, Convsta_roll_max_date_de_stage__c
                        FROM Account
                        WHERE Name = 'Account 2'];
        Case lastCase2 = [SELECT Id, Convsta_DateStart__c
                          FROM Case
                          WHERE Subject = 'Last case 2'];
        System.assertEquals(lastCase2.Convsta_DateStart__c, acc2.Convsta_roll_max_date_de_stage__c);
    }

    @isTest public static void testSchedule() {
    	Test.startTest();        

		BatchAndScheduleRollMaxDateDeStage schedule = new BatchAndScheduleRollMaxDateDeStage();
        String sch = '0 0 4 * * ? *'; //Every day at 04:00
        System.schedule('Test Launch Check', sch, schedule);    
             
        Test.stopTest();
    }
 
}