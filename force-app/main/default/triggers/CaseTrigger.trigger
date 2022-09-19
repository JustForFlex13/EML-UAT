/*--------------------------------------------------------------------
-- - Purpose             : Trigger on Case
--            
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  -------------------------------
-- 14/01/2018  T.CH  MODIS    1.0      Creation
--------------------------------------------------------------------*/
trigger CaseTrigger on Case(before insert, before update, after update) {
  List<Case> convstaSigned = new List<Case>();

  if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
    List<Case> lCasesToAffect = new List<Case>();
    for (Case demande : Trigger.new) {
      if (
        demande.RecordTypeId ==
        APU_ApexUtils.getCaseRecordTypeIdByDeveloperName(
          'Convsta_Validation_d_experience'
        )
      ) {
          system.debug('we have a case');
        lCasesToAffect.add(demande);
      }
    }
      system.debug(lCasesToAffect);
    TR008ManageCase.affectOwner(lCasesToAffect);
  }
  if (Trigger.isAfter && Trigger.isUpdate) {
    System.debug(
      'trigger CaseTrigger on Case Trigger.isAfter && Trigger.isUpdate'
    );
    List<Case> caseToAddSharing = new List<Case>();
    List<Case> caseToAddDocLink = new List<Case>();
    Map<Id, Id> caseToDeleteSharing = new Map<Id, Id>(); // map ot know what CaseShare we have to delete the map model is Map<CaseId, RPid>
    for (Case demande : Trigger.new) {
      if (
        demande.Convsta_Statut_Signature__c !=
        Trigger.oldMap.get(demande.Id).Convsta_Statut_Signature__c &&
        demande.Convsta_Statut_Signature__c == 'Convention validée à émettre'
      ) {
        TR008ManageCase.doPostCreateSignatureConventionQueueable(demande.Id);
      }

      if (
        demande.Convsta_Statut_Signature__c !=
        Trigger.oldMap.get(demande.Id).Convsta_Statut_Signature__c &&
        demande.Convsta_Statut_Signature__c == 'Avenant validé à émettre'
      ) {
        TR008ManageCase.doPostCreateSignatureAvenantQueueable(demande.Id);
        convstaSigned.add(demande);
        System.debug('convstaSigned : ' + convstaSigned);
      }
      if (
        demande.OwnerId != demande.Convsta_Responsable_Pedagogique__c &&
        UserInfo.getUserType() == 'Standard'
      ) {
        // add Read access for the RP (because no he/she doesn't have access if he/she is not Owner)
        if (
          demande.Convsta_Responsable_Pedagogique__c != null &&
          demande.Convsta_Validation_Pedagogique__c
        ) {
          caseToAddSharing.add(demande);
        }
        // if the RP is modified we have to delete the sharing for the old RP
        if (
          demande.Convsta_Responsable_Pedagogique__c !=
          Trigger.oldMap.get(demande.Id).Convsta_Responsable_Pedagogique__c &&
          Trigger.oldMap.get(demande.Id).OwnerId !=
          Trigger.oldMap.get(demande.Id).Convsta_Responsable_Pedagogique__c
        ) {
          caseToDeleteSharing.put(
            demande.Id,
            Trigger.oldMap.get(demande.Id).Convsta_Responsable_Pedagogique__c
          );
        }
      }
    }
    if (caseToAddSharing.size() > 0) {
      TR008ManageCase.addCaseSharing(caseToAddSharing);
    }
    if (caseToDeleteSharing.size() > 0) {
      TR008ManageCase.deleteCaseSharing(caseToDeleteSharing);
    }
    if (convstaSigned.size() != 0) {
      Map<Id, Case> convstaSignedMap = new Map<Id, Case>(convstaSigned);
      System.enqueueJob(
        new SendConvstaDemandeToCursus(convstaSignedMap.keySet())
      );
    }
  }
}