/*--------------------------------------------------------------------
-- - Purpose             : This batch execute extraction lauch
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 10/03/2017  J.NG  MODIS    1.0      Initialisation
--------------------------------------------------------------------*/
global class BatchDataExtract implements Database.Batchable<sObject> {

    @TestVisible static Integer emailLimits;

    global database.querylocator start(Database.BatchableContext bc) {
        String query = 'SELECT ID FROM Account LIMIT 1';
        return  Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<SObject> objects) {
        System.enqueueJob(new DataExtract001Titre());
    }

    global void finish(Database.BatchableContext bc){
        // Récupération de l'ID du Batch
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
        from AsyncApexJob where Id =:BC.getJobId()];

        // Envoi d'un email à la personne qui a lancé le batch quand il est terminé
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Lancement de l\'extraction de données');
        mail.setPlainTextBody('L\'extraction de donnée est lancée, vous recevrez un nouvel e-mail quand ' +
                'elle sera terminée.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        BatchDataExtract.emailLimits = Limits.getEmailInvocations();
    }
}