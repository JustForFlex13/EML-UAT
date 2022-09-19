/**
 * Created by Julie NGUYEN - Modis on 23/02/2017.
 */

public class DataExtract008Departement implements Queueable {

    public static final String OBJECT_NAME_DEPARTEMENT = 'D_partement__c';

    public void execute(QueueableContext context) {
        extractDepartements();
        if(!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract009Etablissement());
        }
    }

    /**
    Extraction de tous les enregistrements "D_partement__c"
     */
    public static void extractDepartements() {
        System.debug('--- BEGIN DataExtract008Departement / extractDepartements() ---');
        String whereClause = ' WHERE TECH_External_ID__c != null';
        DataExtractUtils.extractAllFieldWithSpecificWhereClause('04', OBJECT_NAME_DEPARTEMENT, whereClause);
        System.debug('--- END DataExtract008Departement / extractDepartements() ---');
    }

}