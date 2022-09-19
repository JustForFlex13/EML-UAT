public without sharing class TR010ManageConditionsContractuelles {

        public static void changeTable (Convsta_Conditions_Contractuelles__c ccc){
            Date datedebut = ccc.Date_Debut__c;
            Date datefin = ccc.Date_Fin__c;
            Case demande = [SELECT Id, Convsta_Table_des_Regles_Experience_Pro__c, Code_Ann_e_Etudiant__c, Convsta_Type_de_demande__c FROM Case WHERE Id =: ccc.MD_Demande__c LIMIT 1];
            String codeAnnee = demande.Code_Ann_e_Etudiant__c;

    // Récupération des tdr pour l'année en cours et l'année suivante à partir du code année du contact Etudiant
          try{
            if(demande.Convsta_Type_de_demande__c != 'Validation_experience_anterieure'){
               CONVSTA_Table_Regles_Experience_Pro__c t1 = [
           SELECT
            Id,
            Date_Demarrage_Au_Plus_Tot__c,
            Date_De_Demarrage_Au_Plus_Tard__c,
            Date_Maximum_Fin_Stage__c,
            Code_etude__c,
            Code_etude_Annee_suivante__c
          FROM CONVSTA_Table_Regles_Experience_Pro__c
          WHERE Code_etude__c = :codeAnnee AND Ann_e_suivante__c = false AND Accessible_aux_etudiants__c = true
        ];
    
        // Attribution en fonction de la date de début de Conditions Contractuelles
        List<CONVSTA_Table_Regles_Experience_Pro__c> tableListe = new List<CONVSTA_Table_Regles_Experience_Pro__c>();
         if (t1!=null){
             if(
                ((datedebut >= t1.Date_Demarrage_Au_Plus_Tot__c && t1.Date_De_Demarrage_Au_Plus_Tard__c == null)
            	|| ( t1.Date_De_Demarrage_Au_Plus_Tard__c >= datedebut && datedebut >= t1.Date_Demarrage_Au_Plus_Tot__c))
              	&&((t1.Date_Maximum_Fin_Stage__c == null)||(datefin <= t1.Date_Maximum_Fin_Stage__c))
              	){
             	 tableListe.add(t1);
        	 	 }
              else {
                String codesuivant = t1.Code_etude_Annee_suivante__c;
                if (codesuivant != null) {
        		CONVSTA_Table_Regles_Experience_Pro__c t2 = [
            	SELECT
            	Id,
            	Date_Demarrage_Au_Plus_Tot__c,
            	Date_De_Demarrage_Au_Plus_Tard__c,
                Date_Maximum_Fin_Stage__c,
            	Code_etude__c,
            	Code_etude_Annee_suivante__c
          		FROM CONVSTA_Table_Regles_Experience_Pro__c
          		WHERE Code_etude__c =: codesuivant AND Ann_e_suivante__c = true AND Accessible_aux_etudiants__c = true
        		];
                  if (t2 != null) {
                    if(
                    ((datedebut >= t2.Date_Demarrage_Au_Plus_Tot__c && t2.Date_De_Demarrage_Au_Plus_Tard__c == null)
                		|| ( t2.Date_De_Demarrage_Au_Plus_Tard__c >= datedebut && datedebut >= t2.Date_Demarrage_Au_Plus_Tot__c))
                    &&((t2.Date_Maximum_Fin_Stage__c == null)||(datefin <= t2.Date_Maximum_Fin_Stage__c))
                    ){
                 	 tableListe.add(t2);
                  	 }
                  }
                }
              }
         	}
        
        // Si aucune table de règles ne correspond aux nouvelles dates
        if (tableListe.Size() == 0){
              ccc.addError('Pas de correspondance accessible pour les dates demandées dans les tables de règles, merci de contacter internship@em-lyon.com');
        }else{
          demande.Convsta_Table_des_Regles_Experience_Pro__c = tableListe[0].Id;
          Database.update (demande);
            }
          }
          } catch (QueryException e){
            System.debug( e.getMessage() );
            ccc.addError('Pas de correspondance accessible pour les dates demandées dans les tables de règles, merci de contacter internship@em-lyon.com');
          }
    }
}