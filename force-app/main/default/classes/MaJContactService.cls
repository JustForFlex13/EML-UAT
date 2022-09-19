/*--------------------------------------------------------------------
-- - Purpose             : Update the contact email with the defined email (Email_EM_Lyon__c, Adresse_Email_Personnelle__c, Email_de_repli__c)
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 28/11/2017  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
public class MaJContactService {
    
    /*
     * Update the contact email
     * @In : a list of contact
     * Method called by MaJContactBatch batch
     */ 
    public static void updateContact(List<Contact> contacts){
        List<Contact> contactToUpdate = new List<Contact>();
        
        boolean isUpdated = false;
        for(Contact contact : contacts){
            // EM_LYON Email
            if(contact.Appliquer_l_e_mail_EM_Lyon__c && contact.Email_EM_Lyon__c != null){
                contact.Email = contact.Email_EM_Lyon__c;
                contactToUpdate.add(contact);
                continue;
            }
            
            // Personnal email
            if(contact.Appliquer_l_e_mail_personnel__c && contact.Adresse_Email_Personnelle__c != null){
                contact.Email = contact.Adresse_Email_Personnelle__c;
                contactToUpdate.add(contact);
                continue;
            }
            
            // Professionnal Email
            if(contact.Appliquer_l_e_mail_professionnel__c && contact.Email_de_repli__c != null){
                contact.Email = contact.Email_de_repli__c;
                contactToUpdate.add(contact);
                continue;
            }
            
            // Default email
            Contact contactEmailByDefault = updateEmailByDefault(contact);
            if(contactEmailByDefault != null){
                contactToUpdate.add(contactEmailByDefault);
            }
        }
        
        if(contactToUpdate.size()>0){
            ContactDAO.updateBulk(contactToUpdate);
        }
    }
    
    /*
     * Apply a default email if :
     *  - there is no checkbox checked 
     * (Appliquer_l_e_mail_professionnel__c, Appliquer_l_e_mail_personnel__c, Appliquer_l_e_mail_EM_Lyon__c)
     *  - and an email is defined (Adresse_Email_Personnelle__c or Email_de_repli__c)     
     *  - and no email already defined
     *
     *  - MAJ 23/11/2017 TEN : Suppression de la condition "Si email Vide" : && contact.Email == null
     *  - MAJ 27/11/2017 TEN : Inversion des adresses de contact On test d'abord l'email professionnel
     */ 
    @TestVisible
    private static Contact updateEmailByDefault(Contact contact){
        Contact contactToUpdate = null;
        if(!contact.Appliquer_l_e_mail_professionnel__c 
           && !contact.Appliquer_l_e_mail_personnel__c
           && !contact.Appliquer_l_e_mail_EM_Lyon__c
           ){
               
               if(contact.Email_de_repli__c != null){
                   contact.Email = contact.Email_de_repli__c;
                   contactToUpdate = contact;
               } else if (contact.Adresse_Email_Personnelle__c != null){ 
                   contact.Email = contact.Adresse_Email_Personnelle__c;
                   contactToUpdate = contact;
               }
           }
        return contactToUpdate;
    }
}