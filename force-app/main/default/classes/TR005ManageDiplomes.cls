/*--------------------------------------------------------------------
-- - Purpose             : Implementation of methods called by trigger Contact on Diplome
--            
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  INC   MODIS    1.0      Initial version
-- 16/02/2017  T.CH  MODIS    1.1      Modifié par Tom CHAMART
-- 12/02/2018  A.DO  MODIS    1.2      Recupération du getLastIdentifiantDiplomeForYear
-- 16/02/2018  T.CH  MODIS    1.3      Modification de majIdentifiantDiplome() pour Mantis 4053
--------------------------------------------------------------------*/
public class TR005ManageDiplomes {  

    // -------Initialiser les champs Nombre_de_contacts_dipl_m_s__c et Nombre_de_contacts_dipl_m_s_groupe__c à 0
    public static void initFields(List<Account> accs){
        // Parcourir les comptes et initialiser les deux compteurs à 0
        List<Account> accsToUpdate = new List<Account>();
        for (Account acc :accs)  {
            accsToUpdate.add(new Account(
                Id = acc.Id,
                Nombre_de_contacts_dipl_m_s__c = 0,
                Nombre_de_contacts_dipl_m_s_groupe__c = 0
            ));
        }
        
        // MàJ les comptes en base
        if(accsToUpdate.size()>0) 
        {
            update accsToUpdate;
        }
    }
    
    // -------Mettre à jour toutes les données de diplômés de compte depuis des contacts
    public static void updateDiplomesOfContacts(List<Contact> lCtc){
        // Lancement du traitement en Asynchrone
        AsyncUpdateNbDiplomesOfContacts AsyncUpdateNbDiplomesOfContactsJob = new AsyncUpdateNbDiplomesOfContacts(lCtc);
        ID jobAsyncUpdateAccountsID = System.enqueueJob(AsyncUpdateNbDiplomesOfContactsJob);
    }
    
    // -------Mettre à jour toutes les données de diplômés de compte depuis des comptes
    public static void updateDiplomesOfAccounts(List<Id> lAccIds){
        // Lancement du traitement en Asynchrone
        AsyncUpdateNbDiplomesOfAccounts AsyncUpdateNbDiplomesOfAccountsJob = new AsyncUpdateNbDiplomesOfAccounts(lAccIds);
        ID jobAsyncUpdateAccountsID = System.enqueueJob(AsyncUpdateNbDiplomesOfAccountsJob);      
    }
    
    // -------Mettre à jour le nombre de diplomés de chaque compte  en Asynchrone
    public static void updateAccounts(Set<Id> sAcctIds){
        List<Account> accsToUpdate = new List<Account>();
        
        // By-passer les règles de duplications
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        // Récupération des nbDiplomes des comptes
        List<Account> accs = [
            SELECT  Id,
            (SELECT Id FROM Contacts WHERE Identifiant_dipl_m__c != null)
            FROM    Account
            WHERE   Id IN :sAcctIds
        ];
        
        // MàJ le nombre de diplômés de chaque compte 
        for (Account acc :accs)  {
            accsToUpdate.add(new Account(
                Id = acc.Id,
                Nombre_de_contacts_dipl_m_s__c = acc.contacts.size()
            ));
        }
        
        // MàJ les comptes en base
        if(accsToUpdate.size()>0) 
        {
            update accsToUpdate;
        }
        
    }
    
    // -------Mettre à jour le nombre de diplomés du groupe de chaque compte en Asynchrone
    public static void updateGroupOfAccounts(Set<Id> sAcctIds){
        // By-passer les règles de duplications
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        // Liste des comptes concernés 
        List<Account> lAcct = [SELECT ComptePrincipal__c, ComptePrincipal__r.Nombre_de_contacts_dipl_m_s__c,
                               Id, Nombre_de_contacts_dipl_m_s__c,
                               (SELECT Id FROM Accounts__r LIMIT 1)
                               FROM Account 
                               WHERE Id IN :sAcctIds];
        
        // Récupération des comptes principaux
        Set<Id> sPrincipalIds = new Set<Id>();
        Map<Id,Decimal> mpNbDiplomesSansFamille = new Map<Id,Decimal>();
        // Parcourir tous les comptes concernés
        for(Account acc :lAcct){
            // Si le compte est un compte principal sans comptes dépendants
            if(acc.ComptePrincipal__c == null & acc.Accounts__r.size() == 0) {
                mpNbDiplomesSansFamille.put(acc.Id, acc.Nombre_de_contacts_dipl_m_s__c);
            } 
            // Si le compte est un compte principal
            else if (acc.ComptePrincipal__c == null & acc.Accounts__r.size() > 0){
                // Ajouter l'id du compte au set des comptes principaux concernés
                sPrincipalIds.add(acc.Id);
            }else{
                // Ajouter l'id de son compte principal au set des comptes principaux concernés
                sPrincipalIds.add(acc.ComptePrincipal__c);
            }
        }
        
        // Récupération des comptes fils des comptes principaux
        Map<Id, List<Account>> mpAcctIdChildsList = new Map<Id, List<Account>>();
        // Parcourir chaque compte filiale
        for(Account acc : [SELECT Id, ComptePrincipal__c, Nombre_de_contacts_dipl_m_s__c
                           FROM Account
                           WHERE ComptePrincipal__c IN :sPrincipalIds]){
                               // Si son compte principal n'a pas été ajouté
                               if(!mpAcctIdChildsList.containsKey(acc.ComptePrincipal__c)) {
                                   // Ajouter l'id de son compte principal en clé
                                   mpAcctIdChildsList.put(acc.ComptePrincipal__c, new List<Account>());
                               }
                               // Ajouter ce compte à la liste des enfants de son compte principal
                               mpAcctIdChildsList.get(acc.ComptePrincipal__c).add(acc);            
                           }
        
        // Récupération des nbDiplomes des comptes fils
        Map<Id,Integer> mpNbDiplomesInParent = new Map<Id,Integer>();
        Integer nbDiplomesInParent = 0;
        // Parcourir chaque compte principal
        for(Id parentId :mpAcctIdChildsList.keySet())
        {
            nbDiplomesInParent = 0;
            // Parcourir chaque filiale du compte principal
            for(Account accChild :mpAcctIdChildsList.get(parentId))
            {
                // Calculer la somme du nombre de diplomés au sein des filiales
                nbDiplomesInParent += (Integer)accChild.Nombre_de_contacts_dipl_m_s__c;
            }
            // Alimenter la map de la somme des NbDiplomes des filiales d'un compte principal
            mpNbDiplomesInParent.put(parentId, nbDiplomesInParent);
        }  
        
        // Récupération des nbDiplomes des comptes principaux
        Map<Id,Integer> mpNbDiplomesByParent = new Map<Id,Integer>();
        // Parcourir tous les comptes concernés
        for(Account acc :lAcct){
            // Si le compte est un compte principal
            if(acc.ComptePrincipal__c == null){
				// Ajouter l'id du compte principal et son nombre de diplômés
				mpNbDiplomesByParent.put(acc.Id, (Integer)acc.Nombre_de_contacts_dipl_m_s__c);
            }else{
				// Ajouter l'id du compte principal et son nombre de diplômés
				mpNbDiplomesByParent.put(acc.ComptePrincipal__c, (Integer)acc.ComptePrincipal__r.Nombre_de_contacts_dipl_m_s__c);
            }
        }
        
        // MàJ le nombre de diplomés du groupe des comptes
        Integer nbGroupe = 0; 
        List<Account> accsToUpdate = new List<Account>();
        // Si les comptes ont des enfants
        if(mpAcctIdChildsList.size() > 0){
            for(Id parentId :mpNbDiplomesInParent.keySet()){
                // Calculer le nombre de diplômés du groupe (somme des filiales + nb du compte principal)
                nbGroupe = mpNbDiplomesInParent.get(parentId) + mpNbDiplomesByParent.get(parentId);
                // MàJ le nombre de diplômés du groupe des comptes principaux
                accsToUpdate.add(new Account(
                    Id = parentId,
                    Nombre_de_contacts_dipl_m_s_groupe__c = nbGroupe
                ));
                            
                // MàJ le nombre de diplômés du groupe de chaque filiale du compte principal
                // Parcourir tous les comptes filiales concernés
                for(Account acc :mpAcctIdChildsList.get(parentId)){
                    // MàJ le nombre de diplômés du groupe de cette filiale du compte principal 
                    accsToUpdate.add(new Account(
                        Id = acc.Id,
                        Nombre_de_contacts_dipl_m_s_groupe__c = nbGroupe
                    )); 
                }
            }

            for(Id soloId :mpNbDiplomesSansFamille.keySet()){
                // MàJ le nombre de diplômés du groupe des comptes sans parent et sans enfants 
                accsToUpdate.add(new Account(
                    Id = soloId,
                    Nombre_de_contacts_dipl_m_s_groupe__c = mpNbDiplomesSansFamille.get(soloId)
                ));
            }
            
        }else{ // Si les comptes sont seuls dans leurs hierarchies
            for(Id parentId :mpNbDiplomesByParent.keySet()){
                // MàJ le nombre de diplômés du groupe grâce au seul compte de la hiérarchie 
                accsToUpdate.add(new Account(
                    Id = parentId,
                    Nombre_de_contacts_dipl_m_s_groupe__c = mpNbDiplomesByParent.get(parentId)
                ));
            }
        }


        // MàJ les comptes en base
        if(accsToUpdate.size()>0)  
        {
            Database.update(accsToUpdate,dml);
        }
    }
    
    // Fait par Mahmoud BECHAA
    public static void majDateContact(Set<Id> mDipl){
        
        // on va récupérer pour ces enregistrements l'id du contact associé
        // et on le stocke dans une liste
        List<Dipl_me__c> lDipl = [select id, Contact__c from Dipl_me__c where id in : mDipl];
        Set<Id> sContacts = new Set<Id>();
        
        // on initialise un tableau d'id des contacts dans lequel on stocke tous les contacts
        // auquel a été ajouté ou modifié un diplôme
        for(Dipl_me__c d : lDipl){
            
            sContacts.add(d.Contact__c);
            
        }
        
        // on parcours les contacts associés à chaque diplôme 
        // et on met à jour la date de modification avec la date du jour.
        List<Contact> lContacts = [select id, Date_Modification_Fiche__c  from contact where id in : sContacts];
        
        for(Contact c : lContacts){
            
            c.Date_Modification_Fiche__c = System.Date.today();
            
        }
        
        update lContacts;   
    }

    public static void majIdentifiantDiplome(List<Dipl_me__c> lNewDiplomes) {
        List<Dipl_me__c> lDiplomeCandidats = new List<Dipl_me__c>();
        Set<Id> sContactToUpdateId = new Set<Id>();

        //    Si le contact n'a pas d'identifiant 
        // ET Si le diplôme possède une promo de sortie
        for (Dipl_me__c newDiplome : lNewDiplomes) {
            if (newDiplome.Contact__r.Identifiant_dipl_m__c == null && newDiplome.Promo_de_sortie__c != null){
                // Récupération de l'id du contact
                sContactToUpdateId.add(newDiplome.Contact__c);

                // Récupération du diplôme pour le parcourir
                lDiplomeCandidats.add(newDiplome);
            }else{
            }
        }

        // Génération et mise à jour de l'identifiant diplômé
        if(sContactToUpdateId.size() > 0){
            Map<String, Integer> mYearIdentifiantDiplome = new Map<String, Integer>();
            List<Contact> lContactToUpdate = new List<Contact>();
            
            // Récuparation des contacts
            Map<Id, Contact> mContacts = new Map<Id, Contact>([SELECT Id,Identifiant_dipl_m__c
                                                               FROM Contact 
                                                               WHERE Id IN :sContactToUpdateId
            ]);

            // Génération de l'identifiant diplômé
            for (Dipl_me__c diplome : lDiplomeCandidats) {
                Contact contact = mContacts.get(diplome.Contact__c);
                Integer lastIdentifiantDiplome = null;

                if (contact.Identifiant_dipl_m__c == null) {
                    // Recupération du dernier identifiant diplômé connu
                    lastIdentifiantDiplome = (mYearIdentifiantDiplome.containsKey(diplome.Promo_de_sortie__c))
                        ? mYearIdentifiantDiplome.get(diplome.Promo_de_sortie__c) + 1
                        : getLastIdentifiantDiplomeOfYear(diplome.Promo_de_sortie__c);
                    
                    // Sauvegarde pour le prochain diplome dans la map par rapport a l'année
                    mYearIdentifiantDiplome.put(diplome.Promo_de_sortie__c, lastIdentifiantDiplome);

                    // Affectation de l'identifiant diplômé
                    contact.Identifiant_dipl_m__c = String.valueOf(lastIdentifiantDiplome);
                    lContactToUpdate.add(contact);
                }
            }

            // MàJ des contacts
            if (lContactToUpdate.size() > 0) {
                update lContactToUpdate;
            }
        }        
    }

    public static Integer getLastIdentifiantDiplomeOfYear(String yearDiplome) {
        // Recupération du Identifiant_dipl_m__c le plus grand pour l'année yearDiplome
        List<Contact> lastIdentifiantDiplomeForYear = [
            SELECT Id, Identifiant_dipl_m__c
            FROM Contact
            WHERE Identifiant_dipl_m__c LIKE :yearDiplome + '%'
            ORDER BY Identifiant_dipl_m__c DESC
            LIMIT 1
        ];

        // Si aucun Identifiant_dipl_m__c n'est retourné
        if (   lastIdentifiantDiplomeForYear.size() == 0
            || lastIdentifiantDiplomeForYear[0].Identifiant_dipl_m__c == null) {
            // Retourner le premier identifiant de l'année yearDiplome
            return Integer.valueOf(yearDiplome + '0000');
        }else{
            //Retourner l'identifiant incrémenté de 1
            return  Integer.valueOf(lastIdentifiantDiplomeForYear[0].Identifiant_dipl_m__c) + 1;
        }        
    }

    public static void updateComptePrincipalAfterUpdate(Map<Id,Account> OldMapData, Map<Id,Account> mpAcctModifies){
        List<Account> listToUpdate = new List<Account>();
        
        // Récupérer l'ancien et le nouveau compte principal
        // de chaque compte concernés
        Map<Id,Id> mpConversionComptePrincipal = new Map<Id,Id>();
        // Parcourir chaque compte modifié
        for(Account acc : mpAcctModifies.values()){
            // Si le compte avait un compte principal et en a toujours un
            if(OldMapData.get(acc.Id).ComptePrincipal__c != null && acc.ComptePrincipal__c !=null){
            	// Charger une map avec en clé l'ancien compte principal du compte 
                // et en valeur le compte principal de son nouveau parent
                mpConversionComptePrincipal.put(OldMapData.get(acc.Id).ComptePrincipal__c, acc.ComptePrincipal__c);    
            }else if(OldMapData.get(acc.Id).ComptePrincipal__c != null && acc.ComptePrincipal__c == null){ // Si le compte est devenu compte principal
                // Charger une map avec en clé l'ancien compte principal du compte 
                // et en valeur le compte
                mpConversionComptePrincipal.put(OldMapData.get(acc.Id).ComptePrincipal__c,acc.Id);
            }
            
            // Le compte principal du compte modifié est réaffecté dans le AccountBeforeUpdate
        }
        
        // Récupérer la hiérarchie complète des comptes concernés
        List<Account> lAccs = [
            SELECT 
            Id, ParentId, ComptePrincipal__c,
            Parent.ParentId, 
            Parent.Parent.ParentId,
            Parent.Parent.Parent.ParentId,
            Parent.Parent.Parent.Parent.ParentId,
            Parent.Parent.Parent.Parent.Parent.ParentId
            FROM Account
            WHERE ComptePrincipal__c IN: mpConversionComptePrincipal.keySet()
        ];
                
        // Réaffecter le compte principal des filiales des comptes modifiés
        // Parcourir chaque filiale concerné par les comptes modifiés
        for(account acc : lAccs){
            // Si son parent est un des comptes modifiés
            if(acc.ParentId != null && mpAcctModifies.containsKey(acc.ParentId)){
                // Assigner le nouveau compte principal correspondant à son ancien
                acc.ComptePrincipal__c = mpConversionComptePrincipal.get(acc.ComptePrincipal__c);
                listToUpdate.add(acc);
            }else{
                // Si le parent de son parent est un des comptes modifiés
                if(acc.Parent.ParentId != null && mpAcctModifies.containsKey(acc.Parent.ParentId)){
                    // Assigner le nouveau compte principal correspondant à son ancien
                    acc.ComptePrincipal__c = mpConversionComptePrincipal.get(acc.ComptePrincipal__c);
                    listToUpdate.add(acc);                
                }else{
                    // ...
                    if(acc.Parent.Parent.ParentId != null && mpAcctModifies.containsKey(acc.Parent.Parent.ParentId)){
                        acc.ComptePrincipal__c = mpConversionComptePrincipal.get(acc.ComptePrincipal__c);
                        listToUpdate.add(acc);                
                    }else{
                        if(acc.Parent.Parent.Parent.ParentId != null && mpAcctModifies.containsKey(acc.Parent.Parent.Parent.ParentId)){
                            acc.ComptePrincipal__c = mpConversionComptePrincipal.get(acc.ComptePrincipal__c);
                            listToUpdate.add(acc);                
                        }else{
                            if(acc.Parent.Parent.Parent.Parent.ParentId != null && mpAcctModifies.containsKey(acc.Parent.Parent.Parent.Parent.ParentId)){
                                acc.ComptePrincipal__c = mpConversionComptePrincipal.get(acc.ComptePrincipal__c);
                                listToUpdate.add(acc); 
                            }	               
                        }
                    } 
                } 
            }    
        }
        
        update listToUpdate;        
    } // Fin updateComptePrincipal

    public static Set<Id> updateHierarchyBeforeDelete(Map<Id,Account> OldMapData){        
        // Récupérer les Ids des comptes principaux des comptes supprimés
        Set<Id> sComptePrincipal = new Set<Id>();
        for(Account acc:OldMapData.values()){
            // Si le compte avait un compte principal
            if(acc.ComptePrincipal__c!=null){
                // Ajouter son compte principal à la liste
            	sComptePrincipal.add(acc.ComptePrincipal__c);    
            }else{
                // L'ajouter à la liste
                sComptePrincipal.add(acc.Id);
            }			
        }
        
        
        // Liste des comptes filiales des comptes supprimés
        List<Account> lAccs = [
            SELECT Id, ParentId,
            Parent.ParentId, 
            Parent.Parent.ParentId,
            Parent.Parent.Parent.ParentId,
            Parent.Parent.Parent.Parent.ParentId,
            Parent.Parent.Parent.Parent.Parent.ParentId
            FROM Account
            WHERE ComptePrincipal__c IN :sComptePrincipal
            OR ID in :OldMapData.keyset()
        ];
        
        // Retirer les comptes supprimés de la liste des comptes principaux pour update
        sComptePrincipal.removeAll(OldMapData.keySet());
        
        // Actualiser le compte principal de chaque compte        
        List<Account> listToUpdate = new List<Account>();
        for(Account accFiliale :lAccs){
            if(accFiliale.ParentId != null && OldMapData.containsKey(accFiliale.ParentId)){
            	// Désaffecter le ComptePrincipal du nouveau compte principal
                accFiliale.ComptePrincipal__c = null;
                listToUpdate.add(accFiliale);
            }
            
            // Si le parent du parent de la filiale est un compte supprimé
            if(accFiliale.ParentId != null && OldMapData.containsKey(accFiliale.Parent.ParentId)){
                // Affecter le parent du compte en compte principal
                accFiliale.ComptePrincipal__c = accFiliale.ParentId;
                // Ajouter le compte principal à la liste pour recalcule des nb
                sComptePrincipal.add(accFiliale.ComptePrincipal__c);
                listToUpdate.add(accFiliale);
            }else{
                // Si le parent du parent du parent de la filiale est un compte supprimé
                if(accFiliale.Parent.ParentId != null && OldMapData.containsKey(accFiliale.Parent.Parent.ParentId)){
                    accFiliale.ComptePrincipal__c = accFiliale.Parent.ParentId;
                    sComptePrincipal.add(accFiliale.ComptePrincipal__c);
                    listToUpdate.add(accFiliale); 
                }else{
                    if(accFiliale.Parent.Parent.ParentId != null && OldMapData.containsKey(accFiliale.Parent.Parent.Parent.ParentId)){
                        accFiliale.ComptePrincipal__c = accFiliale.Parent.Parent.ParentId;
                    	sComptePrincipal.add(accFiliale.ComptePrincipal__c);    
                        listToUpdate.add(accFiliale); 
                    }else{
                        if(accFiliale.Parent.Parent.Parent.ParentId != null && OldMapData.containsKey(accFiliale.Parent.Parent.Parent.Parent.ParentId)){
                            accFiliale.ComptePrincipal__c = accFiliale.Parent.Parent.Parent.ParentId;
                            sComptePrincipal.add(accFiliale.ComptePrincipal__c);
                            listToUpdate.add(accFiliale); 
                        }    
                    }     
                }     
            }
        }    
        
        // Mettre à jour les filiales des comptes supprimés
        update listToUpdate;
        
        // Retourner les nouveaux et anciens comptes principaux
        // pour MàJ les hiérarchies correspondantes
        return sComptePrincipal;
    }
}