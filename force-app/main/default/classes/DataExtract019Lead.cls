/**
 * Created by Julie NGUYEN - Modis on 06/03/2017.
 */

public class DataExtract019Lead implements Queueable {

    public static String OBJECT_NAME_LEAD = 'Lead';


    public DataToExport dataExport{
        public get;
        public set;
    }

    /**
    Clauses WHERE pour obtenir un jeu de données pertinent en filtrant les types d'enregistrements
     */
    private static String WHERE_RECORD_TYPE_FORMATION_COURTE = ' WHERE RecordType.Name = \'Formation courte\' ' +
            ' AND TECH_External_ID__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_RECORD_TYPE_INITIALE = ' WHERE RecordType.Name = \'Formation Initiale\' ' +
            ' AND TECH_External_ID__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_RECORD_TYPE_INTRA_ENTREPRISE = ' WHERE RecordType.Name = \'Formation intra-entreprise\' ' +
            ' AND TECH_External_ID__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_RECORD_TYPE_FUNDRAISING_B2C = ' WHERE RecordType.Name = \'Fundraising B2C\' ' +
            ' AND TECH_External_ID__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_RECORD_TYPE_PARTENARIAT_FUNDRAISING = ' WHERE RecordType.Name = \'Partenariat Fundraising\' ' +
            ' AND TECH_External_ID__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_RECORD_TYPE_PRG_LONG_DIPLOMANT = ' WHERE RecordType.Name = \'Programme Long Diplômant\' ' +
            ' AND TECH_External_ID__c != null ' +
            'ORDER BY CreatedDate DESC ';

    public DataExtract019Lead(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractLeads();
        if (!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract021Session(dataExport));
        }
    }

    /**
    Sélection 110 enregistrements 'Lead' avec des types d'enregistrements spécifiques
    Les pistes sélectionnées sont de type :
    - 20 de type 'Formation courte'
    - 40 de type 'Formation Initiale'
    - 10 de type 'Formation intra-entreprise'
    - 10 de type 'Fundraising B2C'
    - 20 de type 'Partenariat Fundraising'
    - 10 de type 'Programme Long Diplômant'
     */
    public void extractLeads() {

        System.debug('--- BEGIN DataExtract019Lead / extractLeads() ---');

        /*
         Stockage des id des différentes pistes récupérées selon leur record type
          */
        // Sélection du quota de pistes de type 'Formation courte'
        dataExport.leadsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_LEAD,
                WHERE_RECORD_TYPE_FORMATION_COURTE, 20));

        // Sélection du quota de pistes de type 'Formation initiale'
        dataExport.leadsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_LEAD,
                WHERE_RECORD_TYPE_INITIALE, 40));

        // Sélection du quota de pistes de type 'Formation intra-entreprise'
        dataExport.leadsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_LEAD,
                WHERE_RECORD_TYPE_INTRA_ENTREPRISE, 10));

        // Sélection du quota de pistes de type 'Fundraising B2C'
        dataExport.leadsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_LEAD,
                WHERE_RECORD_TYPE_FUNDRAISING_B2C, 10));

        // Sélection du quota de pistes de type 'Partenariat Fundraising'
        dataExport.leadsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_LEAD,
                WHERE_RECORD_TYPE_PARTENARIAT_FUNDRAISING, 20));

        // Sélection du quota de pistes de type 'Programme Long Diplômant'
        dataExport.leadsToExport.addAll(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_LEAD,
                WHERE_RECORD_TYPE_PRG_LONG_DIPLOMANT, 10));

        System.debug('DataExtract019Lead LeadsToExport : ' + dataExport.leadsToExport);

        /*
         Extraction vers Csv
          */
        if ( dataExport.leadsToExport != null && !dataExport.leadsToExport.isEmpty()) {
            DataExtractUtils.extractAllFieldsSpecificRecordsToCSV('19', OBJECT_NAME_LEAD, dataExport.leadsToExport);
        } else {
            System.debug('Il n\'y a pas d\'enregistrements de pistes');
        }

        System.debug('--- END DataExtract019Lead / extractLeads() ---');
    }
}