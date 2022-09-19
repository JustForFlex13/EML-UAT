/*--------------------------------------------------------------------
-- - Purpose       : Cette classe sert à récupérer le token d'accès à l'API INSEE et à le stocker en cache
--
-- - Maintenance History:
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  T.CH  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
public without sharing class SireneKeyCache implements Cache.CacheBuilder {
    public static String doLoad(String noUse) {
        Insee_login__mdt inseeLogin = [ SELECT client_secret__c, consumer_key__c 
                                        FROM Insee_login__mdt
                                        WHERE DeveloperName='Connexion_Manu'];
        HttpRequest req = new HttpRequest();
        req.setmethod('GET');
        req.setEndpoint('https://api.insee.fr/token');
        req.setHeader('Authorization', 'Basic '+ EncodingUtil.base64Encode(Blob.valueof(inseeLogin.consumer_key__c+':'+inseeLogin.client_secret__c)));
        req.setBody('grant_type=client_credentials');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug(res.getbody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        String token = (String) results.get('access_token');

        return token;
    }
}