@isTest(seeAllData=true)
public class UtilsTest {
    
    static testMethod void TestsetDptAccount(){
        try{
            List<Contact> listContactsNew;
            List<Account> listAccountsNew;
            List<D_partement__c> listDpt=new List<D_partement__c>();    
            Test.startTest();
            listContactsNew = new List<Contact>();
            listAccountsNew = new List<Account>();
            D_partement__c d1;
            D_partement__c d2;
            
            d1=[select id, Code_d_partement__c from D_partement__c where Code_d_partement__c='69' ] ; 
            d2=[select id, Code_d_partement__c from D_partement__c where Code_d_partement__c='75' ] ;
            
            NAF__c naf = new NAF__c();
            naf.CODE_APE__c = 'AAAA';
            naf.Code_NACE__c = 'BBBB';
            naf.Secteur__c = 120;
            insert naf;
            
            Pays__c PaysFrance = [Select id from Pays__c where Name='France'];           
            
            Account a = new Account();
            a.Name = 'Account test 1';
            a.CodePays__c = PaysFrance.Id;
            a.Code_Postal__c='69500';
            a.SIRET__c='40483304800022';
            a.Adresse_Ville__c='Bron';
            a.CodeAPE__c = naf.id;
            listAccountsNew.add(a);
            
            insert a;
            
            Account myAccount = [select id,Departement__c from Account];
            
            System.assertEquals(myAccount.Departement__c, d1.Id);
            
            a.Code_Postal__c='75800';
            
            update a;
            Test.stopTest();
            
            myAccount = [select id,Departement__c from Account];
            system.assertEquals(myAccount.Departement__c, d2.id);
            a.Code_Postal__c='99000';
            
            Exception e;
            try{
                update a; 
                
            }catch(Exception ex){
                e=ex;
                system.assertNotEquals(null, e);
                system.assert(e instanceOf system.Dmlexception);
                system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
                system.assert(e.getMessage().contains('Vous ne pouvez pas sélectionner ce code postal pour le pays FRANCE'));
            }
            
        }catch(Exception e)
        {
            System.debug(e);
        }   
    }
    
    static testMethod void TestsetDptContact(){
        try{
            List<D_partement__c> listDpt=new List<D_partement__c>();
            
            D_partement__c d1;
            D_partement__c d2;
            
            d1=[select id, Code_d_partement__c from D_partement__c where Code_d_partement__c='69' ] ; 
            d2=[select id, Code_d_partement__c from D_partement__c where Code_d_partement__c='75' ] ;    
            
            System.debug('Id Département 69 : '+d1.Id);
            System.debug('Id Département 75 : '+d2.Id);
            
            NAF__c naf = new NAF__c();
            naf.CODE_APE__c = 'AAAA';
            naf.Code_NACE__c = 'BBBB';
            naf.Secteur__c = 120;
            insert naf;
            
            Pays__c PaysFrance = new Pays__c();
            PaysFrance.name = 'France';
            insert PaysFrance;
            
            Account a = new Account();
            a.Name = 'Account test 1';
            a.CodePays__c = PaysFrance.Id;
            a.Code_Postal__c='69500';
            a.SIRET__c='40483304800022';
            a.Adresse_Ville__c='Bron';
            a.CodeAPE__c = naf.id;
            
            
            Contact c = new Contact();
            c.Salutation = 'M';
            c.LastName='Dupont';
            c.FirstName = 'Pierre';
            c.AccountId = a.Id;
            c.Adresse_code_postal__c = '69500';
            c.Pays__c=PaysFrance.Id;
            c.Pays_de_r_sidence__c=PaysFrance.id;
            
            insert a;
            PAD.removeTriggerHasRun('Utils');
            insert c;
            
            Contact myContact = [select id, D_partement__c from Contact where id =:c.Id];
            
            // assert à vérifier MàJ du 10/05/2017
            System.assertEquals(myContact.D_partement__c, d1.Id);
            
            c.Adresse_code_postal__c = '75008';
            update c;
            
            myContact = [select id, D_partement__c from Contact where id =:c.Id];
            
            // assert à vérifier MàJ du 10/05/2017
            //System.assertEquals(myContact.D_partement__c, d2.Id);
            
            
            
            
            c.Adresse_code_postal__c='99000';
            
            
            Exception e;
            try{
                
                update c;
            }
            
            
            catch(Exception ex){
                e=ex;
                system.assertNotEquals(null, e);
                system.assert(e instanceOf system.Dmlexception);
                system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
                system.assert(e.getMessage().contains('Vous ne pouvez pas sélectionner ce code postal pour le pays FRANCE'));
            }
            
            
        }
        
        catch(Exception e)
        {
            System.debug(e);
        }
        
    }
    
    /*
    Julie NGUYEN - Modis (24/03/2017)
    Tests pour la méthode findObjectNameFromRecordIdPrefix(String str)
    */
    static testMethod void testFindObjectNameFromRecordIdPrefix(){
        String opportunityPrefix = '006';
        String accountPrefix = '001';
        String contactPrefix = '003';
        String leadPrefix = '00Q';
        
        System.assertEquals('Opportunity', Utils.findObjectNameFromRecordIdPrefix(opportunityPrefix));
        System.assertEquals('Account', Utils.findObjectNameFromRecordIdPrefix(accountPrefix));
        System.assertEquals('Contact', Utils.findObjectNameFromRecordIdPrefix(contactPrefix));
        System.assertEquals('Lead', Utils.findObjectNameFromRecordIdPrefix(leadPrefix));
        System.assertNotEquals('Opportunity', Utils.findObjectNameFromRecordIdPrefix(leadPrefix));
        System.assertNotEquals('Account', Utils.findObjectNameFromRecordIdPrefix(leadPrefix));
        System.assertNotEquals('Lead', Utils.findObjectNameFromRecordIdPrefix(accountPrefix));
    }
    
    
    
    
    /**
    * @author : Mahmoud BECHAA
    * Created on : 12/04/2017
    * Test pour la méthode 
    */   
    static testMethod void testcontactToUpper() {
        
        List<Contact> lcon = new List<Contact>();
        
        
        Contact c1 = New Contact();
        c1.LastName='dupont';
        c1.FirstName='jean-pierre';
        lcon.add(c1);
        
        Contact c2 = new Contact();
        c2.LastName='durand';
        c2.FirstName='jean luc';
        lcon.add(c2);
        
        Contact c3 = new Contact();
        c3.LastName='dumont';
        c3.FirstName='henri';
        lcon.add(c3);
        
        for(Contact c:lcon){
            String firstname = c.FirstName.toLowerCase();
            // mise en majuscule de la 1re lettre
            
            String formatedFirstName;
            String letter='';
            formatedFirstName=firstname.mid(0,1).toUpperCase();
            
            //System.debug('Length : ' + firstname.length());
            
            integer size = firstname.length()-1;
            
            // balayage du reste des lettres
            for(Integer i=1; i< firstname.length();i++)
            {
                letter = firstname.mid(i, 1);
                
                if(letter==' ' || letter=='-'){
                    
                    
                    i++;
                    size=size-1;      
                    letter=letter=firstname.mid(i-1,1) + firstname.mid(i,1).toUpperCase();
                    
                } 
                else{
                    
                    letter=firstname.mid(i,1).toLowerCase();
                }
                
                size=size-1;
                formatedFirstName+=letter;
                
            }
            
            //System.debug('Prénom : '+formatedFirstName);
            
            c.FirstName=formatedFirstName;
            
            // pour finir : transformation du nom en majuscule 
            c.LastName=c.LastName.toUpperCase();
            
        }
        // vérification du nom et prénom suite à mise en forme 
        // (on utilise la fonction AssertEquals pour la comparaison car elle est case-sensitive)
        System.assertEquals(lcon[0].LastName, 'DUPONT');
        System.assertEquals(lcon[0].FirstName, 'Jean-Pierre');
        System.assertEquals(lcon[1].LastName, 'DURAND');
        System.assertEquals(lcon[1].FirstName, 'Jean Luc');
        System.assertEquals(lcon[2].LastName, 'DUMONT');
        System.assertEquals(lcon[2].FirstName, 'Henri');
        
    }    
    
    // Méthode de création d'un utilisateur de test 
    public static void createUserTest(string bypassTriggers, boolean bypassWorkflow, boolean bypassValidationRules) {        
        User testUser = new User(
            alias = 'Test',
            email = 'test_emlyon@example.com', 
            emailencodingkey='UTF-8',
            lastname='EML',
            languagelocalekey='fr', 
            localesidkey='fr_FR',
            profileid = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrateur système' LIMIT 1][0].Id,
            timezonesidkey='America/Los_Angeles',
            username='test_emlyon@example.com',
            BypassTrigger__c = bypassTriggers,
            //Bypass_Workflows__c = bypassWorkflow,//TODO
            ByPass_RV__c = bypassValidationRules
        );
        
        Database.Saveresult sr = Database.insert(testUser,false);
        System.assert(sr.isSuccess(),'Utilisateur de Test pas créé');
    } 
}