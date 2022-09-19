/**
LastModifiedBy Sabri Dali 16/03/2016
test class correction and assert implementation
cooments added
*/
@isTest
public class TestTR001ManageContact {
    
    private static void createBeforeDelete(Integer numAccts, Integer numContactsPerAcct) {
        List<Account> accts = new List<Account>();
        
        // création d'un NAF et d'un pays pour alimenter les champs obligatoires de l'objet compte
        
        NAF__c naf = new NAF__c();
        naf.CODE_APE__c = 'AAAA';
        naf.Code_NACE__c = 'BBBB';
        naf.Secteur__c = 120;
        insert naf;
        
        
        Pays__c pays = new Pays__c();
        pays.Name = 'France';
        insert pays;
        
        // création et insertion des comptes simples
        // les noms de comptes simples seront TestAccount0, TestAccount1, TestAccount2,...
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i, 
                                    CodeAPE__c=naf.Id,
                                    SIRET__c='00000000000000',
                                    CodePays__c=pays.id );
            accts.add(a);
        }
        
        
        
        
        try{
            
            insert accts;
            
        } catch(DmlException dmle)
        {
            System.debug(' insert accts ! The following exception has occurred: ' + dmle.getMessage());
        }
        
        // Pour chacun des comptes insérés, ajout de contacts classiques
        // les noms de contacts seront TestContact0, TestContact1, TestContact2...
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];            
            
            for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cons.add(new Contact(firstname='TestContact'+k,
                                     lastname='TestContact'+k,
                                     AccountId=acct.Id));
            }
        }
        
        
        // insertion de contacts diplômés emlyon
        List<Contact> cons_dipl = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];            
            // Pour chacun des comptes insérés, ajout de contacts
            // // Pour chacun des comptes insérés, ajout de Diplômés avec Membre_vie__c =true
            // les noms de Diplômés seront TestDilpl0, TestDilpl1, TestDilpl2...
            for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cons_dipl.add(new Contact(firstname='TestDipl'+k,
                                          Identifiant_dipl_m__c='1000'+k,
                                          lastname='TestDilpl'+k,
                                          Membre_vie__c =true,
                                          AccountId=acct.Id));
            }
        }
        
        
        // Insertion de tous les contacts diplômés pour tous les comptes
        
        try{
            
            insert cons_dipl;
            
        } catch(DmlException dmle)
        {
            System.debug(' insert accts ! The following exception has occurred: ' + dmle.getMessage());
        }
        
        Account acc1 = new Account(Name='AccTest1');
        acc1.SIRET__c  = '40483304800022';
        acc1.CodeAPE__c = naf.Id;
        acc1.CodePays__c = pays.id;
        acc1.Adresse_Ville__c = 'Nantes';
        
        
        try{
            
            insert acc1;
            
        } catch(DmlException dmle)
        {
            System.debug(' insert accts ! The following exception has occurred: ' + dmle.getMessage());
        }
        
        Account acc2 = new Account(Name='AccTest2');
        acc2.SIRET__c  = '40483304800042';
        acc2.CodeAPE__c = naf.Id;
        acc2.CodePays__c = pays.id;
        acc2.Adresse_Ville__c = 'Lyon';
        
        
        try{
            
            insert acc2;
            
        } catch(DmlException dmle)
        {
            System.debug(' insert accts ! The following exception has occurred: ' + dmle.getMessage());
        }
        
        Contact contactForever = new Contact();
        contactForever.lastName = 'totoForever';
        contactForever.firstName = 'totoForever2';
        contactForever.salutation = 'M.';
        contactForever.AccountId = acc2.Id;
        contactForever.Statut__c = 'Etudiant';
        contactForever.Membre_vie__c =true;
        
        
        
        try{
            
            insert contactForever;
            
        } catch(DmlException dmle)
        {
            System.debug(' insert accts ! The following exception has occurred: ' + dmle.getMessage());
        }
        Contact testContactFalse = new Contact();
        testContactFalse.lastName = 'toto';
        testContactFalse.firstName = 'toto2';
        testContactFalse.salutation = 'M.';
        testContactFalse.AccountId = acc1.Id;
        testContactFalse.Statut__c = 'Etudiant';
        testContactFalse.Membre_vie__c =false;
        
        
        try{
            
            insert testContactFalse;
            
        } catch(DmlException dmle)
        {
            System.debug(' insert accts ! The following exception has occurred: ' + dmle.getMessage());
        }
        
       // Boolean MembreVie = false;
        try {
            // suppression d'un contact avec Membre_vie__c = true
            delete contactForever;
            System.assertEquals(true, false);
        } catch (Exception e) {
            // on teste que la suppression a bien levé le message d'erreur attendu
            String errorMessage='Ce contact ne peux pas être supprimé car il est synchronisé avec Forever';
            Boolean MembreVie = e.getMessage().indexOf(errorMessage)!=-1;
            System.assertEquals(MembreVie, true);
            //System.assertEquals(e.getMessage(), '');
        }
        Boolean MembreVie2 = false;
        try {
            // suppression d'un contact avec Membre_vie__c = false
            
            delete testContactFalse;
            System.assertEquals(true, true);
        } catch (Exception e) {
            // on teste que la suppression a bien levé le message d'erreur attendu
            String errorMessage='Ce contact ne peux pas être supprimé car il est synchronisé avec Forever';
            MembreVie2 = e.getMessage().indexOf(errorMessage)!=-1;
            System.assertEquals(MembreVie2, false);
            //System.assertEquals(e.getMessage(), '');
        }
        
    //    system.assertEquals(MembreVie2, false);
        
        
    }            
        
    @isTest static void validationTriggerContactBeforeDelete() {
        createBeforeDelete(3,3);
    }

    @isTest static void verifyCreatePosteSupplementaire(){

        Account acc = TestDataFactory.getAccount();
        insert acc;

        Contact ctc = TestObjectFactory.createContact(acc);
        ctc.Statut__c = 'Professionnel';
        ctc.Famille_Fonction__c = 'Autres';
        ctc.Fonctions__c = 'Non Renseignée';
        ctc.Title = 'Test';
        ctc.Date_de_d_but__c = Date.today();
        ctc.Date_de_fin__c = Date.today().addDays(1);
        ctc.Email_de_repli__c = 'test@test.com';
        ctc.Mobile_professionnel__c = '0600000000';
        insert ctc;
        PAD.removeTriggerHasRun('TR001ManageContact'); // Ajouté dans AfterInsert
        PAD.removeTriggerHasRun('Utils');//Ajouté dans BeforeInsert

        Test.startTest();
        ctc.Famille_Fonction__c = 'Président(e)';
        update ctc;
        Test.stopTest();

        List<Postes_Suppl_mentaires__c> poste = [SELECT Id FROM Postes_Suppl_mentaires__c where Contact__c =:ctc.Id];
        System.assertEquals(1, poste.size());
    }
    
    @isTest static void addErrorMembreAVie(){
        Contact ctc1 = TestDataFactory.getContact();
        
        try{        
            ctc1.Membre_vie__c = true;            
            insert ctc1;
            
            Test.startTest();
            delete ctc1;
            Test.stopTest();
        
        }catch(Exception e){        
            Boolean expectedExceptionThrown =  e.getMessage().contains('Ce contact ne peux pas être supprimé car il est synchronisé avec Forever');
        
            System.AssertEquals(expectedExceptionThrown, true);        
        } 
    }
       
}