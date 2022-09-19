public without sharing class LCctrl02_Convsta_evaluationController {
    @AuraEnabled
    public static String getEvaluationFormDataFromRecordId(Id recordId){
        if(recordId != null){
            if(String.valueOf(recordId).substring(0,3) == '500'){
            	return getEvaluationFormDataFromCaseId(recordId);
            }else{
                return getEvaluationFormDataFromEvalId(recordId);
            }
        }else{
            return null;
        }
    }
    public static String getEvaluationFormDataFromEvalId(Id evalId){
        System.debug('>>> LCctrl02_Convsta_evaluationController - getEvaluationFormDataFromEvalId - START');            
        Convsta_Evaluation__c currentEval = null;
        try{
            currentEval = [
                SELECT
                id,
                Circonstances_du_stage__c,
                Commentaire_Comportementales__c,
                Commentaire_EarlyMaker__c,
                Commentaire_Metiers__c,
                Commentaire_global__c,
                Famille_competences_metier__c,
                Note_globale__c,
                Demande__c,
                Statut__c,
                Evaluateur__r.Id,
                Evaluateur__r.Name,
                Evaluateur__r.HasOptedInOfEmail__c
                FROM
                Convsta_Evaluation__c
                WHERE
                Id = :evalId
                LIMIT 1
            ];
            System.debug('currentEval : ' + currentEval);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentEval - exception : ' + e);
            return 'Convsta_Evaluation__c not found';
        }
        Case currentDemande = null;
        try {
            currentDemande = [
                SELECT
                id,
                Convsta_Entreprise__r.Name,
                Convsta_Tuteur__r.Name,
                Contact.Name, // student name
                Convsta_DateStart__c,
                Convsta_DateEnd__c
                FROM
                Case
                WHERE
                id = :currentEval.Demande__c
                LIMIT 1
            ];
            System.debug('currentDemande : ' + currentDemande);
            System.debug('currentDemande.Contact.Name : ' + currentDemande.Contact.Name);
            System.debug('currentDemande.Convsta_Tuteur__r.Name : ' + currentDemande.Convsta_Tuteur__r.Name);
            System.debug('currentDemande.Convsta_Entreprise__r.Name : ' + currentDemande.Convsta_Entreprise__r.Name);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentDemande - exception : ' + e);
            return 'ERR Case not found';
        }
        Convsta_Mission__c currentMission = null;
        try{
            currentMission = [
                SELECT
                id,
                Name,
                MD_Demande__c,
                Titre_Mission__c,
                Convsta_Description_de_la_mission__c,
                Conceptualiser_et_modeliser__c,
                Demontrer_un_comportement_assertif__c,
                Gerer_son_stress__c,
                Gerer_son_temps_et_les_priorites__c,
                Mobiliser_differentes_sources__c,
                Precision_et_rigueur_au_travail__c,
                Qualifier_et_identifier_l_information__c,
                Elaborer_un_diagnostic__c
                FROM
                Convsta_Mission__c
                WHERE
                MD_Demande__c = :currentEval.Demande__c
                LIMIT 1
            ];
            System.debug('currentMission : ' + currentMission);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentMission - exception : ' + e);
            return 'ERR Convsta_Mission__c not found';
        }
        System.debug('<<< LCctrl02_Convsta_evaluationController - getEvaluationFormDataFromCaseId - END');
        return getEvaluationFormDataJson(currentDemande, currentEval, currentMission);
    }
    public static String getEvaluationFormDataFromCaseId(Id caseId){
        System.debug('>>> LCctrl02_Convsta_evaluationController - getEvaluationFormDataFromCaseId - START');
        Case currentDemande = null;
        try {
            System.Debug('Demande request: SELECT id, Convsta_Entreprise__r.Name, Convsta_Tuteur__r.Name, Contact.Name, Convsta_DateStart__c, Convsta_DateEnd__c FROM Case WHERE id = ' + caseId +' LIMIT 1');
            currentDemande = [
                SELECT
                id,
                Convsta_Entreprise__r.Name,
                Convsta_Tuteur__r.Name,
                Contact.Name, // student name
                Convsta_DateStart__c,
                Convsta_DateEnd__c
                FROM
                Case
                WHERE
                id = :caseId
                LIMIT 1
            ];
            System.debug('currentDemande : ' + currentDemande);
            System.debug('currentDemande.Contact.Name : ' + currentDemande.Contact.Name);
            System.debug('currentDemande.Convsta_Tuteur__r.Name : ' + currentDemande.Convsta_Tuteur__r.Name);
            System.debug('currentDemande.Convsta_Entreprise__r.Name : ' + currentDemande.Convsta_Entreprise__r.Name);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentDemande - exception : ' + e);
            return 'ERR Case not found';
        }
        Convsta_Evaluation__c currentEval = null;
        try{
            currentEval = [
                SELECT
                id,
                Circonstances_du_stage__c,
                Commentaire_Comportementales__c,
                Commentaire_EarlyMaker__c,
                Commentaire_Metiers__c,
                Commentaire_global__c,
                Famille_competences_metier__c,
                Note_globale__c,
                Demande__c,
                Statut__c,
                Evaluateur__r.Id,
                Evaluateur__r.Name,
                Evaluateur__r.HasOptedInOfEmail__c
                FROM
                Convsta_Evaluation__c
                WHERE
                Demande__c = :caseId
                LIMIT 1
            ];
            System.debug('currentEval : ' + currentEval);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentEval - exception : ' + e);
            return 'ERR Convsta_Evaluation__c not found';
        }
        Convsta_Mission__c currentMission = null;
        try{
            currentMission = [
                SELECT
                id,
                Name,
                MD_Demande__c,
                Titre_Mission__c,
                Convsta_Description_de_la_mission__c,
                Conceptualiser_et_modeliser__c,
                Demontrer_un_comportement_assertif__c,
                Gerer_son_stress__c,
                Gerer_son_temps_et_les_priorites__c,
                Mobiliser_differentes_sources__c,
                Precision_et_rigueur_au_travail__c,
                Qualifier_et_identifier_l_information__c,
                Elaborer_un_diagnostic__c
                FROM
                Convsta_Mission__c
                WHERE
                MD_Demande__c = :caseId
                LIMIT 1
            ];
            System.debug('currentMission : ' + currentMission);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentMission - exception : ' + e);
            return 'ERR Convsta_Mission__c not found';
        }
        System.debug('<<< LCctrl02_Convsta_evaluationController - getEvaluationFormDataFromCaseId - END');
        return getEvaluationFormDataJson(currentDemande, currentEval, currentMission);
    }
    @AuraEnabled
    public static String getEvaluationFormDataFromUrl(String cryptedKey, String studentName, String tutorName, String companyName){
        System.debug('>>> LCctrl02_Convsta_evaluationController - getEvaluationFormDataFromURL - START');
        System.debug('cryptedKey : ' + cryptedKey);
        System.debug('studentName : ' + studentName);
        System.debug('tutorName : ' + tutorName);
        System.debug('companyName : ' + companyName);
        Convsta_Evaluation__c currentEval = null;
        try{
            currentEval = [
                SELECT
                id,
                Circonstances_du_stage__c,
                Commentaire_Comportementales__c,
                Commentaire_EarlyMaker__c,
                Commentaire_Metiers__c,
                Commentaire_global__c,
                Famille_competences_metier__c,
                Note_globale__c,
                Demande__c,
                Statut__c,
                Evaluateur__r.Id,
                Evaluateur__r.Name,
                Evaluateur__r.HasOptedInOfEmail__c,
                CanEditReadError__c
                FROM
                Convsta_Evaluation__c
                WHERE
                Cle_cryptee__c = :cryptedKey 
                LIMIT 1
            ];
            System.debug('currentEval : ' + currentEval);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentEval - exception : ' + e);
            return 'ERR Convsta_Evaluation__c not found';
        }
        Case currentDemande = null;
        try {
            System.Debug('Demande request: SELECT id, Convsta_Entreprise__r.Name, Convsta_Tuteur__r.Name, Contact.Name, Convsta_DateStart__c, Convsta_DateEnd__c FROM Case WHERE id = ' + currentEval.Demande__c + ' AND Contact.Name = ' + studentName + ' AND Convsta_Tuteur__r.Name = ' + tutorName + ' AND Convsta_Entreprise__r.Name = ' + companyName + ' LIMIT 1');
            currentDemande = [
                SELECT
                id,
                Convsta_Entreprise__r.Name,
                Convsta_Tuteur__r.Name,
                Contact.Name, // student name
                Convsta_DateStart__c,
                Convsta_DateEnd__c
                FROM
                Case
                WHERE
                id = :currentEval.Demande__c
                AND
                Contact.Name = :studentName
                AND
                Convsta_Entreprise__r.Name = :companyName
                LIMIT 1
            ];
            System.debug('currentDemande : ' + currentDemande);
            System.debug('currentDemande.Contact.Name : ' + currentDemande.Contact.Name);
            System.debug('currentDemande.Convsta_Tuteur__r.Name : ' + currentDemande.Convsta_Tuteur__r.Name);
            System.debug('currentDemande.Convsta_Entreprise__r.Name : ' + currentDemande.Convsta_Entreprise__r.Name);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentDemande - exception : ' + e);
            return 'ERR Case not found';
        }
        Convsta_Mission__c currentMission = null;
        try{
            currentMission = [
                SELECT
                id,
                Name,
                MD_Demande__c,
                Titre_Mission__c,
                Convsta_Description_de_la_mission__c,
                Conceptualiser_et_modeliser__c,
                Demontrer_un_comportement_assertif__c,
                Gerer_son_stress__c,
                Gerer_son_temps_et_les_priorites__c,
                Mobiliser_differentes_sources__c,
                Precision_et_rigueur_au_travail__c,
                Qualifier_et_identifier_l_information__c,
                Elaborer_un_diagnostic__c
                FROM
                Convsta_Mission__c
                WHERE
                MD_Demande__c = :currentEval.Demande__c
                LIMIT 1
            ];
            System.debug('currentMission : ' + currentMission);
        }
        catch(Exception e) {
            System.debug('ERROR - catch while getting currentMission - exception : ' + e);
            return 'Convsta_Mission__c not found';
        }
        System.debug('<<< LCctrl02_Convsta_evaluationController - getEvaluationFormDataFromURL - END');
        return getEvaluationFormDataJson(currentDemande, currentEval, currentMission);
    }
    private static String getEvaluationFormDataJson(Case currentDemande, Convsta_Evaluation__c currentEval, Convsta_Mission__c currentMission){
        FormData formData = new FormData();
        formData.studentName = currentDemande.Contact.Name;
        formData.tutorName = currentEval.Evaluateur__r.Name;
        formData.companyName = currentDemande.Convsta_Entreprise__r.Name;
        formData.currentMission = currentMission;
        formData.missionTitle = currentMission.Titre_Mission__c;
        formData.missionDateStart = formatDateForFront(currentDemande.Convsta_DateStart__c);
        formData.missionDateEnd = formatDateForFront(currentDemande.Convsta_DateEnd__c);
        formData.missionDate = formatDateForFront(currentDemande.Convsta_DateStart__c) + ' au ' + formatDateForFront(currentDemande.Convsta_DateEnd__c);
        // si aucun commentaire présent, champ absent.
        currentEval.Commentaire_Comportementales__c = currentEval.Commentaire_Comportementales__c == null ? '' : currentEval.Commentaire_Comportementales__c;
        currentEval.Commentaire_EarlyMaker__c = currentEval.Commentaire_EarlyMaker__c == null ? '' : currentEval.Commentaire_EarlyMaker__c;
        currentEval.Commentaire_Metiers__c = currentEval.Commentaire_Metiers__c == null ? '' : currentEval.Commentaire_Metiers__c;
        formData.currentEvaluation = currentEval;
        List<Convsta_Competence__c> alreadyRatedCompetences = [SELECT Id, rating__c, ratingValue__c, Label_fr__c, Label_En__c, Famille_metiers__c, type__c FROM Convsta_Competence__c WHERE Evaluation__c = :currentEval.Id];
        List<Convsta_Competences__mdt> competences_mdts = [SELECT Label, Name__c, Name_En__c, Famille_metier__c, Order__c, Type__c FROM Convsta_Competences__mdt ORDER BY Order__c ] ;
        List<Convsta_Competence__c> convstaCompetences = new List<Convsta_Competence__c>();
        System.debug('getEvaluationFormDataJson - alreadyRatedCompetences : ' + alreadyRatedCompetences);
        System.debug('getEvaluationFormDataJson - alreadyRatedCompetences.size() : ' + alreadyRatedCompetences.size());
        System.debug('getEvaluationFormDataJson - competences_mdts : ' + competences_mdts);
        System.debug('getEvaluationFormDataJson - competences_mdts.size() : ' + competences_mdts.size());
        // creating all skills listed in the cmdts
        // if a skills already exists, its rating is set by default
        for(Convsta_Competences__mdt oneMdt : competences_mdts ) {
            Convsta_Competence__c oneComp = new Convsta_Competence__c(
                Name = oneMdt.Name__c,
                Label_fr__c = oneMdt.Name__c,
                Label_En__c = oneMdt.Name_En__c,
                Evaluation__c = currentEval.Id,
                Order__c = oneMdt.Order__c,
                Famille_metiers__c = oneMdt.Famille_metier__c,
                type__c = oneMdt.Type__c
            );
            for(Integer i=0; i<alreadyRatedCompetences.size(); i++) {
                //  || alreadyRatedCompetences[i].Label_En__c == oneMdt.Name_En__c
                if(alreadyRatedCompetences[i].Label_fr__c == oneMdt.Name__c) {
                    oneComp = alreadyRatedCompetences[i];
                }
            }
            convstaCompetences.add(oneComp);
            oneComp = null;
        }
        System.debug('getEvaluationFormDataJson - convstaCompetences : ' + convstaCompetences);
        System.debug('getEvaluationFormDataJson - convstaCompetences.size() : ' + convstaCompetences.size());
        formData.competences = convstaCompetences;
        List<Eval_CompFamily_SelectOption> evalCompFamillyPicklistValues = getPicklistValues(formData.currentEvaluation, 'Famille_competences_metier__c');
        formData.evalCompFamillyPicklistValues = evalCompFamillyPicklistValues;
        System.debug('JSON.serialize(formData) : ' + JSON.serialize(formData));
        return JSON.serialize(formData);
    }
    @AuraEnabled
    public static void upsertCompetence(String competenceStr){
        Convsta_Competence__c competence = (Convsta_Competence__c) JSON.deserialize(competenceStr, Convsta_Competence__c.Class);
        System.debug('>>> LCctrl02_Convsta_evaluationController - upsertCompetence START');
        System.debug('upsertCompetence competence : ' + competence);
        competence.Name = competence.Label_fr__c;
        upsert competence;
    }
    @AuraEnabled
    public static void updateEvaluationCirconstances(String newCirconstances, String evaluationId) {
        System.debug('updateEvaluationCirconstances START');
        System.debug('updateEvaluationCirconstances newCirconstances : ' + newCirconstances);
        System.debug('updateEvaluationCirconstances evaluationId : ' + evaluationId);
        Convsta_Evaluation__c currentEval = [
            SELECT
            id,
            Circonstances_du_stage__c
            FROM
            Convsta_Evaluation__c
            WHERE
            Id = :evaluationId
            LIMIT 1
        ];
        currentEval.Circonstances_du_stage__c = newCirconstances;
        update currentEval;
    }
    @AuraEnabled
    public static void updateEvalCommEarlyMaker(String newCommEarlyMaker, String evaluationId) {
        System.debug('updateEvalCommEarlyMaker START');
        System.debug('updateEvalCommEarlyMaker newCommEarlyMaker : ' + newCommEarlyMaker);
        System.debug('updateEvalCommEarlyMaker evaluationId : ' + evaluationId);
        Convsta_Evaluation__c currentEval = [
            SELECT
            id,
            Circonstances_du_stage__c,
            Commentaire_EarlyMaker__c,
            Famille_competences_metier__c,
            Note_globale__c
            FROM
            Convsta_Evaluation__c
            WHERE
            Id = :evaluationId
            LIMIT 1
        ];
        currentEval.Commentaire_EarlyMaker__c = newCommEarlyMaker;
        update currentEval;
    }
    @AuraEnabled
    public static void updateEvalCommComport(String newCommComport, String evaluationId) {
        System.debug('updateEvalCommComport START');
        System.debug('updateEvalCommComport newCommComport : ' + newCommComport);
        System.debug('updateEvalCommComport evaluationId : ' + evaluationId);
        Convsta_Evaluation__c currentEval = [
            SELECT
            id,
            Circonstances_du_stage__c,
            Commentaire_Comportementales__c,
            Note_globale__c
            FROM
            Convsta_Evaluation__c
            WHERE
            Id = :evaluationId
            LIMIT 1
        ];
        currentEval.Commentaire_Comportementales__c = newCommComport;
        update currentEval;
    }
    @AuraEnabled
    public static void updateEvalMetierFamily(String newEvalMetierFamily, String evaluationId) {
        System.debug('updateEvalMetierFamily START');
        System.debug('updateEvalMetierFamily newEvalMetierFamily : ' + newEvalMetierFamily);
        System.debug('updateEvalMetierFamily evaluationId : ' + evaluationId);
        Convsta_Evaluation__c currentEval = [
            SELECT
            id,
            Famille_competences_metier__c
            FROM
            Convsta_Evaluation__c
            WHERE
            Id = :evaluationId
            LIMIT 1
        ];
        currentEval.Famille_competences_metier__c = newEvalMetierFamily;
        update currentEval;
        // delete all Metiers competences that are NOT of this new Metier family
        List<convsta_competence__c> oldMetierFamilyCompetences = [
            SELECT
            id,
            name,
            Famille_metiers__c,
            evaluation__r.Name,
            evaluation__r.Famille_competences_metier__c,
            rating__c
            FROM
            convsta_competence__c
            WHERE
            evaluation__c = :evaluationId
            AND
            Type__c = '3Métier'
            AND
            Famille_metiers__c != ''
            AND
            Famille_metiers__c != :newEvalMetierFamily
        ];
        if(oldMetierFamilyCompetences.size() > 0) {
            delete oldMetierFamilyCompetences;
        }
    }
    @AuraEnabled
    public static void updateEvalCommMetiers(String newCommComport, String evaluationId) {
        System.debug('updateEvalCommMetiers START');
        System.debug('updateEvalCommMetiers newCommComport : ' + newCommComport);
        System.debug('updateEvalCommMetiers evaluationId : ' + evaluationId);
        Convsta_Evaluation__c currentEval = [
            SELECT
            id,
            Circonstances_du_stage__c,
            Commentaire_Metiers__c,
            Note_globale__c
            FROM
            Convsta_Evaluation__c
            WHERE
            Id = :evaluationId
            LIMIT 1
        ];
        currentEval.Commentaire_Metiers__c = newCommComport;
        update currentEval;
    }
    @AuraEnabled
    public static void updateEvalCommGlobal(String newCommGlobal, String evaluationId) {
        System.debug('updateEvalCommGlobal START');
        System.debug('updateEvalCommGlobal newCommGlobal : ' + newCommGlobal);
        System.debug('updateEvalCommGlobal evaluationId : ' + evaluationId);
        Convsta_Evaluation__c currentEval = [
            SELECT
            id,
            Circonstances_du_stage__c,
            Commentaire_global__c,
            Note_globale__c
            FROM
            Convsta_Evaluation__c
            WHERE
            Id = :evaluationId
            LIMIT 1
        ];
        currentEval.Commentaire_global__c = newCommGlobal;
        update currentEval;
    }
    @AuraEnabled
    public static void updateEvaluateurMarketingOptin(Boolean chosenOptinMarketing, String evaluateurId) {
        System.debug('updateEvalCommGlobal START');
        System.debug('updateEvalCommGlobal chosenOptinMarketing : ' + chosenOptinMarketing);
        System.debug('updateEvalCommGlobal evaluateurId : ' + evaluateurId);
        Contact evaluateur = [
            SELECT
            id,
            HasOptedInOfEmail__c,
            HasOptedOutOfEmail,
            DateOptedInOfEmail__c,
            DateOptedOutOfEmail__c
            FROM
            Contact
            WHERE
            Id = :evaluateurId
            LIMIT 1
        ];
        if(chosenOptinMarketing == true) {
            evaluateur.HasOptedInOfEmail__c = true;
            evaluateur.HasOptedOutOfEmail = false;
            evaluateur.DateOptedInOfEmail__c = Date.today();
        }
        else if(chosenOptinMarketing == false) {
            evaluateur.HasOptedInOfEmail__c = false;
            evaluateur.HasOptedOutOfEmail = true;
            evaluateur.DateOptedOutOfEmail__c = Date.today();
        }
        update evaluateur;
    }
    @AuraEnabled
    public static void updateGlobalRatingChange(String chosenGlobalRating, String evaluationId) {
        System.debug('updateGlobalRatingChange START');
        System.debug('updateGlobalRatingChange chosenGlobalRating : ' + chosenGlobalRating);
        System.debug('updateGlobalRatingChange evaluationId : ' + evaluationId);
        Integer castedRating = null;
        if(chosenGlobalRating.isNumeric()) {
            castedRating = (Integer.valueOf(chosenGlobalRating));
        }
        if(castedRating != null) {
            Convsta_Evaluation__c currentEval = [
                SELECT
                id,
                Circonstances_du_stage__c,
                Commentaire_global__c,
                Note_globale__c
                FROM
                Convsta_Evaluation__c
                WHERE
                Id = :evaluationId
                LIMIT 1
            ];
            currentEval.Note_globale__c = castedRating;
            update currentEval;
        }
    }
    @AuraEnabled
    public static void validateEvaluation(String evaluationId) {
        System.debug('validateEvaluation START');
        System.debug('validateEvaluation evaluationId : ' + evaluationId);
        Convsta_Evaluation__c currentEval = [
            SELECT
            id,
            Statut__c
            FROM
            Convsta_Evaluation__c
            WHERE
            Id = :evaluationId
            LIMIT 1
        ];
        currentEval.Statut__c = 'Évaluée';
        currentEval.Date_Reception_Evalutation__c= Datetime.now();
        update currentEval;
    }
    public static String formatDateForFront(Datetime dt) {
        if(dt == null){
            return '';
        }
        return dt.format('dd/MM/yyyy');
    }
    public static list<Eval_CompFamily_SelectOption> getPicklistValues(SObject obj, String fld){
        list<Eval_CompFamily_SelectOption> options = new list<Eval_CompFamily_SelectOption>();
        Schema.sObjectType objType = obj.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values) {
            Eval_CompFamily_SelectOption oneOption = new Eval_CompFamily_SelectOption();
            oneOption.label = a.getLabel();
            oneOption.value = a.getValue();
            options.add(oneOption);
        }
        return options;
    }
    public class FormData {
        public String studentName;
        public String tutorName;
        public String companyName;
        public String missionTitle;
        public String missionDate;
        public String missionDateStart;
        public String missionDateEnd;
        public Convsta_evaluation__c currentEvaluation;
        public Convsta_Mission__c currentMission;
        public List<Convsta_Competence__c> competences;
        public List<Eval_CompFamily_SelectOption> evalCompFamillyPicklistValues;
    }
    public class Eval_CompFamily_SelectOption {
        public String label;
        public String value;
    }
    
    @AuraEnabled
    public static string createEvalBackOffice(Id caseId){
        try {
            List<Case> cseList = [
                SELECT Id, 
                Contact.Id, 
                Contact.Name, 
                Casenumber,
                Convsta_Referent_pedagogique__c, 
                Convsta_DateEnd__c,
                Convsta_Responsable_Pedagogique__c,
                Convsta_Tuteur__c
                FROM Case
                WHERE Id= :caseId];
            Convsta_Internship.createEval(cseList);
        } catch (Exception e) {
            throw new AuraHandledException('Une erreur s\'est produite. '+e.getMessage());
        }
        return 'success';
    }
}