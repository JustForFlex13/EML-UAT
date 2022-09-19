/**
 * Created by Julie NGUYEN - Modis  on 10/05/2017.
 */

public class DataExtract028OpportunitiesAfterQuotas implements Queueable {
    private DataToExport dataExport;

    public DataExtract028OpportunitiesAfterQuotas(DataToExport dataToExport) {
        this.dataExport = dataToExport;
    }

    public void execute(QueueableContext context) {
        extractOpportunitiesToCsv();
        if (!Test.isRunningTest()) {
            System.enqueueJob(new DataExtract025MailingAfterExtract());
        }
    }

    /**
    Extraction des contacts stockés dans dataExport.contactsToExport vers un fichier csv
     */
    public void extractOpportunitiesToCsv() {

        System.debug('--- BEGIN DataExtract028OpportunitiesAfterQuotas / extractOpportunitiesToCsv() ---');

        if (dataExport.opportunitiesToBeExportedRelatedToMinimalQuotas != null && !dataExport.opportunitiesToBeExportedRelatedToMinimalQuotas.isEmpty()) {
            DataExtractUtils.extractAllFieldsSpecificRecordsToCSV('10 Bis', DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY,
                    dataExport.opportunitiesToBeExportedRelatedToMinimalQuotas);
        }

        System.debug('--- END DataExtract028OpportunitiesAfterQuotas / extractOpportunitiesToCsv() ---');
    }
}