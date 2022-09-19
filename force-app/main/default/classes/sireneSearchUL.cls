/*--------------------------------------------------------------------
-- - Purpose       : Cette classe sert à récupérer les Unités Légales de l'API de l'INSEE en fonction de divers paramètres
--
-- - Maintenance History:
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 26/11/2018  T.CH  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
public without sharing class sireneSearchUL{
    @AuraEnabled
    public static string search(String denomination, String zipCode, String city, string siret) {
        system.debug('START sireneSearchUL.search : ');
        system.debug('PARAMS sireneSearchUL.search : '+denomination+zipCode+city+siret);
        
        HttpRequest req = new HttpRequest();
        req.setmethod('GET');

        //Fabrication de la requête en fonction des paramètres fournis
        String link = 'https://api.insee.fr/entreprises/sirene/V3/siret?q=';
        String query = '';
        query = (!String.isBlank(denomination)  ? ('denominationUniteLegale%3A%22'    + EncodingUtil.URLENCODE(denomination,'UTF-8')+'%22') : query);
        query = (!String.isBlank(zipCode)       ? ((query ==''?'': query+'%20AND%20') + 
                                        'codePostalEtablissement%3A%22'     + EncodingUtil.URLENCODE(zipCode,'UTF-8')+'%22')      : query);
        query = (!String.isBlank(city)           ? ((query ==''?'': query+'%20AND%20') +
                                        'libelleCommuneEtablissement%3A%22' + EncodingUtil.URLENCODE(city,'UTF-8')+'%22')         : query);
        query = (!String.isBlank(siret)          ? ((query ==''?'': query+'%20AND%20') +
                                        'siret%3A%22'                       + EncodingUtil.URLENCODE(siret.remove(' ').remove('.'),'UTF-8')+'%22')        : query);
        //Ajout d'un filtre sur l'etat administratif pour ne renvoyer que ceux actifs à la date du jour.
        query = query + '%20AND%20-periode(etatAdministratifEtablissement%3AF)';
        Date aujourdhui = Date.today();
        String aujourdhuiEnTexte = String.valueOf(aujourdhui);
        query = query + '&date=' + EncodingUtil.URLENCODE(aujourdhuiEnTexte,'UTF-8');
        req.setEndpoint(link+query);
        system.debug('endpoint : '+ query);

        //Récupération du token via l'interface Cache.CacheBuilder
        String token = (String)Cache.Org.get(sireneKeyCache.class, 'token');
        req.setHeader('Authorization', 'Bearer ' + token);
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('STOP sireneSearchUL.search : '+res.getBody());
        return res.getBody();
    }
}