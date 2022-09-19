/*-------------------------------------------------------------------
-- - Purpose            : Used to search internship
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- 17/06/2019  T.CH  MODIS      1.0      Creation
--------------------------------------------------------------------*/
public without sharing class Convsta_Internship {
    @InvocableMethod
    public static void sendNewLink(List<Id> lEvalIds){
        Convsta_Evaluation__c evaluation = [SELECT Id, 
                                            Evaluateur__r.Email,
                                            Etudiant__r.Name,
                                            Lien_pour_evaluation__c 
                                            FROM Convsta_Evaluation__c WHERE ID =:lEvalIds[0] LIMIT 1];
        system.debug(evaluation); 
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {evaluation.Evaluateur__r.Email};
            mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('emlyon business school');
        mail.setSubject('Votre nouveau lien d\'évaluation de ' + evaluation.Etudiant__r.Name);
        mail.setHtmlBody('Bonjour,<br>Voici votre nouveau lien afin d\'évaluer l\'étudiant <b>' + evaluation.Etudiant__r.Name + '</b> :' + evaluation.Lien_pour_evaluation__c );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void createEval(List<Case> lCasesToEval){ //tested by BatchSchedule_CreateEval
        List<Convsta_Evaluation__c> lEvalsToCreate = new List<Convsta_Evaluation__c>();
        set<Id> studentIdSet = new set<Id>();
        for(Case demande :lCasesToEval){
            Convsta_Evaluation__c eval = new Convsta_Evaluation__c();
            Group queueCareerCenter = Convsta_Object_Helper.getCareerCenterQueue();
            eval.OwnerId 			= queueCareerCenter.Id;
            eval.Cle_cryptee__c 	= EncodingUtil.base64Encode(Crypto.generateDigest('SHA-512', Blob.valueOf(demande.caseNumber+String.valueOf(DateTime.now()))))
                						.replace('+','')
                						.replace('=','')
                						.replace('/','');
            eval.DateEndStage__c	= demande.Convsta_DateEnd__c;
            eval.Demande__c			= demande.Id;
            eval.Name		 		= 'Eval '+ demande.caseNumber+ ' '+ demande.Contact.Name;
            eval.Etudiant__c = 		demande.Contact.Id;
            studentIdSet.add(demande.Contact.Id);
            eval.Evaluateur__c = 	demande.Convsta_Tuteur__c;
            eval.Responsable_Pedagogique__c = demande.Convsta_Responsable_Pedagogique__c;
            eval.Statut__c = 		'En attente d\'évaluation';
            eval.ValidFrom__c = 	demande.Convsta_DateEnd__c.addDays(-22);
            eval.ValidTo__c = 		demande.Convsta_DateEnd__c.addDays(14);
            lEvalsToCreate.add(eval);
        }
        if(lEvalsToCreate.size()>0){
            database.insert( lEvalsToCreate,false);
            
            List<Case> lCasesToUpdate = new List<Case>();
            List<Convsta_Evaluation__Share> lEvalSharesToInsert = new List<Convsta_Evaluation__Share>();
            
            for(Convsta_Evaluation__c eval :lEvalsToCreate){
                Case demande = new Case(Id= eval.Demande__c, Convsta_Evaluation__c=eval.Id);                            
                lCasesToUpdate.add(demande);
                if(eval.Responsable_Pedagogique__c!=null){
                    lEvalSharesToInsert.add(shareEvalWithRespPeda(eval));
                }
            }
            update lCasesToUpdate;
            database.insert( lEvalSharesToInsert,false);
        }
    }
    
    public static Convsta_Evaluation__Share shareEvalWithRespPeda(Convsta_Evaluation__c eval){
        Convsta_Evaluation__Share evalShr  = new Convsta_Evaluation__Share();
        
        evalShr.ParentId = eval.Id;
        evalShr.UserOrGroupId = eval.Responsable_Pedagogique__c;
        evalShr.AccessLevel = 'Read';
        evalShr.RowCause = Schema.Convsta_Evaluation__Share.RowCause.Manual;
        
        return evalShr;
    }    
    
    @AuraEnabled
    public static String isEvaluee(Id demandeId){
        Convsta_Evaluation__c eval = [SELECT Id, Statut__c, Lien_pour_evaluation__c 
                                      FROM Convsta_Evaluation__c 
                                      WHERE Demande__c = :demandeId 
                                      LIMIT 1];
        if(eval != null){
            if(eval.Statut__c == 'Évaluée'){
                system.debug('évaluée');
                return eval.Lien_pour_evaluation__c;
            }else{
                system.debug('pas évaluée');
                return '';
            }    
        }else{
            return '';
        }                
    }
    
    @AuraEnabled
    public static String getEvalDownloadLink(Id demandeId){
        Case demande = [SELECT Id, Convsta_Mon_evaluation__c 
                                      FROM Case 
                                      WHERE Id = :demandeId 
                                      LIMIT 1];
        if(demande != null){
            return demande.Convsta_Mon_evaluation__c; 
        }else{
            return '';
        }
    }
    
    public class SearchInput{
        @AuraEnabled
        public String country{get;set;}
        @AuraEnabled
        public String city{get;set;}
        @AuraEnabled
        public String programme{get;set;}
        @AuraEnabled
        public String naf{get;set;}
        @AuraEnabled
        public String companyName{get;set;}
        @AuraEnabled
        public String title{get;set;}
    }
    
    public class SearchOutput{
        @AuraEnabled
        public String companyName{get;set;}
        @AuraEnabled
        public String country{get;set;}
        @AuraEnabled
        public String city{get;set;}
        @AuraEnabled
        public String naf{get;set;}
        @AuraEnabled
        public String title{get;set;}
        @AuraEnabled
        public String startYear{get;set;}
        @AuraEnabled
        public String studentName{get;set;}
    }
    public class SearchReturn{
        @AuraEnabled
        public String state;
        @AuraEnabled
        public Integer size = 0;
        @AuraEnabled
        public List<SearchOutput> lOutputs = new List<SearchOutput>();
    }
    
    @AuraEnabled
    public static SearchReturn search(SearchInput input){
        SearchReturn resReturn = new SearchReturn();
        
        List<String> lCondition = new List<String>();
        if(!String.isBlank(input.country)){
            lCondition.add('MD_Demande__r.Convsta_Entreprise__r.CodePays__r.Name LIKE \'%' + input.country + '%\'');
        }
        if(!String.isBlank(input.city)){
            lCondition.add('MD_Demande__r.Convsta_Entreprise__r.Adresse_Ville__c LIKE \'%' + input.city + '%\'');
        }
        if(!String.isBlank(input.programme)){
            lCondition.add('MD_Demande__r.Convsta_Table_des_Regles_Experience_Pro__r.Programme__c = \''+ input.programme + '\'');
        }
        if(!String.isBlank(input.naf)){
            lCondition.add('MD_Demande__r.Convsta_Entreprise__r.Code_NAF__c = \'' + input.naf + '\'');
        }
        if(!String.isBlank(input.companyName)){
            lCondition.add('MD_Demande__r.Convsta_Entreprise__r.Name LIKE \'%' + input.companyName + '%\'');
        }
        if(!String.isBlank(input.title)){
            lCondition.add('Titre_Mission__c LIKE \'%' + input.title + '%\'');
        }
        
        if(lCondition.size()>0){
            String whereClause = String.join(lCondition, ' AND ') + ' ';
            String query =  'SELECT Id, '+
                'MD_Demande__r.Convsta_Entreprise__r.Name, '+
                'MD_Demande__r.Convsta_Entreprise__r.CodePays__r.Name, '+
                'MD_Demande__r.Convsta_Entreprise__r.Adresse_Ville__c, '+
                'MD_Demande__r.Convsta_Entreprise__r.CodeAPE__r.Name, '+
                'Titre_Mission__c, '+
                'MD_Demande__r.Convsta_DateStart__c, '+
                'MD_Demande__r.Contact.Name '+
                'FROM Convsta_Mission__c '+
                'WHERE '  + whereClause +
                'AND MD_Demande__r.Convsta_Type_de_demande__c = \'Stage\' '+
                'AND MD_Demande__r.Convsta_DateEnd__c < TODAY '+
                'LIMIT 100';
                    
            List<Convsta_Mission__c> lMissions = Database.query(query);
            
            System.debug('lMissions: '+lMissions);
            
            if(lMissions.size()>0){
                for(Convsta_Mission__c mission :lMissions){
                    SearchOutput output = new SearchOutput();            
                    output.companyName =    mission.MD_Demande__r.Convsta_Entreprise__r.Name;
                    output.country =        mission.MD_Demande__r.Convsta_Entreprise__r.CodePays__r.Name;
                    output.city =           mission.MD_Demande__r.Convsta_Entreprise__r.Adresse_Ville__c;
                    output.naf =            mission.MD_Demande__r.Convsta_Entreprise__r.CodeAPE__r.Name;
                    output.title =          mission.Titre_Mission__c;
                    output.startYear =      String.valueOf(mission.MD_Demande__r.Convsta_DateStart__c.year());
                    output.studentName =    mission.MD_Demande__r.Contact.Name;
                    
                    resReturn.state = 'OK';    
                    resReturn.lOutputs.add(output);
                    resReturn.size++;
                }
            }else{
                resReturn.state = 'NOK : No mission found';
                resReturn.size  = 0;
                resReturn.lOutputs = null;    
            }            
        }else{ 
            resReturn.state = 'NOK : No condition entered';
            resReturn.size  = 0;
            resReturn.lOutputs = null;
        }
        
        System.debug('resReturn ' + resReturn);
        return resReturn;
    }
    
    
}