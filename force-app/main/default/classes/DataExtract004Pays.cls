/**
 * Created by Julie NGUYEN - Modis on 22/02/2017.
 */

public class DataExtract004Pays implements Queueable {

     public static final String OBJECT_NAME_PAYS = 'Pays__c';

     public void execute(QueueableContext context) {
          extractPays();
          if(!Test.isRunningTest()) {
               System.enqueueJob(new DataExtract008Departement());
          }
     }

     /**
    Extraction de tous les enregistrements "Pays__c"
     */
     public static void extractPays() {
          System.debug('--- BEGIN DataExtract004Pays / extractPays() ---');
          String whereClause = ' WHERE TECH_External_ID__c != null';
          DataExtractUtils.extractAllFieldWithSpecificWhereClause('03', OBJECT_NAME_PAYS, whereClause);
          System.debug('--- END DataExtract004Pays / extractPays() ---');
     }
}