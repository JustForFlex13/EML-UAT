@isTest
public class TableReglesExperienceProTriggerTest {
	/*
    @isTest
    static void desactivateOldAccessibleTable(){
        CONVSTA_Table_Regles_Experience_Pro__c oldAccessibleTable = TestDataFactory.getTableReglesExperiencePro();
        oldAccessibleTable.Name = 'Old';
        oldAccessibleTable.Accessible_aux_etudiants__c = true;
        insert oldAccessibleTable;

        CONVSTA_Table_Regles_Experience_Pro__c newAccessibleTable = TestDataFactory.getTableReglesExperiencePro();
        newAccessibleTable.Name = 'New';
        newAccessibleTable.Accessible_aux_etudiants__c = false;
        insert newAccessibleTable;

        Test.startTest();
        newAccessibleTable.Accessible_aux_etudiants__c = true;
        update newAccessibleTable;
        Test.stopTest();

        oldAccessibleTable = [SELECT Accessible_aux_etudiants__c FROM CONVSTA_Table_Regles_Experience_Pro__c WHERE Id = :oldAccessibleTable.Id];
        System.assertEquals(false, oldAccessibleTable.Accessible_aux_etudiants__c);
    }*/
}