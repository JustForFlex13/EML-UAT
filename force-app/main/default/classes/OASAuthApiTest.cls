@isTest
private class OASAuthApiTest {
    /**
     * 
     *
     * 
     */
    @isTest
    private static void getIdentiteTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

        OASClient client;
        OASAuthApi api;
        OASIdentityModel response;
        OASIdentityModel expectedResponse;
        String js = '';

        client = new OASClient();
        api = new OASAuthApi(client);
        client.setAuthentication('Basic',new OAS.ApiKeyQueryAuth('abc'));
        ((OAS.ApiKeyAuth)client.getAuthentication('Basic')).setApiKey('foo-bar-api-key');

        js = JSON.serialize(OASIdentityModel.getExample());
        res.setHeader('Content-Type', 'application/json');
        res.setBody(js);
        expectedResponse = OASIdentityModel.getExample();
        response = (OASIdentityModel) api.getIdentite();
        System.assertEquals(expectedResponse, response);


        js = JSON.serialize(OASIdentityModel.getExample());
        res.setHeader('Content-Type', 'application/xml');
        res.setBody(js);
        expectedResponse = OASIdentityModel.getExample();
        response = (OASIdentityModel) api.getIdentite();
        System.assertEquals(expectedResponse, response);
    }

    /**
     * 
     *
     * 
     */
    @isTest
    private static void postTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'authentication' => OASUserAuthenticationRequestModel.getExample()
        };

        OASClient client;
        OASAuthApi api;
        OASUserAuthentificationResponseModel response;
        OASUserAuthentificationResponseModel expectedResponse;
        String js = '';

        client = new OASClient();
        api = new OASAuthApi(client);
        client.setAuthentication('Basic',new OAS.ApiKeyQueryAuth('abc'));
        ((OAS.ApiKeyAuth)client.getAuthentication('Basic')).setApiKey('foo-bar-api-key');


        js = JSON.serialize(OASUserAuthentificationResponseModel.getExample());
        res.setHeader('Content-Type', 'application/json');
        res.setBody(js);
        expectedResponse = OASUserAuthentificationResponseModel.getExample();
        response = (OASUserAuthentificationResponseModel) api.post(params);
        System.assertEquals(expectedResponse, response);


        js = JSON.serialize(OASUserAuthentificationResponseModel.getExample());
        res.setHeader('Content-Type', 'application/xml');
        res.setBody(js);
        expectedResponse = OASUserAuthentificationResponseModel.getExample();
        response = (OASUserAuthentificationResponseModel) api.post(params);
        System.assertEquals(expectedResponse, response);
    }
}