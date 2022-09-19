/*
 * CRUD Contact class tests 
 */
@IsTest
public class ContactDAOTests {

    @IsTest
    public static void updateBulk_Test(){
        // Data
        List<Contact> lCtc = TestDataFactory.getContacts();
        
        for(Contact ctc : lCtc){
            ctc.Email = 'test@test.fr';
        }
        
        // DO
        ContactDAO.updateBulk(lCtc);
        
        List<Contact> lCtcUpdated = [SELECT Id, Email FROM Contact];
        
        // VERIFY
        for(Contact ctc : lCtcUpdated){
            System.assertEquals('test@test.fr', ctc.Email);
        }
    }
}