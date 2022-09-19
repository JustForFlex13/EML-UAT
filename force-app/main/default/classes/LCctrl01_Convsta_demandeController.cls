public without sharing class LCctrl01_Convsta_demandeController {
    
    @AuraEnabled
    public static User getUserInfos(){
        List<User> us = [Select Name, Email, Username, Profile.UserType from User u where u.Id = :UserInfo.getUserId()];
        if(us.size() > 0) {
            return us[0];
        }
        return null;
    }

        @AuraEnabled
    public static void setDetailStatusSignataires(Id demandeId){
        Case demande = [SELECT Id, Convsta_eSign_ExtId__c, Convsta_Detail_statut_signataire__c, Convsta_eSign_Errors__c 
                        FROM Case
                        WHERE Id = :demandeId];

        Convsta_WS_Helper.setDetailStatusSignataires(demande,true);
    }
    
    @AuraEnabled
    public static void setCancelSignatures(Id demandeId){
        Case demande = [SELECT Id, Convsta_eSign_ExtId__c, Convsta_Detail_statut_signataire__c, Convsta_eSign_Errors__c 
                        FROM Case
                        WHERE Id = :demandeId];

        Convsta_WS_Helper.cancelSignature(demande);
    }
    
    @AuraEnabled
    public static string getRelatedFormsId(string caseId){
        system.debug('LCctrl01_Convsta_demandeController.getRelatedFormsId START'+caseId);
        if(!String.isBlank(caseId)){
            caseShellStructure retCase = new caseShellStructure();
            retCase.infoPerso=    [   select Id,is_soumis_etudiant__c
                                        from Convsta_Informations_Personnelles__c 
                                        where MD_Demande__c=:caseId limit 1];
            retCase.maMission=    [   select Id,is_soumis_etudiant__c
                                        from Convsta_Mission__c 
                                        where MD_Demande__c=:caseId limit 1];
            retCase.monEntreprise=[   select Id,Localisation_Entreprise__c,Mon_stage_se_deroule_a_une_autre_adresse__c,
                                        Convsta_Adresse_du_lieu_du_stage__c,is_soumis_etudiant__c 
                                        from Convsta_Entreprise__c 
                                        where MD_Demande__c=:caseId limit 1];
            retCase.monContrat=   [   select Id ,is_soumis_etudiant__c
                                        from Convsta_Conditions_Contractuelles__c 
                                        where MD_Demande__c=:caseId limit 1];
            Case demande = [SELECT Convsta_TypeContrat__c 
                            FROM Case 
                            WHERE Id = :caseId 
                            LIMIT 1];           
            if(demande.Convsta_TypeContrat__c != 'Convention de stage de l ecole'){
                retCase.fileToUpload = true;
            }
            system.debug('LCctrl01_Convsta_demandeController.getRelatedFormsId SUCCESS' + retCase);
            return JSON.serialize(retCase);
        }
        return '{}';
    }

    @AuraEnabled
    public static void setCancelCase(string caseId){
        try{
            Case req = [select id,Convsta_Date_de_premiere_soumission__c from case where id = :caseId limit 1];
            if(req.Convsta_Date_de_premiere_soumission__c != null){
                throw new AuraHandledException(Label.convsta_interditSuppression);
            }
            update new Case(id=caseId, status = 'Brouillon annulé',Convsta_motif_d_annulation__c='Annulation étudiant');
        }
        catch (Exception ex){
            throw new AuraHandledException(ex.getMessage()); 
        }
        
    }

    @AuraEnabled
    public static Id createNewExperienceValidation(String lieu, String type, String subtype, Date datedebut){
        map<String,Object> retVal;
        if(!Test.isRunningTest()){
            retVal = Convsta_WS_Helper.getTableTuteurSignataire(userInfo.getUserEmail(), type, datedebut);
        }
        else{
            retVal= new map<String,Object>();
            retval.put('CONVSTA_Table_Regles_Experience_Pro__c',[select id from CONVSTA_Table_Regles_Experience_Pro__c limit 1].id);
            retval.put('Nom_Responsable_Pedagogique__c',[select id from user where username='respPeda@noemail.com' limit 1].id);
            retval.put('Convsta_Signataire_delegue_EM__c',[select id from Contact limit 1].id);
            retval.put('Convsta_Tuteur_par_defaut__c',[select id from Contact where Convsta_Tuteur_EM__c = true limit 1].id);
            retval.put('expAnterieureOk',type=='Validation_experience_anterieure' ? false : true);
        }
        if(type=='Validation_experience_anterieure' && (String)retVal.get('expAnterieureOk')=='false'){
            throw new AuraHandledException(Label.convsta_NoExpAnterieure);
        }
        Case demande= new Case();
        demande.Origin                                       = 'Portal';
        demande.Convsta_Table_des_Regles_Experience_Pro__c   = (String)retVal.get('CONVSTA_Table_Regles_Experience_Pro__c');
        demande.Convsta_Responsable_Pedagogique__c           = (String)retVal.get('Nom_Responsable_Pedagogique__c');
        demande.Convsta_Signataire_delegue__c                = (String)retVal.get('Convsta_Signataire_delegue_EM__c');
        demande.Convsta_Referent_pedagogique__c              = (String)retVal.get('Convsta_Tuteur_par_defaut__c');
        demande.Code_Ann_e_Etudiant__c                       = (String)retval.get ('Code_Ann_e_Etudiant__c');
        demande.Convsta_Localisation_de_l_entreprise__c      = lieu;
        demande.Convsta_Type_de_demande__c                   = type;
        demande.Convsta_TypeContrat__c                       = subtype;
        demande.recordTypeId                                 = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Convsta_Validation_d_experience').getRecordTypeId();
        demande.Convsta_DateStart__c                         = datedebut;
        insert demande;
        return demande.id;
    }


    @AuraEnabled
    public static String getOpenCase(){
        List<User> lstUser = [Select u.ContactId from User u where u.Id = :UserInfo.getUserId()];
        List<Case> caseList = [ SELECT id, Status,Convsta_Detail_statut_signataire__c,Convsta_Status_Front_Office__c,Convsta_TypeContrat__c,convstatech_Avancement_validation_exp__c
                                FROM Case
                                WHERE contactId=:lstUser[0].ContactId 
                                    AND recordtype.developerName='Convsta_Validation_d_experience'
                                    AND isClosed=false];
        if(caseList.size()>0){
            return JSON.serialize(caseList[0]);
        }
        return '';
    }

    @AuraEnabled
    public static List<ContentDocumentLink> getFileIdList(Id caseId){
        List<ContentDocumentLink> listFile =[SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :caseId];
        return listFile;
    }

    @AuraEnabled
    public static void switchLanguage(String newLanguage){
        system.debug('switchLanguage');
        update new User(id=UserInfo.getUserId(), LanguageLocaleKey=newLanguage);
    }

    @AuraEnabled
    public static void submitCaseServer(String caseId){
        Case req = Convsta_Object_Helper.checkMatchingAccountAndContact(caseId);
        req.Status='Demande soumise';
        Case demande = [SELECT id,Convsta_Date_de_premiere_soumission__c FROM Case WHERE id=:caseId LIMIT 1 ];
        req.Convsta_Date_de_premiere_soumission__c = demande.Convsta_Date_de_premiere_soumission__c ==null ? Datetime.now():demande.Convsta_Date_de_premiere_soumission__c;
        update req;
    }
    
    public class caseShellStructure{
        public Convsta_Informations_Personnelles__c infoPerso =null;
        public Convsta_Mission__c maMission =null;
        public Convsta_Entreprise__c monEntreprise =null;
        public Convsta_Conditions_Contractuelles__c monContrat =null;
        public Boolean canEdit =false;
        public Boolean fileToUpload = false;
    }
    @AuraEnabled
    public static void createAccountServer(id caseId){
        Convsta_Entreprise__c monEntreprise=[
            SELECT Id,MD_Demande__r.Convsta_Localisation_de_l_entreprise__c,Mon_stage_se_deroule_a_une_autre_adresse__c, Convsta_Adresse_du_lieu_du_stage__c,is_soumis_etudiant__c,Pays2__c,Secteur_Activite__c ,Nom_Entreprise__c,Adresse_Entreprise__c,Code_Postal__c,Ville__c,Etat__c,Tranche_effectif_etablissement__c,SIRET__c
            FROM Convsta_Entreprise__c 
            WHERE MD_Demande__c=:caseId limit 1];

        //Vérification du SIRET__c correctement renseigné pour les entreprises à l'étranger.
        if (!monEntreprise.MD_Demande__r.Convsta_Localisation_de_l_entreprise__c.equals('En France')) {
            if (String.isBlank(monEntreprise.SIRET__c) || monEntreprise.SIRET__c.length() != 14) {
                monEntreprise.SIRET__c = '00000000000000';
            }
        }

        Pays__c paysref = [
            SELECT id ,Code_Pays__c
            FROM Pays__c 
            WHERE Code_Pays_2_caracteres__c = :monEntreprise.Pays2__c
            LIMIT 1] ;
        List<Etat__c> etatList = new List<Etat__c>();
        if(monEntreprise.Etat__c != null){
            etatList =[
                SELECT id
                FROM Etat__c
                WHERE code_etat__c = :monEntreprise.Etat__c.right(2) 
                AND   code_pays__c = :paysref.Code_Pays__c
            ];    
        }        
        Account acc = new Account(
            Name =                  monEntreprise.Nom_Entreprise__c.toUppercase(),
            Adresse_Rue__c =        monEntreprise.Adresse_Entreprise__c,
            CodePays__c =           paysref.Id,
            Code_Postal__c =        monEntreprise.Code_Postal__c,
            Adresse_Ville__c =      monEntreprise.Ville__c,
            Tranche_d_effectif__c = monEntreprise.Tranche_effectif_etablissement__c,
            Adresse_Etat1__c =      etatList.size()>0 ? etatList[0].Id :null,
            industry =              monEntreprise.Secteur_Activite__c,
            SIRET__c =              monEntreprise.SIRET__c,
            Convsta_Modifie_par_Convsta__c = true,
            Code_tiers_societe__c =Test.isRunningTest()?'CodeTest':''
        );
        Database.SaveResult sr =Database.insert( acc,false);
        if(!sr.isSuccess()){
            String errorMessage='';
            for(Database.Error duplicateError : sr.getErrors()){
                if(duplicateError instanceof Database.DuplicateError){
                    Datacloud.DuplicateResult duplicateResult = 
                        ((Database.DuplicateError)duplicateError).getDuplicateResult();
                    errorMessage+='Duplicate records have been detected by ' + 
                        duplicateResult.getDuplicateRule();
                    errorMessage+='\n ' + 
                        duplicateResult.getErrorMessage()+'\n';
                    for(Datacloud.MatchResult res:duplicateResult.getMatchResults() ){
                        for(Integer i=0; i< res.getMatchRecords().size();i++){
                            sObject sobj = (sObject)res.getMatchRecords()[i].getRecord();
                            errorMessage+= sobj.get('Name')+' ';
                        }
                    }
                }
                else{
                    errorMessage+='\n ' + duplicateError.getMessage()+ ' ' +duplicateError.getStatusCode()+' fields '+duplicateError.getFields();
                }
            }
            system.debug('debug '+errorMessage);
            throw new AuraHandledException(errorMessage);
        }
        update new Case(id=caseId, convsta_Entreprise__c=acc.id );
    }
    @AuraEnabled
    public static void createRespAdminServer(id caseId){
        Convsta_Entreprise__c monEntreprise=[
            SELECT Id,
                MD_Demande__r.convsta_Entreprise__c,
                Telephone_Signataire_Convention__c,
                Famille_fonction__c,
                Fonction_Signataire_Convention__c,
                Civilite_Signataire_Convention__c,
                Email_Signataire_Convention__c,
                Nom_Signataire_Convention__c,
                Prenom_Signataire_Convention__c
            FROM Convsta_Entreprise__c 
            WHERE MD_Demande__c=:caseId limit 1];
        Contact ctc = new Contact(
            FirstName                       = monEntreprise.Prenom_Signataire_Convention__c,
            LastName                        = monEntreprise.Nom_Signataire_Convention__c,
            Title                           = monEntreprise.Fonction_Signataire_Convention__c,
            Famille_Fonction__c             = monEntreprise.Famille_fonction__c,
            Fonctions__c                    = Convsta_Object_Helper.mapFonctionContact(monEntreprise.Famille_fonction__c),
            Convsta_Modifie_par_Convsta__c  = true,
            Email                           = monEntreprise.Email_Signataire_Convention__c,           
            Email_de_repli__c               = monEntreprise.Email_Signataire_Convention__c,
            Salutation                      = monEntreprise.Civilite_Signataire_Convention__c,
            Accountid                       = monEntreprise.MD_Demande__r.convsta_Entreprise__c,
            Phone                           = monEntreprise.Telephone_Signataire_Convention__c,
            RecordTypeId                    = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Professionnel').getRecordTypeId()
        );
        Database.SaveResult sr =Database.insert( ctc,false);
        if(!sr.isSuccess()){
            String errorMessage='';
            for(Database.Error duplicateError : sr.getErrors()){
                if(duplicateError instanceof Database.DuplicateError){
                    Datacloud.DuplicateResult duplicateResult = 
                        ((Database.DuplicateError)duplicateError).getDuplicateResult();
                    errorMessage+='Doublons d\'après la règle ' + 
                        duplicateResult.getDuplicateRule();
                    errorMessage+='\n ' + 
                        duplicateResult.getErrorMessage()+'\n';
                    for(Datacloud.MatchResult res:duplicateResult.getMatchResults() ){
                        for(Integer i=0; i< res.getMatchRecords().size();i++){
                            sObject sobj = (sObject)res.getMatchRecords()[i].getRecord();
                            errorMessage+= sobj.get('Name')+' ';
                        }
                    }
                }
                else{
                    errorMessage+='\n ' + duplicateError.getMessage();
                }
            }
            system.debug('debug '+errorMessage);
            throw new AuraHandledException(errorMessage);
        }
        update new Case(id=caseId, Responsable_administratif_entreprise__c=ctc.id );
    }
    @AuraEnabled
    public static void createTuteurEntrepriseServer(id caseId){
        Convsta_Mission__c maMission=[
            SELECT Id,
                MD_Demande__r.convsta_Entreprise__c,
                Prenom_Tuteur_Entreprise__c, 
                Telephone_Tuteur_Entreprise__c,
                Nom_Tuteur_Entreprise__c, 
                Tuteur_Entreprise__c,
                Civilite_Tuteur_Entreprise__c,
                Email_Tuteur_Entreprise__c,
                Famille_fonction__c
            FROM Convsta_Mission__c 
            WHERE MD_Demande__c=:caseId limit 1];
        Contact ctc = new Contact(
            FirstName                       = maMission.Prenom_Tuteur_Entreprise__c,
            LastName                        = maMission.Nom_Tuteur_Entreprise__c,
            Email                           = maMission.Email_Tuteur_Entreprise__c,
            Email_de_repli__c               = maMission.Email_Tuteur_Entreprise__c,
            Salutation                      = maMission.Civilite_Tuteur_Entreprise__c,
            Title                           = maMission.Tuteur_Entreprise__c,
            Famille_Fonction__c             = maMission.Famille_fonction__c,
            Fonctions__c                    = Convsta_Object_Helper.mapFonctionContact(maMission.Famille_fonction__c),
            Accountid                       = maMission.MD_Demande__r.convsta_Entreprise__c,
            Phone                           = maMission.Telephone_Tuteur_Entreprise__c,
            Convsta_Modifie_par_Convsta__c  = true,
            RecordTypeId                    = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Professionnel').getRecordTypeId()
        );
        Database.SaveResult sr =Database.insert(ctc,false);
        if(!sr.isSuccess()){
            String errorMessage='';
            for(Database.Error duplicateError : sr.getErrors()){
                if(duplicateError instanceof Database.DuplicateError){
                    Datacloud.DuplicateResult duplicateResult = 
                        ((Database.DuplicateError)duplicateError).getDuplicateResult();
                    errorMessage+='Doublons d\'après la règle ' + 
                        duplicateResult.getDuplicateRule();
                    errorMessage+='\n ' + 
                        duplicateResult.getErrorMessage()+'\n';
                    for(Datacloud.MatchResult res:duplicateResult.getMatchResults() ){
                        for(Integer i=0; i< res.getMatchRecords().size();i++){
                            sObject sobj = (sObject)res.getMatchRecords()[i].getRecord();
                            errorMessage+= sobj.get('Name')+' ';
                        }
                    }
                }
                else{
                    errorMessage+=duplicateError.getMessage()+ ' ' +duplicateError.getStatusCode()+' fields '+duplicateError.getFields();
                }
            }
            system.debug('Erreur : '+errorMessage);
            throw new AuraHandledException(errorMessage);
        }
        
        R_le__c role = new R_le__c(Categorie_role__c='Stages', Liste_r_le__c='Tuteur en entreprise', Contact__c=ctc.id);
        insert role;
        
        update new Case(id=caseId, Convsta_Tuteur__c=ctc.id );
    }
}