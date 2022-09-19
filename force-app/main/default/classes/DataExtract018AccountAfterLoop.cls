/**
 * Created by Julie NGUYEN - Modis on 06/03/2017.
 */

public class DataExtract018AccountAfterLoop implements Queueable {

    private DataToExport dataExport;

    public DataExtract018AccountAfterLoop(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractAccountsToCsv();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract012ContactAfterLoop(dataExport));
        }
    }

    /**
    Extraction des contacts stockés dans dataExport.accountsToExport vers deux fichiers csv :
    - Le premier sans le champ Contact_Principal_Fundraising__c
    - Le second avec tous les champs
     */
    public void extractAccountsToCsv() {

        System.debug('--- BEGIN DataExtract018AccountAfterLoop / extractAccountsToCsv() ---');

        System.debug('-- PARAM dataExport.accountsToExport : ' + dataExport.accountsToExport);

        // Extraction des comptes d'abord sans le champ Contact_Principal_Fundraising__c car les contacts ne sont pas
        // encore insérés en base
        Set<String> fieldsNotToExportFirst = new Set<String> {DataExtract018Account.FIELD_CONTACT_PRINC_FUND};
        DataExtractUtils.extractSpecificRecordsHandlingLookupsToCSV('07','09', DataExtract018Account.OBJECT_NAME_ACCOUNT,
                dataExport.accountsToExport, fieldsNotToExportFirst);

        System.debug('--- END DataExtract018AccountAfterLoop / extractAccountsToCsv() ---');
    }

}