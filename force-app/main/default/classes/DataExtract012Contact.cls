/**
 * Created by Julie NGUYEN - Modis on 23/02/2017.
 */

public class DataExtract012Contact implements Queueable {

    public static final String OBJECT_NAME_CONTACT = 'Contact';

    public static DataToExport dataExp = new DataToExport();

    /**
    Clauses WHERE pour obtenir un jeu de données pertinent en filtrant les types d'enregistrements et en choisissant
    des contacts dont les comptes n'ont pas de compte parent pour faciliter la manipulation des fichiers CSV
     */
    private static final String WHERE_RECORD_TYPE_PROSPECT_ETUDIANT = ' WHERE RecordType.Name = \'Prospect Etudiant\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';
    private static final String WHERE_RECORD_TYPE_ETUDIANT = ' WHERE RecordType.Name = \'Etudiant\' ' +
            ' AND TECH_External_ID__c != null AND Account.TECH_External_Id__c != null ' +
            'AND Account.ParentId = null ' +
            'ORDER BY CreatedDate DESC ';
    private static final String WHERE_RECORD_TYPE_PROFESSIONNEL = ' WHERE RecordType.Name = \'Professionnel\' ' +
            ' AND TECH_External_ID__c != null ' +
            'AND Account.ParentId = null AND Account.TECH_External_Id__c != null ' +
            'ORDER BY CreatedDate DESC ';

    public void execute(QueueableContext context) {
        extractContacts(dataExp);
        if(!Test.isRunningTest()) {
            System.debug('-- PARAM BEFORE EnqueueJob dataToExport.contactsToProcess : ' + dataExp.contactsToProcess);
            System.enqueueJob(new DataExtract017Opportunity(dataExp));
        }
    }

    /**
    Sélection des id de 375 enregistrements 'Contact'
    Les contacts sélectionnés sont de type :
    - 125 de type 'Etudiant'
    - 125 de type 'Prospect Etudiant'
    - 125 de type 'Professionnel'
     */
    public static void extractContacts(DataToExport dataToExport) {

        System.debug('--- BEGIN DataExtract012Contact / extractContacts() ---');

        // Sélection du quota de contacts de type 'Etudiant'
        dataToExport.addAllContactsToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_CONTACT,
                WHERE_RECORD_TYPE_ETUDIANT, 125));

        // Sélection du quota de contacts de type 'Prospect Etudiant'
        dataToExport.addAllContactsToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_CONTACT,
                WHERE_RECORD_TYPE_PROSPECT_ETUDIANT, 125));

        // Sélection du quota de contacts de type 'Professionnel'
        dataToExport.addAllContactsToProcess(DataExtractUtils.extractIdsFromSpecificRecords(OBJECT_NAME_CONTACT,
                WHERE_RECORD_TYPE_PROFESSIONNEL, 125));

        System.debug('-- PARAM dataToExport.contactsToProcess : ' + dataToExport.contactsToProcess);

        System.debug('--- END DataExtract012Contact / extractContacts() ---');
    }
}