@isTest
public class Convsta_Conditions_ContractTriggerTest {
       @testSetup
    static void setup(){
        Id pResp = [select id from profile where name='Responsable Pédagogique'].id;
        list<user> userList = new list<User>();
        userList.add( new User(alias = 'test123', email='test123@noemail.com',ByPass_RV__c =true,
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='FR',
                               localesidkey='en_US', profileid = presp, country='France',IsActive =true,
                               timezonesidkey='America/Los_Angeles', username='respPeda@noemail.com'));
        
        insert userList;
    }
    
    @isTest
    public static void test(){
        Case demande = TestDataFactory.getCaseWithSigners();
        user usr = [select id, username from user where username='respPeda@noemail.com' limit 1];
        demande.ownerId=usr.id;
        insert demande;
        system.runAs(usr) {
            Convsta_Conditions_Contractuelles__c condition = new Convsta_Conditions_Contractuelles__c(MD_Demande__c = demande.Id);
            insert condition;
            
            condition.Code_Devise__c = 'EUR';        
            update condition;
        }
        //Only code coverage
    }
}