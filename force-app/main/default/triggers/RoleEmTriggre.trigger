/*---------------------------------------------------------------------
-- - Purpose             : Manage suiveur status on Role
--
-- - Tested in : TestTR008ManageCase
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 01/02/2019  T.CH  MODIS    1.0      Initial version
---------------------------------------------------------------------*/
trigger RoleEmTriggre on R_le__c (before insert, before update) {
    set<id> contactidSet = new set<id>();
    for( R_le__c role:Trigger.new){
        contactidSet.add(role.contact__c);
    }
    map<id,contact> idToContactMap = new map<id,contact>([select id, name from contact where id in :contactidSet]);
    for( R_le__c role:Trigger.new){
        if(role.Liste_r_le__c !=null && (role.Liste_r_le__c.contains('SUIVEUR OU MAITRE DE STAGE')|| role.Liste_r_le__c.contains('Suiveur GBBA'))){
            role.convsta_suiveur__c=true;
            role.nom_contact__c = idToContactMap.get(role.contact__c).name;
        }
        role.name = idToContactMap.get(role.contact__c).name+ (role.Liste_r_le__c !=null ? ' - '+role.Liste_r_le__c.tolowerCase():'');
    }
}