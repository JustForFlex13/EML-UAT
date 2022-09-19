/**
 * Created by Julie NGUYEN - Modis on 14/03/2017.
 */

@isTest
private class DataExtract024PartenaireFinanceurTest {

    @testSetup static void createData() {
        DataExtractObjectsUtilsTest.createData();
    }

    static testMethod void testExtractPartenairesFinanceurs() {
        String objName = DataExtract024PartenaireFinanceur.OBJECT_NAME_PARTENAIRE_FINANCEUR ;

        List<Opportunity> opportunities = [SELECT Id, TECH_External_Id__c FROM Opportunity];
        for (Opportunity o : opportunities) {
            o.TECH_External_Id__c = o.Id;
        }
        update opportunities;

        List<Account> accounts = [SELECT Id, TECH_External_Id__c FROM Account];
        for (Account a : accounts) {
            a.TECH_External_Id__c = a.Id;
        }
        update accounts;

        DataToExport dataExport = new DataToExport();

        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract018Account.OBJECT_NAME_ACCOUNT);
        DataExtractObjectsUtilsTest.addObjectsToProcess(dataExport, DataExtract017Opportunity.OBJECT_NAME_OPPORTUNITY);

        DataExtract024PartenaireFinanceur de = new DataExtract024PartenaireFinanceur(dataExport);

        Test.startTest();
        de.execute(null);
        Test.stopTest();

        DataExtractObjectsUtilsTest.testCsvFile(objName);
    }

}