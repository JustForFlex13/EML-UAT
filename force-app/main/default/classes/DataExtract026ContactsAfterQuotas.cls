/**
 * Created by Julie NGUYEN - Modis  on 10/05/2017.
 */

public class DataExtract026ContactsAfterQuotas implements Queueable {

    private DataToExport dataExport;

    public DataExtract026ContactsAfterQuotas(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractContactsToCsv();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract027AccountsAfterQuotas(dataExport));
        }
    }

     /**
    Extraction des contacts stockés dans dataExport.contactsToBeExportedRelatedToMinimalQuotas vers un fichier csv
     */
    public void extractContactsToCsv() {

        System.debug('--- BEGIN DataExtract026ContactsAfterQuotas / extractContactsToCsv() ---');

        if (dataExport.contactsToBeExportedRelatedToMinimalQuotas != null && !dataExport.contactsToBeExportedRelatedToMinimalQuotas.isEmpty()) {
            System.debug('-- PARAM dataExport.contactsToBeExportedRelatedToMinimalQuotas.size() : ' + dataExport.contactsToBeExportedRelatedToMinimalQuotas.size());

            DataExtractUtils.extractAllFieldsSpecificRecordsToCSV('08 Bis', DataExtract012Contact.OBJECT_NAME_CONTACT,
                    dataExport.contactsToBeExportedRelatedToMinimalQuotas);
        }
        System.debug('--- END DataExtract026ContactsAfterQuotas / extractContactsToCsv() ---');
    }
}