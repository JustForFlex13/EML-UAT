public class SendConvstaEvaluationToCursus implements Queueable, Database.AllowsCallouts {
  private List<Convsta_Evaluation__c> convstaEvals;

    public static Boolean cancelRunForTest = true;
  public SendConvstaEvaluationToCursus(List<Id> convstaEvalIds) {
    this.convstaEvals = [
      SELECT
        Id,
        Etudiant__c,
        Etudiant__r.convsta_code_etudiant_EM__c,
        Etudiant__r.LastName,
        Etudiant__r.FirstName,
        ValidFrom__c,
        ValidTo__c,
        Date_Reception_Evalutation__c,
        Note_globale__c,
        Demande__c,
        Saisie_dans_cursus__c,
        Erreur_dans_Cursus__c
      FROM Convsta_Evaluation__c
      WHERE Id IN :convstaEvalIds
    ];
  }

  public SendConvstaEvaluationToCursus(List<Convsta_Evaluation__c> evals) {
    this.convstaEvals = evals;
  }

  public void execute(QueueableContext context) {
      if(cancelRunForTest){
        System.debug('>>> SendConvstaEvaluationToCursus START');
        System.debug('convstaEvals : ' + convstaEvals);
        Convsta_Evaluation__c oneEval = null;
        if (convstaEvals.size() > 0) {
          // overkill but preferable
    
          oneEval = convstaEvals.remove(0);
    
          // check if Stage (Case) exists in SF.
          Case theStage = Convsta_WS_Helper_Cursus.getStage(oneEval.Demande__c);
          if (
            theStage == null ||
            theStage.Contact == null ||
            theStage.Contact.convsta_code_etudiant_EM__c == null ||
            theStage.Convsta_DateStart__c == null ||
            theStage.Convsta_DateEnd__c == null
          ) {
            handleEnd();
            return;
          }
    
          // check if corresponding record exists in CURSUS (must have a "codePhase")
          OASElevesApi.getPhaseReturn phaseInternshipRespJson = Convsta_WS_Helper_Cursus.wsGetCodePhase(
            theStage.Contact.convsta_code_etudiant_EM__c,
            theStage.Convsta_DateStart__c,
            theStage.Convsta_DateEnd__c
          );
          if (!phaseInternshipRespJson.success) {
            handleEnd();
            return;
          }
    
          // check if data is complete in SF before sending to Cursus
          String strictEvalDataCheckResultStr = checkStrictEvaluationData(oneEval);
          Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure strictEvalDataCheckResults = (Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure) JSON.deserialize(
            strictEvalDataCheckResultStr,
            Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure.class
          );
          if (!strictEvalDataCheckResults.allDataOK) {
            handleEnd();
            return;
          }
          // also updates the Evaluation for fields : Saisie_dans_cursus__c and Erreur_dans_Cursus__c
          doSendEvalToCursus(JSON.serialize(oneEval));
        } // end if(convstaEvals.size() > 0)
        handleEnd();
          
      }
  }
  public void handleEnd() {
    System.debug('convstaEvals.size() : ' + convstaEvals.size());
    if (convstaEvals.size() > 0) {
      // convstaEvals is already trimmed by 1
      SendConvstaEvaluationToCursus anotherQueueableInstance = new SendConvstaEvaluationToCursus(
        convstaEvals
      );

      if (!Test.isRunningTest()) {
        System.debug('sould be 1 less : convstaEvals : ' + convstaEvals);
        System.enqueueJob(anotherQueueableInstance);
      }
    }
  }
  /* return Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure*/
  public static String checkStrictEvaluationData(
    Convsta_Evaluation__c evaluation
  ) {
    System.debug(
      '>>> SendConvstaEvaluationToCursus checkStrictEvaluationData START'
    );
    System.debug(
      'SendConvstaEvaluationToCursus checkStrictEvaluationData evaluation : ' +
      evaluation
    );

    Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure returnStruct = new Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure();

    if (
      String.isNotBlank(evaluation.Etudiant__c) &&
      String.isNotEmpty(evaluation.Etudiant__c)
    ) {
      returnStruct.hasEtudiant = true;
    } else {
      System.debug('£££ no evaluation.Etudiant__c');
      returnStruct.hasEtudiant = false;
      returnStruct.message += 'erreur Etudiant;';
    }

    if (
      String.isNotBlank(evaluation.Etudiant__r.LastName) &&
      String.isNotEmpty(evaluation.Etudiant__r.LastName)
    ) {
      returnStruct.hasEtudiantLastName = true;
    } else {
      System.debug('£££ no evaluation.Etudiant__r.LastName');
      returnStruct.hasEtudiantLastName = false;
      returnStruct.message += 'erreur Etudiant LastName;';
    }

    if (
      String.isNotBlank(evaluation.Etudiant__r.FirstName) &&
      String.isNotEmpty(evaluation.Etudiant__r.FirstName)
    ) {
      returnStruct.hasEtudiantFirstName = true;
    } else {
      System.debug('£££ no evaluation.Etudiant__r.FirstName');
      returnStruct.hasEtudiantFirstName = false;
      returnStruct.message += 'erreur Etudiant FirstName;';
    }

    if (evaluation.Note_globale__c != null) {
      returnStruct.hasNoteGlobale = true;
    } else {
      System.debug('£££ no evaluation.Note_globale__c');
      returnStruct.hasNoteGlobale = false;
      returnStruct.message += 'erreur Note globale;';
    }
    if (evaluation.Date_Reception_Evalutation__c != null) {
      returnStruct.hasDateReceptionEval = true;
    } else {
      System.debug('£££ no evaluation.Date_Reception_Evalutation__c');
      returnStruct.hasDateReceptionEval = false;
      returnStruct.message += 'erreur Date reception evaluation;';
    }

    returnStruct.allDataOK =
      returnStruct.hasDateReceptionEval &&
      returnStruct.hasNoteGlobale &&
      returnStruct.hasEtudiantFirstName &&
      returnStruct.hasEtudiantLastName &&
      returnStruct.hasEtudiant;
    System.debug('checkStrictEvaluationData returnStruct : ' + returnStruct);
    System.debug(
      '<<< SendConvstaEvaluationToCursus checkStrictEvaluationData END'
    );
    return JSON.serialize(returnStruct);
  }

  /*
    @return Boolean: evaluation recieved needs to be updated or not
    */
  //@Future(callout=true) cause enqueued one by one
  public static void doSendEvalToCursus(String evaluationStr) {
    Convsta_Evaluation__c evaluation = (Convsta_Evaluation__c) JSON.deserialize(
      evaluationStr,
      Convsta_Evaluation__c.class
    );
    System.debug('doSendEvalToCursus @evaluation : ' + evaluation);

    String retStr = Convsta_WS_Helper_Cursus.wsPostEval(evaluation.Id);
    if (String.isBlank(retStr)) {
      evaluation.Erreur_dans_Cursus__c = true;
      update evaluation;
    }
  }
}