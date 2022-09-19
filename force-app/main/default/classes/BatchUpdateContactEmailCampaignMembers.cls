/*--------------------------------------------------------------------
-- - Purpose             : This batch update a email contact field
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 27/12/2016  ????  ???????    1.0      Initialisation
--------------------------------------------------------------------*/
global class BatchUpdateContactEmailCampaignMembers implements 
Database.Batchable<sObject> {
    
    global final List<Id> listId;
    global final String email1Rapport;
    global final String email2Rapport;
    //global final Id campaignOwnerId;
    global final String campaignName;
    global final String campaignOwnerEmail;
    List<Contact> contactUpdate = new List<Contact>();
    
    global BatchUpdateContactEmailCampaignMembers(List<Id> p_listIdToUpdate, String p_email1, String p_email2,/*Id p_campaignOwnerId,*/ String p_campaignOwnerEmail, String p_campaignName) {
        listId = p_listIdToUpdate;
        email1Rapport = p_email1;
        email2Rapport = p_email2;
        campaignOwnerEmail = p_campaignOwnerEmail;
        //campaignOwnerId = p_campaignOwnerId;
        campaignName = p_campaignName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Email, Email_EM_Lyon__c, Email_de_repli__c, Adresse_Email_Personnelle__c From Contact Where Id IN (Select ContactId From CampaignMember Where Id IN :listId)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        Database.DMLOptions dml = new Database.DMLOptions();
		dml.DuplicateRuleHeader.AllowSave = true; 
        
        for(Contact c : scope){
            if(email1Rapport.equals('Email_de_repli__c')){
                c.email = c.Email_de_repli__c;
            }
            
            if(email1Rapport.equals('Email_EM_Lyon__c')){
                c.email = c.Email_EM_Lyon__c;
            }
            
            if(email1Rapport.equals('Adresse_Email_Personnelle__c')){
                c.email = c.Adresse_Email_Personnelle__c;
            }

            if(String.isBlank(c.email)){
                if(email2Rapport.equals('Email_de_repli__c')){
                    c.email = c.Email_de_repli__c;
                }
                
                // A SUPPRIMER REFACTO CODE MORT : 
                // WK_Contact_MAJ E-mail standard par l'email EM Lyon
                if(email2Rapport.equals('Email_EM_Lyon__c')){
                    c.email = c.Email_EM_Lyon__c;
                }
                
                if(email2Rapport.equals('Adresse_Email_Personnelle__c')){
                    c.email = c.Adresse_Email_Personnelle__c;
                }
            }
            contactUpdate.add(c);
        }
        
        Database.update(contactUpdate, dml);
        
    }
    
    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setTargetObjectId(campaignOwnerId);
        String[] toAddresses = new String[] {campaignOwnerEmail};
   		mail.setToAddresses(toAddresses);
        mail.setSubject('Les membres de la campagne ' + campaignName + ' ont été mis à jour');
        mail.setHtmlBody
            ('Bonjour,<br/></br> Les ' + listId.size() + ' membres de la campagne<b> ' + campaignName +
             ' </b>ont bien été mis à jour, vous pouvez maintenant procéder à l\'envoi des emails.<br/><br/>Cordialement.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}