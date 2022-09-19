public class Convsta_GenerationConventionController {
  public Case demande { get; set; }
  public Convsta_Informations_Personnelles__c infoPerso { get; set; }
  public Convsta_Mission__c maMission { get; set; }
  public Convsta_Entreprise__c monEntreprise { get; set; }
  public Convsta_Conditions_Contractuelles__c monContrat { get; set; }
  public Date dateDuJour { get; set; }
  public String lieuStage { get; set; }
  public Boolean isPreviewMode { get; set; }
  public Boolean isNoCachetServeur { get; set; }
  public Boolean isCachetServeur { get; set; }
  public list<String> descriptionList { get; set; }
  public string getOutputClass() {
    return isPreviewMode
      ? 'font-weight:bold;background-color: #ffff00;'
      : 'font-weight:bold;background-color: transparent;';
  }

  public Convsta_GenerationConventionController() {
    String caseId = ApexPages.currentPage().getParameters().get('caseId');
    isPreviewMode = ApexPages.currentPage()
        .getParameters()
        .get('previewMode') == null
      ? false
      : true;

    dateDuJour = System.Date.today();

    demande = [
      SELECT
        Id,
        Convsta_Langue__c,
        Convsta_Tuteur__c,
        Convsta_Tuteur__r.Name,
        Convsta_Tuteur__r.Title,
        Responsable_administratif_entreprise__c,
        Convsta_Condition_speciales__c,
        Convsta_Table_des_Regles_Experience_Pro__r.Volume_academique_annuel__c,
        Convsta_Referent_pedagogique__r.Name,
        Convsta_Table_des_Regles_Experience_Pro__r.Afficher_logo_Paul_Bocuse__c,
        Convsta_Table_des_Regles_Experience_Pro__r.Libell_convention_en__c,
        Convsta_Table_des_Regles_Experience_Pro__r.Libell_convention_fr__c,
        Convsta_Table_des_Regles_Experience_Pro__r.Libell_convention_es__c,
        Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c,
        Convsta_Table_des_Regles_Experience_Pro__r.Programme__c,
        Convsta_DateStart__c,
        Convsta_DateEnd__c
      FROM Case
      WHERE id = :caseId
      LIMIT 1
    ];

    infoPerso = [
      SELECT Id, Nom__c, Prenom__c, Programme__c
      FROM Convsta_Informations_Personnelles__c
      WHERE MD_Demande__c = :caseId
      LIMIT 1
    ];

    maMission = [
      SELECT
        Id,
        Civilite_Tuteur_Entreprise__c,
        Nom_Tuteur_Entreprise__c,
        Prenom_Tuteur_Entreprise__c,
        Tuteur_Entreprise__c,
        Competences_a_acquerir_2__c,
        Titre_Mission__c,
        Convsta_Autre_competence__c,
        Competences_categorie_2__c,
        Convsta_Description_de_la_mission__c,
        Afficher_le_detail_dans_la_convention__c,
        Conceptualiser_et_modeliser__c,
        Demontrer_un_comportement_assertif__c,
        Elaborer_un_diagnostic__c,
        Gerer_son_stress__c,
        Gerer_son_temps_et_les_priorites__c,
        Mobiliser_differentes_sources__c,
        Precision_et_rigueur_au_travail__c,
        Qualifier_et_identifier_l_information__c
      FROM Convsta_Mission__c
      WHERE MD_Demande__c = :caseId
      LIMIT 1
    ];

    monEntreprise = [
      SELECT
        Id,
        Nom_Entreprise__c,
        Adresse_Entreprise__c,
        Code_Postal__c,
        Ville__c,
        Pays2__c,
        Civilite_Signataire_Convention__c,
        Convsta_Code_postal_du_lieu_du_stage__c,
        Convsta_Adresse_du_lieu_du_stage__c,
        Convsta_Ville_du_lieu_du_stage__c,
        Convsta_Pays_du_lieu_de_ma_mission__c,
        Assurance_complementaire__c,
        Nom_Signataire_Convention__c,
        Prenom_Signataire_Convention__c,
        Fonction_Signataire_Convention__c
      FROM Convsta_Entreprise__c
      WHERE MD_Demande__c = :caseId
      LIMIT 1
    ];
    lieuStage = (String.isBlank(
        monEntreprise.Convsta_Adresse_du_lieu_du_stage__c
      )
      ? monEntreprise.Nom_Entreprise__c +
        ' ' +
        monEntreprise.Adresse_Entreprise__c +
        ' ' +
        monEntreprise.Code_Postal__c +
        ' ' +
        monEntreprise.Ville__c +
        ' ' +
        monEntreprise.Pays2__c
      : monEntreprise.Nom_Entreprise__c +
        ' ' +
        monEntreprise.Convsta_Adresse_du_lieu_du_stage__c +
        ' ' +
        monEntreprise.Convsta_Code_postal_du_lieu_du_stage__c +
        ' ' +
        monEntreprise.Convsta_Ville_du_lieu_du_stage__c +
        ' ' +
        monEntreprise.Convsta_Pays_du_lieu_de_ma_mission__c);

    monContrat = [
      SELECT
        Id,
        Date_Debut__c,
        Date_Debut2__c,
        Date_Fin__c,
        Temps_Travail_Hebdomadaire__c,
        Travail_le_dimanche_la_nuit__c,
        Remuneration_Mensuelle__c,
        Code_Devise__c,
        Mode_de_remuneration_2__c,
        Modalites_de_versement_2__c,
        Avantages__c,
        Conges_RTT__c,
        Convsta_Type_de_remuneration__c
      FROM Convsta_Conditions_Contractuelles__c
      WHERE MD_Demande__c = :caseId
      LIMIT 1
    ];

    descriptionList = maMission.Convsta_Description_de_la_mission__c.split(
      '\n'
    );
    convsta_Esign_Config__c customSetting = convsta_Esign_Config__c.getOrgDefaults();
    if (customSetting == null) {
      customSetting = new convsta_Esign_Config__c(Activate_Esign__c = false);
    }
    isNoCachetServeur = !customSetting.Activate_Esign__c;
    isCachetServeur = customSetting.Activate_Esign__c;
          
  }
    
      public String TypeRemuneration{  
          get{
            if(demande.Convsta_Langue__c == 'Anglais'){
                if (monContrat.Convsta_Type_de_remuneration__c == 'Mensuelle') {
                    TypeRemuneration = 'monthly';
                } else if (monContrat.Convsta_Type_de_remuneration__c == 'Hebdomadaire'){
                    TypeRemuneration = 'weekly';
                }else if (monContrat.Convsta_Type_de_remuneration__c == 'Journalière'){
                    TypeRemuneration = 'hourly rate';
                }
            } else if(demande.Convsta_Langue__c == 'Espagnol'){                    
                if (monContrat.Convsta_Type_de_remuneration__c == 'Mensuelle') {
                        TypeRemuneration = 'monthly';
                    } else if (monContrat.Convsta_Type_de_remuneration__c == 'Hebdomadaire'){
                        TypeRemuneration = 'weekly';
                    }else if (monContrat.Convsta_Type_de_remuneration__c == 'Journalière'){
                        TypeRemuneration = 'tarifa horaria';
                    }
                 }else if(demande.Convsta_Langue__c == 'Français'){                    
                if (monContrat.Convsta_Type_de_remuneration__c == 'Mensuelle') {
                        TypeRemuneration = 'mensuelle';
                    } else if (monContrat.Convsta_Type_de_remuneration__c == 'Hebdomadaire'){
                        TypeRemuneration = 'hebdomadaire';
                    }else if (monContrat.Convsta_Type_de_remuneration__c == 'Journalière'){
                        TypeRemuneration = 'taux horaire';
                    }
                 }
          		return TypeRemuneration;
            }
          private set;
      }
      
}