/**
* @author SEASON
* @date 2022
* @description Unit tests for SIS_CTRL_AcademicCertification class.
*/
@isTest
private class SIS_CTRL_AcademicCertification_TEST {
    private static hed__Academic_Certification__c academicCertification {get;set;}
    private static List<SIS_Skill__c> skills {get;set;}

    static {
        academicCertification = new hed__Academic_Certification__c(Name = 'Academic Certification');
        insert academicCertification;
        
        SIS_Skills_Family__c lv_skillFamily = new SIS_Skills_Family__c(Name = 'Skill Family');
        insert lv_skillFamily;

        skills = new List<SIS_Skill__c>{
            new SIS_Skill__c(Name = 'Skill #1', SIS_Skills_Family__c = lv_skillFamily.Id),
            new SIS_Skill__c(Name = 'Skill #2', SIS_Skills_Family__c = lv_skillFamily.Id)
        };
        insert skills;
        
        SIS_Skills_Family_Assignments__c lv_sfa = 
            new SIS_Skills_Family_Assignments__c(
                SIS_Academic_Certification__c = academicCertification.Id,
                SIS_Skills_Family__c = lv_skillFamily.Id);
        insert lv_sfa;
    }

    /************************************************************************************************************
    * @description : We try to run the getRelatedSkills without using an external call, in order to check if the
                     method works on its own.
    * @result      : No error is thrown and the queried records are returned.
    *************************************************************************************************************/
    @isTest
    private static void getRelatedSkills_OK_TestCase() {
        // Data setup
        SIS_CTRL_AcademicCertification lv_customController = new SIS_CTRL_AcademicCertification();
        List<SIS_Skill__c> lst_queriedSkills = new List<SIS_Skill__c>();

        // Test
        Test.startTest();
        lst_queriedSkills = lv_customController.getRelatedSkills(academicCertification.Id);
        Test.stopTest();

        // Verify
        System.assertEquals(skills.size(), lst_queriedSkills.size());
    }

    /************************************************************************************************************
    * @description : We test the getRelatedSkills on its own with a wrong parameter.
    * @result      : An error is thrown and no queried record is returned.
    *************************************************************************************************************/
    @isTest
    private static void getRelatedSkills_WrongParameter_TestCase() {
        // Data setup
        Account lv_account = new Account(Name = 'Test Account');
        insert lv_account;
        
        SIS_CTRL_AcademicCertification lv_customController = new SIS_CTRL_AcademicCertification();
        List<SIS_Skill__c> lst_queriedSkills = new List<SIS_Skill__c>();
        
        String lv_errorMsg;
        
        // Test
        Test.startTest();
        try {
            lst_queriedSkills = lv_customController.getRelatedSkills(lv_account.Id);
        } catch (Exception ex) {
            lv_errorMsg = ex.getMessage();
        }
        Test.stopTest();

        // Verify
        System.assertNotEquals(null, lv_errorMsg);
        System.assert(lst_queriedSkills.isEmpty());
    }

    /************************************************************************************************************
    * @description : We test the getRelatedSkills with an external call.
    * @result      : No error is thrown and the queried records are returned.
    *************************************************************************************************************/
    @isTest
    public static void getRelatedSkills_ExternalCall_OK_TestCase() {
        List<SObject> lst_queriedSkills = new List<SObject>();
        String lv_errorMsg;

        Test.startTest();
        try {
            lst_queriedSkills = 
            SIS_CTRL_CustomRelatedList.fetchRecords(
                'SIS_CTRL_AcademicCertification', 
                'getRelatedSkills', 
                academicCertification.Id
            ).recordsList;
        } catch (Exception ex) {
            lv_errorMsg = ex.getMessage();
        }
        Test.stopTest();

        System.assertEquals(null, lv_errorMsg);
        System.assertEquals(skills.size(), lst_queriedSkills.size());
    }
    
    /************************************************************************************************************
    * @description : We test the getRelatedSkills with an external call.
    * @result      : An error is thrown and no queried record is returned.
    *************************************************************************************************************/
    @isTest
    public static void getRelatedSkills_ExternalCall_KO_TestCase() {
        List<SIS_Skill__c> lst_queriedSkills = new List<SIS_Skill__c>();
        String lv_errorMsg;

        Test.startTest();
        try {
            lst_queriedSkills = 
                SIS_CTRL_CustomRelatedList.fetchRecords(
                    'SIS_CTRL_AcademicCertification', 
                    'anotherMethodName', 
                    academicCertification.Id
                ).recordsList;
        } catch (Exception ex) {
            lv_errorMsg = ex.getMessage();
        }
        Test.stopTest();

        System.assertNotEquals(null, lv_errorMsg);
        System.assert(lst_queriedSkills.isEmpty(), 'No records should have been returned');
    }
}