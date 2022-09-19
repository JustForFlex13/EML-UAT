/*---------------------------------------------------------------------
-- - Purpose             : Implementation of methods called by triggers on cases
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 01/02/2019  T.CH  MODIS    1.0      Initial version
---------------------------------------------------------------------*/
public without sharing class TR008ManageCase {
	private static set<Id> roleEmIdSet = new set<Id>();
	private static Datetime now = Datetime.now();
	private static Group queue = null;
	private static Group getQueue(){
		if(queue == null){
			queue = [SELECT Id
				FROM Group WHERE 
				DeveloperName = 'Convsta_En_attente_de_validation_admin'];
		}
		return queue;
	}
	private static Map<Id, String> mpRespNameById = new Map<Id, String>();

	public static void affectOwner(List<Case> lCases){

        // Map<Id, String> mpRespNameById = new Map<Id, String>([SELECT Id, Convsta_Table_des_Regles_Experience_Pro__r.Nom_Responsable_Pedagogique__c FROM Case WHERE Id IN :lCases]);
        List<Case> lRespName = [SELECT Id, Convsta_Table_des_Regles_Experience_Pro__r.Nom_Responsable_Pedagogique__c FROM Case WHERE Id IN :lCases];
        for(Case demande :lRespName){
            mpRespNameById.put(demande.Id, demande.Convsta_Table_des_Regles_Experience_Pro__r.Nom_Responsable_Pedagogique__c);
        }
		for(Case demande :lCases){
			//on vérifie que la validation administrative n'a pas eu lieu
			if( demande.Convsta_Date_Validation_Administrative__c==null){
				handleBeforeValidationAdministrative(demande);
			}else if(demande.Status == 'Demande soumise' && demande.Convsta_Gestionnaire_en_charge__c == null){
					demande.Convsta_Date_assignation_au_gestionnaire__c = now;
					demande.Status='Demande en cours de validation administrative';
					demande.ownerId= getQueue().id;                
				}
		}
        if(roleEmIdSet.size()>0){
            map<Id,R_le__c> roleMap = new Map<Id,R_le__c>( [SELECT id,Contact__c FROM R_le__c WHERE id in :roleEmIdSet ]);
            for(Case demande:lCases){
                if(demande.Convsta_Role_EMLYON__c!=null){
                    demande.Convsta_suiveur__c =roleMap.get(demande.Convsta_Role_EMLYON__c).Contact__c;
                }
            }
        }
	}

	private static void handleBeforeValidationAdministrative(Case demande){
		if(demande.Convsta_Verdict_Pedagogique__c == 'Demande Acceptée' && demande.Convsta_Validation_Pedagogique__c==false)
		{
			if(demande.Convsta_Role_EMLYON__c!=null){
				roleEmIdSet.add(demande.Convsta_Role_EMLYON__c);
			}
			demande.Convsta_Date_Validation_Pedagogique__c      = now;
			demande.Convsta_Date_assignation_au_gestionnaire__c = now;
			demande.Convsta_Validation_Pedagogique__c   = true;
			demande.Status='Demande en cours de validation administrative';
			demande.ownerId= getQueue().id;                
			//Convsta_Object_Helper.setCasePendingValidation(demande, queue);
		}
		else if(demande.Status == 'Demande soumise' && (demande.Convsta_Gestionnaire_en_charge__c != null))
		{
			demande.Convsta_Date_Soumission_Demande__c = now;
			demande.Status='Demande en cours de validation administrative';
			demande.Convsta_Date_assignation_au_gestionnaire__c = now;
			demande.ownerId=demande.Convsta_Gestionnaire_en_charge__c; 
			//Convsta_Object_Helper.setCasePendingValidation(demande, queue);
		}
		else if(demande.Status == 'Demande soumise' && (demande.Convsta_Table_des_Regles_Experience_Pro__c != null &&
														mpRespNameById.get(demande.Id) == null))
		{
			demande.Convsta_Date_Soumission_Demande__c = now;
			demande.Status='Demande en cours de validation pédagogique';
			demande.ownerId= getQueue().id; 
		}
	}

	public static void doPostCreateSignatureConventionQueueable(Id demandeId){
		ID jobID = System.enqueueJob(new PostCreateSignatureQueueable(demandeId, true));
        System.debug([SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:jobID]);
	}

	public static void doPostCreateSignatureAvenantQueueable(Id demandeId){
		ID jobID = System.enqueueJob(new PostCreateSignatureQueueable(demandeId, false));
        System.debug([SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:jobID]);
	}

	public static void addCaseSharing(list<Case> listDemande){
		//System.debug('TR008 Add Case Sharing of : '+listDemande);
		list<CaseShare> newReadAccess = new list<CaseShare>() ;
		for(Case dem : listDemande){
			CaseShare cs = new CaseShare() ;
			cs.CaseId = dem.Id ;
			cs.CaseAccessLevel = 'Read' ;
			cs.UserOrGroupId = dem.Convsta_Responsable_Pedagogique__c ;
			newReadAccess.add(cs) ;
		}
		if(newReadAccess.size()>0){
			database.insert( newReadAccess,false) ;
		}
	}

	public static void deleteCaseSharing(Map<Id, Id> mapSharingToDelete){
		//System.debug('TR008 Delete Case Sharing of : '+mapSharingToDelete);
		list<CaseShare> deleteAccess = new list<CaseShare>() ;
		for(CaseShare cs : [SELECT Id, CaseId, UserOrGroupId FROM CaseShare WHERE CaseID IN: mapSharingToDelete.keyset()]){
			if(cs.UserOrGroupId == mapSharingToDelete.get(cs.CaseId)){
				deleteAccess.add(cs) ;
			}
		}
		if(deleteAccess.size()>0){
			database.delete( deleteAccess, false) ;
		}
	}
}