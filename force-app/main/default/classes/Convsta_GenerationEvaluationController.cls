public class Convsta_GenerationEvaluationController {
    public Case                                     demande             {get;set;}
    public Boolean                                  isPreviewMode       {get;set;}
    public Convsta_Evaluation__c     				eval       		    {get;set;}
    public List<Convsta_Competence__c>              lCompEarlyMaker     {get;set;}
    public List<Convsta_Competence__c>              lCompComportem      {get;set;}
    public List<Convsta_Competence__c>              lCompMetier         {get;set;}

    public string getOutputClass (){
        return isPreviewMode ?'font-weight:bold;background-color: #ffff00;':'font-weight:bold;background-color: transparent;';
    }
    
    public Convsta_GenerationEvaluationController(){
        String evalId = ApexPages.currentPage().getParameters().get('evalId')!= null ? ApexPages.currentPage().getParameters().get('evalId') : ApexPages.currentPage().getParameters().get('id');
        isPreviewMode = ApexPages.currentPage().getParameters().get('previewMode')==null?false:true; 
	system.debug(ApexPages.currentPage().getParameters()+' '+ApexPages.currentPage().getUrl());        
        eval =			[	SELECT  Id,
                                    Demande__c,
                         			Demande__r.Convsta_Entreprise_Name__c,
                         			Etudiant__r.Name, 
                                    Etudiant__r.FirstName,
                                    Famille_competences_metier__c,
                                    Circonstances_du_stage__c,
                                    Note_globale__c,
                                    Commentaire_global__c
                        	FROM	Convsta_Evaluation__c
                        	WHERE 	ID =:evalId LIMIT 1];
        
        demande=        [   SELECT  Id, 
                                    Convsta_Table_des_Regles_Experience_Pro__r.Afficher_logo_Paul_Bocuse__c, 
                                    Convsta_DateStart__c, 
                                    Convsta_DateEnd__c
                            FROM    Case 
                            WHERE   Id=:eval.Demande__c LIMIT 1];

        lCompEarlyMaker=[   SELECT  Id,
                                    Label_fr__c,
                                    Rating_displayed__c
                            FROM    Convsta_Competence__c
                            WHERE   Evaluation__c =:evalId
                            AND     type__c = '1EarlyMaker'];

        lCompComportem= [   SELECT  Id,
                                    Label_fr__c,
                                    Rating_displayed__c
                            FROM    Convsta_Competence__c
                            WHERE   Evaluation__c =:evalId
                            AND     type__c = '2Comportement'];

        lCompMetier=    [   SELECT  Id,
                                    Label_fr__c,
                                    Rating_displayed__c
                            FROM    Convsta_Competence__c
                            WHERE   Evaluation__c =:evalId
                            AND     type__c = '3Métier'
                            AND     Famille_metiers__c =:eval.Famille_competences_metier__c];
    }
}