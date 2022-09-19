@isTest
global class Convsta_WSHelper_CalloutMockImpl implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/plain');
        
        
        if(req.getEndpoint().contains('Api/v1/Auth')){
            res.setBody('{"CustomId":"ConvSta_20190114_095742_54"}');
        }
        else{
            system.debug('Manu +signers size '+req.getBody());
            SwagSignatureCreateRequest formatedReq = (SwagSignatureCreateRequest) JSON.deserialize(req.getBody(),SwagSignatureCreateRequest.class);
            //system.assert(false,'autoFail');
            Case dem = [SELECT Id, Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c FROM Case WHERE CaseNumber =: formatedReq.description] ;
            if(dem.Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c){
                system.assertEquals(4, formatedReq.signers.size(), 'Modis YGA - Parfait j\' ai 4 signataires + C.POTY autosign') ;
                system.assertEquals(3, formatedReq.documents.get(0).signatureFields.size(), 'Modis YGA - Parfait j\' ai 3 documents à signer') ;
            }
            else{
                system.assertEquals(5, formatedReq.signers.size(), 'Modis YGA - Parfait j\' ai 5 signataires (RP required))') ;
                system.assertEquals(4, formatedReq.documents.get(0).signatureFields.size(), 'Modis YGA - Parfait j\' ai 4 documents à signer (RP required)') ;
            }
            StaticResource static_resource = [SELECT Id, SystemModStamp, Name,body
                                              FROM StaticResource 
                                              WHERE Name = 'convsta_postEsignCreateNewSign'
                                              LIMIT 1];
            String res_json_body = static_resource.body.toString();        
            res.setBody(res_json_body);
        }
        res.setStatusCode(200);
        return res;
    }
}