({
	saveSection: function(component, event, helper){
		component.find('editEntreprise').get("e.recordSave").fire();
	},
	saveFrenchCompany: function(component, event, helper){
		component.set("v.monEntrepriseSave.SIRET__c", 							component.get("v.selectedCompany.siret"));
		component.set("v.monEntrepriseSave.Nom_Entreprise__c", 					component.get("v.selectedCompany.uniteLegale.denominationUniteLegale"));
        component.set("v.monEntrepriseSave.Adresse_Entreprise__c", 				 (component.get("v.selectedCompany.adresseEtablissement.numeroVoieEtablissement")      == null?"":    component.get("v.selectedCompany.adresseEtablissement.numeroVoieEtablissement"))
                      															+(component.get("v.selectedCompany.adresseEtablissement.indiceRepetitionEtablissement")== null?"":    component.get("v.selectedCompany.adresseEtablissement.indiceRepetitionEtablissement")) 
                      															+(component.get("v.selectedCompany.adresseEtablissement.typeVoieEtablissement")        == null?"":" "+component.get("v.selectedCompany.adresseEtablissement.typeVoieEtablissement")) 
                      															+" "
                                                                                + component.get("v.selectedCompany.adresseEtablissement.libelleVoieEtablissement"));
		component.set("v.monEntrepriseSave.Pays2__c", 							"FR");
        
		component.set("v.monEntrepriseSave.Code_Postal__c", 					component.get("v.selectedCompany.adresseEtablissement.codePostalEtablissement"));
		component.set("v.monEntrepriseSave.Ville__c", 							component.get("v.selectedCompany.adresseEtablissement.libelleCommuneEtablissement"));
		component.set("v.monEntrepriseSave.Tranche_effectif_etablissement__c", 	component.get("v.selectedCompany.trancheEffectifsEtablissement"));
		component.set("v.monEntrepriseSave.code_NAF__c", 						component.get("v.selectedCompany.uniteLegale.activitePrincipaleUniteLegale"));
	},
	handleLocalisationToggle: function(component, event, helper){
		console.log("firing localistation toggle event");
		component.getEvent("localistationToggle").fire();
	},
})