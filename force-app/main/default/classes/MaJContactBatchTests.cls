/*
 * Test the batch to update the contact email
 */
@IsTest
public class MaJContactBatchTests {

    @IsTest
    public static void batch_Test(){
        // Data
        List<Contact> lCtc = TestDataFactory.getContacts();
        
        // DO
        Test.startTest();
        MaJContactBatch batch = new MaJContactBatch();
        DataBase.executeBatch(batch, 200);
        Test.stopTest();
        
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