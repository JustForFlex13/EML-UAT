@isTest
public class convsta_BatchSchedule_CreateEvalTest {
  @isTest
    public static void testBatch(){
        CONVSTA_Table_Regles_Experience_Pro__c table = TestObjectFactory.createTable();
        table.A_evaluer__c = true;
        insert table;

        Case demande = TestDataFactory.getCaseWithSigners();
        demande.Convsta_Type_de_demande__c =                    'Stage';
        demande.Convsta_TypeContrat__c =                        'Convention de stage de l ecole';
        demande.Convsta_DateEnd__c =                            Date.today().addDays(28);
        demande.Convsta_Evaluation__c =                         null;
        demande.Convsta_Table_des_Regles_Experience_Pro__c =    table.Id;
        demande.Status =   'Convention signée';
        demande.Convsta_Responsable_Pedagogique__c		 =    UserInfo.getUserId();
        insert demande;
                
        Test.startTest();
        Database.executeBatch(new convsta_BatchSchedule_CreateEval());
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Convsta_Evaluation__c WHERE Demande__c = :demande.Id]);
        System.assertEquals(1, [SELECT count() FROM Case WHERE Convsta_Evaluation__c != null]);
    }

    @isTest
    public static void testSchedule(){
        convsta_BatchSchedule_CreateEval batchSchedule = new convsta_BatchSchedule_CreateEval();
        String sch = '0 0 18 ? * MON-FRI *';

        Test.StartTest();   
        system.schedule('Test Coverage', sch, batchSchedule); 
        Test.stopTest(); 
    }

}