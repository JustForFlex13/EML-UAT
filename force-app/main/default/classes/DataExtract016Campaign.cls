/**
 * Created by Julie NGUYEN - Modis on 28/02/2017.
 */

public class DataExtract016Campaign implements Queueable {

    public static final String OBJECT_NAME_CAMPAIGN = 'Campaign';

    private DataToExport dataExport;

    public DataExtract016Campaign(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractCampaigns();

        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract019Lead(dataExport));
        }
    }

    /**
    Extraction de 20 enregistrements "Campaign"
    Sélection des 20 campagnes les plus récentes (Date de création)
     */
    public void extractCampaigns() {
        System.debug('--- BEGIN DataExtract016Campaign / extractCampaigns() ---');

        // Extraction des 20 campagnes les plus récentes vers un fichier csv
        DataExtractUtils.extractAllFieldsToCSV('16', OBJECT_NAME_CAMPAIGN, 20);

        System.debug('--- END DataExtract016Campaign / extractCampaigns() ---');

    }
}