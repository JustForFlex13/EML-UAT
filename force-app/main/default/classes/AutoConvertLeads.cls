public with sharing class AutoConvertLeads {
    @InvocableMethod   
    public static void leadAssign(List<Id> leadIds)  
    {         
        Database.DMLOptions dml = new Database.DMLOptions(); 
		dml.DuplicateRuleHeader.allowsave = true;
        
        LeadStatus cLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
   		Lead ld = [SELECT Id, Email from Lead WHERE Id IN: leadIds LIMIT 1];
        Contact ctw = [SELECT Id, OwnerId, AccountId from Contact where Email =: ld.Email AND Nature_du_premier_contact__c ='Site internet'];
            
        List<Database.LeadConvert> massLeadconvert = new List<Database.LeadConvert>();    
        
        for(id currentlead: leadIds){                
            Database.LeadConvert leadconvert = new Database.LeadConvert();    
            leadconvert.setLeadId(currentlead);                               
            leadconvert.setConvertedStatus(cLeadStatus.MasterLabel); 
            leadconvert.setAccountId(ctw.AccountId);
            leadconvert.setDoNotCreateOpportunity(TRUE);
            leadconvert.setContactId(ctw.Id);
            leadconvert.setOwnerId(ctw.OwnerId);
            massLeadconvert.add(leadconvert);    
        } 
		
       if (!massLeadconvert.isEmpty())
        {List<Database.LeadConvertResult> lcr = Database.convertLead(massLeadconvert, dml);
            system.debug('---lead convert---'+lcr);
        }   
    } 
}