/**
 * Created by Julie NGUYEN - Modis on 15/03/2017.
 */

@IsTest
public class DataToExportTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    public static void fillObjectsToProcess(DataToExport de) {
        // Récupération de contacts pour les ajouter à contactsToProcess
        List<Contact> contacts = [SELECT Id FROM Contact];
        Set<Id> conIds = new Set<id>();
        for (Contact contact : contacts) {
            conIds.add(contact.Id);
        }

        // Récupération de comptes pour les ajouter à accountsToProcess
        List<Account> accounts = [SELECT Id FROM Account];
        Set<Id> accIds = new Set<id>();
        for (Account account : accounts) {
            accIds.add(account.Id);
        }

        // Récupération d'opportunités pour les ajouter à opportunitiesToProcess
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];
        Set<Id> oppIds = new Set<id>();
        for (Opportunity opp : opportunities) {
            oppIds.add(opp.Id);
        }

        de.addAllContactsToProcess(conIds);
        de.addAllAccountsToProcess(accIds);
        de.addAllOpportunitiesToProcess(oppIds);
    }

    static testMethod void testIsProcessingComplete() {
        DataToExport de = new DataToExport();

        fillObjectsToProcess(de);

        de.loopCounter = 2;
        System.assertEquals(false, de.isProcessingComplete());

        de.loopCounter = 15;
        System.assertEquals(true, de.isProcessingComplete());
    }

    static testMethod void testObjectsToProcess(){
        DataToExport de = new DataToExport();
        fillObjectsToProcess(de);

        List<Contact> contacts = [SELECT Id FROM Contact];
        List<Account> accounts = [SELECT Id FROM Account];
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

        System.assertEquals(contacts.size(), de.contactsToProcess.size());
        System.assertEquals(accounts.size(), de.accountsToProcess.size());
        System.assertEquals(opportunities.size(), de.opportunitiesToProcess.size());
    }
}