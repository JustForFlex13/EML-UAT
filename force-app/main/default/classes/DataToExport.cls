/**
 * Created by Julie NGUYEN on 03/03/2017.
 * Classe qui permet de gérer des sets d'ID d'enregistrements à traiter afin d'en prendre d'autres reliés.
 * Pour les objets Contact, Account et Opporunity le traitement est particulier :
 *  - il y a l'étape 'ToProcess', c'est la phase de traitement d'enregistrements reliés à extraire,
 *  - puis la phase 'ToExport', une fois les enregistrements reliés sélectionnés, on peut stocker les contacts,
 *  comptes ou opportunités pour plus tard les extraire dans un fichier .csv
 */

global class DataToExport {

    // 5 boucles complètes des trois objets Account, Contact et Opportunity
    private static final Integer LIMIT_FOR_LOOP = 5 * 3;

    @TestVisible
    public Integer loopCounter {
        public get;
        private set;
    }
    public Set<Id> contactsToExport {
        public get;
        private set;
    }
    public Set<Id> contactsToProcess{
        public get;
        private set;
    }
    public set<Id> contactsToBeExportedRelatedToMinimalQuotas{
        public get;
        private set;
    }
    public Set<Id> accountsToExport{
        public get;
        private set;
    }
    public Set<Id> accountsToProcess{
        public get;
        private set;
    }
    public set<Id> accountsToBeExportedRelatedToMinimalQuotas{
        public get;
        private set;
    }
    public Set<Id> opportunitiesToExport{
        public get;
        private set;
    }
    public Set<Id> opportunitiesToProcess{
        public get;
        private set;
    }
    public set<Id> opportunitiesToBeExportedRelatedToMinimalQuotas{
        public get;
        private set;
    }
    public Set<Id> leadsToExport{
        public get;
        private set;
    }
    public Set<Id> sessionsToExport{
        public get;
        private set;
    }
    public Set<Id> etatsToExport{
        public get;
        private set;
    }
    public Set<Id> productsToExport{
        public get;
        private set;
    }

    public DataToExport() {
        this.contactsToExport = new Set<Id>();
        this.contactsToProcess = new Set<Id>();
        this.contactsToBeExportedRelatedToMinimalQuotas = new Set<Id>();
        this.accountsToExport = new Set<Id>();
        this.accountsToProcess = new Set<Id>();
        this.accountsToBeExportedRelatedToMinimalQuotas = new Set<Id>();
        this.opportunitiesToExport = new Set<Id>();
        this.opportunitiesToProcess = new Set<Id>();
        this.opportunitiesToBeExportedRelatedToMinimalQuotas = new Set<Id>();
        this.leadsToExport = new Set<Id>();
        this.sessionsToExport = new Set<Id>();
        this.etatsToExport = new Set<Id>();
        this.productsToExport = new Set<Id>();
        this.loopCounter = 0;
    }

    /**
    Méthode qui permet de limiter le nombre de boucles entre les classes Contact, Account et Opportunity
     */
    private Boolean isMaximumLoopReached() {
        loopCounter++;
        return loopCounter > LIMIT_FOR_LOOP;
    }

    /**
    Méthode qui permet de vérifier soit que le nombre de boucles maximum a été atteint, soit qu'il n'y a
    plus aucun objet compte, contact ou opportunité à traiter (tous les objets reliés à ces enregistrements
    ont été traités)
     */
    public Boolean isProcessingComplete() {
        return isMaximumLoopReached() || (contactsToProcess.isEmpty() && accountsToProcess.isEmpty()
                && opportunitiesToProcess.isEmpty());
    }

    /**
    Méthode pour ne garder que les contacts à traiter afin de prendre des objets reliés à ces contacts par la suite
     */
    public void addAllContactsToProcess(Set<Id> contactsIds) {
        if ( contactsIds != null && !contactsIds.isEmpty() ) {
            for ( Id conId : contactsIds) {
                if ( conId == null ) {
                    contactsIds.remove(conId);
                }
            }
            contactsIds.removeAll(contactsToExport);
            contactsToProcess.addAll(contactsIds);
        }
    }

    /**
    Méthode pour ne garder que les comptes à traiter afin de prendre des objets reliés à ces comptes par la suite
    */
    public void addAllAccountsToProcess(Set<Id> accountsIds) {
        if ( accountsIds != null && !accountsIds.isEmpty() ) {
            for ( Id accId : accountsIds) {
                if ( accId == null ) {
                    accountsIds.remove(accId);
                }
            }
            accountsIds.removeAll(accountsToExport);
            accountsToProcess.addAll(accountsIds);
        }
    }

    /**
    Méthode pour ne garder que les opportunités à traiter afin de prendre des objets reliés à ces opportunités par la suite
    */
    public void addAllOpportunitiesToProcess(Set<Id> oppIds) {
        if ( oppIds != null && !oppIds.isEmpty() ) {
            for ( Id oppId : oppIds) {
                if ( oppId == null ) {
                    oppIds.remove(oppId);
                }
            }
            oppIds.removeAll(opportunitiesToExport);
            opportunitiesToProcess.addAll(oppIds);
        }
    }

}