@isTest 
      private class TestAutoConvertLeads{
      static testMethod void createnewlead() {
          
      Contact ct = TestDataFactory.getContact();
      ct.Adresse_Email_Personnelle__c = 'mailtest@test.com';
	  ct.Nature_du_premier_contact__c ='Site internet';  
      insert ct;
          
      Account acct = TestDataFactory.getAccount();
      acct.Name = 'Sans organisation connue';
      insert acct;
      
      Id leadtype = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Formation initiale').getRecordTypeId();
          
      Lead leadToCreate =new Lead();
      List<id> Ids= New List<Id>();
      leadToCreate.RecordtypeId= leadtype;
      leadToCreate.LastName ='Test';
      leadToCreate.Company='Salesforce';
      leadToCreate.LeadSource='Formation continue courte';
      leadToCreate.Rating='';
      leadToCreate.Status='';
      leadToCreate.Adresse_e_mail__c='mailtest@test.com';
      insert leadToCreate; 
      
      Ids.add(leadToCreate.id);
          
           Test.startTest(); 
      AutoConvertLeads.leadAssign(Ids);
          Test.stopTest();
      
          Lead converted = [SELECT Id, OwnerId, Status FROM Lead WHERE Id = :Ids];
    	System.assertEquals('Qualifié', converted.Status);
   }
}