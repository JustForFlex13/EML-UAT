/*--------------------------------------------------------------------
-- - Purpose             : Trigger on Contact
--            
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  -------------------------------
-- 06/12/2017  A.DO  MODIS    1.0      Fusion Trigger Contact
--------------------------------------------------------------------*/
trigger ContactTrigger on Contact (after delete, before delete, after insert, before insert, after update, before update, after undelete) {
	if (Trigger.isBefore && Trigger.isInsert) {
		if(PAD.canTrigger('Utils')){
			// Déclaration de la liste qui va contenir les contacts modifiés
			List <Contact> ContactsNew= new List <Contact>();

			// on crée une liste des départements en dehors de la boucle d'enregistrements
			// pour la màj automatique du dpt en fonction du code postal saisi
			List<D_partement__c> listDpt = [select id, Code_d_partement__c from D_partement__c];
			for (Contact con : Trigger.new) {

				if (con.Conversion_Contact__c=='Prospect Etudiant')		con.RecordTypeID=Label.RecordTypeProspectEtudiant;
				else if (con.Conversion_Contact__c=='Professionnel')	con.RecordTypeID=Label.RecordTypeProfessionnel;
				else if (con.Conversion_Contact__c=='Etudiant')			con.RecordTypeID= Label.RecordTypeEtudiant; 

				// mise en forme casse du nom et prénom
				Utils.contactToUpper(con);
				ContactsNew.add(con);  
			}
			
			if (ContactsNew.Size() > 0) {
				Utils.setDptContact(ContactsNew);
			}
		}	  
	}// End BeforeInsert

	if (Trigger.isAfter && Trigger.isInsert){
		if (PAD.canTrigger('TR005ManageDiplomes')){
			if(Trigger.New.size() > 0 ){
				// Mettre à jour le nombre de diplômés de chaque compte et de leur groupe
                TR005ManageDiplomes.updateDiplomesOfContacts(Trigger.New);  
			}
		}
	}// End AfterInsert

	if (Trigger.isBefore && Trigger.isUpdate) {
		// Déclaration de la liste qui va contenir les contacts modifiés
		List<Contact> ContactsOld= new List <Contact>();
		List<Contact> ContactsNew= new List <Contact>();
		// on crée une liste des départements en dehors de la boucle d'enregistrements
		// pour la màj automatique du dpt en fonction du code postal saisi
		List<Contact> ContactsUpdtDpt = new List<Contact>();
		
		if (PAD.canTrigger('Utils')){
			for (integer i=0;i<Trigger.new.size();i++){
				ContactsUpdtDpt.add(Trigger.new[i]);
				// formatage nom et prénom en majuscules
				Utils.contactToUpper(Trigger.new[i]);
				if('Professionnel'.equalsIgnoreCase(Trigger.new[i].Statut__c) ||
					'Professionnel'.equalsIgnoreCase(Trigger.old[i].Statut__c) ) {
						System.debug('###new' + Trigger.new[i].Famille_Fonction__c);
						System.debug('###old' + Trigger.old[i].Famille_Fonction__c);

					if(Trigger.new[i].AccountId != Trigger.old[i].AccountId||Trigger.new[i].Famille_Fonction__c!= Trigger.old[i].Famille_Fonction__c||Trigger.new[i].Fonctions__c!= Trigger.old[i].Fonctions__c)
					{             
						ContactsOld.add(Trigger.old[i]);
						ContactsNew.add(Trigger.new[i]);
					}
				}
			}
			if(ContactsUpdtDpt.size()>0){      
				Utils.setDptContact(ContactsUpdtDpt);
			}
		}	
		if (PAD.canTrigger('TR001ManageContact')){
			// Vérifier que la liste des contacts n'est pas vide,
			// puis lancer le traitement sur la liste des contacts
			if(ContactsOld.size()>0){
				TR001ManageContact.CreatePosteSupplementaire(ContactsOld,ContactsNew);
			}
		}
	}// End BeforeUpdate
	
	if (Trigger.isAfter && Trigger.isUpdate) {
		if (PAD.canTrigger('TR005ManageDiplomes')){
			// Vérifier si le champ Identifiant_dipl_m__c a été modifié
			List<Contact> ctcsToUpdate = new List<Contact>();
			List<Id> acctsIdToUpdate = new List<Id>();

			for (Contact cNew : Trigger.New) {
				// Si le champ Identifiant_dipl_m__c a été modifié
				if (Trigger.oldMap.get(cNew.Id).Identifiant_dipl_m__c != cNew.Identifiant_dipl_m__c) {
					// Ajouter le contact à la liste de MàJ
					ctcsToUpdate.add(cNew);
				}
				
				// Si le champ Account a été modifié
				if (Trigger.oldMap.get(cNew.Id).AccountId != cNew.AccountId) {
					// Ajouter l'ancien et le nouveau compte à la liste de MàJ
					acctsIdToUpdate.add(Trigger.oldMap.get(cNew.Id).AccountId);
					acctsIdToUpdate.add(cNew.AccountId);
				}
			}

			if(ctcsToUpdate.size() != 0){        
				// Mettre à jour le nombre de diplômés de chaque compte et de leur groupe
		    	TR005ManageDiplomes.updateDiplomesOfContacts(ctcsToUpdate);   
			}
			
			if(acctsIdToUpdate.size() != 0){
				// Mettre à jour les anciens et nouveaux comptes des contacts modifiés par leurs comptes
                TR005ManageDiplomes.updateDiplomesOfAccounts(acctsIdToUpdate); 
			}
		}
	}// End AfterUpdate

	if (Trigger.isBefore && Trigger.isDelete) {
		TR001ManageContact.addErrorMembreAVie(Trigger.Old);
	}// End BeforeDelete

	if (Trigger.isAfter && Trigger.isDelete){
		if(Trigger.Old.size() > 0 ){
			// Mettre à jour le nombre de diplômés de chaque compte et de leur groupe
            TR005ManageDiplomes.updateDiplomesOfContacts(Trigger.Old);
		}
	}// End AfterDelete

	if (Trigger.isAfter && Trigger.isUndelete){
		if(Trigger.New.size() > 0 ){
			// Mettre à jour le nombre de diplômés de chaque compte et de leur groupe
            TR005ManageDiplomes.updateDiplomesOfContacts(Trigger.New);
		}
	}// End AfterUndelete
}