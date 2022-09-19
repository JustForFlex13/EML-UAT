/*---------------------------------------------------------------------
-- - Purpose           : Implementation of methods called by triggers on leads.
--
-- Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 00/00/20XX  XXXX  MODIS    1.0      Initial version
---------------------------------------------------------------------*/
public without sharing class TR004ManageLead {

	public static void LeadConvertion(Id contactId, Id recordTypeId, Id oppId){ 
		Opportunity[] opp = [Select o.Id, o.Contact_central__c, o.StageName From Opportunity o where o.id  = : oppId];
		if (opp.size() > 0) {
			opp[0].Contact_central__c=contactId;
			opp[0].RecordTypeId=recordTypeId;
			update opp;
		}
	}
}