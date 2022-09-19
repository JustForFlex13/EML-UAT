/**
 * Created by Julie NGUYEN - Modis on 03/03/2017.
 */

public class DataExtract018Account implements Queueable {

    public static final String OBJECT_NAME_ACCOUNT = 'Account';
    public static final String FIELD_CONTACT_PRINC_FUND = 'Contact_Principal_Fundraising__c';

    private static final String WHERE_CLAUSE = ' WHERE TECH_External_ID__c != null AND ParentId = null ORDER BY CreatedDate DESC ';

    public DataToExport dataExport{
        public get;
        public set;
    }

    public DataExtract018Account(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractAccounts();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract012ContactLoop(dataExport));
        }
    }

    public void extractAccounts() {

        System.debug('--- BEGIN DataExtract018Account / extractAccounts() ---');

        // Sélection des 200 comptes les plus récents
        dataExport.addAllAccountsToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_ACCOUNT,
                WHERE_CLAUSE, 200));

        System.debug('-- PARAM dataExport.accountsToProcess : ' + dataExport.accountsToProcess);

        System.debug('--- END DataExtract018Account / extractAccounts() ---');
    }
}