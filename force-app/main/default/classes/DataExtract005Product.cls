/**
 * Created by Julie NGUYEN - Modis on 22/02/2017.
 */

public class DataExtract005Product implements Queueable {

    public static final String OBJECT_NAME_PRODUCT = 'Product2';

    public DataToExport dataExport{
        public get;
        public set;
    }

    public DataExtract005Product(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractProducts();
        if(!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract010Etat(dataExport));
        }
    }

     /**
    Extraction de tous les enregistrements "Product2"
     */
    public void extractProducts() {

        System.debug('--- BEGIN DataExtract005Product / extractProducts() ---');

        // Stockage des id pour le traitement d'autres objets plus tard
        dataExport.productsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_PRODUCT,
                null, null));

        System.debug('--PARAM dataExport.productsToExport : ' + dataExport.productsToExport);

        System.debug('--- END DataExtract005Product / extractProducts() ---');
    }
}