global class Convsta_UserHandler implements Auth.SamlJitHandler {
    private class JitException extends Exception{
        public JitException(String message, Boolean toSend){
            if(toSend){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.setToAddresses(new List<String> {Label.Convsta_EM_ResponsableEmailAdress});
                mail.setCcAddresses(new List<String> {Label.Convsta_EM_SecondResponsableEmailAdress});

                mail.setSenderDisplayName('Your Salesforce integrator');
                mail.setSubject('Convsta - Just in Time provisionning failed');

                mail.setPlainTextBody(message);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }            
        }
    }
    
	global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
        					String federationIdentifier, Map<String, String> attributes, String assertion) {
        User u = new User();
        handleJit(true, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes);
                                
        return u;
    }   

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
        					String federationIdentifier, Map<String, String> attributes, String assertion) {
        User u = [SELECT Id FROM User WHERE Id=:userId];
        if(u != null){
            handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes);
        }else{
            throw new JitException('No user has been found with this Id : '+ String.valueOf(userId), true);
        }
        
    }

    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes) {
        Contact ctc = handleContact(u, federationIdentifier);
        handleUser(create, u, ctc, federationIdentifier);
    }

    private Contact handleContact(User u, String federationIdentifier) {
        List<Contact> lCtc = [SELECT Id, Account.Name,
                                        Email_EM_Lyon__c, LastName, FirstName,
                              			Account.owner.userroleId
                                FROM Contact
                                WHERE Email_EM_Lyon__c = :federationIdentifier
                                LIMIT 1];
		
        if(lCtc[0] != null){
            if(lCtc[0].Account.owner.userroleId == null){
                throw new JitException('The portal account\'s owner of \'' + lCtc[0].Account.Name + '\' must have a role', true);
            }
            return lCtc[0];
        }else{
            throw new JitException('No Salesforce contact has been found with this following EMLyon email address : ' + federationIdentifier, true);
        }
    }
    
    private void handleUser(Boolean create, User u, Contact ctc, String federationIdentifier) {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Convsta community Login' LIMIT 1];
        
        u.Email = ctc.Email_EM_Lyon__c;
        u.USERNAME = ctc.Email_EM_Lyon__c;
        u.FederationIdentifier = ctc.Email_EM_Lyon__c;
        u.PROFILEID = p.Id;
        u.LASTNAME = ctc.LastName;
        u.FIRSTNAME = ctc.FirstName;
        u.ALIAS = ctc.FirstName.substring(0, 1) + ctc.LastName.substring(0, Math.min(3,ctc.LastName.length()));


        if(create) {
        	u.CONTACTID = ctc.Id;
            u.LanguageLocaleKey = 'en_us';
            u.LocaleSidKey = 'fr_FR_EURO';
            u.EmailEncodingKey = 'UTF-8';
            u.TimeZoneSidKey = 'Europe/Paris';
            try{
                insert(u);
            }catch(Exception e){
                throw new JitException('Insert operation of user \''+u.LastName+' '+u.FirstName+'\' from JiT provisionning failed', true);
            }
        }else{
            try{
                update(u);
            }catch(Exception e){
                throw new JitException('Update operation on user with Id=\''+String.valueOf(u.Id)+'\' from JiT provisionning failed', true);
            }
        }
    }
}