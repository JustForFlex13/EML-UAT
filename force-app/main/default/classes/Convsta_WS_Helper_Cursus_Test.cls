@isTest
public class Convsta_WS_Helper_Cursus_Test {
  @testSetup
  static void setup() {
    Id p = [SELECT id FROM profile WHERE name = 'Convsta community Login'].id;
    Id pEmpl = [SELECT id FROM profile WHERE name = 'EMPLOYABILITE'].id;
    Id pResp = [SELECT id FROM profile WHERE name = 'Responsable Pédagogique']
    .id;

    CONVSTA_Table_Regles_Experience_Pro__c table = TestObjectFactory.createTable();
    table.Annee_application__c = '2019';
    table.Accessible_aux_etudiants__c = TRUE;
    table.Ann_e_suivante__c = FALSE;
      table.Programme__c = 'BBAP';
    table.Code_etude__c = 'BBAP1';
    table.Nom_Responsable_Pedagogique__c = UserInfo.getUserId();
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

    NAF__c naf = new NAF__c();
    naf.CODE_APE__c = 'UniqueCodeApeExternalId';
    naf.Secteur__c = 123.45;
    insert naf;

    Account company = TestDatafactory.getAccount();
    company.Name = 'Company test';
    company.ID_FEG__c = '1234';
    company.Code_Postal__c = '69100';
    company.Adresse_Ville__c = 'VILLEURBANNE';
    company.CodePays__c = paysref.Id;
    company.Adresse_Rue__c = 'STALINGRAD';
    company.CodeAPE__c = naf.Id;
    insert company;

    User respPeda = new User(
      alias = 'test123',
      email = 'test123@noemail.com',
      emailencodingkey = 'UTF-8',
      FirstName = 'firstNameTest',
      lastname = 'Testing',
      languagelocalekey = 'FR',
      localesidkey = 'en_US',
      profileid = presp,
      country = 'France',
      IsActive = true,
      timezonesidkey = 'America/Los_Angeles',
      username = 'respPeda@noemail.com'
    );
    insert respPeda;

    //postSignatureCreateTest
    Date startDate = Date.today();
    Date endDate = startDate.addDays(20);

    Case demande = TestDatafactory.getCaseWithSigners();

    Contact student = [
      SELECT
        Id,
        FirstName,
        LastName,
        Name,
        Email_EM_Lyon__c,
        convsta_code_etudiant_EM__c
      FROM Contact
      WHERE Id = :demande.contactId
    ];
    student.convsta_code_etudiant_EM__c = '12345678';
    student.FirstName = 'firstnametest';
    student.LastName = 'lastnametest';
    update student;

    Contact tutor = [
      SELECT Id, Name
      FROM Contact
      WHERE Name = 'Tuteur ENTREPRISE'
    ];
    tutor.Fonctions__c = 'Cadre Technique';
    update tutor;

    Contact responsableAdmin = [
      SELECT Id
      FROM Contact
      WHERE Id = :demande.Responsable_administratif_entreprise__c
    ];
    responsableAdmin.Fonctions__c = 'Attaché de Direction';
    responsableAdmin.FirstName = 'firstNameTest';
    responsableAdmin.Convsta_Tuteur_EM__c = true;
    update responsableAdmin;

    demande.Contact = student;
    demande.Convsta_Entreprise__c = company.id;
    demande.Convsta_Tuteur__c = tutor.Id;
    demande.Convsta_Type_de_demande__c = 'Stage';
    demande.Convsta_Langue__c = 'Français';
    demande.Convsta_TypeContrat__c = 'Convention de stage de l ecole';
    demande.Convsta_DateStart__c = startDate;
    demande.Convsta_DateEnd__c = endDate;
    demande.Convsta_Adresse_du_lieu_du_stage__c = '121 rue de l\'addresse du lieu du stage';
    demande.Convsta_Nouvelle_adresse_lieu_de_stage__c = '122 rue de l\'addresse du lieu du stage';
    demande.Origin = 'Téléphone';
    demande.Date_Reception_Convention__c = date.newInstance(2020, 6, 20);
    demande.Convsta_Entreprise__c = company.Id;
    demande.Responsable_administratif_entreprise__c = responsableAdmin.Id;
    demande.Convsta_Referent_pedagogique__c = responsableAdmin.Id;
    demande.Convsta_Responsable_Pedagogique__c = respPeda.Id;
    demande.Code_Ann_e_Etudiant__c = 'BBAP1';
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
    evaluation.Date_Reception_Evalutation__c = Date.today().addDays(-10);
    evaluation.Note_globale__c = 18;
    evaluation.Etudiant__c = student.Id;
    insert evaluation;

    Convsta_Mission__c mission = [
      SELECT Id, Convsta_Description_de_la_mission__c
      FROM Convsta_Mission__c
      WHERE MD_Demande__c = :demande.Id
    ];
    mission.Convsta_Description_de_la_mission__c = 'En voilà une description de mission qu\'elle est bien !';
    mission.Famille_fonction__c = 'Marketing/Communication';
    update mission;

    Convsta_Entreprise__c entreprise = [
      SELECT Id
      FROM Convsta_Entreprise__c
      WHERE MD_Demande__c = :demande.Id
    ];
    entreprise.Ville__c = 'ville';
    entreprise.Adresse_Entreprise__c = 'adresse';
    entreprise.Code_Postal__c = 'CP';
    update entreprise;
    Convsta_Conditions_Contractuelles__c conditions = [
      SELECT Date_Debut__c, Date_Fin__c, Remuneration_Mensuelle__c
      FROM Convsta_Conditions_Contractuelles__c
      WHERE MD_Demande__c = :demande.Id
      LIMIT 1
    ];
    conditions.Date_Debut__c = Date.today().addDays(30);
    conditions.Date_Fin__c = Date.today().addDays(100);
    conditions.Remuneration_Mensuelle__c = 666.66;
    update conditions;

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
  @isTest
  static void testGetStage() {
    Case demande = [
      SELECT Id, Contact.convsta_code_etudiant_EM__c
      FROM Case
      LIMIT 1
    ];
    Test.startTest();
    Case result = Convsta_WS_Helper_Cursus.getStage(demande.Id);
    System.assertEquals(demande.Id, result.Id);
    Test.stopTest();
  }

  @isTest
  static void testCheckStrictTotalData() {
    Case demande = [
      SELECT
        Id,
        RecordType.DeveloperName,
        Convsta_DateStart__c,
        Convsta_DateEnd__c,
        Convsta_Type_de_demande__c,
        Convsta_TypeContrat__c,
        Origin,
        Date_Reception_Convention__c,
        Convsta_Adresse_du_lieu_du_stage__c,
        Convsta_Langue__c,
        Convsta_Entreprise__r.Name,
        Convsta_Entreprise__r.ID_FEG__c,
        Convsta_Entreprise__r.Code_Postal__c,
        Convsta_Entreprise__r.Adresse_Ville__c,
        Convsta_Entreprise__r.CodePays__c,
        Convsta_Entreprise__r.Adresse_Rue__c,
        Responsable_administratif_entreprise__r.Name,
        Responsable_administratif_entreprise__r.FirstName,
        Responsable_administratif_entreprise__r.LastName,
        Responsable_administratif_entreprise__r.Fonctions__c,
        Convsta_Responsable_Pedagogique__r.FirstName,
        Convsta_Responsable_Pedagogique__r.LastName,
        Convsta_Responsable_Pedagogique__r.Email,
        Convsta_Tuteur__r.FirstName,
        Convsta_Tuteur__r.LastName,
        Convsta_Tuteur__r.Fonctions__c,
        Convsta_Tuteur__r.Salutation,
        Convsta_Tuteur__r.Email_Professionnel__c,
        Contact.convsta_code_etudiant_EM__c,
        Contact.Email_Professionnel__c
      FROM Case
      LIMIT 1
    ];

    Test.startTest();
    String resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals(true, result.allDataOK, result.message);

    Test.setMock(
      HttpCalloutMock.class,
      new Convsta_WSHelperCursus_CalloutMockImpl()
    );
    Convsta_Entreprise__c entreprise = [
      SELECT
        Id,
        Adresse_Entreprise__c,
        Convsta_Adresse_du_lieu_du_stage__c,
        Code_Postal__c,
        Convsta_Code_postal_du_lieu_du_stage__c,
        Ville__c,
        Convsta_Ville_du_lieu_du_stage__c,
        Pays2__c,
        Convsta_Pays_du_lieu_de_ma_mission__c
      FROM Convsta_Entreprise__c
      WHERE MD_Demande__c = :demande.Id
      LIMIT 1
    ];
    entreprise.Code_Postal__c = null;
    entreprise.Convsta_Code_postal_du_lieu_du_stage__c = null;
    update entreprise;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assert(
      result.message.contains('erreur Addresse Code Postale;'),
      'entreprise : ' + entreprise.Code_Postal__c
    );
    System.assertEquals(
      false,
      result.entrepriseOK,
      'entreprise should not be ok'
    );

    entreprise.Code_Postal__c = '1234';
    entreprise.Ville__c = null;
    entreprise.Convsta_Ville_du_lieu_du_stage__c = null;
    update entreprise;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur Addresse Ville;', result.message);
    System.assertEquals(false, result.entrepriseOK);

    entreprise.Ville__c = 'VILLEURBANNE';
    entreprise.Convsta_Adresse_du_lieu_du_stage__c = null;
    entreprise.Adresse_Entreprise__c = null;
    update entreprise;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur Addresse Rue;', result.message);
    System.assertEquals(false, result.entrepriseOK);

    entreprise.Adresse_Entreprise__c = 'STALINGRAD';
    update entreprise;
    Convsta_Conditions_Contractuelles__c conditions = [
      SELECT Id, Remuneration_Mensuelle__c
      FROM Convsta_Conditions_Contractuelles__c
      WHERE MD_Demande__c = :demande.Id
    ];
    conditions.Remuneration_Mensuelle__c = null;
    update conditions;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assert(
      result.message.contains(
        'erreur conditions Contractuelle : problème de rémunération'
      ),
      'problème de rémunération non détecté'
    );
    System.assertEquals(false, result.contratOK);

    conditions.Remuneration_Mensuelle__c = 666.66;
    update conditions;
    Convsta_Mission__c missions = [
      SELECT Id, Convsta_Description_de_la_mission__c, Titre_Mission__c
      FROM Convsta_Mission__c
      WHERE MD_Demande__c = :demande.Id
    ];
    missions.Convsta_Description_de_la_mission__c = null;
    update missions;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assert(
      result.message.contains('erreur Mission;'),
      'empty mission not detected'
    );
    System.assertEquals(false, result.missionOK);

    missions.Convsta_Description_de_la_mission__c = 'Description test';
    update missions;
    User respPedago = demande.Convsta_Responsable_Pedagogique__r;
    demande.Convsta_Responsable_Pedagogique__r = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assert(
      result.message.contains('erreur prénom pédago;'),
      'missing data not detected repPeda.firstName'
    );
    System.assertEquals(false, result.respPedagoOK);

    System.assert(
      result.message.contains('erreur nom pédago;'),
      'missing data not detected repPeda.lastName'
    );
    System.assertEquals(false, result.respPedagoOK);

    demande.Convsta_Responsable_Pedagogique__r = respPedago;
    Contact respAdmEntr = demande.Responsable_administratif_entreprise__r;
    demande.Responsable_administratif_entreprise__r = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assert(
      result.message.contains('erreur prénom responsable;'),
      'missing company administrative firstname'
    );
    System.assert(
      result.message.contains('erreur nom responsable;'),
      'missing company administrative lastname'
    );
    System.assert(
      result.message.contains('erreur fonction responsable;'),
      'missing company administrative function'
    );
    System.assertEquals(
      false,
      result.respEntrOK,
      'respEntreprice should not be ok'
    );

    demande.Responsable_administratif_entreprise__r = respAdmEntr;
    demande.Responsable_administratif_entreprise__r.Fonctions__c = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals(
      false,
      result.respEntrOK,
      'respEntreprice should not be ok'
    );
    System.assert(
      result.message.contains('erreur fonction responsable;'),
      'missing company function not detected'
    );

    demande.Responsable_administratif_entreprise__r.Fonctions__c = 'Attaché de Direction';
    demande.Convsta_Tuteur__r.FirstName = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur prénom tuteur;', result.message);
    System.assertEquals(false, result.tuteurEntrOK);

    demande.Convsta_Tuteur__r.FirstName = 'firstnameTest';
    demande.Convsta_Tuteur__r.LastName = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur nom tuteur;', result.message);
    System.assertEquals(false, result.tuteurEntrOK);

    demande.Convsta_Tuteur__r.LastName = 'lastnameTest';
    demande.Convsta_Tuteur__r.Fonctions__c = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur fonction tuteur;', result.message);
    System.assertEquals(false, result.tuteurEntrOK);

    demande.Convsta_Tuteur__r.Fonctions__c = 'Cadre Technique';
    demande.Convsta_Tuteur__r.Salutation = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur civilité tuteur;', result.message);
    System.assertEquals(false, result.tuteurEntrOK);

    demande.Convsta_Tuteur__r.Salutation = 'M.';
    demande.Convsta_TypeContrat__c = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur type contrat;', result.message);
    System.assertEquals(false, result.stageOK);

    demande.Convsta_TypeContrat__c = 'Convention de stage de l ecole';
    demande.Convsta_DateStart__c = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur Date début;', result.message);
    System.assertEquals(false, result.stageOK);

    Date startDate = Date.today();
    demande.Convsta_DateStart__c = startDate;
    demande.Convsta_DateEnd__c = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur date fin;', result.message);
    System.assertEquals(false, result.stageOK);

    demande.Convsta_DateEnd__c = startDate.addDays(20);
    demande.Origin = null;
    resultStr = Convsta_WS_Helper_Cursus.checkStrictTotalData(demande);
    result = (Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure) JSON.deserialize(
      resultStr,
      Convsta_WS_Helper_Cursus.checkStrictTotalDataStructure.class
    );
    System.assertEquals('erreur Origine;', result.message);
    System.assertEquals(false, result.stageOK);

    Test.stopTest();
  }

  @isTest
  // this method tests wsGetCodePhase and wsPostCodePhase of Helper WS Cursus class
  static void testPostPhase() {
    Case demande = [
      SELECT
        Id,
        RecordType.DeveloperName,
        Convsta_DateStart__c,
        Convsta_DateEnd__c,
        Convsta_Type_de_demande__c,
        Convsta_TypeContrat__c,
        Origin,
        Date_Reception_Convention__c,
        Convsta_Nouvelle_adresse_lieu_de_stage__c,
        Convsta_Adresse_du_lieu_du_stage__c,
        Convsta_Langue__c,
        Convsta_Entreprise__r.Name,
        Convsta_Entreprise__r.ID_FEG__c,
        Convsta_Entreprise__r.Code_Postal__c,
        Convsta_Entreprise__r.Adresse_Ville__c,
        Convsta_Entreprise__r.CodePays__c,
        Convsta_Entreprise__r.Adresse_Rue__c,
        Responsable_administratif_entreprise__r.Name,
        Responsable_administratif_entreprise__r.FirstName,
        Responsable_administratif_entreprise__r.LastName,
        Responsable_administratif_entreprise__r.Fonctions__c,
        Convsta_Responsable_Pedagogique__r.FirstName,
        Convsta_Responsable_Pedagogique__r.LastName,
        Convsta_Responsable_Pedagogique__r.Email,
        Convsta_Tuteur__r.FirstName,
        Convsta_Tuteur__r.AccountId,
        Convsta_Tuteur__r.LastName,
        Convsta_Tuteur__r.Fonctions__c,
        Convsta_Tuteur__r.Salutation,
        Convsta_Tuteur__r.Email_Professionnel__c,
        Convsta_Tuteur__r.email,
        Convsta_Tuteur__r.Phone,
        Contact.convsta_code_etudiant_EM__c,
        Contact.Email_Professionnel__c,
        Convsta_Referent_pedagogique__r.lastname,
        Convsta_Referent_pedagogique__r.Email
      FROM Case
      LIMIT 1
    ];

    Convsta_Conditions_Contractuelles__c conditions = [
      SELECT Date_Debut__c, Date_Fin__c, Remuneration_Mensuelle__c
      FROM Convsta_Conditions_Contractuelles__c
      WHERE MD_Demande__c = :demande.Id
      LIMIT 1
    ];

    Test.setMock(
      HttpCalloutMock.class,
      new Convsta_WSHelperCursus_CalloutMockImpl()
    );

    Test.startTest();
    String res = Convsta_WS_Helper_Cursus.wsPostPhase(demande, null);
    System.assertEquals('', res, 'result should be empty');
    Test.stopTest();
  }

  @isTest
  static void testUpdateStageCursusDoneBolean() {
    Case demande = [SELECT Id FROM Case LIMIT 1];
    Test.startTest();
    Convsta_WS_Helper_Cursus.updateStageCursusDoneBolean(demande.Id);
    Case demandeModified = [
      SELECT Id, Convsta_Phase_de_stage_dans_Cursus__c
      FROM Case
      WHERE Id = :demande.Id
    ];
    System.assertEquals(
      true,
      demandeModified.Convsta_Phase_de_stage_dans_Cursus__c
    );
    Test.stopTest();
  }

  @isTest
  static void testCheckStrictEvaluationData() {
    Convsta_Evaluation__c eval = [
      SELECT
        Id
      FROM Convsta_Evaluation__c
      LIMIT 1
    ];

    Test.setMock(
      HttpCalloutMock.class,
      new Convsta_WSHelperCursus_CalloutMockImpl()
    );
    Test.startTest();
    String returnStructStr = Convsta_WS_Helper_Cursus.checkStrictEvaluationData(
      eval.Id
    );
    Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure returnStruct = (Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure) JSON.deserialize(
      returnStructStr,
      Convsta_WS_Helper_Cursus.checkStrictEvaluationDataStructure.class
    );
    System.assertEquals(true, returnStruct.allDataOK);
    Test.stopTest();
  }
}