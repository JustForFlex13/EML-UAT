/**
 * Created by Julie NGUYEN - Modis on 07/03/2017.
 */

public class DataExtract023ContactAssoOpp implements Queueable {

    public static String OBJECT_NAME_CONTACT_ASSO_OPP = 'Contact_associ_s_l_opportunit__c';

    private DataToExport dataExport;

    public DataExtract023ContactAssoOpp(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractContactsAssoToOpp();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract024PartenaireFinanceur(dataExport));
        }
    }

    /**
    Extraction des contacts associés à des opportunités et reliés aux enregistrements déjà traités parmi les objets :
    - Contact
    - Opportunity
     */
    public void extractContactsAssoToOpp() {
        System.debug('--- BEGIN DataExtract023ContactAssoOpp / extractContactsAssoToOpp() ---');
        if ( ( dataExport.contactsToExport != null && !dataExport.contactsToExport.isEmpty() )
                &&  ( dataExport.opportunitiesToExport != null && !dataExport.opportunitiesToExport.isEmpty() ) ) {

            selectAtLeastAQuotaAndRelatedRecords(20, dataExport);

            String clause = ' WHERE Contact__c IN ' + DataExtractUtils.convertSetToString(dataExport.contactsToExport) +
                    ' AND Opportunit__c IN ' + DataExtractUtils.convertSetToString(dataExport.opportunitiesToExport)
            ;

            System.debug('-- PARAM String clause : ' + clause);

            DataExtractUtils.extractAllFieldWithSpecificWhereClause('18', OBJECT_NAME_CONTACT_ASSO_OPP, clause);
        } else {
            System.debug('Il n\'y a pas de contacts associés à des opportunités parmi les contacs et les ' +
                    'opportunités déjà traités');
        }

        System.debug('--- END DataExtract023ContactAssoOpp / extractContactsAssoToOpp() ---');
    }

     /**
     Récupération de contacts supplémentaires avec une formation liée pour être sûr d'avoir au moins un certain nombre
     de formations. Puis récupération des comptes associés à ces contacts
     */
    private static void selectAtLeastAQuotaAndRelatedRecords(Integer quota, DataToExport dataExport) {
        Set<Id> conIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        // Sélection de contacts dont le compte n'a pas de parent pour faciliter la manipulation des fichiers CSV
        for (Contact_associ_s_l_opportunit__c c : [SELECT Id, Contact__c, Opportunit__c FROM Contact_associ_s_l_opportunit__c
                                    WHERE Contact__r.Account.ParentId = null
                                    AND Contact__r.Account.TECH_External_Id__c != null
                                    AND Contact__r.TECH_External_Id__c != null
                                    ORDER BY CreatedDate DESC LIMIT :quota]) {
            conIds.add(c.Contact__c);
            oppIds.add(c.Opportunit__c);
        }

        /* Ajout des nouveaux contacts à contactsToBeExportedRelatedToMinimalQuotas pour pouvoir être extraits
        dans un autre fichier CSV mais aussi à contactsToExport afin de continuer à extraire des enregistrements liés
         */
        if (conIds != null && !conIds.isEmpty()) {
            dataExport.contactsToBeExportedRelatedToMinimalQuotas.addAll(conIds);
            dataExport.contactsToExport.addAll(conIds);
        }

        /* Ajout des nouvelles opportunités à opportunitiesToBeExportedRelatedToMinimalQuotas pour pouvoir être extraits
        dans un autre fichier CSV mais aussi à opportunitiesToExport afin de continuer à extraire des enregistrements liés
        */
        if (oppIds != null && !oppIds.isEmpty()) {
            dataExport.opportunitiesToBeExportedRelatedToMinimalQuotas.addAll(oppIds);
            dataExport.opportunitiesToExport.addAll(oppIds);
        }
    }
}