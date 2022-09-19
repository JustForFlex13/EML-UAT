/*--------------------------------------------------------------------
-- - Purpose             : Classe servant à l'extraction de données
--                         Il en est de même pour toutes les classes commençant par DataExtract0XX
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 13/02/2017  J.NG  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
public class DataExtract001Titre implements Queueable {

    public static final String OBJECT_NAME_TITRE = 'Titre__c';

    public void execute(QueueableContext context) {
        extractTitres();
        if(!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract003Naf());
        }
    }

    /**
    Extraction de tous les enregistrements "Titre__c"
     */
    public static void extractTitres() {
        System.debug('--- Begin DataExtract001Titre / extractTitres() ---');
        String whereClause = ' WHERE TECH_External_ID__c != null';
        DataExtractUtils.extractAllFieldWithSpecificWhereClause('01', OBJECT_NAME_TITRE, whereClause);
        System.debug('--- End DataExtract001Titre / extractTitres() ---');
    }
}