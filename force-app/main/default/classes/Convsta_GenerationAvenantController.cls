public class Convsta_GenerationAvenantController {
    public Case                                     avenant         {get;set;}
    public Case                                     demande         {get;set;}
    public Convsta_Informations_Personnelles__c     infoPerso       {get;set;}
    public Convsta_Entreprise__c                    monEntreprise   {get;set;}
    public Date                                     dateDuJour      {get;set;}
    public Boolean                                  isPreviewMode     {get;set;}
    public string getOutputClass (){
        return isPreviewMode ?'background-color: #ffff00;':'background-color: transparent;';
    }

    public Convsta_GenerationAvenantController(){
        String caseId = ApexPages.currentPage().getParameters().get('caseId');
        isPreviewMode = ApexPages.currentPage().getParameters().get('previewMode')==null?false:true;
        
        dateDuJour =    System.Date.today();
        
        avenant=        [   SELECT  ParentId, Convsta_Avenant__c
                            FROM    Case 
                            WHERE   id=:caseId LIMIT 1];
        demande=        [   SELECT  CaseNumber,Responsable_administratif_entreprise__r.Name, Convsta_Langue__c
                            FROM    Case 
                            WHERE   id=:avenant.ParentId LIMIT 1];

        infoPerso=      [   SELECT  Nom__c, Prenom__c 
                            FROM    Convsta_Informations_Personnelles__c
                            WHERE   MD_Demande__c=:avenant.ParentId LIMIT 1];

        monEntreprise=  [   SELECT  Nom_Entreprise__c
                            FROM    Convsta_Entreprise__c 
                            WHERE   MD_Demande__c=:avenant.ParentId LIMIT 1];
    }
}