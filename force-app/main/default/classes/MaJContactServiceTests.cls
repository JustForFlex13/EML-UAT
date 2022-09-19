/*
 * Test class
 * Test the update the contact email with the defined email
 */
@IsTest
public class MaJContactServiceTests {

    @IsTest
    public static void updateEmailByDefault_Perso_Test(){
        // Data
        List<Contact> lCtc = TestDataFactory.getContacts();
        
        // DO
        Contact contactUpdated = MaJContactService.updateEmailByDefault(lCtc.get(4));
        
        // VERIFY
        System.assertNotEquals(null, contactUpdated);
        System.assertEquals(lCtc.get(4).Adresse_Email_Personnelle__c, contactUpdated.email);
    }
    
    @IsTest
    public static void updateEmailByDefault_Pro_Test(){
        // Data
        List<Contact> lCtc = TestDataFactory.getContacts();
        
        // DO
        Contact contactUpdated = MaJContactService.updateEmailByDefault(lCtc.get(3));
        
        // VERIFY
        System.assertNotEquals(null, contactUpdated);
        System.assertEquals(lCtc.get(3).Email_de_repli__c, contactUpdated.email);
    }
    
    @IsTest
    public static void updateContact_Test(){
        // Data
        List<Contact> lCtc = TestDataFactory.getContacts();
        
        // DO
        MaJContactService.updateContact(lCtc);
        
        List<Contact> contacts = [SELECT Id, Email, Appliquer_l_e_mail_EM_Lyon__c, Email_EM_Lyon__c,
                                  Appliquer_l_e_mail_personnel__c, Adresse_Email_Personnelle__c,
                                  Appliquer_l_e_mail_professionnel__c, Email_de_repli__c
                                  FROM Contact];
        
        // VERIFY
        for(Contact contact : contacts){
            if(contact.Appliquer_l_e_mail_EM_Lyon__c){
                System.assertEquals(contact.Email_EM_Lyon__c, contact.Email);
            }
            
            if(contact.Appliquer_l_e_mail_personnel__c){
                System.assertEquals(contact.Adresse_Email_Personnelle__c, contact.Email);
            }
            
            if(contact.Appliquer_l_e_mail_professionnel__c){
                System.assertEquals(contact.Email_de_repli__c, contact.Email);
            }
        }
    }
}