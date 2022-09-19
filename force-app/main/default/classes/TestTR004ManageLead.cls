/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

 /**
 LastModifiedBy Sabri Dali 16/03/2016
 test class correction and assert implementation
 cooments added
 */
@isTest
private class TestTR004ManageLead {

    static testMethod void myUnitTest() {
     // data creation
     Id leadtype = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Formation initiale').getRecordTypeId();
       Lead l = new Lead();
       l.RecordtypeId= leadtype;
       l.LastName='ettahiri';
       l.FirstName='Kerensen';
       l.Company='kerensen';
       l.LeadSource='Email';
       l.Status='Suspect';
       l.Login__c='asmae.ettahiri@kerensen.com';
       l.Adresse_e_mail__c='asmae.ettahiri@kerensen.com';

       insert l;

       Pays__c pays = new Pays__c();
       pays.Name = 'France';
       insert pays;


       Account a = new Account(Name = 'Test', SIRET__c = '00000000000000', Industry='Agriculture',Adresse_Ville__c = 'Nantes',CodePays__c = pays.id);
       insert a;

       // test
       Test.startTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setAccountId(a.id);
        lc.setLeadId(l.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Qualifié');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
       Test.stopTest();
    }
}