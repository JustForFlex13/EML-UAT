/**
 * Created by Julie NGUYEN - Modis on 03/03/2017.
 */

public class DataExtract012ContactLoop implements Queueable {

    private DataToExport dataExport;

    public DataExtract012ContactLoop(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        processContacts();
        if (!Test.isRunningTest()) {
            if (!dataExport.isProcessingComplete()) {
                System.debug('-- DataExtract012ContactLoop / execute() : !dataExport.isProcessingComplete() ');
                System.enqueueJob(new DataExtract017OpportunityLoop(dataExport));
            } else {
                System.debug('-- DataExtract012ContactLoop / execute() : ELSE');
                System.enqueueJob(new DataExtract018AccountAfterLoop(dataExport));
            }
        }
    }


    /**
    Récupérer les comptes et les opportunités liés aux contacts et les stocker dans DataToExport
     */
    public void processContacts() {

        System.debug('--- BEGIN DataExtract012ContactLoop / processContacts() ---');

        if (!dataExport.contactsToProcess.isEmpty() && dataExport.contactsToProcess != null) {
            String idsToString = DataExtractUtils.convertSetToString(dataExport.contactsToProcess);

            System.debug('-- PARAM contactsToProcess\'Ids converted to String : ' + idsToString);

            // Sélection des opportunités liées aux contacts à traiter
            selectOpportunitiesRelatedToContacts(idsToString);

            // Sélection des comptes liés aux contacts à traiter
            selectAccountsWhichReferenceContacts(idsToString);
            selectAccountsRelatedToContacts(idsToString);
        }

        System.debug('-- PARAM dataExport.contactsToExport before transfer : ' + dataExport.contactsToExport);
        System.debug('-- PARAM dataExport.contactsToProcess before transfer : ' + dataExport.contactsToProcess);

        // Déplacement des contacts traités de contactsToProcess à contactsToExport
        dataExport.contactsToExport.addAll(dataExport.contactsToProcess);
        dataExport.contactsToProcess.clear();

        System.debug('-- PARAM dataExport.contactsToExport after transfer : ' + dataExport.contactsToExport);
        System.debug('-- PARAM dataExport.contactsToProcess after transfer : ' + dataExport.contactsToProcess);
        System.debug('-- PARAM dataExport.loopCounter : ' + dataExport.loopCounter);

        System.debug('--- END DataExtract012ContactLoop / processContacts() ---');
    }

    /**
    Sélection des opportunités liées aux contacts passés en paramètre
    @param idsContacts: Set d'Id de contacts pour lesquels on retrouve les opportunités
     */
    private void selectOpportunitiesRelatedToContacts(String idsToString) {

        System.debug('--- METHOD : DataExtract012ContactLoop / selectOpportunitiesRelatedToContacts() ---');

        String clause = ' WHERE TECH_External_Id__c != null AND ' + DataExtract017Opportunity.FIELD_CONTACT_CENTRAL + ' IN ' +
                idsToString;

        System.debug('--PARAM clause for query : ' + clause);

        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(
                DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY, clause, null));

        System.debug('--PARAM dataExport.opportunitiesToProcess : ' + dataExport.opportunitiesToProcess);

        System.debug('--- END METHOD : DataExtract012ContactLoop / selectOpportunitiesRelatedToContacts() ---');

    }

    /**
    Sélection des comptes liés aux contacts passés en paramètre
    @param idsContacts: Set d'Id de contacts pour lesquels on retrouve les comptes
     */
    private void selectAccountsRelatedToContacts(String idsToString) {

        System.debug('--- METHOD : DataExtract012ContactLoop / selectAccountsRelatedToContacts() ---');

        String query = ' SELECT AccountId FROM ' + DataExtract012Contact.OBJECT_NAME_CONTACT + ' WHERE ID IN ' +
                idsToString;

        System.debug('-- PARAM query : ' + query);

        List<Contact> contacts = Database.query(query);
        if ( contacts != null && !contacts.isEmpty() ) {
            Set<Id> accountIds = new Set<Id>();
            for ( Contact con : contacts ) {
                if ( con.AccountId != null ) {
                    accountIds.add(con.AccountId);
                }
            }
            dataExport.addAllAccountsToProcess(accountIds);
        }

        System.debug('--PARAM dataExport.accountsToProcess ' + dataExport.accountsToProcess);

        System.debug('--- END METHOD : DataExtract012ContactLoop / selectAccountsRelatedToContacts() ---');
    }

    private void selectAccountsWhichReferenceContacts(String idsToString) {

        System.debug('--- METHOD : DataExtract012ContactLoop / selectAccountsWhichReferenceContacts() ---');

        String clause = ' WHERE ' + DataExtract018Account.FIELD_CONTACT_PRINC_FUND + ' IN ' +
                idsToString;

        System.debug('--PARAM clause for query : ' + clause);

        Set<Id> accountIds = DataExtractUtils.extractIdsFromSpecificRecords(DataExtract018Account.OBJECT_NAME_ACCOUNT,
                clause, null);
        dataExport.addAllAccountsToProcess(accountIds);

        System.debug('--PARAM dataExport.accountsToProcess ' + dataExport.accountsToProcess);

        System.debug('--- END METHOD : DataExtract012ContactLoop / selectAccountsWhichReferenceContacts() ---');
    }
}