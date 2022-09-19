/*--------------------------------------------------------------------
-- - Purpose             : Implementation of methods called by triggers on contacts.
--            
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  INC   MODIS    1.0      Initial version
-- 06/12/2018  A.DO  MODIS    1.1      Merge
--------------------------------------------------------------------*/
public class TR001ManageContact {

    public static void addErrorMembreAVie(List<Contact> contacts) {
       for (Contact c: contacts) {
		    if (c.Membre_vie__c == true) {   
		        c.adderror('Ce contact ne peux pas être supprimé car il est synchronisé avec Forever');
		 	} 
		} 
    }

    // Fonction de création d’un enregistrement « poste supplémentaire »
    public static void CreatePosteSupplementaire(List <Contact> ContactsOld, List <Contact> ContactsNew){
        Set<String> DevsNot2execSet = new Set<String>();
        DevsNot2execSet.add('TR001ManageContact');
        Pad.doNotExecuteAfterMe(DevsNot2execSet);
        
        // Déclaration de la liste qui va contenir les postes à créer
        list<Postes_Suppl_mentaires__c> posteList = new list<Postes_Suppl_mentaires__c>();
        
        Integer i = 0;
        for(Contact c : ContactsOld){
            // Condition ci-dessous ajoutée le 25/11/2016 afin d'éviter une erreur
            // lorsque le contact ne possède pas de compte associé
            if(c.AccountId!=null){
                Postes_Suppl_mentaires__c poste = new Postes_Suppl_mentaires__c();
                
                poste.Compte__c = c.AccountId;
                poste.Famille_Fonction__c = c.Famille_Fonction__c;
                poste.Fonctions__c = c.Fonctions__c;
                poste.Fonction_exacte__c = c.title;
                poste.Date_de_d_but_du_poste__c = c.Date_de_d_but__c;
                poste.Date_de_fin_du_poste__c = (c.Date_de_fin__c != null ? c.Date_de_fin__c : Date.today());
                poste.Email_Professionnel__c = c.Email_de_repli__c;
                poste.Mobile_professionnel__c = c.Mobile_professionnel__c;
                poste.Parti_de_l_entreprise__c = (ContactsOld[i].AccountId != ContactsNew[i].AccountId ? true : false);
                poste.Contact__c = c.id;
                
                i++;
                posteList.add(poste);
            }
        }
        
        // Persistence
        // Condition ci-dessous ajoutée le 25/11/2016 
        if(posteList.size()>0){
            insert posteList;
        }
    }
}