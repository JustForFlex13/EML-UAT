trigger Convsta_evaluation_evaluee on Convsta_evaluation_evaluee__e (after insert) {
    System.debug('>>> Convsta_evaluation_evaluee on Convsta_evaluation_evaluee__e START' + Trigger.new);
    List<String> convstaEvalIds = new List<String>();
    for (Convsta_evaluation_evaluee__e evalEvent : Trigger.new) {
        if(evalEvent.evaluationId__c != null) {
            convstaEvalIds.add(evalEvent.evaluationId__c);
        }
    }
    System.debug('>>> enqueueJob(new SendConvstaEvaluationToCursus BEFORE');
    System.enqueueJob(new SendConvstaEvaluationToCursus(convstaEvalIds));
    System.debug('>>> enqueueJob(new SendConvstaEvaluationToCursus AFTER');
}