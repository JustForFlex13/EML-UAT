/**
 * Created by Julie NGUYEN - Modis on 06/03/2017.
 */

public class DataExtract017OpportunityAfterLoop implements Queueable {

    private DataToExport dataExport;

    public DataExtract017OpportunityAfterLoop(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractOpportunitiesToCsv();
        if (!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract011Formation(dataExport));
        }
    }

    /**
    Extraction des opportunités stockées dans dataExport.opportunitiesToExport vers un fichier csv
     */
    public void extractOpportunitiesToCsv() {

        System.debug('--- BEGIN DataExtract017OpportunityAfterLoop / extractOpportunitiesToCsv() ---');

        System.debug('-- PARAM dataExport.opportunitiesToExport : ' + dataExport.opportunitiesToExport);

        DataExtractUtils.extractAllFieldsSpecificRecordsToCSV('10', DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY,
                dataExport.opportunitiesToExport);

        System.debug('--- END DataExtract017OpportunityAfterLoop / extractOpportunitiesToCsv() ---');
    }

}