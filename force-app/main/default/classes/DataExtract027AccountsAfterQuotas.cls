/**
 * Created by Julie NGUYEN - Modis  on 10/05/2017.
 */

public class DataExtract027AccountsAfterQuotas implements Queueable {

    private DataToExport dataExport;

    public DataExtract027AccountsAfterQuotas(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractAccountsToCsv();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract028OpportunitiesAfterQuotas(dataExport));
        }
    }

     /**
    Extraction des comptes stockés dans dataExport.accountsToBeExportedRelatedToMinimalQuotas vers un fichier csv
     */
    public void extractAccountsToCsv() {

        System.debug('--- BEGIN DataExtract027AccountsAfterQuotas / extractAccountsToCsv() ---');

        if (dataExport.accountsToBeExportedRelatedToMinimalQuotas != null && !dataExport.accountsToBeExportedRelatedToMinimalQuotas.isEmpty()) {
            DataExtractUtils.extractAllFieldsSpecificRecordsToCSV('07 Bis', DataExtract018Account.OBJECT_NAME_ACCOUNT,
                    dataExport.accountsToBeExportedRelatedToMinimalQuotas);
        }

        System.debug('--- END DataExtract027AccountsAfterQuotas / extractAccountsToCsv() ---');
    }
}