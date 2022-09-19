/**
 * Created by Julie NGUYEN - Modis on 28/02/2017.
 */
public class DataExtract017Opportunity implements Queueable {

    public static String OBJECT_NAME_OPPORTUNITY = 'Opportunity';
    public static String FIELD_CONTACT_CENTRAL = 'Contact_central__c';
    public static String FORMATION_INITIALE_REC_TYPE = 'Formation initiale';

    /**
    Clauses WHERE pour obtenir un jeu de données pertinent en filtrant les types d'enregistrements, en s'assurant que
    les contacts et comptes liés ont leur champ TECH_External_ID rempli, et enfin en ne prenant des opportunités
    qu'en lien avec des comptes sans compte parent, pour faciliter la manipulation des fichiers CSV
     */
    private static String WHERE_REC_TYPE_FORM_COURTE = ' WHERE RecordType.Name = \'Formation courte\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null  ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_REC_TYPE_FORM_INITIALE = ' WHERE RecordType.Name = \'Formation initiale\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_REC_TYPE_FORM_INTRA_ENTREPRISE = ' WHERE RecordType.Name = \'Formation intra-entreprise\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_REC_TYPE_FUNDRAISING_B2C = ' WHERE RecordType.Name = \'Fundraising B2C\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_REC_TYPE_PARTENARIAT_FUNDRAISING = ' WHERE RecordType.Name = \'Partenariat Fundraising\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_REC_TYPE_PRG_LONG_DIPLOMANT = ' WHERE RecordType.Name = \'Programme Long Diplômant\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_REC_TYPE_RELATIONS_EMPLOYEUR = ' WHERE RecordType.Name = \'Relations employeur\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static String WHERE_REC_TYPE_TAXE = ' WHERE RecordType.Name = \'Taxe\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Contact_central__r.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';

    public DataToExport dataExport{
        public get;
        public set;
    }

    public DataExtract017Opportunity(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractOpportunities();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract018Account(dataExport));
        }
    }

    /**
    Sélection d'enregistrements "Opportunity". Les quotas sont :
    - 100 Opportunités de type 'Formation courte'
    - 150 Opportunités de type 'Formation initiale'
    - 50 Opportunités de type 'Formation intra-entreprise'
    - 50 Opportunités de type 'Fundraising B2C'
    - 100 Opportunités de type 'Partenariat Fundraising'
    - 50 Opportunités de type 'Programme Long Diplômant'
    - 75 Opportunités de type 'Relations employeur'
    - 75 Opportunités de type 'Taxe'
     */
    public void extractOpportunities() {

        System.debug('--- BEGIN DataExtract017Opportunity / extractOpportunities() ---');

        System.debug('-- PARAM : dataExport.contactsToProcess from previous class : ' + dataExport.contactsToProcess);

        // Sélection du quota d'opportunités de type 'Formation courte'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_FORM_COURTE, 100));

        // Sélection du quota d'opportunités de type 'Formation initiale'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_FORM_INITIALE, 150));

        // Sélection du quota d'opportunités de type 'Formation intra-entreprise'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_FORM_INTRA_ENTREPRISE, 50));

        // Sélection du quota d'opportunités de type 'Fundraising B2C'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_FUNDRAISING_B2C, 50));

        // Sélection du quota d'opportunités de type 'Partenariat Fundraising'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_PARTENARIAT_FUNDRAISING, 100));

        // Sélection du quota d'opportunités de type 'Programme Long Diplômant'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_PRG_LONG_DIPLOMANT, 50));

        // Sélection du quota d'opportunités de type 'Relations employeur'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_RELATIONS_EMPLOYEUR, 75));

        // Sélection du quota d'opportunités de type 'Taxe'
        dataExport.addAllOpportunitiesToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_OPPORTUNITY,
                WHERE_REC_TYPE_TAXE, 75));


        System.debug('-- PARAM dataExport.opportunitiesToProcess : ' + dataExport.opportunitiesToProcess);

        System.debug('--- END DataExtract017Opportunity / extractOpportunities() ---');
    }
}