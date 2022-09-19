/**
 * Created by Julie NGUYEN - Modis on 21/03/2017.
 * Classe servant au remplissage des champs TECH_External_What_Id__c et TECH_External_Who_Id__c
 * L'utilisateur qui a lancé les batchs de remplissage reçoit un mail à la fin
 * Sa classe de test est : TestBatchFillTechId017Event
 */

global class BatchFillTechId017Event implements Database.Batchable<sObject> {

    @TestVisible static Integer emailLimits;

    String query = 'SELECT WhoId, WhatId ' +
            'FROM Event ' +
            'WHERE (Tech_External_Who_Id__c = null AND Tech_External_What_Id__c = null) ' +
            'AND (WhoId != null OR WhatId != null)';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('--- BEGIN BatchFillTechId017Event ---');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Event> records){
        System.debug('--- Execute part BatchFillTechId017Event ---');
        for (Event event : records) {
            // Remplissage du champ TECH_External_What_Id__c
            if (event.WhatId != null) {
                event.TECH_External_What_Id__c = event.WhatId;
            }

            // Remplissage du champ TECH_External_Who_Id__c
            if (event.WhoId != null) {
                event.TECH_External_Who_Id__c = event.WhoId;
            }
        }
        Database.update(records, false);
    }

    /**
    Envoi d'un mail pour signifier à l'utilisateur que l'exécution des batchs de remplissage est terminée
     */
    global void finish(Database.BatchableContext bc){
        // Récupération de l'ID du Batch
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
        from AsyncApexJob where Id =:BC.getJobId()];

        // Envoi d'un email à la personne qui a lancé le batch quand il est terminé
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Données mises à jour');
        mail.setPlainTextBody('La mise à jour des données est terminée. Vous pouvez réactiver les workflows, ' +
                'les règles de validation et les triggers.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        BatchFillTechId017Event.emailLimits = Limits.getEmailInvocations();
        System.debug('--- END BatchFillTechId017Event ---');
    }
}