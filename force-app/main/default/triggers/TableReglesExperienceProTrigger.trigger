trigger TableReglesExperienceProTrigger on CONVSTA_Table_Regles_Experience_Pro__c (before update) {
    /*if (PAD.canTrigger('TableReglesExperienceProTrigger')){
        Set<String> sProgrammesToDesactivate = new Set<String>();
        for(CONVSTA_Table_Regles_Experience_Pro__c table :Trigger.new){
            if(table.Accessible_aux_etudiants__c = true){
                sProgrammesToDesactivate.add(table.Programme__c);
            }            
        }
        
        if(sProgrammesToDesactivate.size() > 0){
            List<CONVSTA_Table_Regles_Experience_Pro__c> lOldAccessibleTables = [SELECT Id FROM CONVSTA_Table_Regles_Experience_Pro__c WHERE Programme__c IN :sProgrammesToDesactivate 
                                                                                                                                        AND Accessible_aux_etudiants__c = true
                                                                                                                                        AND ID NOT IN :Trigger.newMap.keySet()];
            if(lOldAccessibleTables.size() > 0){
                system.debug('passé');
                for(CONVSTA_Table_Regles_Experience_Pro__c oldAccessibleTable :lOldAccessibleTables){    
                    oldAccessibleTable.Accessible_aux_etudiants__c = false;
                }

                PAD.addTriggerBypass('TableReglesExperienceProTrigger');
                update lOldAccessibleTables; 
            }
        }
    }*/
}