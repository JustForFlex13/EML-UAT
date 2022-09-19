/*-------------------------------------------------------------------
-- - Purpose : This class is used to attach a convention to a case attached at the name attachement, getted from email 
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- 19/12/2018  T.CH  MODIS       1.0      Initial version
--------------------------------------------------------------------*/
global class Convsta_AttachConventionFromEmail implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                           Messaging.InboundEnvelope env)
    {        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        try{
            for (Messaging.Inboundemail.BinaryAttachment binAttachment : email.binaryAttachments) {
                if(binAttachment.fileName.contains('convention')||binAttachment.fileName.contains('avenant')){
                    String caseNumber = binAttachment.fileName.replace('convention-', '').replace('avenant-', '').left(8);
                    Case demande = [SELECT Id,ParentId
                                    FROM   Case 
                                    WHERE  CaseNumber = :caseNumber LIMIT 1];
                    
                    ContentVersion cv = new ContentVersion();
                    cv.ContentLocation = 'S';
                    cv.PathOnClient = binAttachment.fileName;
                    cv.Origin = 'H';
                    cv.Title = binAttachment.fileName;
                    cv.VersionData = binAttachment.body;
                    insert cv;                   
                    
                    ContentVersion cv2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id];
                    List<ContentDocumentLink> listCl = new List<ContentDocumentLink>();
                    listCl.add(new ContentDocumentLink(LinkedEntityId = demande.Id, ContentDocumentId = cv2.ContentDocumentId, ShareType = 'I', Visibility='AllUsers'));
                    demande.Status = 'Convention signée';
                    demande.Convsta_Statut_Signature__c = 'Signée';
                    demande.Convsta_Convention__c = true;
                    demande.Convsta_ConventionDocumentId__c = String.valueOf(cv2.ContentDocumentId);
                    demande.Date_Reception_Convention__c = Datetime.now();
                    if(demande.parentid!=null){
                        demande.Status ='Avenant signé';
                        listCl.add( new ContentDocumentLink(LinkedEntityId = demande.parentId, ContentDocumentId = cv2.ContentDocumentId, ShareType = 'I', Visibility='AllUsers'));
                    }
                    insert listCl;
                    update demande;                    
                }
            }
        }catch(QueryException e){
            result.success = false;
            result.message = 'La pièce-jointe ne correspond pas à un enregistrement connu.';
            
            return result;
        }    
        
        result.success = true;
        
        return result;
    }
}