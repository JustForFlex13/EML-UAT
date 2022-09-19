@isTest public with sharing class SireneKeyCacheTest {
	@isTest static void testCache() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('convsta_GetTokenResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);
        
        String token = sireneKeyCache.doLoad('token');

        System.assertEquals('eed799cb-5bd8-33ed-854c-df029e2612ca', token);
    }
}