@isTest
public class TR009ManageConvstaEvaluationTest {
    @isTest
    public static void shareEvalWithRespPedaTest(){
        User respPedagogique = TestObjectFactory.createUser('RespPedago','Responsable Pédagogique');
        insert respPedagogique;
        Convsta_Evaluation__c evaluation = TestObjectFactory.createEvaluation();
        evaluation.Responsable_Pedagogique__c = respPedagogique.Id;
        insert evaluation;    
                    
        Test.startTest();
        Convsta_Evaluation__Share evalShare = Convsta_Internship.shareEvalWithRespPeda(evaluation);
        insert evalShare;
        Test.stopTest();
    
        List<Convsta_Evaluation__Share> jShrs = [
            SELECT Id, UserOrGroupId, AccessLevel, RowCause 
            FROM Convsta_Evaluation__Share 
            WHERE ParentId =:evaluation.Id 
            AND UserOrGroupId =:respPedagogique.Id];

        System.assertEquals(jShrs.size(), 1);
        System.assertEquals(jShrs[0].AccessLevel, 'Read');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
    }
}