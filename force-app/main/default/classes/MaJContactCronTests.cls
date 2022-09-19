/*
 * Test class
 * Test the CRON to update the contact email
 */
@IsTest
public class MaJContactCronTests {

    @IsTest
    public static void cron_Test(){
        // Data
        List<Contact> lCtc = TestDataFactory.getContacts();
        
        // DO
        Test.startTest();
        System.schedule('MaJContactCron', '0 0 3 * * ?', new MaJContactCron());          
        Test.stopTest();
    }
}