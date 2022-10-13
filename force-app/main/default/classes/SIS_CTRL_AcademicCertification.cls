/**
* @author SEASON
* @date 2022
* @description Custom controller for Academic Certification object.
*/
public with sharing class SIS_CTRL_AcademicCertification implements callable {
    /**************************************************************************************************************************
    @description Makes some methods of this class dynamically callable from another class in the same namespace.
    @param p_action Name of the method called.
    @param p_args Map of arguments to pass to the called method.
    @return Result returned by the called method.
    ***************************************************************************************************************************/
    public Object call(String p_action, Map<String, Object> p_args) {
        switch on p_action {
            when 'getRelatedSkills' {
                return this.getRelatedSkills((String)p_args.get('parentRecordId'));
            }
            when else {
                throw new ExtensionMalformedCallException(p_action + ': ' + System.Label.SIS_Methode_not_set_up_for_dynamic_calls);
            }
        }
    }
    public class ExtensionMalformedCallException extends Exception {}

    /**************************************************************************************************************************
    @description For a given Id of a Academic Certification, returns a list of Skills related through Skills Family.
    @param p_recordId String value of the Academic Certification Id.
    @return List of found Skills
    ***************************************************************************************************************************/
    public List<SIS_Skill__c> getRelatedSkills(String p_recordId) {
        if (String.valueOf(Id.valueOf(p_recordId).getSobjectType()) != Schema.SObjectType.hed__Academic_Certification__c.getName()) {
            throw new AcademicCertificationException(System.Label.SIS_Wrong_Academic_Certification_Id);
        }
		List<Id> lst_skillsFamilyId = new List<Id>();
        for(SIS_Skills_Family_Assignments__c lv_sfa : 
            [SELECT SIS_Skills_Family__c 
             FROM SIS_Skills_Family_Assignments__c 
             WHERE SIS_Academic_Certification__c = :p_recordId])
        {
            lst_skillsFamilyId.add(lv_sfa.SIS_Skills_Family__c);
        }
        List<SIS_Skill__c> lst_skills =
            [SELECT Id, Name 
             FROM SIS_Skill__c 
             WHERE SIS_Skills_Family__c IN 
                (SELECT Id
                 FROM SIS_Skills_Family__c 
                 WHERE Id IN :lst_skillsFamilyId)];
        return lst_skills;
    }   

    public class AcademicCertificationException extends Exception {}
}