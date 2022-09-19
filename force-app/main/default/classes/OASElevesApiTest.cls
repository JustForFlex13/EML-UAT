@isTest
private class OASElevesApiTest {
  /**
   * Méthode pour rechercher l’existence d’une phase (de type stage) dans le cursus d’un étudiant.
   *
   *
   */
  @isTest
  private static void getPhasesCursusTest() {
    HttpResponse res = new HttpResponse();
    res.setStatusCode(200);
    res.setStatus('OK');
    Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

    Map<String, Object> params = new Map<String, Object>{
      'codeEleve' => 'null',
      'typePhase' => 'null',
      'dateDebut' => Datetime.newInstanceGmt(2013, 11, 12, 3, 3, 3),
      'dateFin' => Datetime.newInstanceGmt(2013, 11, 12, 3, 3, 3)
    };

    OASClient client;
    OASElevesApi api;
    OASElevesApi.getPhaseReturn response;
    String expectedResponse;
    String js = '';

    client = new OASClient();
    api = new OASElevesApi(client);

    js = JSON.serialize(OASModeleRetourPhase.getExample());
    res.setHeader('Content-Type', 'application/json');
    res.setBody(js);
    expectedResponse = 'abc';
    response = api.getPhasesCursus(params);
    System.assertEquals(false, response.success);
  }

  /**
   * Méthode pour mettre à jour une évaluation d’un étudiant.
   *
   * Exemple de requête :\r\n            \r\n    PUT /20201138/evaluation\r\n    {\r\n      &quot;codePhase&quot;: &quot;424467&quot;,\r\n      &quot;exercice&quot;: &quot;2020&quot;,\r\n      &quot;codeEpr&quot;: &quot;6FACPA&quot;,\r\n      &quot;numsession&quot;: &quot;02&quot;,\r\n      &quot;codePeriode&quot;: &quot;1S&quot;,\r\n      &quot;absctl&quot;: false,\r\n      &quot;ctlseul&quot;: false,\r\n      &quot;dispens&quot;: false,\r\n      &quot;rang&quot;: 1,\r\n      &quot;complet&quot;: false,\r\n      &quot;notechiffre&quot;: 19.50,\r\n      &quot;notevalid&quot;: true,\r\n      &quot;exeBul&quot;: &quot;2020&quot;,\r\n      &quot;etuBul&quot;: &quot;MDA&quot;,\r\n      &quot;perBul&quot;: &quot;1S&quot;,\r\n      &quot;editeBul&quot;: 0,\r\n      &quot;majnoteVerrou&quot;: 0,\r\n      &quot;noteects&quot;: &quot;A&quot;,\r\n      &quot;dateCrenote&quot;: &quot;2020-07-23T13:58:48.806Z&quot;,\r\n      &quot;dateMajverdict&quot;: &quot;2020-07-23T13:58:48.806Z&quot;\r\n    }
   */
  @isTest
  private static void updateEvaluationEtudiantAsyncTest() {
    HttpResponse res = new HttpResponse();
    res.setStatusCode(200);
    res.setStatus('OK');
    res.setBody('"{\"errorCode\":\"200\",\"errorMessage\":\"\"}"');
    Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

    Map<String, Object> params = new Map<String, Object>{
      'codeEleve' => 'null',
      'evaluation' => OASUpdateEvaluation.getExample()
    };

    OASClient client;
    OASElevesApi api;
    OASElevesApi.updateEvalReturn response;
    OASElevesApi.updateEvalReturn expectedResponse;
    String js = '';

    client = new OASClient();
    api = new OASElevesApi(client);

    js = JSON.serialize(OASErrorResult.getExample());
    res.setHeader('Content-Type', 'application/json');
    res.setBody(js);
    response = (OASElevesApi.updateEvalReturn) api.updateEvaluationEtudiantAsync(params);
    System.assertEquals('200', response.errorCode, 'response was not 200 empty string');
  }

  /**
   * Méthode pour mettre à jour un stage dans le cursus d’un étudiant.
   *
   * Exemple de requête :\r\n            \r\n    PUT /20201138/stage\r\n    {\r\n      &quot;codePhase&quot;: &quot;424469&quot;,\r\n      &quot;exercice&quot;: &quot;2020&quot;,\r\n      &quot;codeProf&quot;: 21989,\r\n      &quot;codEntreprise&quot;: &quot;29153M&quot;,\r\n      &quot;codPosteMaitre&quot;: &quot;006739&quot;,\r\n      &quot;codeTheme&quot;: &quot;Marketing           &quot;, \r\n      &quot;missionStage&quot;: &quot;Ma Mission&quot;,\r\n      &quot;codeOrigine&quot;: &quot;AU&quot;,\r\n      &quot;oblistage&quot;: false,\r\n      &quot;descf&quot;: false,\r\n      &quot;raisSocialeHist&quot;: &quot;Entreprise&quot;,\r\n      &quot;cpvilleHist&quot;: &quot;01010 MA-VILLE&quot;,\r\n      &quot;nomMaitreHist&quot;: &quot;NOM&quot;,\r\n      &quot;dateMaj&quot;: &quot;2020-07-23T14:41:57.219Z&quot;,\r\n      &quot;prenomMaitreHist&quot;: &quot;PRENOM&quot;,\r\n      &quot;civiliteMaitreHist&quot;: &quot;M.&quot;,\r\n      &quot;coordMaitreHist&quot;: &quot;Tel : 01 01 01 01 01&quot;,\r\n      &quot;codeLangueConven&quot;: &quot;FR&quot;,\r\n      &quot;ediConven&quot;: 1,\r\n      &quot;dateEdiconven&quot;: &quot;2020-07-23T14:41:57.219Z&quot;,\r\n      &quot;representant&quot;: &quot;Prenom Nom&quot;,\r\n      &quot;gratification&quot;: 1.00,\r\n      &quot;codeTypeContratStage&quot;: &quot;CONSTA&quot;,\r\n      &quot;fonctionMaitre&quot;: &quot;Fonction...&quot;,\r\n      &quot;emailTuteur&quot;: &quot;string&quot;,\r\n      &quot;emailSignataire&quot;: &quot;string&quot;\r\n    }
   */
  @isTest
  private static void updateStageEtudiantAsyncTest() {
    HttpResponse res = new HttpResponse();
    res.setStatusCode(200);
    res.setStatus('OK');
    Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

    Map<String, Object> params = new Map<String, Object>{
      'codeEleve' => 'null',
      'stage' => OASUpdateStage.getExample()
    };

    OASClient client;
    OASElevesApi api;
    String js = '';

    client = new OASClient();
    api = new OASElevesApi(client);

    api.updateStageEtudiantAsync(params);
  }
}