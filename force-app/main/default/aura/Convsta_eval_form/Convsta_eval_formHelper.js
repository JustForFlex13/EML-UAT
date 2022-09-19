({
    getEvaluationFormDataFromUrl: function (component, event, helper) {
        var cryptedKey = helper.getUrlParameter("id");
        var studentName = helper.getUrlParameter("ns");
        var tutorName = helper.getUrlParameter("nt");
        var companyName = helper.getUrlParameter("nc");
        var language = helper.getUrlParameter("language");
        component.set('v.currentLanguage', language? language :'fr');
        cryptedKey =  cryptedKey ? cryptedKey.split("+").join(" "):'';
        studentName = studentName?studentName.split("+").join(" "):'';
        tutorName = tutorName?tutorName.split("+").join(" "):'';
        companyName = companyName?companyName.split("+").join(" "):'';
        if(cryptedKey.trim() == '' || studentName.trim() == '' || tutorName.trim() == '' || companyName.trim() == '' || language.trim() == '') {
            helper.showErrorPopup(component, event, 'ERR Missing from url');
            helper.hideSpinner(component);
        }
        else{
            var action = component.get("c.getEvaluationFormDataFromUrl");
            action.setParams({
                cryptedKey: cryptedKey,
                studentName: studentName,
                tutorName: tutorName,
                companyName: companyName
            });
            action.setCallback(
                this,
                $A.getCallback(function (response) {
                    var state = response.getState();
                    if (state == "SUCCESS") {
                        let respString = response.getReturnValue();
                        if (respString.startsWith('ERR')) {
                            helper.showErrorPopup(component, event, respString);
                            helper.hideSpinner(component);
                            return;
                        }
                        let formData = JSON.parse(respString);
                        if(formData.currentEvaluation.Statut__c == 'Évaluée') {
                            component.set('v.isReadOnly', true);
                            helper.hideSpinner(component);
                        }
                        var formEditionTiming = formData.currentEvaluation.CanEditReadError__c;
                        if(formEditionTiming != '' && formEditionTiming != 'Edit') {
                            helper.showErrorPopup(component, event, formEditionTiming);
                            helper.hideSpinner(component);
                            return;
                        }
                        component.set("v.formData", formData);
                        component.set("v.chosenMetierCompFamily", formData.currentEvaluation.Famille_competences_metier__c);
                        component.set("v.competences", formData.competences);
                        var competenceEarlyMakerAverageRating = helper.evaluateAverageRating(component, "1EarlyMaker");
                        component.set("v.competenceEarlyMakerAverageRating", competenceEarlyMakerAverageRating);
                        var competenceComportementAverageRating = helper.evaluateAverageRating(component, "2Comportement");
                        component.set("v.competenceComportementAverageRating", competenceComportementAverageRating);
                        var competenceMetiersAverageRating = helper.evaluateAverageRating(component, "3Métier");
                        component.set("v.competenceMetiersAverageRating", competenceMetiersAverageRating);
                        var currentMetiersFamily = formData.currentEvaluation.Famille_competences_metier__c;
                        component.set('v.chosenMetierCompFamily', currentMetiersFamily);
                        var isOptinMarketing = formData.currentEvaluation.Evaluateur__r.HasOptedInOfEmail__c;
                        component.set('v.isOptinMarketing', isOptinMarketing);
                        helper.computeTitle(component,formData);
                        var globalRating = formData.currentEvaluation.Note_globale__c;
                        if (globalRating) {
                            component.set("v.globalRating", "" + globalRating);
                        }
                        helper.hideSpinner(component);
                    } else {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                helper.showErrorPopup(component, event, errors[0].message);
                                helper.hideSpinner(component);
                            }
                        } else {
                            helper.hideSpinner(component);
                        }
                    }
                })
            );
            $A.enqueueAction(action);
            
        }
    },
    getEvaluationFormDataFromRecordId: function (component, event, helper) {
        var action = component.get("c.getEvaluationFormDataFromRecordId");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    let respString = response.getReturnValue();
                    if (respString !== "" && respString !== "ERR Convsta_Evaluation__c not found" ) {
                        let formData = JSON.parse(respString);
                        if(formData.currentEvaluation.Statut__c == 'Évaluée') {
                            component.set('v.isReadOnly', true);
                        }
                        component.set("v.formData", formData);
                        component.set("v.chosenMetierCompFamily", formData.currentEvaluation.Famille_competences_metier__c);
                        component.set("v.competences", formData.competences);
                        var competenceEarlyMakerAverageRating = helper.evaluateAverageRating(component, "1EarlyMaker");
                        component.set("v.competenceEarlyMakerAverageRating", competenceEarlyMakerAverageRating);
                        var competenceComportementAverageRating = helper.evaluateAverageRating(component, "2Comportement");
                        component.set("v.competenceComportementAverageRating", competenceComportementAverageRating);
                        var competenceMetiersAverageRating = helper.evaluateAverageRating(component, "3Métier");
                        component.set("v.competenceMetiersAverageRating", competenceMetiersAverageRating);
                        var currentMetiersFamily = formData.currentEvaluation.Famille_competences_metier__c;
                        component.set('v.chosenMetierCompFamily', currentMetiersFamily);
                        helper.computeTitle(component,formData);
                        var globalRating = formData.currentEvaluation.Note_globale__c;
                        if (globalRating) {
                            component.set("v.globalRating", "" + globalRating);
                        }
                        helper.hideSpinner(component);
                    }
                } else {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showErrorPopup(component, event, errors[0].message);
                            helper.hideSpinner(component);
                        }
                    }
                }
            })
        );
        $A.enqueueAction(action);
    },
    showErrorPopup: function (component, event, errCodeStr) {
        component.set("v.showErrorPopup", true);
        var errMsg = "";
        switch (errCodeStr) {
            case "ERR Convsta_Mission__c not found":
                errMsg = $A.get('$Label.c.Convsta_ERR_mission_not_found');
                break;
            case "ERR Case not found":
                errMsg = $A.get('$Label.c.Convsta_ERR_Case_not_found');
                break;
            case "ERR Convsta_Evaluation__c not found":
                errMsg = $A.get('$Label.c.Convsta_ERR_Convsta_Evaluation_c_not_found');
                break;
            case "ERR Missing from url":
                errMsg = $A.get('$Label.c.Convsta_ERR_Missing_from_url');
                break;
            case "Expired":
                errMsg = $A.get('$Label.c.Convsta_ERR_Expired');
                break;
            case "Read":
                errMsg = $A.get('$Label.c.Convsta_ERR_Read');
                break;
        }
        component.set("v.errorMessage", errMsg);
    },
    showSubmitSuccessPopup: function (component) {
        component.set("v.showSubmitSuccessPopup", true);
    },
    showSubmitErrorPopup: function (component, event, errMsg) {
        component.set("v.errorSubmitMessage", errMsg);
        component.set("v.showSubmitErrorPopup", true);
    },
    getUrlParameter: function (sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split("&"),
            sParameterName,
            i;
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split("=");
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined
                ? true
                : sParameterName[1];
            }
        }
    },
    updateEvaluationCirconstances: function (component, helper, newCirconstances) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateEvaluationCirconstances");
        action.setParams({
            newCirconstances: newCirconstances,
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                }
            })
        );
        $A.enqueueAction(action);
    },
    updateEvalCommEarlyMaker: function (component, helper, newCommEarlyMaker) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateEvalCommEarlyMaker");
        action.setParams({
            newCommEarlyMaker: newCommEarlyMaker,
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                } else {
                    var errors = response.getError();
                }
            })
        );
        $A.enqueueAction(action);
    },
    updateEvalCommComport: function (component, helper, newCommComport) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateEvalCommComport");
        action.setParams({
            newCommComport: newCommComport,
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                }
            })
        );
        $A.enqueueAction(action);
    }, 
    updateEvalMetierFamilyJS: function (component, helper, evalMetierFamily) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateEvalMetierFamily");
        action.setParams({
            newEvalMetierFamily: evalMetierFamily,
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                helper.hideSpinner(component);
            }
        })
                          );
        $A.enqueueAction(action);
    },
    updateEvalCommMetiers: function (component, helper, newCommComport) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateEvalCommMetiers");
        action.setParams({
            newCommComport: newCommComport,
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                }
            })
        );
        $A.enqueueAction(action);
    },
    updateEvalCommGlobal: function (component, helper, newCommComport) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateEvalCommGlobal");
        action.setParams({
            newCommGlobal: newCommComport,
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                }
            })
        );
        $A.enqueueAction(action);
    },
    evaluateAverageRating: function (component, compType) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var allCompetences = component.get("v.competences");
        var wantedCompetences = [];
        // pour chaque compétence, on vérifie si elle est du bon type
        for (var i = 0; i < allCompetences.length; i++) {
            if (allCompetences[i].type__c == compType) {
                // pour le type métier, on vérifie en plus si la compétence appartient à la famille de compétences métier choisie
                if (compType == "3Métier") {
                    var chosenMetierCompFamily = component.get("v.chosenMetierCompFamily");
                    if (allCompetences[i].Famille_metiers__c == chosenMetierCompFamily) {
                        wantedCompetences.push(allCompetences[i]);
                    }
                } else {
                    wantedCompetences.push(allCompetences[i]);
                }
            }
        }
        var avergeRating = 0;
        var ratedCompetencesCount = 0;
        for (var i = 0; i < wantedCompetences.length; i++) {
            var oneCompRating = 1 * wantedCompetences[i].rating__c;
            // WARNING
            // si zéro devient une note possible,
            // il faudra différencier AUTREMENT les 'n/a' des zéros.
            // Pour le moment, les zéros sont des n/a
            if (oneCompRating > 0 && wantedCompetences[i].rating__c != "n/a") {
                ratedCompetencesCount++;
                avergeRating += oneCompRating;
            }
        }
        if (ratedCompetencesCount != 0 && avergeRating != 0) {
            avergeRating = avergeRating / ratedCompetencesCount;
        }
        return Math.round(avergeRating) != 0
        ? Math.round(avergeRating * 10) / 10
        : "n/a";
    },
    updateGlobalRatingChange: function (component, helper, chosenGlobalRating) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateGlobalRatingChange");
        action.setParams({
            chosenGlobalRating: chosenGlobalRating,
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                }
            })
        );
        $A.enqueueAction(action);
    },
    updateEvaluateurMarketingOptin: function (component, chosenOptinMarketing) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.updateEvaluateurMarketingOptin");
        action.setParams({
            chosenOptinMarketing: chosenOptinMarketing,
            evaluateurId: formData.currentEvaluation.Evaluateur__r.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                }
            })
        );
        $A.enqueueAction(action);
    },
    submitForm: function (component, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var formData = component.get("v.formData");
        var action = component.get("c.validateEvaluation");
        action.setParams({
            evaluationId: formData.currentEvaluation.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    helper.hideSpinner(component);
                    helper.showSubmitSuccessPopup(component);
                }
            })
        );
        $A.enqueueAction(action);
    },
    checkForm: function (component, event, helper, shouldShowErrorPopup, shouldSubmitAfter) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }        
        // init what to check
        var competences = component.get("v.formData.competences");
        component.set("v.isCompetenceListEarlyMakerOkay", false);
        component.set("v.isCompetenceListComportementOkay", false);
        component.set("v.isCompetenceListMetiersOkay", false);
        var nbEarlyMaker = 0;
        var nbComport = 0;
        var nbMetier = 0;
        var nbRatedEarlyMaker = 0;
        var nbRatedComport = 0;
        var nbRatedMetier = 0;
        var chosenMetierCompFamily = component.get("v.chosenMetierCompFamily");
        var errMsg = "";
        // counts all competences 
        for (var i = 0; i < competences.length; i++) {
            switch (competences[i].type__c) {
                case "1EarlyMaker":
                    nbEarlyMaker++;
                    if (competences[i].rating__c != null && competences[i].rating__c != 0) {
                        nbRatedEarlyMaker++;
                    }
                    break;
                case "2Comportement":
                    if(competences[i].selectedByStudent){
                        nbComport++;
                        if (competences[i].rating__c != null && competences[i].rating__c != 0) {
                            nbRatedComport++;
                        }
                    }
                    break;
                case "3Métier":
                    // if right metier family
                    if (chosenMetierCompFamily != "" && chosenMetierCompFamily == competences[i].Famille_metiers__c) {
                        nbMetier++;
                        if (competences[i].rating__c != null && competences[i].rating__c != 0) {
                            nbRatedMetier++;
                        }
                    }
                    break;
            }
        } // end for competences.length
        // checks if all competences are rated AND if appreciation is present if necessary
        errMsg += helper.checkEarlyMakerCompetencesAndComment(component, nbEarlyMaker, nbRatedEarlyMaker);
        errMsg += helper.checkComportementCompetencesAndComment(component, nbComport, nbRatedComport);
        errMsg += helper.checkMetiersFamilyAndCompetencesAndComment(component, nbMetier, nbRatedMetier);
        // checks if global rating and appreciation are filled in
        errMsg += helper.checkGlobalEvaluationSection(component);
        if (errMsg != "" && shouldShowErrorPopup) {
            helper.showSubmitErrorPopup(component, event, errMsg);
            return;
        }
        if(shouldSubmitAfter == true) {
            helper.submitForm(component, helper);
        }
    },
    checkEarlyMakerCompetencesAndComment: function(component, nbEarlyMaker, nbRatedEarlyMaker) {
        var errMsg = '';
        var competenceEarlyMakerAverageRating = component.get("v.competenceEarlyMakerAverageRating");
        var commentaire_EarlyMaker__c = component.get("v.formData.currentEvaluation.Commentaire_EarlyMaker__c");
        if (nbEarlyMaker != nbRatedEarlyMaker) {
            component.set('v.isEarlyMakerCompetencesEvalDone', false);
            errMsg += "<li>" + $A.get("$Label.c.Convsta_eval_errCompEM") + "</li>";
        }
        if (competenceEarlyMakerAverageRating <= 2 && commentaire_EarlyMaker__c == "") {
            component.set('v.isEarlyMakerCompetencesEvalDone', false);
            errMsg += "<li>" + $A.get("$Label.c.Convsta_eval_errComEMreq") + "</li>";
        }
        if(errMsg == '') {
            component.set('v.isEarlyMakerCompetencesEvalDone', true);
        }
        return errMsg;
    },
    checkComportementCompetencesAndComment: function(component, nbComport, nbRatedComport) {
        var errMsg = '';
        var competenceComportementAverageRating = component.get("v.competenceComportementAverageRating");
        var commentaire_Comportementales__c = component.get("v.formData.currentEvaluation.Commentaire_Comportementales__c");
        if (competenceComportementAverageRating <= 2 && commentaire_Comportementales__c == "") {
            component.set('v.isComportementCompetencesEvalDone', false);
            errMsg += "<li>" + $A.get("$Label.c.Convsta_eval_errComCprtReq") + "</li>";
        }
        if (nbComport != nbRatedComport) {
            component.set('v.isComportementCompetencesEvalDone', false);
            errMsg += "<li>" + $A.get("$Label.c.Convsta_eval_errCompCprt") + "</li>";
        }
        if(errMsg == '') {
            component.set('v.isComportementCompetencesEvalDone', true);
        }
        return errMsg;
    },
    checkMetiersFamilyAndCompetencesAndComment: function(component, nbMetier, nbRatedMetier) {
        var errMsg = '';
        var chosenMetierCompFamily = component.get("v.chosenMetierCompFamily");
        var competenceMetiersAverageRating = component.get("v.competenceMetiersAverageRating");
        var commentaire_Metiers__c = component.get("v.formData.currentEvaluation.Commentaire_Metiers__c");
        if (competenceMetiersAverageRating <= 2 && commentaire_Metiers__c == "") {
            component.set('v.isCompetencesMetiersEvalDone', false);
            errMsg += "<li>" + $A.get("$Label.c.Convsta_eval_errComMetierReq") + "</li>";
        }
        if (chosenMetierCompFamily == "") {
            component.set('v.isCompetencesMetiersEvalDone', false);
            errMsg += "<li>" + $A.get("$Label.c.Convsta_eval_errFamilleMetier") + "</li>";
        }
        if (nbMetier != nbRatedMetier) {
            component.set('v.isCompetencesMetiersEvalDone', false);
            errMsg += "<li>" + $A.get("$Label.c.Convsta_eval_errCompMetiers") + "</li>";
        }
        if(errMsg == '') {
            component.set('v.isCompetencesMetiersEvalDone', true);
        }
        return errMsg;
    },
    checkGlobalEvaluationSection: function(component) {
        var globalSectionErrors = '';
        var globalRating = component.get("v.globalRating");
        if (globalRating == "") {
            component.set('v.isGlobalEvalDone', false);
            globalSectionErrors += "<li>" + $A.get("$Label.c.Convsta_eval_errNoteGlobaleReq") + "</li>";
        }
        var commentaire_global__c = component.get("v.formData.currentEvaluation.Commentaire_global__c");
        if (!commentaire_global__c) {
            component.set('v.isGlobalEvalDone', false);
            globalSectionErrors += "<li>" + $A.get("$Label.c.Convsta_eval_errCommGlobalReq") + "</li>";
        }
        if(globalSectionErrors == '') {
            component.set('v.isGlobalEvalDone', true);
        }
        return globalSectionErrors;
    },
    showMetierCompetenceFamilyChangePopup: function(component, oldMetierCompFamily, nextMetierCompFamily) {
        component.set("v.showConfirmFamilyChangePopup", true);
        component.set("v.oldMetierCompFamily", oldMetierCompFamily);
        component.set("v.nextMetierCompFamily", nextMetierCompFamily);        
    },
    resetMetierCompetenceFamily: function(component, helper) {
        var oldMetierCompFamily = component.get("v.oldMetierCompFamily");
        component.set('v.chosenMetierCompFamily', oldMetierCompFamily);
        var formData = component.get('v.formData');
        formData.currentEvaluation.Famille_competences_metier__c = oldMetierCompFamily;
        component.set('v.formData', formData);
        helper.hideMetierCompetenceFamilyChangePopup(component);
    },
    hideMetierCompetenceFamilyChangePopup: function(component) {
        component.set("v.showConfirmFamilyChangePopup", false);
        component.set("v.nextMetierCompFamily", "");
    },
    navigateTo: function (component, goToUrl) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: goToUrl
        });
        urlEvent.fire();
    },
    hideSpinner: function (component) {
        var spinner = component.find("slds-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner: function (component) {
        var spinner = component.find("slds-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    computeTitle: function (component, formData){
        var titleTxt = $A.get('$Label.c.convsta_Eval_title');
        titleTxt = titleTxt.replace('$1',formData.studentName);
        titleTxt = titleTxt.replace('$2',formData.companyName);
        titleTxt = titleTxt.replace('$3',formData.missionDateStart)
        titleTxt = titleTxt.replace('$4',formData.missionDateEnd)
        titleTxt = titleTxt.replace('$5',formData.tutorName);
        
        component.set("v.someData",true);
        component.set("v.title" , titleTxt);
    }
});