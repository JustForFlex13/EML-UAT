public class convsta_ws_refint {
  private static String refintToken;
  public static String getToken() {
    if (refintToken == null) {
      System.debug('>>> convsta_ws_refint getToken START');
      HttpRequest req = new HttpRequest();
      req.setEndpoint(Label.convsta_domain_refint + 'Api/v1/Auth');
      req.setMethod('POST');
      req.setBody(
        '{"userName" : "' +
        Label.convsta_refint_user +
        '", "password" : "' +
        Label.convsta_refint_password +
        '"}'
      );
      req.setHeader('Content-Type', 'application/json');

      Http http = new Http();
      HTTPResponse res = http.send(req);
      System.debug('res : ' + res);
      if (res.getStatusCode() == 200) {
        Map<String, Object> results = new Map<String, Object>();
        results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        System.debug('results : ' + results);
        System.debug('accessToken : ' + results.get('accessToken'));
        System.debug('<<< convsta_ws_refint getToken END');
        refintToken = (String) results.get('accessToken');
      } else {
        throw new CalloutException('refintAut unvailable');
      }
    }
    return refintToken;
  }
  @AuraEnabled
  public static RefIntReturn searchMail(String email) {
    System.debug('>>> convsta_ws_refint searchMail START');
    system.debug('@email : ' + email);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      Label.convsta_domain_refint + 'Api/v1/Users/InformationUtilisateur/'+ email
    );
    req.setMethod('GET');
    String accessToken = getToken();
    req.setHeader('Authorization', 'Basic ' + accessToken);
    //req.setBody('{"email" : ["' + email + '"]}');
    req.setHeader('Content-Type', 'application/json');
    System.debug('req : ' + req);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    system.debug('res : ' + res);
    RefIntReturn retVal = new RefIntReturn();
    retVal.isSuccess = false;
    if (res.getStatusCode() == 200) {
      system.debug('res.getBody() ' + res.getBody());
      RefintDashboardReturn results = (RefintDashboardReturn) JSON.deserialize(
        res.getBody(),
        RefintDashboardReturn.class
      );
        if (results != null) {
        String codeIntervenant = results.codeItIntervenant;
        return searchMatricule(codeIntervenant);
      } else {
        retVal.error = 'Intervenant non trouvé dans les dashboard';
      }
    }
    return retVal;
  }
  public static RefIntReturn searchMatricule(String codeIntervenant) {
    System.debug('>>> convsta_ws_refint searchName START');
    system.debug('@name : ' + codeIntervenant);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      Label.convsta_domain_refint +
      'Api/v1/DossierIntervenant/GestionRh?codeItIntervenant=' +
      codeIntervenant
    );
    req.setMethod('GET');
    String accessToken = getToken();
    req.setHeader('Authorization', 'Basic ' + accessToken);
    req.setHeader('Content-Type', 'application/json');
    System.debug('req : ' + req);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    system.debug('res : ' + res);
    RefIntReturn retVal = new RefIntReturn();
    retVal.isSuccess = false;
    if (res.getStatusCode() == 200) {
      system.debug('res.getBody() ' + res.getBody());
      RefintGestionRhModel result = (RefintGestionRhModel) JSON.deserialize(
        res.getBody(),
        RefintGestionRhModel.class
      );
        
            System.debug('result : ' + result);

      if (result.listeSocieteRattachement.size() > 0) {
          
              System.debug('listeSocieteRattachement : ' + result.listeSocieteRattachement);

          
        retVal.codeItIntervenant = result.listeSocieteRattachement[0].matricule;
        retVal.isSuccess = true;
      } else {
        retVal.error =
          'problème de récupération du matricule de l\'intervenant ' +
          codeIntervenant +
          ' pas de société rattachée';
      }
    } else {
      retVal.error =
        'problème de récupération du matricule de l\'intervenant ' +
        codeIntervenant +
        ' pas de correspondance trouvée';
    }
    system.debug('retVal in wsrefint '+retval);
    return retVal;
  }
  public class RefIntReturn {
    public string codeItIntervenant;
    public Boolean isSuccess;
    public String error;
  }
    public class RefintDashboardReturn {
    public string nom;
    public string specialite;
    public string statutDossierIntervenant;
    public Boolean estValide;
    public String codeItIntervenant;
  } 
}