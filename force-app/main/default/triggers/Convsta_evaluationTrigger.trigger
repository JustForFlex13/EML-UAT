trigger Convsta_evaluationTrigger on Convsta_evaluation__c(after update) {
  if (Trigger.isAfter && Trigger.isUpdate) {
    System.debug('## >>> Convsta_evaluationTrigger after Update - START');
    List<Convsta_evaluation_evaluee__e> mweList = new List<Convsta_evaluation_evaluee__e>();

    for (Convsta_Evaluation__c eval : Trigger.new) {
      if (
        eval.Statut__c!= null &&
        eval.Statut__c.equalsIgnoreCase('Évaluée') &&
        (Trigger.oldMap.get(eval.Id).Statut__c != 'Évaluée' ||
        eval.Note_globale__c != Trigger.oldMap.get(eval.Id).Note_globale__c) &&
        !eval.Ne_pas_basculer_la_note_dans_la_Scola__c
      ) {
        mweList.add(
          new Convsta_evaluation_evaluee__e(evaluationId__c = eval.Id)
        );
      }
    }

    List<Database.SaveResult> results = EventBus.publish(mweList);
    // Inspect publishing results
    System.debug('EventBus.publish(mweList) results :' + results);
    for (Database.SaveResult result : results) {
      if (!result.isSuccess()) {
        for (Database.Error error : result.getErrors()) {
          System.debug(
            'Error returned: ' +
            error.getStatusCode() +
            ' - ' +
            error.getMessage()
          );
        }
      }
    }
    System.debug('## >>> Convsta_evaluationTrigger after Update - END');
  }
}