/**
 * Created by Julie NGUYEN - Modis on 28/02/2017.
 */

public class DataExtract013Diplome implements Queueable {

    public static final String OBJECT_NAME_DIPLOME = 'Dipl_me__c';

    private DataToExport dataExport;

    public DataExtract013Diplome(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractDiplomes();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract014Role(dataExport));
        }
    }

    /**
    Extraction des diplômes liés aux contacts déjà traités
     */
    public void extractDiplomes() {

        System.debug('--- BEGIN DataExtract013Diplome / extractDiplomes() ---');

        if ( dataExport.contactsToExport != null && !dataExport.contactsToExport.isEmpty() ) {

            selectAtLeastAQuotaAndRelatedRecords(100, dataExport);

            String whereClause = ' WHERE Contact__r.TECH_External_Id__c != null AND ' +
                    ' Contact__c IN ' + DataExtractUtils.convertSetToString(dataExport.contactsToExport);

            System.debug('--PARAM whereClause for query : ' + whereClause);

            DataExtractUtils.extractAllFieldWithSpecificWhereClause('12', OBJECT_NAME_DIPLOME, whereClause);
        } else {
            System.debug(' Il n\'y a de diplômés parmi les contacts traités');
        }

        System.debug('--- END DataExtract013Diplome / extractDiplomes() ---');
    }

        /**
     Récupération de contacts supplémentaires avec un diplôme lié pour être sûr d'avoir au moins un certain nombre
     de diplômes. Puis récupération des comptes associés à ces contacts
     */
    private static void selectAtLeastAQuotaAndRelatedRecords(Integer quota, DataToExport dataExport) {
        System.debug('--- BEGIN DataExtract013Diplome / selectAtLeastAQuotaAndRelatedRecords() ---');

        Set<Id> conIds = new Set<Id>();
        // Sélection de contacts dont le compte n'a pas de parent pour faciliter la manipulation des fichiers CSV
        for (Dipl_me__c d : [SELECT Id, Contact__c FROM Dipl_me__c
                                    WHERE Contact__r.Account.ParentId = null
                                    AND Contact__r.Account.TECH_External_Id__c != null
                                    AND Contact__r.TECH_External_Id__c != null
                                    ORDER BY CreatedDate DESC LIMIT :quota]) {
            conIds.add(d.Contact__c);
        }

        /* Ajout des nouveaux contacts à contactsToBeExportedRelatedToMinimalQuotas pour pouvoir être extraits
        dans un autre fichier CSV mais aussi à contactsToExport afin de continuer à extraire des enregistrements liés
         */
        if (conIds != null && !conIds.isEmpty()) {
            dataExport.contactsToBeExportedRelatedToMinimalQuotas.addAll(conIds);
            dataExport.contactsToExport.addAll(conIds);

            DataExtractUtils.selectAccountsRelatedToContacts(conIds, dataExport);
        }
        System.debug('--- END DataExtract013Diplome / selectAtLeastAQuotaAndRelatedRecords() ---');
    }
}