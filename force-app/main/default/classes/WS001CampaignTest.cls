@isTest
private class WS001CampaignTest {
    @isTest 
    static void testdedouble() {
        
        // This code runs as the system user
        Profile p = [select id from profile where name='Administrateur système' or name='System Administrator' Limit 1];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='fr_FR_EURO', ProfileId = p.Id,
                          TimeZoneSidKey='Europe/Paris', UserName='standarduser@arpege-emlyon--dev2.com');
        
        System.runAs(u) {
            //Data creation
            Contact cont = new Contact();
            cont.Salutation = 'Mr';
            cont.FirstName = 'Sabri';
            cont.LastName = 'Dali';
            insert cont;
            
            Contact cont2 = new Contact();
            cont2.Salutation = 'Mr';
            cont2.FirstName = 'Sabrii';
            cont2.LastName = 'Dalii';
            insert cont2;
            
            Campaign c = new Campaign();
            c.Priorit_dedoublonnage__c ='1';
            c.Name='camp1';
            Database.insert(c);
            
            Campaign b = new Campaign();
            b.Priorit_dedoublonnage__c ='2';
            b.Name='camp2';
            b.ParentID=c.id;
            Database.insert(b);
            
            Campaign d = new Campaign();
            d.Priorit_dedoublonnage__c ='2';
            d.Name='camp2';
            Database.insert(d);
            
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = c.Id;
            cm.ContactId = cont.Id;
            insert cm;
            
            CampaignMember cm2 = new CampaignMember();
            cm2.CampaignId = b.Id;
            cm2.ContactId = cont.Id;
            insert cm2;
            
            //Test
            Test.startTest();
            WS001Campaing.dedupeContacts(d.id);
            WS001Campaing.dedupeContacts(b.id);
            List<Campaign> camp = [SELECT id,Dedoublonage_effectue__c FROM Campaign where Dedoublonage_effectue__c = True];
            System.assertEquals(camp.size(),3);
            Test.stopTest();
        }
    }
}