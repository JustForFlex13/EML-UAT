/**
 * Created by Julie NGUYEN - Modis on 28/02/2017.
 */

public class DataExtract014Role implements Queueable {

    public static final String OBJECT_NAME_ROLE = 'R_le__c';

    private DataToExport dataExport;

    public DataExtract014Role(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractRoles();
        if (!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract016Campaign(dataExport));
        }
    }

    /**
    Extraction des rôles liés aux contacts déjà traités
     */
    public void extractRoles() {

        System.debug('--- BEGIN DataExtract014Role / extractRoles() ---');

        if ( dataExport.contactsToExport != null && !dataExport.contactsToExport.isEmpty() ) {
            String whereClause = ' WHERE Contact__c IN ' + DataExtractUtils.convertSetToString(dataExport.contactsToExport);

            System.debug('--PARAM whereClause for query : ' + whereClause);

            DataExtractUtils.extractAllFieldWithSpecificWhereClause('13', OBJECT_NAME_ROLE, whereClause);
        } else {
            System.debug(' Il n\'y a de rôles parmi les contacts traités');
        }

        System.debug('--- END DataExtract014Role / extractRoles() ---');
    }
}