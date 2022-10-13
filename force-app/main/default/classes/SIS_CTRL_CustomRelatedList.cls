/**
* @author SEASON
* @date 2022
* @description Controller for customRelatedList LWC.
*/
public with sharing class SIS_CTRL_CustomRelatedList {
    /**************************************************************************************************************************
    @description Fetches records from the method which infos are passed as parameters.
    @param p_className Name of the class called.
    @param p_methodName Name of the method called.
    @param p_parentRecordId Id of the record on which we want to display the related list.
    @return Fetched records.
    ***************************************************************************************************************************/
    @AuraEnabled( cacheable=true ) 
    public static RelatedListWrapper fetchRecords(String p_className, String p_methodName, String p_parentRecordId)  { 
        RelatedListWrapper lv_objWrap = new RelatedListWrapper();
        Callable lv_class;
        try {
            lv_class = (Callable) Type.forName(p_className).newInstance();
        } catch (Exception ex) {
            throw new AuraHandledException(p_className + ': ' + System.Label.SIS_Invalid_method_name_or_class_not_set_up);
        }
        try {
            List<SObject> lst_result = (List<SObject>) lv_class.call(p_methodName, new Map<String, Object> { 'parentRecordId' => p_parentRecordId });
            lv_objWrap.recordCount = lst_result.size();
            lv_objWrap.recordsList = lst_result;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return lv_objWrap; 
    }

    public class RelatedListWrapper {
        @AuraEnabled
        public List <SObject> recordsList;
        @AuraEnabled
        public Integer recordCount;
    }
}