/**
 * Class containing tests for sireneSearchUL
 */
@isTest public with sharing class sireneSearchULTest {
    @isTest static void testSearch() {
        StaticResourceCalloutMock mockToken = new StaticResourceCalloutMock();
        mockToken.setStaticResource('convsta_GetTokenResource');
        mockToken.setStatusCode(200);
        mockToken.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mockToken);
        sireneKeyCache.doLoad('token');

        StaticResourceCalloutMock mockSearch = new StaticResourceCalloutMock();
        mockSearch.setStaticResource('convsta_GetULResource');
        mockSearch.setStatusCode(200);
        mockSearch.setHeader('Content-Type', 'application/json;charset=UTF-8');
             
        Test.setMock(HttpCalloutMock.class, mockSearch);
        String body = sireneSearchUL.search('modis', '69100', null, null);
        
        Map<String, Object> mResults = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> mResultHeader = (Map<String, Object>) mResults.get('header');
        System.assertEquals(5, mResultHeader.get('total'));
        
		StaticResourceCalloutMock mockSearch2 = new StaticResourceCalloutMock();
        mockSearch2.setStaticResource('convsta_GetULResourceVide');
        mockSearch2.setStatusCode(404);
        mockSearch2.setHeader('Content-Type', 'application/json;charset=UTF-8');

		Test.setMock(HttpCalloutMock.class, mockSearch2);
		String body2 = sireneSearchUL.search('Le Tandoori', '59000', null, null);

        Map<String, Object> mResults2 = (Map<String, Object>) JSON.deserializeUntyped(body2);
        Map<String, Object> mResultHeader2 = (Map<String, Object>) mResults2.get('header');
        System.assertEquals(404, mResultHeader2.get('statut'));
    }
}