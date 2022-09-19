/*-------------------------------------------------------------------
-- - Purpose : Helper for Convsta's WebServices
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- 18/12/2018  T.CH  MODIS       1.0      Initial version
-- 03/01/2019  T.CH  MODIS       1.2      Adding method to get TableRegles, Tuteur & Signataire by Email via the student service
-- 04/01/2019  T.CH  MODIS       1.3      Adding method to call ESign API for Convention (Signature)
-- 09/01/2019  T.CH  MODIS       1.4      Adding logic for Avenant Generation et refactoring of 1.2
-- 11/01/2019  T.CH  MODIS       1.5      Isolation of token access
-- 25/02/2019  E.BE  MODIS       1.6      Added observer to the call
-- 25/02/2019  E.BE  MODIS       1.7      change dataRetrieve
-- 27/05/2019  T.CH  MODIS       1.8      Expired or cancelled sign manage
-- 12/12/2019  Y.GA  Modis       1.9      application of the server cachet at the end of the process line 339 : "request.type"
--------------------------------------------------------------------*/
public without sharing class Convsta_WS_Helper {
  public class SignatureStruct {
    public String fileTitle { get; set; }
    public String fileName { get; set; }
    public PageReference page { get; set; }
  }

  /*------------- start GET/SET methods---------------*/
  public static eSign_Configuration__mdt getESignConf() {
    eSign_Configuration__mdt eSignConf = [
      SELECT
        ID_organization__c,
        cancelURL__c,
        failURL__c,
        successURL__c,
        ID_profile__c,
        ID_du_profil_cachet_serveur__c,
        ID_transacIdApplicationSource__c,
        ID_transacCodeApplicationSource__c,
        posSignXrespAdmin__c,
        posSignYrespAdmin__c,
        ID_transacCodePrestataireSignature__c,
        ID_transacDemandeurApplicationSource__c,
        documentCheckBoxTexts__c,
        documentTitle__c,
        posSignXstagiaire__c,
        posSignYstagiaire__c,
        posSignXtuteurEntreprise__c,
        posSignYtuteurEntreprise__c,
        posSignXrespEcole__c,
        posSignYrespEcole__c,
        posSignXcachet__c,
        posSignYcachet__c,
        nbMaxRelance__c,
        nbJoursAvantRelance__c
      FROM eSign_Configuration__mdt
      WHERE DeveloperName = 'Convsta_convention'
    ];
    return eSignConf;
  }

  public static String getSignatureToken(Case demande) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(Label.convsta_domain_esign + 'Api/v1/Auth');
    req.setMethod('POST');
    req.setBody(
      '{"userName" : "' +
      Label.convsta_username_esign +
      '", "password" : "' +
      Label.convsta_password_esign +
      '"}'
    );
    req.setHeader('Content-Type', 'application/json');

    Http http = new Http();
    req.setTimeout(120000);
    HTTPResponse res = http.send(req);
    system.debug(res);
    if (res.getStatusCode() == 200) {
      Map<String, Object> results = new Map<String, Object>();
      results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

      demande.Convsta_eSign_Errors__c = '';
      return (String) results.get('accessToken');
    } else {
      updateDemandeRequestError(demande, res, 'token');
      return null;
    }
  }

  @AuraEnabled
  public static Map<String, Object> getTableTuteurSignataire(String email, String type, date datedebut) {
    HttpRequest req = new HttpRequest();
    req.setmethod('GET');
    req.setEndpoint(
      Label.convsta_domain_wsstudent +
      'api/v1.0/Student/' +
      email +
      '/getstudentbymail'
    );

    Http http = new Http();
    HttpResponse resp = http.send(req);

    if (resp.getStatusCode() != 200) {
      throw new AuraHandledException(
        resp.getStatusCode() +
        'Ws student not returning for current student : ' +
        Label.convsta_domain_wsstudent +
        'api/v1.0/Student/' +
        email +
        '/getstudentbymail'
      );
    } else {
      System.debug(resp.getBody());
    }

    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
      resp.getBody()
    );

    String codeProgramme = (String) results.get('codeProgramme');
    codeProgramme = codeProgramme.replaceAll('\\s+', ''); //Remove spaces
    String codeEleve = (String) results.get('codeEleve');
    String codeAnnee = (String) results.get('codeAnneeEtude');
    codeAnnee = codeAnnee.replaceAll('\\s+', ''); //Remove spaces
    String annee = codeEleve.substring(0, 4);

    //update contact information with current user
    List<Contact> lstCtc = [
      SELECT Id
      FROM Contact
      WHERE Email_EM_Lyon__c = :email
    ];
    if (lstCtc.size() > 0) {
      lstCtc[0].firstName = ((String) results.get('prenom')).normalizeSpace();
      lstCtc[0].LastName = ((String) results.get('nom')).normalizeSpace();
      lstCtc[0].convsta_code_etudiant_EM__c = codeEleve;
      lstCtc[0].convsta_programme__c = codeProgramme;
      update lstCtc[0];
    }

   CONVSTA_Table_Regles_Experience_Pro__c t1 = [
     SELECT
        Id,
        Convsta_Tuteur_par_defaut__c,
        Convsta_Signataire_delegue_EM__c,
        Anterieur__c,
        Date_Demarrage_Au_Plus_Tot__c,
        Date_De_Demarrage_Au_Plus_Tard__c,
        Code_etude__c,
        Code_etude_Annee_suivante__c
      FROM CONVSTA_Table_Regles_Experience_Pro__c
      WHERE Code_etude__c = :codeAnnee AND Ann_e_suivante__c = false AND Accessible_aux_etudiants__c = true
      LIMIT 1
    ];

    List<CONVSTA_Table_Regles_Experience_Pro__c> tableListe = new List<CONVSTA_Table_Regles_Experience_Pro__c>();
    if (t1!=null){
        
      if(type =='Validation_experience_anterieure'
        ||(datedebut >= t1.Date_Demarrage_Au_Plus_Tot__c && t1.Date_De_Demarrage_Au_Plus_Tard__c == null)
     	|| ( t1.Date_De_Demarrage_Au_Plus_Tard__c >= datedebut && datedebut >= t1.Date_Demarrage_Au_Plus_Tot__c)){
        tableListe.add(t1);
      }
      else {
          String codesuivant = t1.Code_etude_Annee_suivante__c;
          if (codesuivant != null) {
    CONVSTA_Table_Regles_Experience_Pro__c t2 = [
        SELECT
        Id,
        Name,
        Convsta_Tuteur_par_defaut__c,
        Convsta_Signataire_delegue_EM__c,
        Anterieur__c,
        Date_Demarrage_Au_Plus_Tot__c,
        Date_De_Demarrage_Au_Plus_Tard__c,
        Code_etude__c,
        Code_etude_Annee_suivante__c
      FROM CONVSTA_Table_Regles_Experience_Pro__c
      WHERE Code_etude__c =: codesuivant AND Ann_e_suivante__c = true AND Accessible_aux_etudiants__c = true
      LIMIT 1
    ];
        if (t2 != null) {
          if((datedebut >= t2.Date_Demarrage_Au_Plus_Tot__c && t2.Date_De_Demarrage_Au_Plus_Tard__c == null)
          || ( t2.Date_De_Demarrage_Au_Plus_Tard__c >= datedebut && datedebut >= t2.Date_Demarrage_Au_Plus_Tot__c)){
            tableListe.add(t2);
          }
        }
      }
    } 
   }
 
    if (tableListe.size() == 0) {
      throw new AuraHandledException(
        'Pas de correspondance accessible pour le profil du candidat dans les tables de règles, merci de contacter le service employabilité avec les références: Programme :#' +
        codeAnnee +
        '#. Merci de contacter internship@em-lyon.com / Notify internship@em-lyon.com to unlock you '
      );
    }
    /* le requis au diplome a été désactivé en attendant le développement du service cursus qui 
    permettrait de vérifier la conformité de la situation de l'étudiant à son programme 
    gitlab #439

    convsta_Requis_au_diplome__c requisAuDiplome;
      try{
        requisAuDiplome = [
          SELECT Id
          FROM convsta_Requis_au_diplome__c
          WHERE Programme__c = :codeProgramme AND Annee_Application__c = :annee
          LIMIT 1
        ];
      }
      catch(Exception e){
          throw new AuraHandledException(
              'Pas de correspondance accessible pour le profil du candidat, dans les requis au diplome : Prefixe du code étudiant :#' +
              annee +
              '# et Programme :#' +
              codeProgramme +
              '#. Prenez contact avec le career centrer / Notify career center to unlock you'
          );
      }
      */

    Map<String, Object> res = new Map<String, Object>();
    res.put('email', email);
    res.put('CONVSTA_Table_Regles_Experience_Pro__c', tableListe[0].Id);
    //res.put('convsta_Requis_au_diplome__c', requisAuDiplome.Id);
    res.put(
      'Convsta_Tuteur_par_defaut__c',
      tableListe[0].Convsta_Tuteur_par_defaut__c
    );
    res.put(
      'Convsta_Signataire_delegue_EM__c',
      tableListe[0].Convsta_Signataire_delegue_EM__c
    );
    res.put('expAnterieureOk', String.valueOf(tableListe[0].Anterieur__c));
    res.put('Code_Ann_e_Etudiant__c', codeAnnee);

    return res;
  }

  public static Case setDetailStatusSignataires(
    Case demande,
    Boolean doInsert
  ) {
    try {
      if (!isCanceledSignature(demande.Convsta_Detail_statut_signataire__c)) {
        String accessToken = getSignatureToken(demande);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(
          Label.convsta_domain_esign +
          'Api/v1/Signature/Status/' +
          demande.Convsta_eSign_ExtId__c
        );
        req.setMethod('GET');
        req.setHeader('Authorization', 'Basic ' + accessToken);
        req.setTimeout(120000);

        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        res = http.send(req);

        if (res.getStatusCode() == 200) {
          JsonParser parser = Json.createParser(res.getBody());
          parser.nextToken();
          SwagSignatureStatusResponse signatureStatusResponse = (SwagSignatureStatusResponse) parser.readValueAs(
            Type.forName('SwagSignatureStatusResponse')
          );
          demande.Convsta_Statut_Signature__c = statusFromWsStatus(
            signatureStatusResponse.currentStatus
          );
          demande.Convsta_date_derniere_relance_signature__c = signatureStatusResponse.horodatageCurrentStatus;
          demande.Convsta_Detail_statut_signataire__c = '';
          for (
            SwagSignatureSignataireStatus signataireStatus : signatureStatusResponse.signatairesStatus
          ) {
            demande.Convsta_Detail_statut_signataire__c += (signataireStatus.prenomSignataire !=
              'observer'
              ? signataireStatus.nomSignataire +
                ' ' +
                signataireStatus.prenomSignataire +
                ' ' +
                signataireStatus.currentStatus +
                ' ' +
                (signataireStatus.currentStatus == 'signed'
                  ? signataireStatus.horodatageCurrentStatus.format(
                      'dd/MM/yyyy HH:mm:ss',
                      'Europe/Paris'
                    ) + '\n'
                  : '\n')
              : '');

            if (signataireStatus.currentStatus == 'expired') {
              demande.Convsta_Statut_Signature__c = 'Expirée';
              demande.Status = 'Expirée';
              break;
            } else if (signataireStatus.currentStatus == 'canceled') {
              demande.Convsta_Statut_Signature__c = 'Annulée';
              break;
            }
          }
          demande.Convsta_Detail_statut_signataire__c +=
            'MAJ ' +
            Datetime.now().format('dd/MM/yyyy HH:mm:ss', 'Europe/Paris');

          demande.Convsta_eSign_Errors__c = '';
        } else {
          updateDemandeRequestError(demande, res, 'setDetailStatus');
        }
      }
    } catch (Exception e) {
      updateDemandeException(demande, e, 'setDetailStatusSignataires');
    }
    if (doInsert) {
      update demande;
    }
    return demande;
  }
  public static String statusFromWsStatus(String inStatus) {
    String outStatus = '';
    switch on inStatus {
      when 'ready' {
        // this line errors
        outStatus = 'Convention en attente de signature';
      }
      when 'completed' {
        outStatus = 'Signée';
      }
      when null {
        outStatus = 'Expirée';
      }
      when 'canceled' {
        outStatus = 'Annulée';
      }
    }
    return outStatus;
  }
  public static String getSignedDocumentURL(Case demande) {
    String url = '';
    try {
      String accessToken = getSignatureToken(demande);

      HttpRequest req = new HttpRequest();
      req.setEndpoint(
        Label.convsta_domain_esign +
        'Api/v1/Signature/Documents/' +
        /*'ConvSta_20191204_025630_282' */ demande.Convsta_eSign_ExtId__c /*+ '&minutesToExpire=60'*/
      );
      //req.setEndpoint('https://int-wsesign-convsta-ext.pdw-em-lyon.com:443/Home/OpenDocument?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InN2Yy1pbnQtY29udnN0YSIsIkNvZGVJdERvY3VtZW50IjoiQ29udlN0YV8yMDE5MTIwNF8wMjU2MzFfMDAwMDA1MjgiLCJuYmYiOjE1NzU2MjU5NTcsImV4cCI6MTU3NTcxMjM1NywiaWF0IjoxNTc1NjI1OTU3fQ.cDBhf_jhUOYPJ2Wm-2N9tij4OE1GGsHgPXJAAz59_iM');
      req.setMethod('GET');
      req.setHeader('Authorization', 'Basic ' + accessToken);
      req.setTimeout(120000);

      system.debug('£££ YGA Modis - request GET Signature/Document : ' + req);

      Http http = new Http();
      HTTPResponse res = new HTTPResponse();
      if (!Test.isRunningTest()) {
        res = http.send(req);
      } else {
        res.setBody(
          '{"CustomId":"ConvSta_20191204_025630_282","Documents":[{"DocumentId":"ConvSta_20191204_025631_00000528","Link":"https://int-wsesign-convsta-ext.pdw-em-lyon.com:443/Home/OpenDocument?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InN2Yy1pbnQtY29udnN0YSIsIkNvZGVJdERvY3VtZW50IjoiQ29udlN0YV8yMDE5MTIwNF8wMjU2MzFfMDAwMDA1MjgiLCJuYmYiOjE1NzU2MjU5NTcsImV4cCI6MTU3NTcxMjM1NywiaWF0IjoxNTc1NjI1OTU3fQ.cDBhf_jhUOYPJ2Wm-2N9tij4OE1GGsHgPXJAAz59_iM"}]}'
        );
        res.setStatusCode(200);
      }

      if (res.getStatusCode() == 200) {
        system.debug('£££ YGA Modis - jai URL du doc : ' + res.getBody());
        JsonParser parser = Json.createParser(res.getBody());
        parser.nextToken();
        SwagSignatureDocumentResponse signDocResponse = (SwagSignatureDocumentResponse) parser.readValueAs(
          Type.forName('SwagSignatureDocumentResponse')
        );

        for (
          SwagSignatureDocumentSignedModel signedDoc : signDocResponse.documents
        ) {
          url = signedDoc.link;
        }
      } else {
        system.debug('£££ YGA error WS - Status Code : ' + res.getStatusCode());
        system.debug('£££ YGA error WS - Status : ' + res.getStatus());
        system.debug('£££ YGA error WS - Body : ' + res.getBody());
        updateDemandeRequestError(demande, res, 'getSignedDocumentURL');
        //update demande;
        return null;
      }
    } catch (Exception e) {
      system.debug('£££ YGA error WS - Catch Exception' + e);
      updateDemandeException(demande, e, 'getSignedDocumentURL');
      //update demande;
      return null;
    }
    return url;
  }

  public static void getSignedDocument(Case demande) {
    String endPoint = getSignedDocumentUrl(demande);
    if (endPoint != null) {
      try {
        String accessToken = getSignatureToken(demande);

        HttpRequest req = new HttpRequest();
        //req.setEndpoint(Label.convsta_domain_esign + 'Api/v1/Signature/Documents/' + /*'ConvSta_20191204_025630_282' */demande.Convsta_eSign_ExtId__c);
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Basic ' + accessToken);
        req.setTimeout(120000);

        system.debug('£££ YGA Modis - request download Document : ' + req);

        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
          res = http.send(req);
        } else {
          res.setBody(
            'TEST is running - fake data for body response for get PDF document'
          );
          res.setStatusCode(200);
        }

        if (res.getStatusCode() == 200) {
          system.debug('£££ YGA Modis - jai le doc resp : #' + res.getBody());

          String filename = demande.parentId == null
            ? 'Convention-'
            : 'Avenant-' + demande.CaseNumber + '.pdf';

          ContentVersion cv = new ContentVersion();
          //cv.ExternalDocumentInfo1 = demande.id;
          //cv.OwnerId = '0050D000002dzZO';
          cv.ContentLocation = 'S';
          cv.PathOnClient = fileName;
          cv.Origin = 'C';
          cv.Title = fileName;
          cv.VersionData = res.getBodyAsBlob();
          insert cv;

          ContentVersion cv2 = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
          ];

          List<ContentDocumentLink> listCl = new List<ContentDocumentLink>();
          listCl.add(
            new ContentDocumentLink(
              LinkedEntityId = demande.Id,
              ContentDocumentId = cv2.ContentDocumentId,
              ShareType = 'V',
              Visibility = 'AllUsers'
            )
          );
          if (demande.parentid != null) {
            demande.Status = 'Avenant signé';
            listCl.add(
              new ContentDocumentLink(
                LinkedEntityId = demande.parentId,
                ContentDocumentId = cv2.ContentDocumentId,
                ShareType = 'I',
                Visibility = 'AllUsers'
              )
            );
          } else {
            demande.Status = 'Convention signée';
          }
          insert listCl;

          demande.Convsta_Statut_Signature__c = 'Signée';
          demande.Convsta_Convention__c = true;
          demande.Convsta_ConventionDocumentId__c = String.valueOf(
            cv2.ContentDocumentId
          );
          demande.Date_Reception_Convention__c = Datetime.now();
          update demande;
        } else {
          system.debug(
            '£££ YGA error WS - Status Code : ' + res.getStatusCode()
          );
          system.debug('£££ YGA error WS - Status : ' + res.getStatus());
          system.debug('£££ YGA error WS - Body : ' + res.getBody());
          updateDemandeRequestError(demande, res, 'getSignedDocument');
          update demande;
        }
      } catch (Exception e) {
        system.debug('£££ YGA error WS - Catch Exception' + e);
        updateDemandeException(demande, e, 'getSignedDocument');
        update demande;
      }
    }
  }
  /*------------- end GET/SET methods---------------*/

  /*------------- start DOPOST methods---------------*/
  public static void doPostSignatureCreate(
    Case demande,
    SignatureStruct typeStruct,
    List<SwagSignatureSignerModel> lSigners,
    List<SwagSignatureFieldModel> signatureFieldList,
    SwagSignatureServerOptionsModel signatureServerOptions
  ) {
    Boolean errorEsign = false;
    try {
      Boolean useCachetServeur = false;
      convsta_Esign_Config__c customSetting = convsta_Esign_Config__c.getOrgDefaults();
      if (customSetting == null) {
        customSetting = new convsta_Esign_Config__c(Activate_Esign__c = false);
      }
      useCachetServeur = customSetting.Activate_Esign__c;

      demande.Convsta_eSign_Errors__c = '';
      eSign_Configuration__mdt eSignConf = getESignConf();
      PageReference pdf = typeStruct.page;

      pdf.getParameters().put('caseId', demande.Id);
      Blob content;
      if (Test.IsRunningTest()) {
        content = Blob.valueOf('TEST');
      } else {
        content = pdf.getContent();
      }
      //dynamic content
      SwagSignatureDocumentModel transactionDocument = new SwagSignatureDocumentModel();
      transactionDocument.content = content;
      transactionDocument.url = null;
      transactionDocument.documentType = 'pdf';
      transactionDocument.fileName =
        typeStruct.fileName +
        demande.CaseNumber +
        '.pdf';
      transactionDocument.signatureFields = signatureFieldList;
      transactionDocument.checkBoxTexts = new List<String>{
        eSignConf.documentCheckBoxTexts__c
      };
      transactionDocument.metaData = null;
      transactionDocument.title = eSignConf.documentTitle__c;
      transactionDocument.sepaData = null;
      if (useCachetServeur) {
        transactionDocument.serverSignatureOptions = signatureServerOptions;
      }

      SwagSignatureCreateRequest request = new SwagSignatureCreateRequest();
      request.transacIdApplicationSource = eSignConf.ID_transacIdApplicationSource__c;
      request.transacCodeApplicationSource = eSignConf.ID_transacCodeApplicationSource__c;
      request.transacDemandeurApplicationSource = eSignConf.ID_transacDemandeurApplicationSource__c;
      request.transacCodePrestataireSignature = Integer.valueOf(
        eSignConf.ID_transacCodePrestataireSignature__c
      );
      request.transacUrlWebHookApplicationSource = Label.convsta_returnWebhook;
      request.profile = eSignConf.ID_profile__c;
      request.signers = lSigners;
      request.documents = new List<SwagSignatureDocumentModel>{
        transactionDocument
      };
      request.mustContactFirstSigner = true;
      request.finalDocSent = true;
      request.language = SwagSignatureCreateRequest.LanguageEnum.FR;
      request.finalDocRequesterSent = false;
      request.finalDocObserverSent = true;
      request.description = demande.CaseNumber;
      request.certificateType = SwagSignatureCreateRequest.CertificateTypeEnum.SIMPLE;
      request.handwrittenSignatureMode = SwagSignatureCreateRequest.HandwrittenSignatureModeEnum.DESACTIVESIGNATUREMANUSCRITE;
      request.chainingMode = SwagSignatureCreateRequest.ChainingModeEnum.EMAIL;
      request.finalDocCCeMails = new List<String>{
        Label.convsta_email_salesforce
      };
      request.twoStepsRegistration = new List<String>();
      if (useCachetServeur) {
        request.type = SwagSignatureCreateRequest.RTypeEnum.MIXTEAVECOPTION;
      } else {
        request.type = SwagSignatureCreateRequest.RTypeEnum.SIMPLE;
      }
      request.nbJoursAvantRelance = Integer.valueOf(
        eSignConf.nbJoursAvantRelance__c
      );
      request.nbMaxRelance = Integer.valueOf(eSignConf.nbMaxRelance__c);

      String accessToken = getSignatureToken(demande);
      System.debug('€€€accessToken: ' + accessToken);

      HttpRequest req = new HttpRequest();
      req.setEndpoint(Label.convsta_domain_esign + 'Api/v1/Signature/Create');
      req.setMethod('POST');
      req.setBody(JSON.serialize(request));
      System.debug('JSON.serialize(request) : ' + JSON.serialize(request));
      req.setHeader('Content-Type', 'application/json');
      req.setHeader('Authorization', 'Basic ' + accessToken);
      req.setTimeout(120000);
      Http http = new Http();
      HTTPResponse res = http.send(req);

      Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      String signExtId = (String) results.get('CustomId');

      if (res.getStatusCode() == 200 && signExtId != null) {
        demande.Convsta_Statut_Signature__c = 'Envoyé';
        demande.Convsta_eSign_ExtId__c = signExtId;

        if (typeStruct.fileTitle == 'AVENANT CONVENTION DE STAGE') {
          demande.Convsta_Statut_Signature__c = 'Avenant en cours de signature';
        } else {
          demande.Convsta_Statut_Signature__c = 'Convention en attente de signature';
        }

        demande.Convsta_eSign_Errors__c = '';

        update demande;
      } else {
        updateDemandeRequestError(demande, res, 'PostCreate');
        update demande;

        errorEsign = true;
      }
    } catch (Exception e) {
      updateDemandeException(demande, e, 'doPostSignatureCreate');
      update demande;
      if (errorEsign) {
        throw new CalloutException('Esign refused the incoming message');
      }
    }
  }

  public static void doPostSignatureCreateConvention(
    Case demande,
    SwagSignatureSignerModel respAdmin,
    eSign_Configuration__mdt eSignConf
  ) {
    Integer indexRP = 2;

    SignatureStruct struct = new SignatureStruct();
    struct.fileTitle = (demande.Convsta_Langue__c == 'Français')
      ? 'CONVENTION DE STAGE'
      : ((demande.Convsta_Langue__c == 'Anglais')
          ? 'WORK PLACEMENT AGREEMENT'
          : ((demande.Convsta_Langue__c == 'Espagnol')
              ? 'CONVENIO DE PRÁCTICAS'
              : null));
    struct.fileName = 'convention-';
    struct.page = Page.Convsta_GenerationConvention;

    String name = struct.fileTitle;

    List<SwagSignatureFieldModel> signatureFieldList = new List<SwagSignatureFieldModel>();

    List<SwagSignatureSignerModel> lSigners = new List<SwagSignatureSignerModel>();
    System.debug(
      'makeSigner(demande.Contact.Id,eSignConf) : ' +
      makeSigner(demande.Contact.Id, eSignConf, true)
    );
    lSigners.add(makeSigner(demande.Contact.Id, eSignConf, true));
    System.debug('respAdmin: ' + respAdmin);
    lSigners.add(respAdmin);

    if (
      demande.Convsta_Tuteur__c !=
      demande.Responsable_administratif_entreprise__c
    ) {
      indexRP++;
      SwagSignatureSignerModel tuteur = makeSigner(
        demande.Convsta_Tuteur__c,
        eSignConf,
        false
      );
      Convsta_Mission__c tuteurDetail = [
        SELECT
          Email_Tuteur_Entreprise__c,
          Prenom_Tuteur_Entreprise__c,
          Nom_Tuteur_Entreprise__c
        FROM Convsta_Mission__c
        WHERE MD_Demande__c = :demande.Id
        LIMIT 1
      ];
      tuteur.emailAddress = tuteurDetail.Email_Tuteur_Entreprise__c;
      tuteur.lastName = tuteurDetail.Nom_Tuteur_Entreprise__c;
      tuteur.firstName = tuteurDetail.Prenom_Tuteur_Entreprise__c;
      /*List<SwagSignatureSignerModel> lSigners = new List<SwagSignatureSignerModel>();
System.debug('makeSigner(demande.Contact.Id,eSignConf) : '+makeSigner(demande.Contact.Id,eSignConf,true));
lSigners.add(makeSigner(demande.Contact.Id,eSignConf,true));
System.debug('respAdmin: '+respAdmin);
lSigners.add(respAdmin);*/
      System.debug('tuteur : ' + tuteur);
      lSigners.add(tuteur);

      signatureFieldList.add(
        makeSignatureField(
          name,
          indexRP - 1,
          (Integer) eSignConf.posSignXtuteurEntreprise__c,
          (Integer) eSignConf.posSignYtuteurEntreprise__c,
          tuteur.lastName +
          ' ' +
          tuteur.firstName
        )
      );
    }

    System.debug(
      'last: ' +
      makeSigner(
        (demande.Convsta_Signataire_delegue__c == null
          ? demande.Convsta_Referent_pedagogique__c
          : demande.Convsta_Signataire_delegue__c),
        eSignConf,
        false
      )
    );

    //lSigners.add(makeSigner((demande.Convsta_Signataire_delegue__c==null ? demande.Convsta_Referent_pedagogique__c : demande.Convsta_Signataire_delegue__c), eSignConf));
    // 19/11/2019 YGA Modis - Pour les programmes BBA on applique directement la signature de Chantal POTY sur la convetion donc on ne l'envoit pas au WS
    if (
      !demande.Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c
    ) {
      lSigners.add(
        makeSigner(
          (demande.Convsta_Signataire_delegue__c == null
            ? demande.Convsta_Referent_pedagogique__c
            : demande.Convsta_Signataire_delegue__c),
          eSignConf,
          false
        )
      );
    }

    lSigners.add(makeObserver(eSignConf));

    //String name = struct.fileTitle;
    //List<SwagSignatureFieldModel> signatureFieldList = new List<SwagSignatureFieldModel>();
    signatureFieldList.add(
      makeSignatureField(
        name,
        0,
        (Integer) eSignConf.posSignXstagiaire__c,
        (Integer) eSignConf.posSignYstagiaire__c,
        demande.contact.LastName +
        ' ' +
        demande.contact.FirstName
      )
    );
    signatureFieldList.add(
      makeSignatureField(
        name,
        1,
        (Integer) eSignConf.posSignXrespAdmin__c,
        (Integer) eSignConf.posSignYrespAdmin__c,
        respAdmin.lastName +
        ' ' +
        respAdmin.firstName
      )
    );

    // 19/11/2019 YGA Modis - Pour les programmes BBA on applique directement la signature de Chantal POTY sur la convetion donc on ne l'envoit pas au WS
    if (
      !demande.Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c
    ) {
      signatureFieldList.add(
        makeSignatureField(
          name,
          indexRP,
          (Integer) eSignConf.posSignXrespEcole__c,
          (Integer) eSignConf.posSignYrespEcole__c,
          (demande.Convsta_Signataire_delegue__c == null
            ? demande.Convsta_Referent_pedagogique__r.LastName +
              ' ' +
              demande.Convsta_Referent_pedagogique__r.FirstName
            : demande.Convsta_Signataire_delegue__r.LastName +
              ' ' +
              demande.Convsta_Signataire_delegue__r.FirstName)
        )
      );
    }
    /*else{
makeCertificateField(  name,
0,
(Integer)eSignConf.posSignXrespEcole__c, 
(Integer)eSignConf.posSignYrespEcole__c, 
Label.convsta_responsable_pedagogique);
}*/

    /*signatureFieldList.add( makeSignatureField( name,
5,
(Integer)eSignConf.posSignXcachet__c, 
(Integer)eSignConf.posSignYcachet__c, 
Label.convsta_directeur_academique));*/

    SwagSignatureServerOptionsModel signatureServerOptionsModel = makeCertificateField(
      name,
      0,
      (Integer) eSignConf.posSignXcachet__c,
      (Integer) eSignConf.posSignYcachet__c,
      Label.convsta_directeur_academique
    );

    doPostSignatureCreate(
      demande,
      struct,
      lSigners,
      signatureFieldList,
      signatureServerOptionsModel
    );
  }

  public static void doPostSignatureCreateAvenant(
    Case avenant,
    SwagSignatureSignerModel respAdmin,
    eSign_Configuration__mdt eSignConf
  ) {
    Case demande = [
      SELECT
        CaseNumber,
        Responsable_administratif_entreprise__c,
        Responsable_administratif_entreprise__r.LastName,
        Responsable_administratif_entreprise__r.FirstName
      FROM Case
      WHERE id = :avenant.ParentId
      LIMIT 1
    ];
    SignatureStruct struct = new SignatureStruct();
    struct.fileTitle = 'AVENANT CONVENTION DE STAGE';
    struct.fileName = 'avenant-';
    struct.page = Page.Convsta_GenerationAvenant;

    List<SwagSignatureSignerModel> lSigners = new List<SwagSignatureSignerModel>();
    lsigners.add(makeSigner(avenant.Contact.Id, eSignConf, true));
    lSigners.add(respAdmin);
    lSigners.add(makeObserver(eSignConf));

    String name = struct.fileTitle;
    List<SwagSignatureFieldModel> signatureFieldList = new List<SwagSignatureFieldModel>();
    signatureFieldList.add(
      makeSignatureField(
        name,
        0,
        44,
        640,
        avenant.contact.LastName +
        ' ' +
        avenant.contact.FirstName
      )
    );
    signatureFieldList.add(
      makeSignatureField(
        name,
        1,
        44,
        520,
        respAdmin.lastName +
        ' ' +
        respAdmin.firstName
      )
    );

    SwagSignatureServerOptionsModel signatureServerOptionsModel = makeCertificateField(
      name,
      0,
      (Integer) eSignConf.posSignXcachet__c,
      (Integer) eSignConf.posSignYcachet__c,
      Label.convsta_directeur_academique
    );

    doPostSignatureCreate(
      avenant,
      struct,
      lSigners,
      signatureFieldList,
      signatureServerOptionsModel
    );
  }

  public static void doPostSignatureCreateFromQueueable(
    Case demande,
    Boolean isForConvention
  ) {
    try {
      eSign_Configuration__mdt eSignConf = getESignConf();

      if (isForConvention) {
        Convsta_WS_Helper.doPostSignatureCreateConvention(
          demande,
          Convsta_WS_Helper.makeRespAdministratif(
            demande.Responsable_administratif_entreprise__c,
            demande.id,
            eSignConf
          ),
          eSignConf
        );
      } else {
        Convsta_WS_Helper.doPostSignatureCreateAvenant(
          demande,
          Convsta_WS_Helper.makeRespAdministratif(
            demande.parent.Responsable_administratif_entreprise__c,
            demande.parentid,
            eSignConf
          ),
          eSignConf
        );
      }
    } catch (Exception e) {
      String error =
        'Erreur lors de doPostSignatureCreate : ' +
        e.getMessage() +
        e.getStackTraceString();
      throw new CalloutException(error);
    }
  }
  /*------------- end DOPOST methods---------------*/

  /*------------- start MAKE SIGNER DATA methods---------------*/
  public static SwagSignatureSignerModel makeSigner(
    Id salesforceId,
    eSign_Configuration__mdt eSignConf,
    Boolean useMailEtu
  ) {
    SwagSignatureSignerModel signer = new SwagSignatureSignerModel();
    signer.organization = eSignConf.ID_organization__c;
    signer.profile = eSignConf.ID_profile__c;
    //signer.phoneNumber =                    null;
    signer.language = SwagSignatureSignerModel.LanguageEnum.FR; //demande.Convsta_Langue__c;
    signer.role = SwagSignatureSignerModel.RoleEnum.SIGNER;
    //signer.birthDate =                       null;
    //signer.univerSignID =                   null;
    signer.successURL = eSignConf.successURL__c;
    signer.cancelURL = eSignConf.cancelURL__c;
    signer.failURL = eSignConf.failURL__c;
    //signer.certificateType =                'simple';
    //signer.idDocuments =                    null;
    signer.validationSessionId = null;

    Contact ctc = new Contact();
    User usr = new User();
    System.debug('€€€ sfid:' + salesforceId);
    if (String.valueOf(salesforceId).startsWith('003')) {
      System.debug('€€€contact');
      ctc = [
        SELECT Id, FirstName, LastName, Email, Email_EM_Lyon__c
        FROM Contact
        WHERE Id = :salesforceId
      ];
    } else {
      System.debug('€€€user');
      usr = [
        SELECT Id, FirstName, LastName, Email
        FROM User
        WHERE Id = :salesforceId
      ];
    }

    signer.firstName = ctc.Id == null ? usr.FirstName : ctc.FirstName;
    signer.lastName = ctc.Id == null ? usr.LastName : ctc.LastName;
    signer.emailAddress = ctc.Id == null
      ? usr.Email
      : (useMailEtu ? ctc.Email_EM_Lyon__c : ctc.Email);
    return signer;
  }

  public static SwagSignatureSignerModel makeObserver(
    eSign_Configuration__mdt eSignConf
  ) {
    SwagSignatureSignerModel signer = new SwagSignatureSignerModel();
    signer.organization = eSignConf.ID_organization__c;
    signer.profile = eSignConf.ID_profile__c;
    //signer.phoneNumber =                    null;
    signer.language = SwagSignatureSignerModel.LanguageEnum.FR;
    signer.role = SwagSignatureSignerModel.RoleEnum.OBSERVER;
    //signer.birthDate =                       null;
    //signer.univerSignID =                   null;
    signer.successURL = eSignConf.successURL__c;
    signer.cancelURL = eSignConf.cancelURL__c;
    signer.failURL = eSignConf.failURL__c;
    //signer.certificateType =                'simple';
    //signer.idDocuments =                    null;
    signer.validationSessionId = null;
    signer.firstName = 'observer';
    signer.lastName = 'return';
    signer.emailAddress = label.convsta_email_salesforce;
    return signer;
  }

  public static SwagSignatureSignerModel makeRespAdministratif(
    id respAdmId,
    id caseId,
    eSign_Configuration__mdt eSignConf
  ) {
    SwagSignatureSignerModel respAdmin = makeSigner(
      respAdmId,
      eSignConf,
      false
    );
    system.debug('€€€:' + caseId);
    Convsta_Entreprise__c respAdminDetail = [
      SELECT
        Nom_Signataire_Convention__c,
        Prenom_Signataire_Convention__c,
        Email_Signataire_Convention__c
      FROM Convsta_Entreprise__c
      WHERE MD_Demande__c = :caseId
      LIMIT 1
    ];
    respAdmin.emailAddress = respAdminDetail.Email_Signataire_Convention__c;
    respAdmin.firstName = respAdminDetail.Prenom_Signataire_Convention__c;
    respAdmin.lastName = respAdminDetail.Nom_Signataire_Convention__c;
    return respAdmin;
  }

  public static SwagSignatureFieldModel makeSignatureField(
    String name,
    Integer index,
    Integer xpos,
    Integer ypos,
    String label
  ) {
    SwagSignatureFieldModel documentSign = new SwagSignatureFieldModel();
    documentSign.image = null;
    documentSign.label = label; // nom+prénom(+fonction du signataire à
    documentSign.name = name;
    documentSign.page = -1;
    documentSign.patternName = null;
    documentSign.signerIndex = index; //correspond au signataire
    documentSign.x = xpos;
    documentSign.y = ypos;
    return documentSign;
  }

  public static SwagSignatureServerOptionsModel makeCertificateField(
    String name,
    Integer index,
    Integer xpos,
    Integer ypos,
    String label
  ) {
    SwagSignatureServerOptionsModel signatureServerOptionsModel = new SwagSignatureServerOptionsModel();
    signatureServerOptionsModel.image = null;
    signatureServerOptionsModel.label = label;
    signatureServerOptionsModel.location = null;
    signatureServerOptionsModel.name = name;
    signatureServerOptionsModel.page = -1;
    signatureServerOptionsModel.patternName = null;
    signatureServerOptionsModel.profile = getESignConf()
      .ID_du_profil_cachet_serveur__c; //'default';//getESignConf().ID_profile__c;
    signatureServerOptionsModel.reason = null;
    signatureServerOptionsModel.signatureFormat = null;
    signatureServerOptionsModel.x = xpos;
    signatureServerOptionsModel.y = ypos;
    return signatureServerOptionsModel;
  }
  /*------------- end MAKE SIGNER DATA methods---------------*/

  /*------------- start UPDATE methods---------------*/
  public static void updateDemandeException(
    Case demande,
    Exception e,
    String methodName
  ) {
    demande.Convsta_Statut_Signature__c = 'Erreur génération';
    demande.Convsta_eSign_Errors__c +=
      'Erreur lors de la méthode ' +
      methodName +
      ' :\r\n';
    demande.Convsta_eSign_Errors__c +=
      'Numéro de la ligne en erreur : ' +
      e.getLineNumber() +
      '\r\n';
    demande.Convsta_eSign_Errors__c +=
      'Message de l\'erreur : ' +
      e.getMessage() +
      '\r\n';
    demande.Convsta_eSign_Errors__c +=
      'Trace de l\'erreur : ' +
      e.getStackTraceString() +
      '\r\n';
    demande.Convsta_eSign_Errors__c +=
      'Type de l\'erreur : ' +
      e.getTypeName() +
      '\r\n';
    demande.Convsta_eSign_Errors__c += 'Cause de l\'erreur : ' + e.getCause();
  }

  public static void updateDemandeRequestError(
    Case demande,
    HttpResponse res,
    string methodName
  ) {
    demande.Convsta_Statut_Signature__c = 'Erreur génération';
    demande.Convsta_eSign_Errors__c += methodName + ' error : \r\n';
    demande.Convsta_eSign_Errors__c +=
      'Status Code : ' +
      res.getStatusCode() +
      '\r\n';
    demande.Convsta_eSign_Errors__c += 'Status : ' + res.getStatus() + '\r\n';
    demande.Convsta_eSign_Errors__c += 'Body : ' + res.getBody() + '\r\n';
  }
  /*------------- end UPDATE methods---------------*/

  /*------------- start OTHERS methods---------------*/
    private static Boolean isCanceledSignature(String detailStatusSignature){
        return detailStatusSignature != null && detailStatusSignature.contains('Annulation par : ');
    }
    
  public static void cancelSignature(Case demande) {
    if (
        !isCanceledSignature(demande.Convsta_Detail_statut_signataire__c)
    ) {
      try {
        String accessToken = getSignatureToken(demande);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(
          Label.convsta_domain_esign +
          'Api/v1/Signature/Cancel/' +
          demande.Convsta_eSign_ExtId__c
        );
        req.setMethod('DELETE');
        req.setHeader('Authorization', 'Basic ' + accessToken);
        req.setTimeout(120000);

        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        res = http.send(req);

        if (res.getStatusCode() == 200) {
          demande.Convsta_Statut_Signature__c = 'Annulée';
            
          demande.Convsta_Detail_statut_signataire__c = 
              (demande.Convsta_Detail_statut_signataire__c !=null ? (demande.Convsta_Detail_statut_signataire__c +'\n' ):'')+
            'Annulation par : ' +
            UserInfo.getName() +
            ' le ' +
            Datetime.now().format('dd/MM/yyyy HH:mm:ss', 'Europe/Paris');
        } else {
          updateDemandeRequestError(demande, res, 'cancelSignature');
        }

        update demande;
      } catch (Exception e) {
        updateDemandeException(demande, e, 'cancelSignature');
        update demande;
      }
    }
  }
  /*------------- end OTHERS methods---------------*/
}