public with sharing class UniversalValueMap {

    public static Map<String, Map<String, Map<String, String>>> valueMapSf2Ext {
        get{
            if(valueMapSf2Ext == null) {
                valueMapSf2Ext = makeUvmFromSF();
            }
            return valueMapSf2Ext;
        }
        set;
    }
    public static Map<String, Map<String, Map<String, String>>> valueMapExt2sf {
        get{
            if(valueMapExt2sf == null) {
                valueMapExt2sf = makeUvmFromExt();
            }
            return valueMapExt2sf;
        }
        set;
    }

     
    private static Map<String, Map<String, Map<String, String>>> makeUvmFromSF(){
        Map<String, Map<String, Map<String, String>>> retMap = new Map<String, Map<String, Map<String, String>>>();
        // TODO implemente filters ?
        List<universalValueMap__mdt> mdtList = [SELECT ExtValue__c, fieldName__c, objectName__c, SFDC_value__c FROM universalValueMap__mdt];
        for(universalValueMap__mdt mdt : mdtList){
            if(retMap.get(mdt.objectName__c) == null){
                retMap.put(mdt.objectName__c, new Map<String, Map<String, String>>());
            }
            if(retMap.get(mdt.objectName__c).get(mdt.fieldname__c) == null){
                retMap.get(mdt.objectName__c).put(mdt.fieldname__c, new Map<String, String>());
            }
            retMap.get(mdt.objectName__c).get(mdt.fieldname__c).put(mdt.SFDC_value__c, mdt.ExtValue__c);
        }
        return retMap;
    }

    private static Map<String, Map<String, Map<String, String>>> makeUvmFromExt(){
        Map<String, Map<String, Map<String, String>>> retMap = new Map<String, Map<String, Map<String, String>>>();
        List<universalValueMap__mdt> mdtList = [SELECT ExtValue__c, fieldName__c, objectName__c, SFDC_value__c FROM universalValueMap__mdt];
        for(universalValueMap__mdt mdt:mdtList){
            if(retMap.get(mdt.objectName__c) == null){
                retMap.put(mdt.objectName__c, new Map<String, Map<String, String>>());
            }
            if(retMap.get(mdt.objectName__c).get(mdt.fieldname__c) == null){
                retMap.get(mdt.objectName__c).put(mdt.fieldname__c, new Map<String, String>());
            }
            retMap.get(mdt.objectName__c).get(mdt.fieldname__c).put(mdt.ExtValue__c,mdt.SFDC_value__c);
        }
        return retMap;
    }
}