/**
 * Created by Julie NGUYEN - Modis on 23/02/2017.
 */

public class DataExtract009Etablissement implements Queueable {

    public static final String OBJECT_NAME_ETABLISSEMENT = 'Etablissement__c';

    public void execute(QueueableContext context) {
        extractEtablissements();
        if(!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract012Contact());
        }
    }

    /**
    Extraction de tous les enregistrements "Etablissement__c"
     */
    public static void extractEtablissements() {
        System.debug('--- BEGIN DataExtract009Etablissement / extractEtablissements() ---');
        String whereClause = ' WHERE TECH_External_ID__c != null';
        DataExtractUtils.extractAllFieldWithSpecificWhereClause('05', OBJECT_NAME_ETABLISSEMENT, whereClause);
        System.debug('--- END DataExtract009Etablissement / extractEtablissements() ---');
    }
}