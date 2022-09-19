/**
 * Created by Julie NGUYEN - Modis on 16/03/2017.
 */

public class DataExtract025MailingAfterExtract implements Queueable {

    @TestVisible static Integer emailLimits;

    public void execute(QueueableContext context) {
        sendEmailMessage();
    }

    public static void sendEmailMessage() {
        System.debug('--- BEGIN DataExtract025MailingAfterExtract sendEmailMessage() ---');

        System.debug('--- UserInfo.getUserEmail() ' + UserInfo.getUserEmail());

        // Envoi d'un email à la personne qui a lancé l'extraction quand elle est terminée
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {UserInfo.getUserEmail()};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Extraction de données terminée');
        mail.setPlainTextBody('L\'extraction de donnée est terminée. ' +
                'Vous pouvez récupérer les fichiers .csv (Excel) générés.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        // Valeur permettant de tester la classe et vérifier le nombre de mails envoyés
        DataExtract025MailingAfterExtract.emailLimits = Limits.getEmailInvocations();

        System.debug('--- END DataExtract025MailingAfterExtract sendEmailMessage() ---');
    }

}