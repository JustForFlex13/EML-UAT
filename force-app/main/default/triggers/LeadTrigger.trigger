/*-------------------------------------------------------------------
-- - Purpose           : Trigger on Lead 
--            
-- Maintenance History :
--
-- Date         Name  Version  Remarks 
-- -----------  ----  -------  ---------------------------------------
-- 19/02/2018   T.CH  1.0      Fusion for triggers
--------------------------------------------------------------------  */
trigger LeadTrigger on Lead (before insert, before update, after update) {	

	if (trigger.isInsert) {
		//BEFORE INSERT
		if (trigger.isBefore) {
			for (Lead piste : trigger.new) {
				if (String.isNotBlank(piste.Int_r_t_de_la_piste__c)) {
					List<String> interets = piste.Int_r_t_de_la_piste__c.split(';');
					piste.Nombre_d_int_r_t_de_la_piste__c = interets.size();
				}
				else {
					piste.Nombre_d_int_r_t_de_la_piste__c = 0;	
				}
			}
		}
		//END BEFORE INSERT
	}
	
	if (trigger.isUpdate) {
		//BEFORE UPDATE
		if (trigger.isBefore) {
			for (Lead piste : trigger.new) {
				if (piste.Int_r_t_de_la_piste__c != Trigger.oldMap.get(piste.Id).Int_r_t_de_la_piste__c) {
					if (String.isNotBlank(piste.Int_r_t_de_la_piste__c)) {
						List<String> interets = piste.Int_r_t_de_la_piste__c.split(';');
						piste.Nombre_d_int_r_t_de_la_piste__c = interets.size();
					}
					else {
						piste.Nombre_d_int_r_t_de_la_piste__c = 0;	
					}
				}
			}
		}
		//END BEFORE UPDATE

		//AFTER UPDATE
		if (trigger.isAfter) {
			if(PAD.canTrigger('TR004ManageLead')){		
				//no bulk processing; will only run from the UI
				if (Trigger.new.size() == 1) {
	
					// on recherche l'id des record type, l'id de l'opportunité convertie dépend uniquement de l'id 
					String recordTypePisteName = APU_ApexUtils.getLeadRecordTypeNameById(Trigger.old[0].RecordTypeId);    
					Id recordTypeOpportunityId = APU_ApexUtils.getOpportunityRecordTypeIdByName(recordTypePisteName);
	
					if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true) {
						if(Trigger.new[0].ConvertedContactId!=null && Trigger.new[0].ConvertedOpportunityId!=null){				 
							TR004ManageLead.LeadConvertion(Trigger.new[0].ConvertedContactId, recordTypeOpportunityId, Trigger.new[0].ConvertedOpportunityId);
						}
					}
				}
			}
		}
		//END AFTER UPDATE
	}
}