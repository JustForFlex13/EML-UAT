public with sharing class Convsta_GenererDemandeDEvaluation_CX {
    private final Convsta_Evaluation__c eval;
    public Boolean isPreviewMode {get;set;}
    
    // Constructor used to get the Evaluation record
    public Convsta_GenererDemandeDEvaluation_CX(ApexPages.StandardController stdController) {
        this.eval = (Convsta_Evaluation__c) stdController.getRecord();
    }

    public Case demande {
        get {
            return [SELECT Id,
                    Convsta_Langue__c
                     FROM Case
                     WHERE Case.Convsta_Evaluation__c = :eval.Id
                     LIMIT 1];
        }
        set;
    }
    public Convsta_Mission__c mission {
        get {
            return [SELECT Id,
                    Precision_et_rigueur_au_travail__c,
                    Conceptualiser_et_modeliser__c,
                    Qualifier_et_identifier_l_information__c,
                    Demontrer_un_comportement_assertif__c,
                    Elaborer_un_diagnostic__c,
                    Gerer_son_temps_et_les_priorites__c,
                    Mobiliser_differentes_sources__c,
                    Gerer_son_stress__c,
                    Competences_categorie_2__c
                     FROM Convsta_Mission__c
                     WHERE Convsta_Mission__c.MD_Demande__c = :demande.Id];
        }
        set;
    }
    
    //public string getOutputClass (){
       // return isPreviewMode ?'font-weight:bold;background-color: #ffff00;':'font-weight:bold;background-color: transparent;';
  //  }
    
     public List<Convsta_Competences__mdt> lCompEarlyMaker {
        get {
            return [SELECT  Name__c,
                    Name_En__c,
                    Type__c,
                    Famille_metier__c,
                    Order__c
                    FROM    Convsta_Competences__mdt
                    WHERE   Type__c = '1EarlyMaker'
                    ORDER BY Order__c
                    ];
        }
        set;
    }
    
   public List<Convsta_Competences__mdt> lCompComportem {
        get { 
                List<Convsta_Competences__mdt> listComp = [SELECT  Id,
                        Name__c,
                        Name_En__c,
                        Type__c,
                        Famille_metier__c,
                        Order__c
                        FROM    Convsta_Competences__mdt
                        WHERE   Type__c = '2Comportement'
                        ORDER BY Order__c
                    ];

                Map<Convsta_Competences__mdt, Boolean> compCochees = new Map<Convsta_Competences__mdt, Boolean>();
                    compCochees.put(listComp.get(0), mission.Conceptualiser_et_modeliser__c);
                    compCochees.put(listComp.get(1), mission.Demontrer_un_comportement_assertif__c);
                    compCochees.put(listComp.get(2), mission.Elaborer_un_diagnostic__c);
                    compCochees.put(listComp.get(3), mission.Precision_et_rigueur_au_travail__c);
                    compCochees.put(listComp.get(4), mission.Gerer_son_stress__c);
                    compCochees.put(listComp.get(5), mission.Gerer_son_temps_et_les_priorites__c);
                    compCochees.put(listComp.get(6), mission.Mobiliser_differentes_sources__c);
                    compCochees.put(listComp.get(7), mission.Qualifier_et_identifier_l_information__c);
            		System.debug(compCochees.size());

                List<Convsta_Competences__mdt> listChecked = new List<Convsta_Competences__mdt>();

                for (Convsta_Competences__mdt competence : compCochees.keySet()) {
                    System.debug(competence);
                    Boolean coche = compCochees.get(competence);
                    if (coche == TRUE) {
                        listChecked.add(competence);
                    }
                }
                return listChecked;
        }
        set;
    }
    
      public List<Convsta_Competences__mdt> lCompMetier {
        get {
            return [SELECT  Name__c,
                    Name_En__c,
                    Type__c,
                    Famille_metier__c,
                    Order__c
                    FROM  Convsta_Competences__mdt
                    WHERE Type__c = '3Métier'
                    AND  Famille_metier__c =:eval.Famille_competences_metier__c
                    ORDER BY Order__c
                    ];
        }
        set;
    }  
}