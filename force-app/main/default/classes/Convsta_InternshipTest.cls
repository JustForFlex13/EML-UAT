@isTest
public class Convsta_InternshipTest {
    @testSetup
    public static void setup(){
        Account entreprise = TestDataFactory.getAccount();
        entreprise.Name = 'Test Name';
        insert entreprise;

        Contact etudiant = TestDataFactory.getContact();
        insert etudiant;

        CONVSTA_Table_Regles_Experience_Pro__c table = TestObjectFactory.createTable();
        insert table;

        Case demande = TestObjectFactory.createCase(etudiant);
        demande.Convsta_DateStart__c = Date.today().addDays(-30);
        demande.Convsta_DateEnd__c = Date.today().addYears(-1);
        demande.Convsta_Entreprise__c = entreprise.Id;
        demande.Convsta_Table_des_Regles_Experience_Pro__c = table.Id;
        demande.Convsta_Type_de_demande__c = 'Stage';
        demande.Convsta_TypeContrat__c = 'Convention de stage de l ecole';
        insert demande;

        Convsta_Mission__c mission = [SELECT Id FROM Convsta_Mission__c WHERE MD_Demande__c =:demande.Id];
        mission.Titre_Mission__c = 'Researchable';
        update mission;

        Convsta_Mission__c missionNOK = new Convsta_Mission__c();
        missionNOK.Titre_Mission__c = 'Not found';
        missionNOK.MD_Demande__c = demande.Id;
        insert missionNOK;
    }

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

    @isTest
    public static void testSearchOK(){
        Convsta_Internship.SearchInput input = new Convsta_Internship.SearchInput();
        input.country = 'France';
        input.city = 'TestVille';
        input.programme = 'E2MS';
        input.companyName = 'Test Name';
        input.title = 'Researchable';

        Test.startTest();
        Convsta_Internship.SearchReturn resReturn = Convsta_Internship.search(input);
        Test.stopTest();
        system.debug(resReturn);
        System.assertEquals(1, resReturn.lOutputs.size(), resReturn);
    }

    @isTest
    public static void testSearchNoCondition(){
        Convsta_Internship.SearchInput input = new Convsta_Internship.SearchInput();

        Test.startTest();
        Convsta_Internship.SearchReturn resReturn = Convsta_Internship.search(input);
        Test.stopTest();

        System.assertEquals( 'NOK : No condition entered', resReturn.state );
    }

    @isTest
    public static void testSearchNoResult(){
        Convsta_Internship.SearchInput input = new Convsta_Internship.SearchInput();
        input.country = 'NOK';
        input.city = 'NOK';
        input.programme = 'NOK';
        input.naf = 'NOK';
        input.companyName = 'NOK';
        input.title = 'NOK';

        Test.startTest();
        Convsta_Internship.SearchReturn resReturn = Convsta_Internship.search(input);
        Test.stopTest();

        System.assertEquals(null, resReturn.lOutputs);
    }
}