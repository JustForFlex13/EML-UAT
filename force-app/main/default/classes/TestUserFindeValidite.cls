@istest(seeAllData=true)
public class TestUserFindeValidite {
    
    static testmethod void test1(){
        
        test.startTest();
        
        Date currentDate = system.Date.today();
        User u1 = new User();
        TimeZone tz =  UserInfo.getTimeZone();
        u1.FirstName='Jean';
        u1.LastName='TEST 1';
        u1.IsActive=true;
        u1.Date_de_fin_de_validite__c=Date.today();
        u1.Email='jeantest1@nowhere.com';
        u1.Username='jeantest1@nowhere.com';
        u1.Alias='jtest1';
        u1.CommunityNickname='test1';
        u1.ProfileId='00ew0000001mrBd';
        u1.TimeZoneSidKey = 'Europe/Paris';
        u1.emailencodingkey='UTF-8' ;
        u1.languagelocalekey='fr';
        u1.localesidkey='fr_FR' ;
        u1.country='France';
        
            
            insert u1;
        
        // Schedule the test job
        
        SchedulableContext sc;
        UserFindeValidite SE = new UserFindeValidite();
        SE.execute(sc);
        
        
        // vérification
        
        List<User> lUsers = new List<User>();
        
        lUsers = [select id, isActive from User where email ='jeantest1@nowhere.com'];
        User u = lUsers.get(0);
        
        System.assertEquals(false,u.IsActive);
        
        
    }
    
    static testmethod void test2(){
        
        test.startTest();
        
        Date currentDate = system.Date.today();
        User u1 = new User();
        TimeZone tz =  UserInfo.getTimeZone();
        u1.FirstName='Pierre';
        u1.LastName='TEST 2';
        u1.IsActive=true;
        u1.Date_de_fin_de_validite__c=Date.today().addDays(+3);
        u1.Email='pierretest2@nowhere.com';
        u1.Username='pierretest2@nowhere.com';
        u1.Alias='ptest2';
        u1.CommunityNickname='test2';
        u1.ProfileId='00ew0000001mrBd';
        u1.TimeZoneSidKey = 'Europe/Paris';
        u1.emailencodingkey='UTF-8' ;
        u1.languagelocalekey='fr';
        u1.localesidkey='fr_FR' ;
        u1.country='France';
       
            
            insert u1;
        
        // Schedule the test job
        
        SchedulableContext sc;
        UserFindeValidite SE = new UserFindeValidite();
        SE.execute(sc);
        
        
        // vérification
        
        List<User> lUsers = new List<User>();
        
        lUsers = [select id, isActive from User where email ='pierretest2@nowhere.com'];
        User u = lUsers.get(0);
        
        System.assertEquals(true,u.IsActive);
        
        test.stopTest();
    }
    
    // test date fin de validité avec valeur nulle
    static testmethod void test3(){
        
        test.startTest();
        
        Date currentDate = system.Date.today();
        User u1 = new User();
        TimeZone tz =  UserInfo.getTimeZone();
        u1.FirstName='Marc';
        u1.LastName='TEST 3';
        u1.IsActive=true;
        u1.Date_de_fin_de_validite__c=null;
        u1.Email='marctest3@nowhere.com';
        u1.Username='marctest3@nowhere.com';
        u1.Alias='mtest3';
        u1.CommunityNickname='test3';
        u1.ProfileId='00ew0000001mrBd';
        u1.TimeZoneSidKey = 'Europe/Paris';
        u1.emailencodingkey='UTF-8' ;
        u1.languagelocalekey='fr';
        u1.localesidkey='fr_FR' ;
        u1.country='France';
       
            
            insert u1;
        
        // Schedule the test job
        
        SchedulableContext sc;
        UserFindeValidite SE = new UserFindeValidite();
        SE.execute(sc);
        
        
        // vérification
        
        List<User> lUsers = new List<User>();
        
        lUsers = [select id, isActive from User where email ='marctest3@nowhere.com'];
        User u = lUsers.get(0);
        
        System.assertEquals(true,u.IsActive);
        
        test.stopTest();
    }
    
}