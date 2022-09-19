/**
 * Created by Julie NGUYEN - Modis on 07/03/2017.
 */

public class DataExtract024PartenaireFinanceur implements Queueable {

    public static final String OBJECT_NAME_PARTENAIRE_FINANCEUR = 'Partenaire_financeur__c';

    private DataToExport dataExport;

    public DataExtract024PartenaireFinanceur(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractPartenairesFinanceurs();
        if ( !Test.isRunningTest() ) {
            System.enqueueJob(new DataExtract026ContactsAfterQuotas(dataExport));
        }
    }

    /**
    Extraction des partenaires financeurs reliés aux enregistrements déjà traités parmi les objets :
    - Account
    - Opportunity
     */
    public void extractPartenairesFinanceurs() {
        System.debug('--- BEGIN DataExtract024PartenaireFinanceur / extractPartenairesFinanceurs() ---');

        if ( ( dataExport.accountsToExport != null && !dataExport.accountsToExport.isEmpty() ) &&
                ( dataExport.opportunitiesToExport != null && !dataExport.opportunitiesToExport.isEmpty() ) ) {

            selectAtLeastAQuotaAndRelatedRecords(20, dataExport);

            String clause = ' WHERE Compte_financeur__c IN ' + DataExtractUtils.convertSetToString(dataExport.accountsToExport) +
                    ' AND Opportunite_financee__c IN ' + DataExtractUtils.convertSetToString(dataExport.opportunitiesToExport)
            ;

            System.debug('-- PARAM String clause : ' + clause);

            DataExtractUtils.extractAllFieldWithSpecificWhereClause('20', OBJECT_NAME_PARTENAIRE_FINANCEUR, clause);
        } else {
            System.debug('Il n\'y a pas de comptes associés à des opportunités parmi les comptes et les ' +
                    'opportunités déjà traités');
        }

        System.debug('--- END DataExtract024PartenaireFinanceur / extractPartenairesFinanceurs() ---');
    }

    /**
    Sélection d'un quota minimum de partenaires financeurs, et des opportunités et conmpts associés
     */
    private static void selectAtLeastAQuotaAndRelatedRecords(Integer quota, DataToExport dataExport) {
        Set<Id> accIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        // Sélection de comptes qui n'ont pas de compte parent pour faciliter la manipulation des fichiers CSV
        for (Partenaire_financeur__c p : [SELECT Id, Compte_financeur__c, Opportunite_financee__c
                                                FROM Partenaire_financeur__c
                                                WHERE Opportunite_financee__r.Contact_central__c = null
                                                AND Compte_financeur__r.ParentId = null
                                                AND Compte_financeur__r.TECH_External_Id__c != null
                                                AND Opportunite_financee__r.TECH_External_Id__c != null
                                                ORDER BY CreatedDate DESC
                                                LIMIT :quota]) {
            accIds.add(p.Compte_financeur__c);
            oppIds.add(p.Opportunite_financee__c);
        }

        /* Ajout des nouveaux comptes à accountsToBeExportedRelatedToMinimalQuotas pour pouvoir être extraits
        dans un autre fichier CSV mais aussi à accountsToExport afin de continuer à extraire des enregistrements liés
        */
        dataExport.accountsToBeExportedRelatedToMinimalQuotas.addAll(accIds);
        dataExport.accountsToExport.addAll(accIds);

        /* Ajout des nouvelles opportunités à opportunitiesToBeExportedRelatedToMinimalQuotas pour pouvoir être extraits
        dans un autre fichier CSV mais aussi à opportunitiesToExport afin de continuer à extraire des enregistrements liés
        */
        dataExport.opportunitiesToBeExportedRelatedToMinimalQuotas.addAll(oppIds);
        dataExport.opportunitiesToExport.addAll(oppIds);
    }
}