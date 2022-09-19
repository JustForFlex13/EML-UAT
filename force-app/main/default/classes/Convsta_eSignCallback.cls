/*--------------------------------------------------------------------
-- - Purpose       : Cette classe sert à récupérer et mettre à jour le statut de signature d'une demande
--
-- - Maintenance History:
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 12/12/2018  T.CH  MODIS    1.0      Initial version
---------------------------------------------------------------------*/
@RestResource(urlMapping='/signRequest')
//@RestResource(urlMapping='/Convsta_eSignCallback')
global without sharing class Convsta_eSignCallback{
    @HttpGet
    global static void doGet() {
        RestContext.response.addHeader('Content-Type', 'text/plain');
        String idCase  = RestContext.request.params.get('caseId');
        String codeHash	   = (RestContext.request.params.get('hashCode')!=null ? RestContext.request.params.get('hashCode') :'0');
        String relance	   = RestContext.request.params.get('relance');
        system.debug(idCase+' '+codeHash+' '+relance);
        Case c = [SELECT id, 
                  CreatedDate,
                  Convsta_Detail_statut_signataire__c,
                  Convsta_Date_Validation_Administrative__c 
                  FROM Case 
                  WHERE Id =: idCase LIMIT 1] ;
        
        if(Integer.valueOf(codeHash) == Convsta_eSignCallback.hashCode(c)){
            if(relance != null){
                c.Convsta_date_derniere_relance_signature__c = datetime.now();
                DateTime lastupdate= null;
                List<String> statusList =c.Convsta_Detail_statut_signataire__c.split('\n');
                StatusList.remove(StatusList.size()-1);
                for( String strStatus:StatusList){
                    system.debug('str statuts line : '+strStatus+'*'+strStatus.right(19));
                    try{
                        string dateSubString = strStatus.right(19);
                        if(DateTime.newinstance(
                            Integer.valueOf(dateSubString.substring(0,4)),
                            Integer.valueOf(dateSubString.substring(5,7)),
                            Integer.valueOf(dateSubString.substring(8,10)),
                            Integer.valueOf(dateSubString.substring(11,13)),
                            Integer.valueOf(dateSubString.substring(14,16)),
                            Integer.valueOf(dateSubString.substring(17,19)))!=null){
                                lastupdate=DateTime.newinstance(
                                    Integer.valueOf(dateSubString.substring(0,4)),
                                    Integer.valueOf(dateSubString.substring(5,7)),
                                    Integer.valueOf(dateSubString.substring(8,10)),
                                    Integer.valueOf(dateSubString.substring(11,13)),
                                    Integer.valueOf(dateSubString.substring(14,16)),
                                    Integer.valueOf(dateSubString.substring(17,19)));
                                system.debug('lastUpdate update '+lastupdate);
                            }
                    }
                    catch(Exception e){
                        break;
                    }
                }
                eSign_Configuration__mdt conf = Convsta_WS_Helper.getESignConf();
                Decimal nbJourAvantSansEffet = conf.nbJoursAvantRelance__c*conf.nbMaxRelance__c;
                if(lastUpdate == null){
                    system.debug('lastUpdate was null');
                    lastUpdate= c.Convsta_Date_Validation_Administrative__c;
                }
                system.debug('LastUpdate : '+lastUpdate);
                if((lastUpdate.date().daysBetween(DateTime.now().date())) >=nbJourAvantSansEffet){
                    c.Convsta_Statut_Signature__c='Relance sans effet';
                }
                update c;
            }
            else{
                EventBus.publish(new List<convsta_document_signe__e>{ new convsta_document_signe__e (CaseId__c=idCase, hash__c=Convsta_eSignCallback.hashCode(c))});                            
            }
        }
        else{
            system.debug('£££ Modis YGA - Convsta_eSignCallback bad HashCode £££ expected : '+ Convsta_eSignCallback.hashCode(c)+' got :'+Integer.valueOf(codeHash));            
        }
        RestContext.response.responseBody = Blob.valueOf('Modis YGA eSign CallBack params : Case\'s id SF : '+idCase);//+' - Date : '+demande.Createddate/*+' - Type of Document : '+docType+' - hash code for this record : '+codeHash*/);
    }
    
    public static Integer hashCode(Case demande) {
        Integer hashCode = 43;
        hashCode = (17 * hashCode) + (demande.Id == null ? 0 : System.hashCode(String.valueOf(demande.Id)));
        hashCode = (17 * hashCode) + (demande.CreatedDate == null ? 0 : System.hashCode(demande.CreatedDate));
        return hashCode;
    }
}