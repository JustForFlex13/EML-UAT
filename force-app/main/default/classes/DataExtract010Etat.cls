/**
 * Created by Julie NGUYEN - Modis on 23/02/2017.
 */

public class DataExtract010Etat implements Queueable {

    public static final String OBJECT_NAME_ETAT = 'Etat__c';

    public DataToExport dataExport{
        public get;
        public set;
    }

    public DataExtract010Etat(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractEtats();
        if(!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract020Task(dataExport));
        }
    }

    /**
    Extraction de tous les enregistrements "Etat__c"
     */
    public void extractEtats() {

        System.debug('--- BEGIN DataExtract010Etat / extractEtats() ---');

        // Stockage des id pour le traitement d'autres objets plus tard
        dataExport.etatsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_ETAT,
                null, null));

        System.debug('--PARAM dataExport.etatsToExport : ' + dataExport.etatsToExport);

        // Génération du fichier csv
        String whereClause = ' WHERE TECH_External_ID__c != null';
        DataExtractUtils.extractAllFieldWithSpecificWhereClause('06', OBJECT_NAME_ETAT, whereClause);

        System.debug('--- END DataExtract010Etat / extractEtats() ---');
    }
}