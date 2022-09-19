@isTest
public class AsyncUpdateContactTest {
	static TestMethod void testQueueable() {
        try{
        	Account acc = TestDataFactory.getAccount();
      		insert acc;

            final Contact contact= new Contact(AccountId=acc.Id,
                                               statut__c='Etudiant',
                                               FirstName='Mohamed',
                                               LastName='Abdelfadel',
                                               Salutation='Mr',
                                               Famille_Fonction__c='Autres');

            try{
                insert contact;
            } catch(DmlException dmle)
            {
                System.debug('The following exception has occurred: ' + dmle.getMessage());
            }


            Id RecordTypeFundraisingB2CId= APU_ApexUtils.getOpportunityRecordTypeIdByName('Fundraising B2C');
            final Opportunity opp1= new Opportunity(RecordTypeId= RecordTypeFundraisingB2CId,StageName='Prospect probable',
                                                    Name='test opp 1',
                                                    Contact_central__c=contact.Id,
                                                    AccountId=acc.Id,
                                                    amount = 1000,
                                                    Exercice__c='2015',
                                                    CloseDate=Date.valueOf('2015-08-15'),
                                                    InterfaceExternalId__c = 'blabla1',
                                                    Date_de_mise__c = DateTime.valueOf('2014-12-01 10:00:00'));

            final Opportunity opp2= new Opportunity(RecordTypeId= RecordTypeFundraisingB2CId,StageName='Conclu',
                                                    Name='test opp 2',
                                                    Contact_central__c=contact.Id,
                                                    AccountId=acc.Id,
                                                    amount = 500,
                                                    Exercice__c='2015',
                                                    CloseDate=Date.valueOf('2015-08-15'),
                                                    InterfaceExternalId__c = 'blabla2',
                                                    Date_de_mise__c = DateTime.valueOf('2014-12-01 10:00:00'));


            final List<Opportunity> myOpportunities = new List <Opportunity>();
            myOpportunities.add(opp1);
            myOpportunities.add(opp2);

            Boolean exceptionCatched = false;
            String err ='';
            try{
                insert myOpportunities;
            }catch (System.DMLException e){
                exceptionCatched = true;
                err = e.getMessage();
            }
            System.assertEquals(exceptionCatched, false, err);

            opp1.StageName='Conclu';
            opp2.StageName='Prospect probable';

            //Assert Test
            Test.startTest();

            exceptionCatched = false;
            try {
                update myOpportunities;
            } catch (System.DMLException e) {
                exceptionCatched = true;
                err = e.getMessage();
            }
            System.assertEquals(exceptionCatched, false, err);

            final Opportunity opp3= new Opportunity();
            myOpportunities.add(opp3);
            try {
                update myOpportunities;
            } catch (System.DMLException e) {
                exceptionCatched = true;
            }

            System.assertEquals(exceptionCatched, true);
            Test.stopTest();
        }catch(DmlException dmle)
        {
            System.debug('The following exception has occurred: ' + dmle.getMessage());
        }
    }
}