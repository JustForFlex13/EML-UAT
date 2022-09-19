/**
 * Created by Julie NGUYEN - Modis on 07/03/2017.
 */

public class DataExtract022Event implements Queueable {

    public static String OBJECT_NAME_EVENT = 'Event';

    private DataToExport dataExport;

    public DataExtract022Event(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractEvents();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract023ContactAssoOpp(dataExport));
        }
    }

    /**
    Extraction des événements reliés aux enregistrements déjà traités parmi les objets :
    - Contact
    - Account
    - Etat__c
    - Lead
    - Opportunity
    - Product2
    - Session__c
     */
    public void extractEvents() {
        System.debug('--- BEGIN DataExtract022Event / extractEvents() ---');
        String whoIdClause = ' WHERE ((';

        if ( dataExport.contactsToExport != null && !dataExport.contactsToExport.isEmpty() ) {
            whoIdClause += ' WhoId IN ' + DataExtractUtils.convertSetToString(dataExport.contactsToExport);
        }

        if ( dataExport.accountsToExport != null && !dataExport.accountsToExport.isEmpty() ) {
            whoIdClause += ' OR WhoId IN ' + DataExtractUtils.convertSetToString(dataExport.accountsToExport);
        }

        if ( dataExport.etatsToExport != null && !dataExport.etatsToExport.isEmpty() ) {
            whoIdClause += ' OR WhoId IN ' + DataExtractUtils.convertSetToString(dataExport.etatsToExport);
        }

        if ( dataExport.leadsToExport != null && !dataExport.leadsToExport.isEmpty() ) {
            whoIdClause += ' OR WhoId IN ' + DataExtractUtils.convertSetToString(dataExport.leadsToExport);
        }

        if ( dataExport.opportunitiesToExport != null && !dataExport.opportunitiesToExport.isEmpty() ) {
            whoIdClause += ' OR WhoId IN ' + DataExtractUtils.convertSetToString(dataExport.opportunitiesToExport);
        }

        if ( dataExport.productsToExport != null && !dataExport.productsToExport.isEmpty() ) {
            whoIdClause += ' OR WhoId IN ' + DataExtractUtils.convertSetToString(dataExport.productsToExport);
        }

        if ( dataExport.sessionsToExport != null && !dataExport.sessionsToExport.isEmpty() ) {
            whoIdClause += ' OR WhoId IN ' + DataExtractUtils.convertSetToString(dataExport.sessionsToExport);
        }

        whoIdClause += ') ';

        System.debug('-- PARAM String whoIdClause : ' + whoIdClause);

        String whatIdClause = ' OR (';

        if ( dataExport.contactsToExport != null && !dataExport.contactsToExport.isEmpty() ) {
            whatIdClause += ' WhatId IN ' + DataExtractUtils.convertSetToString(dataExport.contactsToExport);
        }

        if ( dataExport.accountsToExport != null && !dataExport.accountsToExport.isEmpty() ) {
            whatIdClause += ' OR WhatId IN ' + DataExtractUtils.convertSetToString(dataExport.accountsToExport);
        }

        if ( dataExport.etatsToExport != null && !dataExport.etatsToExport.isEmpty() ) {
            whatIdClause += ' OR WhatId IN ' + DataExtractUtils.convertSetToString(dataExport.etatsToExport);
        }

        if ( dataExport.leadsToExport != null && !dataExport.leadsToExport.isEmpty() ) {
            whatIdClause += ' OR WhatId IN ' + DataExtractUtils.convertSetToString(dataExport.leadsToExport);
        }

        if ( dataExport.opportunitiesToExport != null && !dataExport.opportunitiesToExport.isEmpty() ) {
            whatIdClause += ' OR WhatId IN ' + DataExtractUtils.convertSetToString(dataExport.opportunitiesToExport);
        }

        if ( dataExport.productsToExport != null && !dataExport.productsToExport.isEmpty() ) {
            whatIdClause += ' OR WhatId IN ' + DataExtractUtils.convertSetToString(dataExport.productsToExport);
        }

        if ( dataExport.sessionsToExport != null && !dataExport.sessionsToExport.isEmpty() ) {
            whatIdClause += ' OR WhatId IN ' + DataExtractUtils.convertSetToString(dataExport.sessionsToExport);
        }

        whatIdClause += ' )) ';

        System.debug('-- PARAM String whatIdClause : ' + whatIdClause);

        // Set qui contient les champs à ne pas prendre en compte pour l'extraction
        Set<String> fieldNamesNotToExport = new Set<String>{'WhatId','WhoId'};

        String techIdClause = ' AND (TECH_External_Who_Id__c != null OR TECH_External_What_Id__c != null) ';

        DataExtractUtils.extractFieldsWithExceptionsToCSV('17', OBJECT_NAME_EVENT, fieldNamesNotToExport,
                whoIdClause + whatIdClause + techIdClause, null);

        System.debug('--- END DataExtract022Event / extractEvents() ---');
    }

}