/**
 * Created by Julie NGUYEN - Modis on 06/03/2017.
 */

public class DataExtract012ContactAfterLoop implements Queueable {

    private DataToExport dataExport;

    public DataExtract012ContactAfterLoop(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractContactsToCsv();
        if (!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract017OpportunityAfterLoop(dataExport));
        }
    }

    /**
    Extraction des contacts stockés dans dataExport.contactsToExport vers un fichier csv
     */
    public void extractContactsToCsv() {

        System.debug('--- BEGIN DataExtract012ContactAfterLoop / extractContactsToCsv() ---');

        System.debug('-- PARAM dataExport.contactsToExport.size : ' + dataExport.contactsToExport.size());

        DataExtractUtils.extractAllFieldsSpecificRecordsToCSV('08', DataExtract012Contact.OBJECT_NAME_CONTACT,
            dataExport.contactsToExport);

        System.debug('--- END DataExtract012ContactAfterLoop / extractContactsToCsv() ---');
    }
}