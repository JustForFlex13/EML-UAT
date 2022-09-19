/**
 * Created by Julie NGUYEN - Modis on 06/03/2017.
 */

public class DataExtract021Session implements Queueable{

    public static final String OBJECT_NAME_SESSION = 'Session__c';


    public DataToExport dataExport{
        public get;
        public set;
    }

    public DataExtract021Session(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractSessions();
        if (!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract005Product(dataExport));
        }
    }

    /**
    Extraction des 100 sessions les plus récentes et stockage de leur id en prévision du traitement d'autres objets
     */
    public void extractSessions() {

        System.debug('--- BEGIN DataExtract021Session / extractSessions() ---');

        String clause = ' WHERE TECH_External_ID__c != null ORDER BY CreatedDate ';

        // Stockage des id
        dataExport.sessionsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_SESSION,
                clause, 100));

        System.debug('--PARAM dataExport.sessionsToExport : ' + dataExport.sessionsToExport);

        // Génération du fichier csv
        DataExtractUtils.extractAllFieldsSpecificRecordsToCSV('21', OBJECT_NAME_SESSION, dataExport.sessionsToExport);

        System.debug('*** Approximate amount of memory that has been used for the heap : ' + Limits.getHeapSize() + ' ***');

        System.debug(' *** Final heap size: ' +  Limits.getHeapSize() + ' ***');

        System.debug('--- END DataExtract021Session / extractSessions() ---');
    }
}