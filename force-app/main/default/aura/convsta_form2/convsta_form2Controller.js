({
    doInit: function (component, event, helper) {
        console.log("doInit NO recordId");
        helper.getEvaluationFormDataFromUrl(component, event, helper);        
    },
    updateEvaluationCirconstancesJS: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        helper.updateEvaluationCirconstances(component, helper, event.target.value);
    },
    updateEvalCommEarlyMakerJS: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var newComm = component.get("v.formData").currentEvaluation.Commentaire_EarlyMaker__c;
        helper.updateEvalCommEarlyMaker(component, helper, newComm);
    },
    updateEvalCommComportJS: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var newComm = component.get("v.formData").currentEvaluation.Commentaire_Comportementales__c;
        helper.updateEvalCommComport(component, helper, newComm);
    },
    updateEvalCommMetiersJS: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var newComm = component.get("v.formData").currentEvaluation
        .Commentaire_Metiers__c;
        helper.updateEvalCommMetiers(component, helper, newComm);
    },
    updateEvalCommGlobalJS: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var newComm = component.get(
            "v.formData.currentEvaluation.Commentaire_global__c"
        );
        helper.updateEvalCommGlobal(component, helper, newComm);
    },
    handleCompFamilyChange: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var chosenMetierCompFamily = event.getParam("value");
        var currentMetierCompFamily = component.get('v.formData.currentEvaluation.Famille_competences_metier__c');
        if(chosenMetierCompFamily != currentMetierCompFamily) {
            helper.showMetierCompetenceFamilyChangePopup(component, currentMetierCompFamily, chosenMetierCompFamily);
        }
    },
    doCompFamilyChange: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        } 
        var nextMetierCompFamily = component.get("v.nextMetierCompFamily");
        var formData = component.get('v.formData');
        formData.currentEvaluation.Famille_competences_metier__c = nextMetierCompFamily;
        component.set('v.formData', formData);
        component.set("v.showConfirmFamilyChangePopup", false);
        //component.set("v.chosenMetierCompFamily", nextMetierCompFamily);
        helper.updateEvalMetierFamilyJS(component, helper, nextMetierCompFamily);
        var competenceMetiersAverageRating = helper.evaluateAverageRating(component, "3Métier");
        component.set("v.competenceMetiersAverageRating", competenceMetiersAverageRating);
        helper.hideMetierCompetenceFamilyChangePopup(component);
    },
    handleOptinMarketingChange: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var chosenOptinMarketing = component.get("v.isOptinMarketing");
        var formData = component.get("v.formData");
        formData.currentEvaluation.Evaluateur__r.HasOptedInOfEmail__c = chosenOptinMarketing;
        component.set("v.formData", formData);
        helper.updateEvaluateurMarketingOptin(component, chosenOptinMarketing);
    },
    toggleSpinner: function (component, event, helper) {
        if (event.getParam("showSpinner") == true) {
            //helper.showSpinner(component);
        } else {
            helper.hideSpinner(component);
        }
    },
    refreshAverageRatings: function (component, event, helper) {
        var competenceEarlyMakerAverageRating = helper.evaluateAverageRating(component, "1EarlyMaker");
        component.set("v.competenceEarlyMakerAverageRating", competenceEarlyMakerAverageRating);
        var competenceComportementAverageRating = helper.evaluateAverageRating(component, "2Comportement");
        component.set("v.competenceComportementAverageRating", competenceComportementAverageRating);
        var competenceMetiersAverageRating = helper.evaluateAverageRating(component, "3Métier");
        component.set("v.competenceMetiersAverageRating", competenceMetiersAverageRating);
    },
    handleGlobalRatingChange: function (component, event, helper) {
        if (component.get("v.isReadOnly") === true) {
            return;
        }
        var chosenGlobalRating = event.getParam("value");
        // update formData object in view
        var formData = component.get("v.formData");
        formData.currentEvaluation.Note_globale__c = chosenGlobalRating;
        component.set("v.formData", formData);
        // update in DB
        helper.updateGlobalRatingChange(component, helper, chosenGlobalRating);
    },
    checkForm: function (component, event, helper) {
        // shouldShowErrorPopup, shouldSubmitAfter
        helper.checkForm(component, event, helper, false, false);
    },
    submitEval: function (component, event, helper) {
        helper.checkForm(component, event, helper, true, true); 
    },
    hideSubmitErrorPopup: function (component, event, helper) {
        component.set("v.showSubmitErrorPopup", false);
        component.set("v.errorMessage", "");
    },
    hideConfirmFamilyChangePopup: function (component, event, helper) {
        helper.resetMetierCompetenceFamily(component, helper);
    },
    refreshPage: function (component, event, helper) {
        location.reload();
        //$A.get('e.force:refreshView').fire();
    }
});