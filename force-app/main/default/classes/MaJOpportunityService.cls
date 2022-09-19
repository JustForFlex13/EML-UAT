/*--------------------------------------------------------------------
-- - Purpose             : Update the owner and the Souhait_programme__c of a contact in function of the recorType of the opportunity.
--                         If a contact is the same between different opportunities updated, the last value encountered replaced the oldest.
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 15/01/2018  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
public class MaJOpportunityService {
    
    @TestVisible
    private static final ID RECORD_TYPE_FOR_FI = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Formation initiale').getRecordTypeId();
    
    private static final ID RECORD_TYPE_FOR_FC_1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Formation courte').getRecordTypeId();
    private static final ID RECORD_TYPE_FOR_FC_2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Formation intra-entreprise').getRecordTypeId();
    private static final ID RECORD_TYPE_FOR_FC_3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Programme Long Diplômant').getRecordTypeId();
    
    private static final ID RECORD_TYPE_FOR_PROGRAMME_1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Taxe').getRecordTypeId();
    private static final ID RECORD_TYPE_FOR_PROGRAMME_2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fundraising B2C').getRecordTypeId();
    private static final ID RECORD_TYPE_FOR_PROGRAMME_3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Relations Employeur').getRecordTypeId();
    private static final ID RECORD_TYPE_FOR_PROGRAMME_4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partenariat Fundraising').getRecordTypeId();

    /*
     * Update contact when some values on opportunities are updated
     * If a contact is the same between different opportunities updated, the last value encountered replaced the oldest
     */
    public static void updateContactByOpportunity(List<Opportunity> opps){
        List<Contact> contactsToUpdate = new List<Contact>(); 
        Map<Id, Contact> mapContactToUpdate = new Map<Id, Contact>();
        
        // Get the ids of contact
        List<Id> contactIds = getContactIds(opps);
        // Retrieve all opportunities with the FORM_Exercice_en_cours__c whose the Contact_central__c is one of the contacts
        List<Opportunity> oppsExEnCoursByContact = [SELECT Id, OwnerId, Contact_central__c, Name
                                                    FROM Opportunity 
                                                    WHERE Contact_central__c IN :contactIds AND FORM_Exercice_en_cours__c = true
                                                    AND IsClosed = false
                                                    ORDER BY CreatedDate DESC];
        
        // Keep only the newest opportunity for each contact
        Map<Id, Opportunity> mapContactIdToNewestOpp = getMapContactIdToNewestOpp(oppsExEnCoursByContact);
    
        boolean isUpdated = false;
        for(Opportunity opp : opps){
            if(opp.Contact_central__r != null){
				Contact contactToUpdate = opp.Contact_central__r;
                // If the contact is already updated, retrieve it
                // A same contact can update the ownerId and the Souhait_programme__c
            	if(mapContactToUpdate.containsKey(opp.Contact_central__c)){
              		contactToUpdate = mapContactToUpdate.get(opp.Contact_central__c);
            	}
            
                // Update ownerId && Programme        	
                boolean isUpdatedOwner = updateOwnerContact(contactToUpdate, mapContactIdToNewestOpp);
                boolean isUpdatedProgramme = updateProgrammeContact(contactToUpdate, mapContactIdToNewestOpp);
            	
                isUpdated = isUpdatedOwner ||isUpdatedProgramme;

            	if(isUpdated){
                    // Replace the last values
                	mapContactToUpdate.put(opp.Contact_central__c, contactToUpdate);
                	isUpdated = false;
            	}                
            }
        }
        
        // Bulk update
        if(mapContactToUpdate.values().size()>0){
            ContactDAO.updateBulk(mapContactToUpdate.values());
        }
    }
    
    
    /*
     * Update the ownerId of contact
     */
    @TestVisible
    private static boolean updateOwnerContact(Contact contact, Map<Id, Opportunity> mapContactIdToNewestOpp){
        Boolean isUpdated = false;
        if (mapContactIdToNewestOpp.containsKey(contact.Id)) {
            contact.OwnerId = mapContactIdToNewestOpp.get(contact.Id).OwnerId;
            isUpdated = true;  
        }
         
        return isUpdated;
    }
    
    /*
     * Update the Souhait_programme__c of contact
     */
    @TestVisible
    private static boolean updateProgrammeContact(Contact contact, Map<Id, Opportunity> mapContactIdToNewestOpp){
        Boolean isUpdated = false;
        if(mapContactIdToNewestOpp.containsKey(contact.Id)){
            contact.Souhait_programme__c =  mapContactIdToNewestOpp.get(contact.Id).Name;
            isUpdated = true;
        }
        return isUpdated;
    }
    
    /*
     * Return the list of the Contact_central__c ids of the given opportunities
     */
    @TestVisible
    private static List<Id> getContactIds(List<Opportunity> opps){
        List<Id> contactIds = new List<Id>();
        
        for(Opportunity opp : opps){
            if(opp.Contact_central__c != null){
                contactIds.add(opp.Contact_central__c);
            }
        }
        
        return contactIds;
    }
    
    /*
     * Return a map which contains for each Contact_central__c of the given opportunities the newest opportunity whose the exercise in "En_cours"
     */
    @TestVisible
    private static Map<Id, Opportunity> getMapContactIdToNewestOpp(List<Opportunity> opps){
        Map<Id, Opportunity> mapContactToOpportunity = new Map<Id, Opportunity>();
        
        for(Opportunity opp : opps){
            if(!mapContactToOpportunity.containsKey(opp.Contact_central__c)){
                mapContactToOpportunity.put(opp.Contact_central__c, opp);
            }
        }
        
        return mapContactToOpportunity;
    }
}