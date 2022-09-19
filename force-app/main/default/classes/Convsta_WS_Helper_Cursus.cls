/*-------------------------------------------------------------------
-- - Purpose : Helper for Convsta's WebServices
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- 20/05/2018  Y.GA  MODIS       1.0      Initial version
--------------------------------------------------------------------*/
public without sharing class Convsta_WS_Helper_Cursus {
  public class checkStrictTotalDataStructure {
    public Boolean allDataOK = false;
    public Boolean entrepriseOK = false;
    public Boolean missionOK = false;
    public Boolean contratOK = false;
    public Boolean respPedagoOK = false;
    public Boolean respEntrOK = false;
    public Boolean tuteurEntrOK = false;
    public Boolean stageOK = false;

    public Boolean isAvenantOK = false;
    public Boolean avenantTuteurEntrOK = false;
    public Boolean avenantGratifOK = false;
    public Boolean avenantAdresseEntrOK = false;
    public String message = '';
  }
  public class checkStrictEvaluationDataStructure {
    public Boolean allDataOK = false;
    public Boolean hasEtudiant = false;
    public Boolean hasEtudiantLastName = false;
    public Boolean hasEtudiantFirstName = false;
    public Boolean hasNoteGlobale = false;
    public Boolean hasDateReceptionEval = false;
    public Boolean hasPhase = false;
    public String message = '';
  }

  @AuraEnabled
  public static Case getStage(Id caseId) {
    Case stage;
    Case checkCaseType = [
      SELECT Id, RecordType.DeveloperName
      FROM Case
      WHERE Id = :caseId
    ];
    Boolean isAvenant = checkCaseType.RecordType.DeveloperName.equalsIgnoreCase(
      'Convsta_Avenant'
    );
    if (!isAvenant) {
      stage = [
        SELECT
          Id,
          RecordType.DeveloperName,
          Convsta_DateStart__c,
          Convsta_DateEnd__c,
          Convsta_Type_de_demande__c,
          Convsta_TypeContrat__c,
          Origin,
          Convsta_Langue__c,
          Date_Reception_Convention__c,
          Convsta_Entreprise__c,
          Convsta_Entreprise__r.Name,
          Convsta_Entreprise__r.ID_FEG__c,
          Convsta_Entreprise__r.Code_Postal__c,
          Convsta_Entreprise__r.Adresse_Ville__c,
          Convsta_Entreprise__r.CodePays__c,
          Convsta_Entreprise__r.Adresse_Rue__c,
          Responsable_administratif_entreprise__c,
          Responsable_administratif_entreprise__r.AccountId,
          Responsable_administratif_entreprise__r.Name,
          Responsable_administratif_entreprise__r.FirstName,
          Responsable_administratif_entreprise__r.LastName,
          Responsable_administratif_entreprise__r.Fonctions__c,
          Convsta_Responsable_Pedagogique__r.FirstName,
          Convsta_Responsable_Pedagogique__r.LastName,
          Convsta_suiveur__r.LastName,
          Convsta_Tuteur__r.FirstName,
          Convsta_Tuteur__r.LastName,
          Convsta_Tuteur__r.Fonctions__c,
          Convsta_Tuteur__r.AccountId,
          Convsta_Tuteur__r.Salutation,
          Contact.convsta_code_etudiant_EM__c,
          Convsta_Referent_pedagogique__r.Email
        FROM Case
        WHERE Id = :caseId
        LIMIT 1
      ];
    } else {
      // isAvenant
      stage = [
        SELECT
          Id,
          RecordType.DeveloperName,
          CONVSTA_Nouveau_tuteur__c,
          Convsta_Nouvelle_gratification__c,
          Convsta_Nouvelle_adresse_lieu_de_stage__c,
          Convsta_Nouvelle_date_de_debut__c,
          Convsta_Nouvelle_date_de_fin__c,
          Convsta_Langue__c,
          Parent.Id,
          Parent.RecordType.DeveloperName,
          Parent.Convsta_DateStart__c,
          Parent.Convsta_DateEnd__c,
          Parent.Convsta_Type_de_demande__c,
          Parent.Convsta_TypeContrat__c,
          Parent.Origin,
          Parent.Date_Reception_Convention__c,
          Parent.Convsta_Entreprise__c,
          Parent.Convsta_Entreprise__r.Name,
          Parent.Convsta_Entreprise__r.ID_FEG__c,
          Parent.Convsta_Entreprise__r.Code_Postal__c,
          Parent.Convsta_Entreprise__r.Adresse_Ville__c,
          Parent.Convsta_Entreprise__r.CodePays__c,
          Parent.Convsta_Entreprise__r.Adresse_Rue__c,
          Parent.Responsable_administratif_entreprise__r.AccountId,
          Parent.Responsable_administratif_entreprise__r.Name,
          Parent.Responsable_administratif_entreprise__r.FirstName,
          Parent.Responsable_administratif_entreprise__r.LastName,
          Parent.Responsable_administratif_entreprise__r.Fonctions__c,
          Parent.Convsta_Responsable_Pedagogique__r.FirstName,
          Parent.Convsta_Responsable_Pedagogique__r.LastName,
          Parent.Convsta_Tuteur__c,
          Parent.Convsta_Tuteur__r.AccountId,
          Parent.Convsta_Tuteur__r.FirstName,
          Parent.Convsta_Tuteur__r.LastName,
          Parent.Convsta_Tuteur__r.Fonctions__c,
          Parent.Convsta_Tuteur__r.Salutation,
          Parent.Contact.convsta_code_etudiant_EM__c,
          Parent.Convsta_Referent_pedagogique__r.Email
        FROM Case
        WHERE Id = :caseId
        LIMIT 1
      ];
    }
    return stage;
  }

  @AuraEnabled
  public static string wsGetCodePhaseFront(
    String numEtudiant,
    Date debut,
    Date fin
  ) {
    return JSON.serialize(wsGetCodePhase(numEtudiant, debut, fin));
  }
  @AuraEnabled
  public static OASElevesApi.getPhaseReturn wsGetCodePhase(
    /*SwagPhaseApi spa,*/ String numEtudiant,
    Date debut,
    Date fin
  ) {
    OASElevesApi spa = new OASElevesApi();
    Map<String, Object> paramsGet = new Map<String, Object>();
    paramsGet.put('codeEleve', numEtudiant);
    paramsGet.put('dateDebut', debut);
    paramsGet.put('dateFin', fin);
    paramsGet.put('typePhase', 'STA');
    system.debug(
      'code eleve ' +
      numEtudiant +
      ' dateDeb ' +
      debut +
      ' date fin ' +
      fin
    );
    OASElevesApi.getPhaseReturn retval = spa.getPhasesCursus(paramsGet);
    string fullError = '';
    if (!retval.success) {
      fullError += 'STA ' + retval.errorMsg + '\n';
      paramsGet.put('typePhase', 'STAI');
      retval = spa.getPhasesCursus(paramsGet);
      if (!retval.success) {
        fullError += 'STAI ' + retval.errorMsg + '\n';
        paramsGet.put('typePhase', 'STAF');
        retval = spa.getPhasesCursus(paramsGet);
        if (!retval.success) {
          fullError += 'STAF ' + retval.errorMsg + '\n';
          paramsGet.put('typePhase', 'STPM');
          retval = spa.getPhasesCursus(paramsGet);
          if (!retval.success) {
            fullError += 'STPM ' + retval.errorMsg + '\n';
            paramsGet.put('typePhase', 'STTP');
            retval = spa.getPhasesCursus(paramsGet);
            if (!retval.success) {
              fullError += 'STTP ' + retval.errorMsg + '\n';
              retval.errorMsg = fullError;
            }
          }
        }
      }
    }
    return retVal;
  }

/*  private static String fixCodeProfName(String inValue){
    return inValue.replaceAll('\'', ' ').replaceAll('Ö','O').replaceAll('È','E').replaceAll('Ê','E').replaceAll('É','E');
  } */
  @AuraEnabled
  public static /*Convsta_ws_refint.RefIntReturn*/ String wsGetCodeProf(
    String email
  ) {
  //  String correctedName = fixCodeProfName(name);
    System.debug('>>> Convsta_WS_Helper_Cursus wsGetCodeProf START');
  //  System.debug('@name : ' + name+ ' corrected into '+correctedName);
    System.debug('@email : ' + email);

    Convsta_ws_refint.RefIntReturn resultStr = convsta_ws_refint.searchMail(email);
    system.debug('refinResult '+resultStr);
    return JSON.serialize(resultStr);
  }

  @AuraEnabled
  public static String wsPostPhase(Case stage, String codePhaseIn) {
    String demandeId = stage.Id;
    Boolean isAvenant = stage.recordType.DeveloperName.equalsIgnoreCase(
      'Convsta_Avenant'
    );
    Case avenant = new Case(); // so as to not check for null at every line
    if (isAvenant) {
      demandeId = stage.Parent.Id;
      avenant = (Case) JSON.deserialize(JSON.serialize(stage), Case.class);
      stage = stage.Parent;
    }

    Convsta_Conditions_Contractuelles__c conditions = [
      SELECT Remuneration_Mensuelle__c, Moyen_d_Obtention__c
      FROM Convsta_Conditions_Contractuelles__c
      WHERE MD_Demande__c = :demandeId
      LIMIT 1
    ];

    Convsta_Mission__c missions = [
      SELECT
        Id,
        Convsta_Description_de_la_mission__c,
        Titre_Mission__c,
        Famille_fonction__c
      FROM Convsta_Mission__c
      WHERE MD_Demande__c = :demandeId
      LIMIT 1
    ];
    Convsta_Entreprise__c entreprise = [
      SELECT
        Id,
        Adresse_Entreprise__c,
        Convsta_Adresse_du_lieu_du_stage__c,
        Code_Postal__c,
        Convsta_Code_postal_du_lieu_du_stage__c,
        Ville__c,
        Convsta_Ville_du_lieu_du_stage__c,
        Pays2__c,
        Convsta_Pays_du_lieu_de_ma_mission__c,
        Email_Signataire_Convention__c
      FROM Convsta_Entreprise__c
      WHERE MD_Demande__c = :demandeId
      LIMIT 1
    ];

    OASElevesApi spa = new OASElevesApi();
    if (codePhaseIn == null) {
      codePhaseIn = wsGetCodePhase(
          stage.Contact.convsta_code_etudiant_EM__c,
          stage.Convsta_DateStart__c,
          stage.Convsta_DateEnd__c
        )
        .codePhase;
      System.debug('codePhaseInFromWS ' + codePhaseIn);
      codePhaseIn = codePhaseIn.replaceAll('"', '');
      System.debug('codePhaseInAfterTreatment ' + codePhaseIn);
    }
    String codeEntreprise = spa.getFEGCodeEntreprise(
      stage.Convsta_Entreprise__c
    );
    String codeTuteur = String.isNotBlank(stage.Convsta_Tuteur__c)
      ? spa.getFEGCodeTuteur(
          stage.Convsta_Tuteur__r.accountId,
          stage.Convsta_Tuteur__c,
          stage.Convsta_Tuteur__r.fonctions__c
        )
      : null;
    String codeProfStr = String.isBlank(
        stage.Convsta_Referent_pedagogique__r.Email
      )
      ? null
      : Convsta_ws_refint.searchMail(stage.Convsta_Referent_pedagogique__r.Email).codeItIntervenant;
    OASUpdateStage postPhaseRequest = new OASUpdateStage();
    system.debug('codePhaseIn ' + codePhaseIn);
    postPhaseRequest.codePhase = codePhaseIn;
    postPhaseRequest.exercice = String.valueOf(
      stage.Convsta_DateStart__c.year() +
      //si le stage commence en Aout, il est dans l'exercice suivant
      (stage.Convsta_DateStart__c.Month() > 7 ? 1 : 0)
    );
    postPhaseRequest.codeProf = codeProfStr;
    postPhaseRequest.codEntreprise = codeEntreprise;
    postPhaseRequest.codPosteMaitre = codeTuteur;
    postPhaseRequest.ordreStage = null;

    postPhaseRequest.missionStage = shortenLongString(missions.Titre_Mission__c,16);
    postPhaseRequest.codeOrigine = UniversalValueMap.valueMapSf2Ext.get(
        'Convsta_Conditions_Contractuelles__c'
      )
      .get('Moyen_d_Obtention__c')
      .get(conditions.Moyen_d_Obtention__c);
    postPhaseRequest.convstage = null;
    postPhaseRequest.oblistage = false;
    postPhaseRequest.descf = false;
    postPhaseRequest.apprEnt = null;
    postPhaseRequest.dateMaj = null; // pas de spec
    postPhaseRequest.raisSocialeHist = shortenLongString(stage.Convsta_Entreprise__r.Name,40);
    postPhaseRequest.cpvilleHist = shortenLongString(stage.Convsta_Entreprise__r.Code_Postal__c,50); 

    // compare with possible avenant values
    postPhaseRequest.codeTheme = UniversalValueMap.valueMapSf2Ext.get(
        'Convsta_Mission__c'
      )
      .get('Famille_fonction__c')
      .get(missions.Famille_fonction__c)
      ?.rightPad(20, ' ');
    postPhaseRequest.nomMaitreHist =shortenLongString( avenant.CONVSTA_Nouveau_tuteur__c != null
      ? avenant.CONVSTA_Nouveau_tuteur__r.LastName
      : stage.Convsta_Tuteur__r.LastName,40); 
    postPhaseRequest.prenomMaitreHist = shortenLongString(
      avenant.CONVSTA_Nouveau_tuteur__c !=
      null
      ? avenant.CONVSTA_Nouveau_tuteur__r.FirstName
      : stage.Convsta_Tuteur__r.FirstName,30); 
    postPhaseRequest.civiliteMaitreHist = shortenLongString( avenant.CONVSTA_Nouveau_tuteur__c !=
      null
      ? avenant.CONVSTA_Nouveau_tuteur__r.Salutation
      : stage.Convsta_Tuteur__r.Salutation,4); 
    postPhaseRequest.fonctionMaitre = shortenLongString(avenant.CONVSTA_Nouveau_tuteur__c != null
      ? avenant.CONVSTA_Nouveau_tuteur__r.Fonctions__c
      : stage.Convsta_Tuteur__r.Fonctions__c,250);
    postPhaseRequest.coordMaitreHist = shortenLongString(avenant.CONVSTA_Nouveau_tuteur__c != null
      ? avenant.CONVSTA_Nouveau_tuteur__r.Phone
      : stage.Convsta_Tuteur__r.Phone,60);
    postPhaseRequest.emailTuteur = shortenLongString(avenant.CONVSTA_Nouveau_tuteur__c != null
      ? avenant.CONVSTA_Nouveau_tuteur__r.email
      : stage.Convsta_Tuteur__r.email,200); 
    postPhaseRequest.gratification = avenant.Convsta_Nouvelle_gratification__c !=
      null
      ? avenant.Convsta_Nouvelle_gratification__c
      : conditions.Remuneration_Mensuelle__c; 
    postPhaseRequest.gratificationNette = avenant.Convsta_Nouvelle_gratification__c !=
      null
      ? avenant.Convsta_Nouvelle_gratification__c
      : conditions.Remuneration_Mensuelle__c; 
    String adresseStr = getStageAdress(entreprise, avenant);
    postPhaseRequest.adresse1Stage = adresseStr.substring(0,Math.min(38,adresseStr.length())); 
    postPhaseRequest.adresse2Stage = adresseStr.length()>38 ? adresseStr.substring(38,Math.min(76,adresseStr.length())):''; // info pertinante ?
    postPhaseRequest.adresse3Stage = adresseStr.length()>76 ? adresseStr.substring(76,Math.min(114,adresseStr.length())):'';
    postPhaseRequest.cpStage = getStageCp(entreprise, avenant); 
    postPhaseRequest.villeStage = getStageVille(entreprise, avenant); 
    postPhaseRequest.paysStage = getStagePays(entreprise, avenant); 
    postPhaseRequest.dateDeb = stage.Convsta_DateStart__c;
    postPhaseRequest.dateFin = stage.Convsta_DateEnd__c;
    postPhaseRequest.codeLangueConven = UniversalValueMap.valueMapSf2Ext.get(
        'CASE'
      )
      .get('Convsta_Langue__c')
      .get(stage.Convsta_Langue__c);
    postPhaseRequest.ediConven = 1;
    postPhaseRequest.dateEdiconven = stage.Date_Reception_Convention__c != null
      ? stage.Date_Reception_Convention__c.date()
      : null; 
    postPhaseRequest.representant = shortenLongString(stage.Responsable_administratif_entreprise__r.Name,60);
    postPhaseRequest.emailSignataire = shortenLongString(entreprise.Email_Signataire_Convention__c,200);
    postPhaseRequest.codeTypeContratStage = UniversalValueMap.valueMapSf2Ext.get(
        'Case'
      )
      .get('Convsta_TypeContrat__c')
      .get(stage.Convsta_TypeContrat__c); 
    postPhaseRequest.dateRetourconven = null;
    postPhaseRequest.dateEnvoieval = null;
    postPhaseRequest.dateRetoureval = null;
    postPhaseRequest.gratificationLocale = conditions.Remuneration_Mensuelle__c.format(); 
    postPhaseRequest.fonctionRepresentant = shortenLongString(stage.Responsable_administratif_entreprise__r.Fonctions__c,250);

    Map<String, Object> paramsPost = new Map<String, Object>();
    paramsPost.put('stage', postPhaseRequest);
    paramsPost.put(
      'codeEleve',
      String.valueOf(stage.Contact.convsta_code_etudiant_EM__c)
    );
    System.debug(
      'wsPostPhase JMA postPhaseRequest.nomMaitreHist : ' +
      postPhaseRequest.nomMaitreHist
    );
    System.debug('wsPostPhase paramsPost : ' + paramsPost);
    String retVal = spa.updateStageEtudiantAsync(paramsPost);
    system.debug('wspost retval ' + retval);
    return retVal;
  }

  @AuraEnabled
  public static /*checkStrictTotalDataStructure*/ String checkStrictTotalData(
    Case stage
  ) {
    System.debug('checkStrictTotalData start');
    System.debug('checkStrictTotalData stage : ' + stage);
    String demandeId = stage.Id;
    Boolean isAvenant = stage.recordType.DeveloperName.equalsIgnoreCase(
      'Convsta_Avenant'
    );
    System.debug('checkStrictTotalData isAvenant : ' + isAvenant);
    if (isAvenant) {
      demandeId = stage.Parent.Id;
    }
    Convsta_Mission__c missions = [
      SELECT
        Id,
        Convsta_Description_de_la_mission__c,
        Titre_Mission__c,
        Famille_fonction__c
      FROM Convsta_Mission__c
      WHERE MD_Demande__c = :demandeId
      LIMIT 1
    ];
    System.debug('checkStrictTotalData missions : ' + missions);

    Convsta_Conditions_Contractuelles__c conditions = [
      SELECT Id, Remuneration_Mensuelle__c, Moyen_d_Obtention__c
      FROM Convsta_Conditions_Contractuelles__c
      WHERE MD_Demande__c = :demandeId
      LIMIT 1
    ];
    System.debug('checkStrictTotalData conditions : ' + conditions);
    Convsta_Entreprise__c entreprise = [
      SELECT
        Id,
        Adresse_Entreprise__c,
        Convsta_Adresse_du_lieu_du_stage__c,
        Code_Postal__c,
        Convsta_Code_postal_du_lieu_du_stage__c,
        Ville__c,
        Convsta_Ville_du_lieu_du_stage__c,
        Pays2__c,
        Convsta_Pays_du_lieu_de_ma_mission__c
      FROM Convsta_Entreprise__c
      WHERE MD_Demande__c = :demandeId
      LIMIT 1
    ];

    checkStrictTotalDataStructure returnStruct = new checkStrictTotalDataStructure();
    returnStruct.message = '';
    Case avenant = null;
    if (stage.RecordType.DeveloperName == 'Convsta_Avenant') {
      avenant = (Case) JSON.deserialize(JSON.serialize(stage), Case.class);
      stage = stage.Parent;
    }
    System.debug('checkStrictTotalData avenant : ' + avenant);
    System.debug('checkStrictTotalData stage : ' + stage);
    returnStruct.entrepriseOK = true;
    if (String.isBlank(getStageCp(entreprise, avenant))) {
      System.debug('£££ no stage.Convsta_Entreprise__r.Code_Postal__c');
      returnStruct.entrepriseOK = false;
      returnStruct.message += 'erreur Addresse Code Postale;';
    }
    if (String.isBlank(getStageVille(entreprise, avenant))) {
      System.debug('£££ no stage.Convsta_Entreprise__r.Adresse_Ville__c');
      returnStruct.entrepriseOK = false;
      returnStruct.message += 'erreur Addresse Ville;';
    }
    if (String.isBlank(getStageAdress(entreprise, avenant))) {
      System.debug('£££ no stage.Convsta_Entreprise__r.Adresse_Rue__c');
      returnStruct.entrepriseOK = false;
      returnStruct.message += 'erreur Addresse Rue;';
    }
    if (
      String.isNotBlank(missions.Convsta_Description_de_la_mission__c) &&
      String.isNotEmpty(missions.Convsta_Description_de_la_mission__c)
    ) {
      returnStruct.missionOK = true;
    } else {
      System.debug(
        '£££ no stage.missions.Convsta_Description_de_la_mission__c'
      );
      returnStruct.missionOK = false;
      returnStruct.message += 'erreur Mission;';
    }

    if (
      conditions.Remuneration_Mensuelle__c != null &&
      String.valueOf(conditions.Remuneration_Mensuelle__c) != ''
    ) {
      returnStruct.contratOK = true;
    } else {
      System.debug('£££ no stage.conditions.Remuneration_Mensuelle__c');
      returnStruct.contratOK = false;
      returnStruct.message += 'erreur conditions Contractuelle : problème de rémunération';
    }

    // Suiveur
    returnStruct.respPedagoOK = true;
    if (
      String.isBlank(stage.Convsta_Responsable_Pedagogique__r.FirstName) ||
      String.isEmpty(stage.Convsta_Responsable_Pedagogique__r.FirstName)
    ) {
      returnStruct.respPedagoOK = false;
      returnStruct.message += 'erreur prénom pédago;';
    }
    if (
      String.isBlank(stage.Convsta_Responsable_Pedagogique__r.LastName) ||
      String.isEmpty(stage.Convsta_Responsable_Pedagogique__r.LastName)
    ) {
      returnStruct.respPedagoOK = false;
      returnStruct.message += 'erreur nom pédago;';
    }

    // Resp Entreprise
    if (stage.Convsta_Type_de_demande__c == 'Stage') {
      returnStruct.respEntrOK = true;
      if (
        String.isBlank(
          stage.Responsable_administratif_entreprise__r.FirstName
        ) ||
        String.isEmpty(stage.Responsable_administratif_entreprise__r.FirstName)
      ) {
        returnStruct.respEntrOK = false;
        returnStruct.message += 'erreur prénom responsable;';
      }
      if (
        String.isBlank(
          stage.Responsable_administratif_entreprise__r.LastName
        ) ||
        String.isEmpty(stage.Responsable_administratif_entreprise__r.LastName)
      ) {
        returnStruct.respEntrOK = false;
        returnStruct.message += 'erreur nom responsable;';
      }
      if (
        String.isBlank(
          stage.Responsable_administratif_entreprise__r.Fonctions__c
        ) ||
        String.isEmpty(
          stage.Responsable_administratif_entreprise__r.Fonctions__c
        )
      ) {
        returnStruct.respEntrOK = false;
        returnStruct.message += 'erreur fonction responsable;';
      }

      // Tuteur Entreprise
      returnStruct.tuteurEntrOK = true;
      if (
        String.isBlank(stage.Convsta_Tuteur__r.FirstName) ||
        String.isEmpty(stage.Convsta_Tuteur__r.FirstName)
      ) {
        returnStruct.tuteurEntrOK = false;
        returnStruct.message += 'erreur prénom tuteur;';
      }
      if (
        String.isBlank(stage.Convsta_Tuteur__r.LastName) ||
        String.isEmpty(stage.Convsta_Tuteur__r.LastName)
      ) {
        returnStruct.tuteurEntrOK = false;
        returnStruct.message += 'erreur nom tuteur;';
      }
      if (
        String.isBlank(stage.Convsta_Tuteur__r.Salutation) ||
        String.isEmpty(stage.Convsta_Tuteur__r.Salutation)
      ) {
        returnStruct.tuteurEntrOK = false;
        returnStruct.message += 'erreur civilité tuteur;';
      }
      if (
        String.isBlank(stage.Convsta_Tuteur__r.Fonctions__c) ||
        String.isEmpty(stage.Convsta_Tuteur__r.Fonctions__c) ||
        String.isBlank(
          UniversalValueMap.valueMapSf2Ext.get('Convsta_Mission__c')
            .get('Famille_fonction__c')
            .get(missions.Famille_fonction__c)
        )
      ) {
        returnStruct.tuteurEntrOK = false;
        returnStruct.message += 'erreur fonction tuteur;';
      }
    } else {
      returnStruct.respEntrOK = true;
      returnStruct.tuteurEntrOK = true;
      if (
        String.isBlank(
          UniversalValueMap.valueMapSf2Ext.get('Convsta_Mission__c')
            .get('Famille_fonction__c')
            .get(missions.Famille_fonction__c)
        )
      ) {
        returnStruct.missionOK = false;
        returnStruct.message += 'erreur le type de stage ne peut être déterminé car la fonciton tuteur n\'est pas reconnue;';
      }
    }
    // Stage
    if (
      String.isNotBlank(stage.Convsta_TypeContrat__c) &&
      String.isNotEmpty(stage.Convsta_TypeContrat__c)
    ) {
      if (
        (stage.Convsta_DateEnd__c != null &&
        String.valueOf(stage.Convsta_DateEnd__c) != '')
      ) {
        if (
          (stage.Convsta_DateStart__c != null &&
          String.valueOf(stage.Convsta_DateStart__c) != '')
        ) {
          if (
            String.isNotBlank(stage.Origin) && String.isNotEmpty(stage.Origin)
          ) {
            returnStruct.stageOK = true;
          } else {
            returnStruct.stageOK = false;
            returnStruct.message += 'erreur Origine;';
          }
        } else {
          returnStruct.stageOK = false;
          returnStruct.message += 'erreur Date début;';
        }
      } else {
        returnStruct.stageOK = false;
        returnStruct.message += 'erreur date fin;';
      }
    } else {
      returnStruct.stageOK = false;
      returnStruct.message += 'erreur type contrat;';
    }

    returnStruct.allDataOK =
      returnStruct.entrepriseOK &&
      returnStruct.missionOK &&
      returnStruct.contratOK &&
      returnStruct.respPedagoOK &&
      returnStruct.respEntrOK &&
      returnStruct.tuteurEntrOK &&
      returnStruct.stageOK;

    // si Avenant et si tout est OK avec la Demande de stage, verif l'avenant
    System.debug('£££ avenant before recheck : ' + avenant);

    if (avenant != null) {
      // only recheck Tutor if new tutor is not null on avenant
      if (avenant.CONVSTA_Nouveau_tuteur__r != null) {
        returnStruct.tuteurEntrOK = false;
        if (
          String.isNotBlank(avenant.CONVSTA_Nouveau_tuteur__r.FirstName) &&
          String.isNotEmpty(avenant.CONVSTA_Nouveau_tuteur__r.FirstName)
        ) {
          if (
            String.isNotBlank(avenant.CONVSTA_Nouveau_tuteur__r.LastName) &&
            String.isNotEmpty(avenant.CONVSTA_Nouveau_tuteur__r.LastName)
          ) {
            if (
              String.isNotBlank(
                avenant.CONVSTA_Nouveau_tuteur__r.Fonctions__c
              ) &&
              String.isNotEmpty(avenant.CONVSTA_Nouveau_tuteur__r.Fonctions__c)
            ) {
              if (
                String.isNotBlank(
                  avenant.CONVSTA_Nouveau_tuteur__r.Salutation
                ) &&
                String.isNotEmpty(avenant.CONVSTA_Nouveau_tuteur__r.Salutation)
              ) {
                returnStruct.avenantTuteurEntrOK = true;
              } else {
                System.debug(
                  '£££ no avenant.CONVSTA_Nouveau_tuteur__r.Salutation'
                );
                returnStruct.avenantTuteurEntrOK = false;
                returnStruct.message += 'erreur avenant civilité tuteur;';
              }
            } else {
              System.debug(
                '£££ no avenant.CONVSTA_Nouveau_tuteur__r.Fonctions__c'
              );
              returnStruct.avenantTuteurEntrOK = false;
              returnStruct.message += 'erreur avenant fonction tuteur;';
            }
          } else {
            System.debug('£££ no avenant.CONVSTA_Nouveau_tuteur__r.LastName');
            returnStruct.avenantTuteurEntrOK = false;
            returnStruct.message += 'erreur avenant nom tuteur;';
          }
        } else {
          System.debug('£££ no avenant.CONVSTA_Nouveau_tuteur__r.FirstName');
          returnStruct.avenantTuteurEntrOK = false;
          returnStruct.message += 'erreur avenant prénom tuteur;';
        }
      } else {
        System.debug('£££ no avenant.CONVSTA_Nouveau_tuteur__r');
        returnStruct.avenantTuteurEntrOK = false;
        returnStruct.message += 'no avenant tuteur;';
      }

      if (
        avenant.Convsta_Nouvelle_gratification__c != null &&
        String.valueOf(avenant.Convsta_Nouvelle_gratification__c) != ''
      ) {
        returnStruct.avenantGratifOK = true;
      } else {
        System.debug('£££ no avenant.Convsta_Nouvelle_gratification__c');
        returnStruct.avenantGratifOK = false;
        returnStruct.message += 'erreur avenant gratification;';
      }

      if (
        avenant.Convsta_Nouvelle_adresse_lieu_de_stage__c != null &&
        String.valueOf(avenant.Convsta_Nouvelle_adresse_lieu_de_stage__c) != ''
      ) {
        returnStruct.avenantAdresseEntrOK = true;
      } else {
        System.debug(
          '£££ no avenant.Convsta_Nouvelle_adresse_lieu_de_stage__c'
        );
        returnStruct.avenantAdresseEntrOK = false;
        returnStruct.message += 'erreur avenant Addresse;';
      }
      // JMA evaluate avenant : at least one update must be present ?
      returnStruct.isAvenantOK =
        returnStruct.avenantTuteurEntrOK ||
        returnStruct.avenantGratifOK ||
        returnStruct.avenantAdresseEntrOK;
    } // end avenant != null

    // reevaluate
    returnStruct.allDataOK =
      returnStruct.entrepriseOK &&
      returnStruct.missionOK &&
      returnStruct.contratOK &&
      returnStruct.respPedagoOK &&
      returnStruct.respEntrOK &&
      returnStruct.tuteurEntrOK &&
      returnStruct.stageOK;
    System.debug('checkStrictTotalData returnStruct : ' + returnStruct);
    System.debug('checkStrictTotalData end');
    return JSON.serialize(returnStruct);
  }

  @AuraEnabled
  public static void updateStageCursusDoneBolean(Id stageId) {
    Case stage = new Case(Id = stageId);
    stage.Convsta_Phase_de_stage_dans_Cursus__c = true;
    update stage;
  }

  @AuraEnabled
  public static String wsgetEntreprise(String idSFCompteEntreprise) {
    OASElevesApi eleveApi = new OASElevesApi();
    return eleveApi.getFEGCodeEntreprise(idSFCompteEntreprise);
  }
  @AuraEnabled
  public static String wsgetTuteur(
    String idSFCompteEntreprise,
    String idSfTutor,
    String function
  ) {
    OASElevesApi eleveApi = new OASElevesApi();
    return eleveApi.getFEGCodeTuteur(idSFCompteEntreprise, idSfTutor, function);
  }
  @AuraEnabled(cacheable=true)
  public static /*checkStrictEvaluationDataStructure*/ String checkStrictEvaluationData(
    Id caseId
  ) {
    System.debug('checkStrictEvaluationData start');
    System.debug('checkStrictEvaluationData stageId : ' + caseId);

    checkStrictEvaluationDataStructure returnStruct = new checkStrictEvaluationDataStructure();

    Convsta_Evaluation__c evaluation = [
      SELECT
        Id,
        Etudiant__c,
        Etudiant__r.LastName,
        Etudiant__r.FirstName,
        Note_globale__c,
        Date_Reception_Evalutation__c,
        Demande__r.Contact.convsta_code_etudiant_EM__c,
        Demande__r.Convsta_DateStart__c,
        Demande__r.Convsta_DateEnd__c
      FROM Convsta_Evaluation__c
      WHERE Id = :caseId
    ];

    if (
      wsGetCodePhase(
          evaluation.Demande__r.Contact.convsta_code_etudiant_EM__c,
          evaluation.Demande__r.Convsta_DateStart__c,
          evaluation.Demande__r.Convsta_DateEnd__c
        )
        .success
    ) {
      returnStruct.hasPhase = true;
    } else {
      returnStruct.hasPhase = false;
    }
    if (
      String.isNotBlank(evaluation.Etudiant__c) &&
      String.isNotEmpty(evaluation.Etudiant__c)
    ) {
      returnStruct.hasEtudiant = true;
    } else {
      System.debug('£££ no evaluation.Etudiant__c');
      returnStruct.hasEtudiant = false;
      returnStruct.message += 'erreur Etudiant;';
    }

    if (
      String.isNotBlank(evaluation.Etudiant__r.LastName) &&
      String.isNotEmpty(evaluation.Etudiant__r.LastName)
    ) {
      returnStruct.hasEtudiantLastName = true;
    } else {
      System.debug('£££ no evaluation.Etudiant__r.LastName');
      returnStruct.hasEtudiantLastName = false;
      returnStruct.message += 'erreur Etudiant LastName;';
    }

    if (
      String.isNotBlank(evaluation.Etudiant__r.FirstName) &&
      String.isNotEmpty(evaluation.Etudiant__r.FirstName)
    ) {
      returnStruct.hasEtudiantFirstName = true;
    } else {
      System.debug('£££ no evaluation.Etudiant__r.FirstName');
      returnStruct.hasEtudiantFirstName = false;
      returnStruct.message += 'erreur Etudiant FirstName;';
    }

    if (evaluation.Note_globale__c != null) {
      returnStruct.hasNoteGlobale = true;
    } else {
      System.debug('£££ no evaluation.Note_globale__c');
      returnStruct.hasNoteGlobale = false;
      returnStruct.message += 'erreur Note globale;';
    }

    if (evaluation.Date_Reception_Evalutation__c != null) {
      returnStruct.hasDateReceptionEval = true;
    } else {
      System.debug('£££ no evaluation.Date_Reception_Evalutation__c');
      returnStruct.hasDateReceptionEval = false;
      returnStruct.message += 'erreur Date reception evaluation;';
    }

    returnStruct.allDataOK =
      returnStruct.hasDateReceptionEval &&
      returnStruct.hasNoteGlobale &&
      returnStruct.hasEtudiantFirstName &&
      returnStruct.hasEtudiantLastName &&
      returnStruct.hasEtudiant;
    System.debug('checkStrictEvaluationData returnStruct : ' + returnStruct);

    System.debug('checkStrictEvaluationData end');
    return JSON.serialize(returnStruct);
  }

  @AuraEnabled
  public static string wsPostEval(Id caseId) {
    Convsta_Evaluation__c evaluation = [
      SELECT
        Id,
        Etudiant__c,
        Etudiant__r.LastName,
        Etudiant__r.FirstName,
        Note_globale__c,
        Date_Reception_Evalutation__c,
        Demande__r.Contact.convsta_code_etudiant_EM__c,
        Demande__r.Convsta_DateStart__c,
        Demande__r.Convsta_DateEnd__c
      FROM Convsta_Evaluation__c
      WHERE Id = :caseId
    ];
    OASUpdateEvaluation evalToPost = new OASUpdateEvaluation();
    String codePhaseIn = wsGetCodePhase(
        evaluation.Demande__r.Contact.convsta_code_etudiant_EM__c,
        evaluation.Demande__r.Convsta_DateStart__c,
        evaluation.Demande__r.Convsta_DateEnd__c
      )
      .codePhase;
    String exeB = wsGetCodePhase(
      evaluation.Demande__r.Contact.convsta_code_etudiant_EM__c,
      evaluation.Demande__r.Convsta_DateStart__c,
      evaluation.Demande__r.Convsta_DateEnd__c
    ).exeBul;
    String etuB = wsGetCodePhase(
      evaluation.Demande__r.Contact.convsta_code_etudiant_EM__c,
      evaluation.Demande__r.Convsta_DateStart__c,
      evaluation.Demande__r.Convsta_DateEnd__c
    ).etuBul;
    String perB = wsGetCodePhase(
      evaluation.Demande__r.Contact.convsta_code_etudiant_EM__c,
      evaluation.Demande__r.Convsta_DateStart__c,
      evaluation.Demande__r.Convsta_DateEnd__c
    ).perBul;
    evalToPost.exeBul = exeB;
    evalToPost.etuBul = etuB;
    evalToPost.perBul = perB;
    evalToPost.codePhase = codePhaseIn;
    evalToPost.dateMajnote = Date.today();
    evalToPost.notechiffre = evaluation.Note_globale__c;
    evalToPost.absctl = false;
    evalToPost.complet = false;
    evalToPost.notevalid = evaluation.Note_globale__c >= 10 ? true : false;
    evalToPost.ctlseul = false;
    evalToPost.dispens = false;
    evalToPost.codeEpr = 'XSTAGE';
    evalToPost.numsession = '01';
    evalToPost.exercice = String.valueOf(
      evaluation.Demande__r.Convsta_DateStart__c.Year() +
      //si le stage commence en Aout, il est dans l'exercice suivant
      (evaluation.Demande__r.Convsta_DateStart__c.Month() > 7 ? 1 : 0)
    );
    Map<String, Object> paramsPost = new Map<String, Object>();
    paramsPost.put('evaluation', evalToPost);
    paramsPost.put(
      'codeEleve',
      String.valueOf(evaluation.Demande__r.Contact.convsta_code_etudiant_EM__c)
    );
    System.debug('wsPostPhase paramsPost : ' + paramsPost);
    OASElevesApi oas = new OASElevesApi();
    OASElevesApi.updateEvalReturn returnWs = oas.updateEvaluationEtudiantAsync(paramsPost);
    system.debug(returnWs);
    if(returnWs.errorCode == '200'){
      Convsta_Evaluation__c updatedEval = new Convsta_Evaluation__c(Id = evaluation.Id, Saisie_dans_cursus__c = true ); 
      update updatedEval;
    }
    return returnWs.errorMessage;
  }
  public class CustomException extends Exception {
  }

  public static String getStageAdress(
    Convsta_Entreprise__c entreprise,
    Case avenant
  ) {
    if (
      avenant != null &&
      !String.isBlank(avenant.Convsta_Nouvelle_adresse_lieu_de_stage__c)
    ) {
      return avenant.Convsta_Nouvelle_adresse_lieu_de_stage__c;
    } else if (
      !String.isBlank(entreprise.Convsta_Adresse_du_lieu_du_stage__c)
    ) {
      return entreprise.Convsta_Adresse_du_lieu_du_stage__c;
    } else if (!String.isBlank(entreprise.Adresse_Entreprise__c)) {
      return entreprise.Adresse_Entreprise__c;
    }
    return null;
  }
  public static String getStageCp(
    Convsta_Entreprise__c entreprise,
    Case avenant
  ) {
    if (!String.isBlank(entreprise.Convsta_Code_postal_du_lieu_du_stage__c)) {
      return entreprise.Convsta_Code_postal_du_lieu_du_stage__c.length()<7 ?
        entreprise.Convsta_Code_postal_du_lieu_du_stage__c:
        'NC';
    } else if (!String.isBlank(entreprise.Code_Postal__c)) {
      return entreprise.Code_Postal__c.length()<7 ?
        entreprise.Code_Postal__c :
        'NC';
    }
    return null;
  }
  public static String getStageVille(
    Convsta_Entreprise__c entreprise,
    Case avenant
  ) {
    if (!String.isBlank(entreprise.Convsta_Ville_du_lieu_du_stage__c)) {
      return entreprise.Convsta_Ville_du_lieu_du_stage__c.substring(0,Math.Min(30,entreprise.Convsta_Ville_du_lieu_du_stage__c.length()));
    } else if (!String.isBlank(entreprise.Ville__c)) {
      return entreprise.Ville__c.substring(0,Math.Min(30,entreprise.Ville__c.length()));
    }
    return '';
  }
  public static String getStagePays(
    Convsta_Entreprise__c entreprise,
    Case avenant
  ) {
    if (!String.isBlank(entreprise.Convsta_Pays_du_lieu_de_ma_mission__c)) {
      return entreprise.Convsta_Pays_du_lieu_de_ma_mission__c;
    } else if (!String.isBlank(entreprise.Pays2__c)) {
      return entreprise.Pays2__c;
    }
    return '';
  }
  private static String shortenLongString(String inStr,Integer maxLength){
    String outStr = '';
    if(String.isNotBlank(inStr)){
      outStr= inStr.substring(0,Math.min(maxLength, inStr.length()));
    }
    return outStr;
  }
}