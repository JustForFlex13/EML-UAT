/**
 * Created by Julie NGUYEN - Modis on 23/02/2017.
 */

public class DataExtract011Formation implements Queueable {

    public static final String OBJECT_NAME_FORMATION = 'Formation__c';

    public DataToExport dataExport{
        public get;
        public set;
    }

    public DataExtract011Formation(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractFormations();

        if(!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract013Diplome(dataExport));
        }
    }

    /**
    Extraction des formations liées aux contacts déjà traités
     */
    public void extractFormations() {

        System.debug('--- BEGIN DataExtract011Formation / extractFormations() ---');

        if (!dataExport.contactsToExport.isEmpty() && dataExport.contactsToExport != null) {

            selectAtLeastAQuotaAndRelatedRecords(100, dataExport);

            String whereClauseWithContacts = ' WHERE Contact__c IN ' + DataExtractUtils.convertSetToString(dataExport.contactsToExport);

            System.debug('--PARAM whereClause for query : ' + whereClauseWithContacts);

            DataExtractUtils.extractAllFieldWithSpecificWhereClause('11', OBJECT_NAME_FORMATION, whereClauseWithContacts);

        } else {
            System.debug('Il n\'y a pas de formations liées aux contacts déjà traités');
        }

        System.debug('--- END DataExtract011Formation / extractFormations() ---');
    }

    /**
     Récupération de contacts supplémentaires avec une formation liée pour être sûr d'avoir au moins un certain nombre
     de formations. Puis récupération des comptes associés à ces contacts
     */
    private static void selectAtLeastAQuotaAndRelatedRecords(Integer quota, DataToExport dataExport) {
        Set<Id> conIds = new Set<Id>();
        // Sélection de contacts dont le compte n'a pas de parent pour faciliter la manipulation des fichiers CSV
        for (Formation__c f : [SELECT Id, Contact__c FROM Formation__c
                                    WHERE Contact__r.Account.ParentId = null
                                    AND Contact__r.Account.TECH_External_Id__c != null
                                    AND Contact__r.TECH_External_Id__c != null
                                    ORDER BY CreatedDate DESC LIMIT :quota]) {
            conIds.add(f.Contact__c);
        }

        /* Ajout des nouveaux contacts à contactsToBeExportedRelatedToMinimalQuotas pour pouvoir être extraits
        dans un autre fichier CSV mais aussi à contactsToExport afin de continuer à extraire des enregistrements liés
         */
        if (conIds != null && !conIds.isEmpty()) {
            dataExport.contactsToBeExportedRelatedToMinimalQuotas.addAll(conIds);
            dataExport.contactsToExport.addAll(conIds);

            DataExtractUtils.selectAccountsRelatedToContacts(conIds, dataExport);
        }
    }
}