/*
 * WSCursus Externe
 * Service externe du webservice WSCursus.
 *
 * The version of the OpenAPI document: 1
 * Contact: taubert@em-lyon.com
 *
 * NOTE: This class is auto generated by the OAS code generator program.
 * https://github.com/OpenAPITools/openapi-generator
 * Do not edit the class manually.
 */

public class OASElevesApi {
  OASClient client;
  String auth;

  public OASElevesApi(OASClient client) {
    this.client = client;
    auth = this.getToken();
  }

  public OASElevesApi() {
    this.client = new OASClient();
    auth = this.getToken();
  }

  public OASClient getClient() {
    return this.client;
  }

  private String getToken() {
    HttpRequest req = new HttpRequest();
    //    req.setEndpoint('https://uat-wsrefint-ext.pdw-em-lyon.com/Api/v1/Auth');
    req.setEndpoint(Label.convsta_domain_ws_cursus + 'Api/v1/Auth');
    req.setMethod('POST');
    req.setBody(
      '{"userName" : "' +
      Label.convsta_cursus_user +
      '", "password" : "' +
      Label.convsta_cursus_password +
      '"}'
    );
    req.setHeader('Content-Type', 'application/json');
    req.setTimeout(120000);
    Http http = new Http();
    Map<String, Object> results = new Map<String, Object>();
    if (Test.isRunningTest()) {
      results = new Map<String, Object>{ 'accessToken' => 'token' };
    } else {
      HTTPResponse res = http.send(req);
      results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
    }
    return (String) results.get('accessToken');
  }
  /**
   * Méthode pour rechercher l’existence d’une phase (de type stage) dans le cursus d’un étudiant.
   *
   * @param codeEleve Code élève (required)
   * @param typePhase Type de phase - Exemple : STA (pour une phase de stage) (optional)
   * @param dateDebut Date de début de la phase - Format : 2019-12-31T00:00:00Z (optional)
   * @param dateFin Date de début de la phase - Format : 2020-06-30T00:00:00Z (optional)
   * @return OASModeleRetourPhase
   * @throws OAS.ApiException if fails to make API call
   */
  public getPhaseReturn getPhasesCursus(Map<String, Object> params) {
    client.assertNotNull(params.get('codeEleve'), 'codeEleve');
    List<OAS.Param> query = new List<OAS.Param>();

    // cast query params to verify their expected type
    query.addAll(
      client.makeParam('typePhase', (String) params.get('typePhase'))
    );
    query.addAll(
      client.makeParam('dateDebut', (Datetime) params.get('dateDebut'))
    );
    query.addAll(client.makeParam('dateFin', (Datetime) params.get('dateFin')));

    List<OAS.Param> form = new List<OAS.Param>();

    HttpRequest req = client.makeRequest(
      'GET',
      '/Api/v1/Eleves/{codeEleve}/phases',
      '',
      query,
      form,
      new Map<String, Object>{
        'codeEleve' => (String) params.get('codeEleve')
      },
      new Map<String, Object>(),
      new List<String>{ 'application/json' },
      new List<String>(),
      new List<String>{ 'Basic ' + this.auth }
    );
    req.setTimeout(120000);
    HttpResponse rep = new Http().send(req);
    system.debug(rep.getBody());
    if (
      rep.getBody() == '"Il n\'existe pas de phase de stage pour cet étudiant"'
    ) {
      return new getPhaseReturn('', '', '', '', rep.getBody(), false);
    }
    OASModeleRetourPhase returnVal = (OASModeleRetourPhase) JSON.deserialize(
      rep.getBody(),
      OASModeleRetourPhase.class
    );

    if (String.isNotBlank(returnVal.codePhase)) {
      return new getPhaseReturn(returnVal.codePhase, returnVal.exeDeb, returnVal.etuDeb, returnVal.perDeb, '', true);
    } else {
      return new getPhaseReturn(null, '', '', '', returnVal.messageRetour, false);
    }
  }

  public class getPhaseReturn {
    public String codePhase;
    public String exeBul;
    public String etuBul;
    public String perBul;
    public String errorMsg;
    public Boolean success;

    public getPhaseReturn(String code, string exeBul, string etuBul, string perBul,string msg, Boolean sccss) {
      this.codePhase = code;
      this.exeBul = exeBul;
      this.etuBul = etuBul;
      this.perBul = perBul;
      this.errorMsg = msg;
      this.success = sccss;
    }
  }
  /**
   * Méthode pour mettre à jour une évaluation d’un étudiant.
   * Exemple de requête :\r\n            \r\n    PUT /20201138/evaluation\r\n    {\r\n      &quot;codePhase&quot;: &quot;424467&quot;,\r\n      &quot;exercice&quot;: &quot;2020&quot;,\r\n      &quot;codeEpr&quot;: &quot;6FACPA&quot;,\r\n      &quot;numsession&quot;: &quot;02&quot;,\r\n      &quot;codePeriode&quot;: &quot;1S&quot;,\r\n      &quot;absctl&quot;: false,\r\n      &quot;ctlseul&quot;: false,\r\n      &quot;dispens&quot;: false,\r\n      &quot;rang&quot;: 1,\r\n      &quot;complet&quot;: false,\r\n      &quot;notechiffre&quot;: 19.50,\r\n      &quot;notevalid&quot;: true,\r\n      &quot;exeBul&quot;: &quot;2020&quot;,\r\n      &quot;etuBul&quot;: &quot;MDA&quot;,\r\n      &quot;perBul&quot;: &quot;1S&quot;,\r\n      &quot;editeBul&quot;: 0,\r\n      &quot;majnoteVerrou&quot;: 0,\r\n      &quot;noteects&quot;: &quot;A&quot;,\r\n      &quot;dateCrenote&quot;: &quot;2020-07-23T13:58:48.806Z&quot;,\r\n      &quot;dateMajverdict&quot;: &quot;2020-07-23T13:58:48.806Z&quot;\r\n    }
   * @param codeEleve Code élève (required)
   * @param evaluation Données de l\&#39;évaluation (optional)
   * @return OASErrorResult
   * @throws OAS.ApiException if fails to make API call
   */
  public updateEvalReturn updateEvaluationEtudiantAsync(Map<String, Object> params) {
    client.assertNotNull(params.get('codeEleve'), 'codeEleve');
    List<OAS.Param> query = new List<OAS.Param>();
    List<OAS.Param> form = new List<OAS.Param>();

    String retString = (String) client.invoke(
      'PUT',
      '/Api/v1/Eleves/{codeEleve}/evaluation',
      (OASUpdateEvaluation) params.get('evaluation'),
      query,
      form,
      new Map<String, Object>{
        'codeEleve' => (String) params.get('codeEleve')
      },
      new Map<String, Object>(),
      new List<String>{ 'application/json' },
      new List<String>{ 'application/json' },
      new List<String>{ 'Basic ' + this.auth },
      String.class
    );
    system.debug('retString ' + retString);
    updateEvalReturn retVal;
    if(Test.isRunningTest()){
      retVal = new updateEvalReturn();
      retVal.errorCode='200';
      retVal.errorMessage='';
    }
    else{
      retVal = (updateEvalReturn) JSON.deserialize(
        retString,
        updateEvalReturn.class
      );
    }

    return retVal;
  }
  public class updateEvalReturn {
    public String errorCode;
    public String errorMessage;
  }
  /**
   * Méthode pour mettre à jour un stage dans le cursus d’un étudiant.
   * Exemple de requête :\r\n            \r\n    PUT /20201138/stage\r\n    {\r\n      &quot;codePhase&quot;: &quot;424469&quot;,\r\n      &quot;exercice&quot;: &quot;2020&quot;,\r\n      &quot;codeProf&quot;: 21989,\r\n      &quot;codEntreprise&quot;: &quot;29153M&quot;,\r\n      &quot;codPosteMaitre&quot;: &quot;006739&quot;,\r\n      &quot;codeTheme&quot;: &quot;Marketing           &quot;, \r\n      &quot;missionStage&quot;: &quot;Ma Mission&quot;,\r\n      &quot;codeOrigine&quot;: &quot;AU&quot;,\r\n      &quot;oblistage&quot;: false,\r\n      &quot;descf&quot;: false,\r\n      &quot;raisSocialeHist&quot;: &quot;Entreprise&quot;,\r\n      &quot;cpvilleHist&quot;: &quot;01010 MA-VILLE&quot;,\r\n      &quot;nomMaitreHist&quot;: &quot;NOM&quot;,\r\n      &quot;dateMaj&quot;: &quot;2020-07-23T14:41:57.219Z&quot;,\r\n      &quot;prenomMaitreHist&quot;: &quot;PRENOM&quot;,\r\n      &quot;civiliteMaitreHist&quot;: &quot;M.&quot;,\r\n      &quot;coordMaitreHist&quot;: &quot;Tel : 01 01 01 01 01&quot;,\r\n      &quot;codeLangueConven&quot;: &quot;FR&quot;,\r\n      &quot;ediConven&quot;: 1,\r\n      &quot;dateEdiconven&quot;: &quot;2020-07-23T14:41:57.219Z&quot;,\r\n      &quot;representant&quot;: &quot;Prenom Nom&quot;,\r\n      &quot;gratification&quot;: 1.00,\r\n      &quot;codeTypeContratStage&quot;: &quot;CONSTA&quot;,\r\n      &quot;fonctionMaitre&quot;: &quot;Fonction...&quot;,\r\n      &quot;emailTuteur&quot;: &quot;string&quot;,\r\n      &quot;emailSignataire&quot;: &quot;string&quot;\r\n    }
   * @param codeEleve Code élève (required)
   * @param stage Données du stage (optional)
   * @throws OAS.ApiException if fails to make API call
   */
  public String updateStageEtudiantAsync(Map<String, Object> params) {
    client.assertNotNull(params.get('codeEleve'), 'codeEleve');
    List<OAS.Param> query = new List<OAS.Param>();
    List<OAS.Param> form = new List<OAS.Param>();

    HttpRequest req = client.makeRequest(
      'PUT',
      '/Api/v1/Eleves/{codeEleve}/stage',
      (OASUpdateStage) params.get('stage'),
      query,
      form,
      new Map<String, Object>{
        'codeEleve' => (String) params.get('codeEleve')
      },
      new Map<String, Object>(),
      new List<String>{
        'text/plain',
        'application/json',
        'text/json',
        'application/xml',
        'text/xml'
      },
      new List<String>{ 'application/json' },
      new List<String>{ 'Basic ' + this.auth }
    );
    Http web = new Http();
    HttpResponse res = web.send(req);
    system.debug('res status = ' + res.getStatusCode());
    system.debug('res body = ' + res.getBody());
    if (res.getStatusCode() == 200) {
      return 'success';
    }
    return res.getBody();
  }

  /**
   * Méthode pour récupérer le code FEG d'une entreprise.
   * @param idSFCompteEntreprise id SF entreprise (required)
   * @throws OAS.ApiException if fails to make API call
   */
  public String getFEGCodeEntreprise(String idSFCompteEntreprise) {
    System.debug('>>> getFEGCodeEntreprise START');
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      Label.convsta_domain_ws_cursus +
      'Api/v1/Entreprise?idSalesforceEntreprise=' +
      idSFCompteEntreprise
    );
    req.setMethod('GET');
    req.setHeader('Authorization', 'Basic ' + this.auth);
    req.setHeader('accept', 'application/json');
    req.setTimeout(120000);
    System.debug('req : ' + req);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    system.debug('res : ' + res);
    if (res.getStatusCode() == 200) {
      system.debug('res.getBody() ' + res.getBody());
      Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      return (String) results.get('codeEntreprise');
    }
    return '';
  }

  /**
   * Méthode pour récupérer le code FEG d'un tuteur.
   * @param idSFCompteEntreprise id SF entreprise (required)
   * @throws OAS.ApiException if fails to make API call
   */
  public String getFEGCodeTuteur(
    String idSFCompteEntreprise,
    String idSfTutor,
    String function
  ) {
    System.debug('>>> getFEGCodeTuteur START');
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      Label.convsta_domain_ws_cursus +
      'Api/v1/Tuteur?idSalesforceEntreprise=' +
      idSFCompteEntreprise +
      '&idSalesforceTuteur=' +
      idSfTutor +
      '&libFonctionTuteur=' +
      EncodingUtil.urlEncode(function, 'UTF-8')
    );
    req.setMethod('GET');
    req.setHeader('Authorization', 'Basic ' + this.auth);
    req.setHeader('accept', 'application/json');
    req.setTimeout(120000);
    System.debug('req : ' + req);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    system.debug('res : ' + res);
    if (res.getStatusCode() == 200) {
      system.debug('res.getBody() ' + res.getBody());
      Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      return (String) results.get('codePosteMaitre');
    }
    return '';
  }
}