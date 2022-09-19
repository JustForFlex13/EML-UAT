@isTest
public with sharing class convsta_BatchSchedule_CancelCase_test {
  @testSetup
  static void setup() {
    Id p = [SELECT id FROM profile WHERE name = 'Convsta community Login'].id;
    Id pEmpl = [SELECT id FROM profile WHERE name = 'EMPLOYABILITE'].id;
    Id pResp = [SELECT id FROM profile WHERE name = 'Responsable Pédagogique']
    .id;

    User thisUser = TestObjectFactory.createUser();
    ThisUser.UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'EML'].id;
    insert thisUser;

    System.runAs(thisUser) {
      //getTableTuteurSignataireByRespTest--
      list<contact> ctcList = new List<Contact>();
      Contact ctc = TestDataFactory.getContact();
      ctc.Email_EM_Lyon__c = 'test@edu.emlyon.com';
      ctcList.add(ctc);
      Contact ctc2 = TestDataFactory.getContact();
      ctc2.Convsta_Tuteur_EM__c = true;
      ctc2.email = 'tuteur@yopmail.com';
      ctcList.add(ctc2);
      insert ctcList;
      list<user> userList = new List<User>();
      userList.add(
        new User(
          alias = 'test123',
          email = 'test@edu.emlyon.com',
          emailencodingkey = 'UTF-8',
          lastname = 'Testing',
          languagelocalekey = 'FR',
          localesidkey = 'en_US',
          profileid = p,
          country = 'France',
          IsActive = true,
          ContactId = ctc.Id,
          timezonesidkey = 'America/Los_Angeles',
          username = 'tester@noemail.com'
        )
      );
      userList.add(
        new User(
          alias = 'test123',
          email = 'test123@noemail.com',
          emailencodingkey = 'UTF-8',
          lastname = 'Testing',
          languagelocalekey = 'FR',
          localesidkey = 'en_US',
          profileid = pEmpl,
          country = 'France',
          IsActive = true,
          timezonesidkey = 'America/Los_Angeles',
          username = 'administratif@noemail.com'
        )
      );
      userList.add(
        new User(
          alias = 'test123',
          email = 'test123@noemail.com',
          emailencodingkey = 'UTF-8',
          lastname = 'Testing',
          languagelocalekey = 'FR',
          localesidkey = 'en_US',
          profileid = presp,
          country = 'France',
          IsActive = true,
          timezonesidkey = 'America/Los_Angeles',
          username = 'respPeda@noemail.com'
        )
      );
      insert userList;
      CONVSTA_Table_Regles_Experience_Pro__c table = TestObjectFactory.createTable();
      table.Annee_application__c = '2019';
      table.Accessible_aux_etudiants__c = true;
      insert table;
      Pays__c paysref = new Pays__c(
        Name = 'Pays_Test01',
        Code_Pays_2_caracteres__c = 'US'
      );
      insert paysref;
      insert new Etat__c(
        code_etat__c = 'CO',
        code_pays__c = 'US',
        Name = 'Colorado'
      );
      Account company = TestDatafactory.getAccount();
      company.Name = 'Company test';
      insert company;
      //postSignatureCreateTest
      Date startDate = Date.today();
      Date endDate = startDate.addDays(20);
      Case demande = TestDatafactory.getCaseWithSigners();
      demande.Convsta_DateStart__c = startDate;
      demande.Convsta_DateEnd__c = endDate;
      system.debug('inserted TEST demande : ' + demande);
      Contact student = [
        SELECT Id, Name
        FROM Contact
        WHERE id = :demande.ContactId
      ];
      Contact tutor = [
        SELECT Id, Name
        FROM Contact
        WHERE Name = 'Tuteur ENTREPRISE'
      ];
      student.FirstName = 'yoyoyoy';
      student.lastName = 'yoyoyoyo';
      update student;
      demande.ContactId = student.id;
      demande.Convsta_Entreprise__c = company.id;
      demande.Convsta_Tuteur__c = tutor.Id;
      insert demande;
      Contact evaluateur = TestDataFactory.getContact();
      evaluateur.email = 'evaluateur@yopmail.com';
      insert evaluateur;
      String fakeCryptedKey = 'fakeCryptedKey';
      Convsta_Evaluation__c evaluation = TestDataFactory.getEvaluation(
        demande.Id
      );
      evaluation.cle_cryptee__c = fakeCryptedKey;
      evaluation.Demande__c = demande.Id;
      evaluation.Evaluateur__c = evaluateur.id;
      insert evaluation;
      Convsta_Mission__c mission = TestDatafactory.getMission(demande.Id);
      insert mission;
      Convsta_Competence__c oneComp = new Convsta_Competence__c(
        Name = 'competence test',
        Label_fr__c = 'competence test fr',
        Label_En__c = 'competence test en',
        Evaluation__c = evaluation.Id,
        Famille_metiers__c = evaluation.Famille_competences_metier__c,
        type__c = '3Métier',
        Order__c = 0,
        rating__c = '4'
      );
      insert oneComp;
    }
  }

  @isTest
  static void cancelOldCase() {
    test.startTest();
    database.executeBatch(new convsta_BatchSchedule_CancelCase(-5));
    test.stopTest();
    system.assertEquals(
      1,
      [SELECT Id FROM case WHERE Status = 'Brouillon expiré'].size()
    );
  }
  static testMethod void scheduletest() {
    Test.startTest();

    String jobId = System.schedule(
      'testBasicScheduledApex',
      '0 0 0 3 9 ? 2022',
      new convsta_BatchSchedule_CancelCase(-5000000)
    );

    // Get the information from the CronTrigger API object
    CronTrigger ct = [
      SELECT Id, CronExpression, TimesTriggered, NextFireTime
      FROM CronTrigger
      WHERE id = :jobId
    ];

    // Verify the expressions are the same
    System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);

    // Verify the job has not run
    System.assertEquals(0, ct.TimesTriggered);

    // Verify the next time the job will run
    System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
    Test.stopTest();
  }
}