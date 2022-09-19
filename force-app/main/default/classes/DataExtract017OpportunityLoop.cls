/**
 * Created by Julie NGUYEN - Modis on 03/03/2017.
 */

public class DataExtract017OpportunityLoop implements Queueable {

    private static String OBJECT_NAME_CONTACT = 'Opportunity';

    private DataToExport dataExport;

    public DataExtract017OpportunityLoop(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        processOpportunities();
        if (!Test.isRunningTest()) {
            if (!dataExport.isProcessingComplete()) {
                System.debug('-- DataExtract017OpportunityLoop / execute() : !dataExport.isProcessingComplete() ');
                System.enqueueJob(new DataExtract018AccountLoop(dataExport));
            } else {
                System.debug('-- DataExtract017OpportunityLoop / execute() : ELSE');
                System.enqueueJob(new DataExtract018AccountAfterLoop(dataExport));
            }
        }
    }

    public void processOpportunities() {

        System.debug('--- BEGIN DataExtract017OpportunityLoop / processOpportunities() ---');

        String idsToString = DataExtractUtils.convertSetToString(dataExport.opportunitiesToProcess);

        System.debug('-- PARAM opportunitiesToProcess\'Ids converted to String : ' + idsToString);

        // Sélection des comptes liés aux opportunités
        selectAccountsRelatedToOpportunities(idsToString);

        // Sélection des contacts liés aux opportunités
        selectContactsRelatedToOpportunities(idsToString);

        System.debug('-- PARAM dataExport.opportunitiesToProcess before transfer : ' + dataExport.opportunitiesToProcess);
        System.debug('-- PARAM dataExport.opportunitiesToExport before transfer : ' + dataExport.opportunitiesToExport);

        // Déplacement des opportunités traitées de opportunitiesToProcess à opportunitiesToExport
        dataExport.opportunitiesToExport.addAll(dataExport.opportunitiesToProcess);
        dataExport.opportunitiesToProcess.clear();

        System.debug('-- PARAM dataExport.opportunitiesToProcess after transfer : ' + dataExport.opportunitiesToProcess);
        System.debug('-- PARAM dataExport.opportunitiesToExport after transfer : ' + dataExport.opportunitiesToExport);
        System.debug('-- PARAM dataExport.loopCounter : ' + dataExport.loopCounter);

        System.debug('--- END DataExtract017OpportunityLoop / processOpportunities() ---');
    }

    /**
    Sélection des comptes liés aux opportunités
     */
    private void selectAccountsRelatedToOpportunities(String oppIds) {

        System.debug('--- METHOD : DataExtract017OpportunityLoop / selectAccountsRelatedToOpportunities() ---');

        String query = 'SELECT Id, AccountId FROM ' + DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY +
                ' WHERE TECH_External_Id__c != null AND ID IN ' + oppIds;

        System.debug('-- PARAM query : ' + query);

        List<Opportunity> opportunities = Database.query(query);
        if ( opportunities != null && !opportunities.isEmpty() ) {
            Set<Id> accountIds = new Set<Id>();
            for ( Opportunity opp : opportunities ) {
                accountIds.add(opp.AccountId);
            }
            dataExport.addAllAccountsToProcess(accountIds);
        }

        System.debug('-- PARAM dataExport.accountsToProcess : ' + dataExport.accountsToProcess);

        System.debug('--- END METHOD : DataExtract017OpportunityLoop / selectAccountsRelatedToOpportunities() ---');
    }

    private void selectContactsRelatedToOpportunities(String oppIds) {
        System.debug('--- METHOD : DataExtract017OpportunityLoop / selectContactsRelatedToOpportunities() ---');

        String query = 'SELECT Id, Contact_central__c FROM ' + DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY +
                ' WHERE TECH_External_Id__c != null AND ID IN ' + oppIds;

        System.debug('-- PARAM query : ' + query);

        List<Opportunity> opportunities = Database.query(query);
        if ( opportunities != null && !opportunities.isEmpty() ) {
            Set<Id> contactIds = new Set<Id>();
            for ( Opportunity opp : opportunities ) {
                contactIds.add(opp.Contact_central__c);
            }
            dataExport.addAllContactsToProcess(contactIds);
        }

        System.debug('-- PARAM dataExport.contactsToProcess : ' + dataExport.contactsToProcess);

        System.debug('--- END METHOD : DataExtract017OpportunityLoop / selectContactsRelatedToOpportunities() ---');
    }
}