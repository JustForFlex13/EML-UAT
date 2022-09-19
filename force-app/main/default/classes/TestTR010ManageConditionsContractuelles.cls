@isTest
public class TestTR010ManageConditionsContractuelles {
    @isTest 
    static void changeTableTest(){
        Date d1 = Date.newInstance(2021, 01, 01);
        Date d2 = Date.newInstance(2021, 03, 01);
        Date d3 = Date.newInstance(2021, 08, 01);
        Date d4 = Date.newInstance(2021, 10, 01);

        CONVSTA_Table_Regles_Experience_Pro__c table1 = new CONVSTA_Table_Regles_Experience_Pro__c();
        table1.Name =                    'TestAnneeEncours';
        table1.Programme__c =            'E2MS';
        table1.Code_etude__c =           'E2MS2';
        table1.Code_etude_Annee_suivante__c =  'E2MS3';
        table1.Ann_e_suivante__c =       false;
        table1.Annee_application__c  =   '2019';
        table1.Accessible_aux_etudiants__c = true;
        table1.Date_Demarrage_Au_Plus_Tot__c = Date.newInstance(2020, 7, 1);
        table1.Date_Maximum_Fin_Stage__c = Date.newInstance(2021, 7, 1);
        insert table1;

        CONVSTA_Table_Regles_Experience_Pro__c table2 = new CONVSTA_Table_Regles_Experience_Pro__c();
        table2.Name =                    'TestAnneeSuivante';
        table2.Programme__c =            'E2MS';
        table2.Code_etude__c =           'E2MS3';
        table2.Code_etude_Annee_suivante__c =  'E2MS4';
        table2.Ann_e_suivante__c =       true;
        table2.Annee_application__c  =   '2019';
        table2.Accessible_aux_etudiants__c = true;
        table2.Date_Demarrage_Au_Plus_Tot__c = Date.newInstance(2021, 07, 01);
        table2.Date_Maximum_Fin_Stage__c = Date.newInstance(2022, 07, 01);
        insert table2;
        
        Contact etu1 = TestDataFactory.getContact();
        insert etu1;
        Contact etu2 = TestDataFactory.getContact();
        insert etu2;

        Case demande1 = TestObjectFactory.createCase(etu1);
        demande1.Code_Ann_e_Etudiant__c = 'E2MS2';
        demande1.Convsta_Type_de_demande__c = 'Stage';
        insert demande1;
        Convsta_Conditions_Contractuelles__c ccc1 = new Convsta_Conditions_Contractuelles__c();
        ccc1.MD_Demande__c = demande1.Id;
        ccc1.Date_Debut__c = d1;
        ccc1.Date_Fin__c = d2;
        insert ccc1;
        
        Case demande2 = TestObjectFactory.createCase(etu2);
        demande2.Code_Ann_e_Etudiant__c = 'E2MS2';
        demande2.Convsta_Type_de_demande__c = 'Stage';
        insert demande2;
		Convsta_Conditions_Contractuelles__c ccc2 = new Convsta_Conditions_Contractuelles__c();
        ccc2.MD_Demande__c = demande2.Id;
        ccc2.Date_Debut__c = d3;
        ccc2.Date_Fin__c = d4;
        insert ccc2;

        Test.startTest();
        TR010ManageConditionsContractuelles.changeTable(ccc1);
        TR010ManageConditionsContractuelles.changeTable(ccc2);
        Test.stopTest();

        Case dmd1 = [SELECT Id, Convsta_Table_des_Regles_Experience_Pro__c FROM Case WHERE Id =: ccc1.MD_Demande__c LIMIT 1];
        System.assertEquals(table1.Id, dmd1.Convsta_Table_des_Regles_Experience_Pro__c);
		Case dmd2 = [SELECT Id, Convsta_Table_des_Regles_Experience_Pro__c FROM Case WHERE Id =: ccc2.MD_Demande__c LIMIT 1];
        System.assertEquals(table2.Id, dmd2.Convsta_Table_des_Regles_Experience_Pro__c);
    }
}