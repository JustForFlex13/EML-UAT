@isTest
private class CTR001CampaignManageMembersAddTabTest{

 static testMethod void myUnitTest() {

  // This code runs as the system user
  Profile p = [select id from profile where name='Administrateur système' or name='System Administrator' Limit 1];
  User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
  EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US',
  LocaleSidKey='fr_FR_EURO', ProfileId = p.Id,
  TimeZoneSidKey='Europe/Paris', UserName='standarduser@arpege-emlyon--dev2.com');

  System.runAs(u) {

   PageReference newpage = Page.VF001CampaignManageMembersAddTab;

   Campaign c = new Campaign();
   c.Name = 'test';
   insert c;
   CampaignMember m = new CampaignMember();
   CampaignMember m2 = new CampaignMember();
   Contact co = new Contact();
   co.LastName = 'test';
   co.FirstName = 'test';
   co.salutation = 'M.';
   insert co;
   Lead l = new Lead();
   Id leadtype = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Formation initiale').getRecordTypeId();
   l.RecordtypeId= leadtype;
   l.LastName = 'testLead';
   l.FirstName = 'testLead';
   l.Adresse_e_mail__c = 'test@testCTR001.com';
   insert l;
   m.contactId = co.id;
   m.campaignId = c.id;
   m2.leadId = l.id;
   m2.campaignId = c.id;
   insert m;
   insert m2;

   (newpage.getParameters()).put('campaignid',c.id);
   Test.setCurrentPage (newpage);
   CTR001CampaignManageMembersAddTab ctrl = new CTR001CampaignManageMembersAddTab(new ApexPages.StandardController(c));
   ctrl.setQueryCondition_1('');
   ctrl.setQueryCondition_2('');
   ctrl.setQueryCondition_3('');
   ctrl.setQueryCondition_4('');
   ctrl.setOperator_1('=');
   ctrl.setOperator_2('=');
   ctrl.setOperator_3('=');
   ctrl.setOperator_4('=');
   ctrl.setType('Pistes');
   ctrl.initialiser();
   ctrl.setType('Contacts');
   ctrl.initialiser();
   ctrl.initialisertab2();
   ctrl.populateMyMembers();
   ctrl.populateMyMembersExist();
   ctrl.populateMyMembersExistRapport();
   ctrl.populateCampaignMemberStatus();
   ctrl.selectDeselectAll();
   ctrl.effacerFiltres();


   ctrl.setType('Pistes');
   ctrl.setOperator_1('like_commence_par');
   ctrl.setQueryCondition_1('test');
   ctrl.rechercher();
   ctrl.setCheckedAll(true);
   ctrl.addMembersToCampaing();
   ctrl.populateMyMembers();

   ctrl.setType('Contacts');
   ctrl.setOperator_1('like_commence_par');
   ctrl.setQueryCondition_1('test');
   ctrl.rechercher();
   ctrl.setCheckedAll(true);
   ctrl.addMembersToCampaing();

   ctrl.addMembersToCampaignRapport();

   ctrl.populateMyMembers();
   ctrl.populateMyMembersExist();
   ctrl.populateMyMembersExistRapport();

   Contact co2 = new Contact();
   co2.LastName = 'test2for';
   co2.FirstName = 'test2for';
   co2.Email = 'testing@testfor.com';
   co2.salutation = 'M.';
   insert co2;

   Lead l2 = new Lead();
   l2.RecordtypeId= leadtype;
   l2.LastName = 'testLead2';
   l2.FirstName = 'testLead2';
   l2.Adresse_e_mail__c = 'test2@test.com';
   insert l2;

   ctrl.setType('Pistes');
   ctrl.setOperator_1('');
   ctrl.setQueryCondition_1('test');
   ctrl.rechercher();
   ctrl.setCheckedAll(true);
   ctrl.addMembersToCampaing();

   ctrl.setType('Pistes');
   ctrl.setOperator_1('like_contient');
   ctrl.setOperator_2('like_contient');
   ctrl.setOperator_3('like_contient');
   ctrl.setOperator_4('like_contient');
   ctrl.setQueryCondition_1('test');
   ctrl.rechercher();
   ctrl.setCheckedAll(true);
   ctrl.addMembersToCampaing();

   ctrl.setType('Contacts');
   ctrl.setOperator_1('like_ne_contient_pas');
   ctrl.setOperator_2('like_ne_contient_pas');
   ctrl.setOperator_3('like_ne_contient_pas');
   ctrl.setOperator_4('like_ne_contient_pas');
   ctrl.setQueryCondition_1('test');
   ctrl.rechercher();
   ctrl.setCheckedAll(true);
   ctrl.addMembersToCampaing();

   ctrl.setType('Contacts');
   ctrl.setOperator_1('like_commence_par');
   ctrl.setOperator_2('like_commence_par');
   ctrl.setOperator_3('like_commence_par');
   ctrl.setOperator_4('like_commence_par');
   ctrl.setQueryCondition_1('test');
   ctrl.rechercher();
   ctrl.setCheckedAll(true);
   ctrl.addMembersToCampaing();

   ctrl.addMembersToCampaignRapport();

   ctrl.getLeads();
   ctrl.getContacts();
   ctrl.getLeadsFields();
   ctrl.getLeadsField_1();
   ctrl.getLeadsField_2();
   ctrl.getLeadsField_3();
   ctrl.getLeadsField_4();
   ctrl.getOperators();
   ctrl.getOperator_1();
   ctrl.getOperator_2();
   ctrl.getOperator_3();
   ctrl.getOperator_4();
   ctrl.getMembers();
   ctrl.getMyMembers();
   ctrl.getCampaignMemberStatus();
   ctrl.getCampaignMemberStatusSelected();
   ctrl.getCampaignMemberStatusSelectedRapport();
   ctrl.getType();
   ctrl.getVisible();
   ctrl.getSelectedTab();
   ctrl.getEmail1();
   ctrl.getEmail2();
   ctrl.getEmail1Rapport();
   ctrl.getEmail2Rapport();
   ctrl.getCampaignId();
   ctrl.getCampaignName();
   ctrl.getQueryCondition_1();
   ctrl.getQueryCondition_2();
   ctrl.getQueryCondition_3();
   ctrl.getQueryCondition_4();
   ctrl.getQuery();
   ctrl.getIdToDelete();
   ctrl.getCheckedAll();
   ctrl.getCheckedAllExist();
   ctrl.getCheckedAllExistRapport();

   ctrl.selectedItems = ',';
   ctrl.selectItems();
   String selectedItemsJson = ctrl.selectedItemsJson;
   system.assert(selectedItemsJson!=null);

   ctrl.setLeadsField_1('');
   ctrl.setLeadsField_2('');
   ctrl.setLeadsField_3('');
   ctrl.setLeadsField_4('');
   ctrl.setCampaignMemberStatusSelected('');
   ctrl.setCampaignMemberStatusSelectedRapport('');
   ctrl.setVisible(true);
   ctrl.setSelectedTab('tab1');
   ctrl.setEmail1('');
   ctrl.setEmail1Rapport('p_email1Rapport');
   ctrl.setEmail2('');
   ctrl.setEmail2Rapport('');
   ctrl.setCampaignId('p_campaignId');
   ctrl.setCampaignName('p_campaignName');
   ctrl.setIdToDelete('p_idToDelete');
   ctrl.setCheckedAll(true);
   ctrl.setCheckedAllExist(true);
   ctrl.setCheckedAllExistRapport(true);
   ctrl.getRecordsTab2();
   ctrl.getRecordsTab3();
   ctrl.nextPageTab2();
   ctrl.previousPageTab2();
   ctrl.previousPageTab3();
   ctrl.selectAllMembersTab3();
   ctrl.selectDeselectAll();
   ctrl.nextPageTab2();
   ctrl.nextPageTab3();
   ctrl.getNbSelected();



   CTR001CampaignManageMembersAddTab.MyMember mm = new CTR001CampaignManageMembersAddTab.MyMember();
   mm.getChecked();
   mm.getCompany();
   mm.getEmail();
   mm.getFirstName();
   mm.getLastName();
   mm.getStatus();
   mm.getTitle();
   mm.setChecked(true);
  }
 }
}