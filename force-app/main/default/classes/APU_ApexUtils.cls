/*--------------------------------------------------------------------
-- - Purpose           : Utils class
--
-- Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 04/01/2018  A.DO  MODIS    1.0      Initialisation
-- 08/01/2018  T.CH  MODIS    1.1	   getRecordType without SOQL on Opp and Contact
-- 14/02/2018  T.CH  MODIS    1.2      remove getRecordType via SOQL & getRecordType without SOQL on Lead and Product2
-- 14/12/2018  T.CH  MODIS    1.3      add method for Case object
--------------------------------------------------------------------*/

public class APU_ApexUtils {

    public static Id getOpportunityRecordTypeIdByName(String pName){
        return Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(pName).getRecordTypeId();
    }
    
    public static Id getContactRecordTypeIdByName(String pName){
        return Schema.SObjectType.Contact.getRecordTypeInfosByName().get(pName).getRecordTypeId();
    }

    public static Id getProduct2RecordTypeIdByName(String pName){
        return Schema.SObjectType.Product2.getRecordTypeInfosByName().get(pName).getRecordTypeId();
    }

    public static Id getLeadRecordTypeIdByName(String pName){
        return Schema.SObjectType.Lead.getRecordTypeInfosByName().get(pName).getRecordTypeId();
    }

    public static String getLeadRecordTypeNameById(Id pId){
        return Schema.SObjectType.Lead.getRecordTypeInfosById().get(pId).getName();
    }
    
    public static Id getCaseRecordTypeIdByDeveloperName(String pName){
        return Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(pName).getRecordTypeId();
    }
}