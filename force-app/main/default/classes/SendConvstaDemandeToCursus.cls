public with sharing class SendConvstaDemandeToCursus implements Queueable, Database.AllowsCallouts {
  private List<Case> convstaDemandes;

  public SendConvstaDemandeToCursus(List<Case> demandes) {
    this.convstaDemandes = demandes;
  }
  public SendConvstaDemandeToCursus(Set<Id> caseIds) {
    this.convstaDemandes = [
      SELECT
        Id,
        Convsta_DateStart__c,
        Convsta_DateEnd__c,
        Convsta_Type_de_demande__c,
        Convsta_TypeContrat__c,
        Origin,
        Convsta_Adresse_du_lieu_du_stage__c,
        Convsta_Nouvelle_adresse_lieu_de_stage__c,
        Convsta_Langue__c,
        Date_Reception_Convention__c,
        Convsta_Entreprise__r.Name,
        Convsta_Entreprise__r.ID_FEG__c,
        Convsta_Entreprise__r.Code_Postal__c,
        Convsta_Entreprise__r.Adresse_Ville__c,
        Convsta_Entreprise__r.CodePays__c,
        Convsta_Entreprise__r.Adresse_Rue__c,
        Responsable_administratif_entreprise__r.Name,
        Responsable_administratif_entreprise__r.FirstName,
        Responsable_administratif_entreprise__r.LastName,
        Responsable_administratif_entreprise__r.Fonctions__c,
        Convsta_Responsable_Pedagogique__r.FirstName,
        Convsta_Responsable_Pedagogique__r.LastName,
        Convsta_Responsable_Pedagogique__r.Email,
        Convsta_Tuteur__r.FirstName,
        Convsta_Tuteur__r.LastName,
        Convsta_Tuteur__r.Fonctions__c,
        Convsta_Tuteur__r.Salutation,
        Convsta_Tuteur__r.Email_Professionnel__c,
        Contact.convsta_code_etudiant_EM__c
      FROM Case
      WHERE Id IN :caseIds
    ];
  }

  public void execute(QueueableContext context) {
    System.debug('>>> SendConvstaDemandeToCursus Queueable Execute START');

    Case convstaDemande = convstaDemandes.remove(0);
    System.debug('convstaDemande : ' + convstaDemande);
    // check phase exists
    OASElevesApi.getPhaseReturn wsReturn = Convsta_WS_Helper_Cursus.wsGetCodePhase(
      convstaDemande.Contact.convsta_code_etudiant_EM__c,
      convstaDemande.Convsta_DateStart__c,
      convstaDemande.Convsta_DateEnd__c
    );
    if (wsReturn.success) {
      // check si data ok
      String resCheckDataStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(
        convstaDemande
      );
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure resCheckData = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
        resCheckDataStr,
        Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
      );

      System.debug('resCheckData : ' + resCheckData);
      if (resCheckData.allDataOK != null) {
        Convsta_WS_Helper_Cursus.wsPostPhase(convstaDemande, wsReturn.codePhase);
      }
    }

    if (convstaDemandes.size() != 0) {
      System.enqueueJob(new SendConvstaDemandeToCursus(convstaDemandes));
    }
  }
}