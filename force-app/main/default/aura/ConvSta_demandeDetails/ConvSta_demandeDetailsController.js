({
	doInit : function(component, event, helper) {
        var action = component.get("c.getRelatedFormsId");
        if(component.get("v.recordIdTest")||component.get("v.recordId")){
            action.setParams({
                caseId: component.get("v.recordIdTest")||component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    let retVal = JSON.parse(response.getReturnValue());
                    console.log(response.getReturnValue());
                    component.set("v.recordInfo",   retVal);
                    component.set("v.boolInfo",     retVal.infoPerso.is_soumis_etudiant__c);
                    component.set("v.boolComp",     retVal.monEntreprise.is_soumis_etudiant__c);
                    component.set("v.boolMiss",     retVal.maMission.is_soumis_etudiant__c);
                    component.set("v.boolContr",    retVal.monContrat.is_soumis_etudiant__c); 
                    component.set("v.toUpload",     retVal.fileToUpload);
                }
                else{
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);    
        }
    },
    doUpdate : function(component, event, helper) {
        var action = component.get("c.getRelatedFormsId");
        if(component.get("v.recordIdTest")||component.get("v.recordId")){
            action.setParams({
                caseId: component.get("v.recordIdTest")||component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    let sectionName = component.find("accordion").get("v.activeSectionName");
                    component.find("accordion").set("v.activeSectionName",(Number(sectionName)+1).toString());
                    let retVal = JSON.parse(response.getReturnValue());
                    component.set("v.boolInfo",     retVal.infoPerso.is_soumis_etudiant__c);
                    component.set("v.boolComp",     retVal.monEntreprise.is_soumis_etudiant__c);
                    component.set("v.boolMiss",     retVal.maMission.is_soumis_etudiant__c);
                    component.set("v.boolContr",    retVal.monContrat.is_soumis_etudiant__c); 
                }
                else{
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);    
        }
    },
	handleScroll: function(component, event, helper){
		component.find("topInfo").getElement().scrollIntoView(true);
	},
	saveSection: function(component, event, helper){
        let sourceValue =event.getSource().get("v.value");
        let formId='';
        switch (sourceValue) {
            case "savePerso":
                formId='editInfoPerso';
                break;
            case "saveMission":            
                formId='editMission';
                break;
            case "saveContrat":
                formId='editContrat';
                break;
            default:
                formId='';
        }
        console.log("saveSection"+formId);
		component.find(formId).get("e.recordSave").fire();
	},
	openSection: function(component, event, helper){
    	component.find("accordion").set("v.activeSectionName",event.getSource().get("v.value"));
    },
    submitCase: function(component, event, helper){
        var action = component.get("c.submitCaseServer");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            console.log(response.getState());
            console.log('222'+response.getState());
            let resultsToast = $A.get("e.force:showToast");
            if (response.getState() === "SUCCESS") {
                resultsToast.setParams({
                    "title": $A.get("$Label.c.Convsta_succes"),
                    "message": $A.get("$Label.c.Convsta_DemandeSoumise"),
                    "type":"success"
                });
                resultsToast.fire();   
                var navEvt = $A.get("e.force:navigateHome");
                navEvt.setParams({
                    "isredirect": true
                });
                navEvt.fire();             
            } else if (response.getState() === "ERROR") {
                console.log('Error: ' + JSON.stringify(response.getError()));
                resultsToast.setParams({
                    "title": $A.get("$Label.c.Convsta_erreur"),
                    "message": $A.get("$Label.c.Convsta_ErreurSurvenue"),
                    "type":"error"
                });
                resultsToast.fire();
            } else {
                console.log('Unknown problem, state: ' + response.getState() + ', error: ' + response.getError());
            }});
        $A.enqueueAction(action);
    },
    handleEntreprise: function(component, event, helper){
        component.find("accordion").set("v.activeSectionName","3");
        var action = component.get("c.getRelatedFormsId");
        if(component.get("v.recordIdTest")||component.get("v.recordId")){
            action.setParams({
                caseId: component.get("v.recordIdTest")||component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    let retVal = JSON.parse(response.getReturnValue());
                    component.set("v.boolInfo",     retVal.infoPerso.is_soumis_etudiant__c);
                    component.set("v.boolComp",     retVal.monEntreprise.is_soumis_etudiant__c);
                    component.set("v.boolMiss",     retVal.maMission.is_soumis_etudiant__c);
                    component.set("v.boolContr",    retVal.monContrat.is_soumis_etudiant__c); 
                }
            });
            
            $A.enqueueAction(action);  
        }  
    },
    handleLocalisationToggle: function(component, event, helper){
        console.log("handleLocalisationToggle5 " + component.get("v.demande.Convsta_Localisation_de_l_entreprise__c") );
        var spinner = component.find("mySpinner"); 
        component.set("v.canEditRefreh",0);
        $A.util.toggleClass(spinner, "slds-hide");
        component.find("caseRecord").saveRecord($A.getCallback(function(saveResult) {
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            component.set("v.canEditRefreh",1);
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    createAccount: function(component, event, helper){
        component.set("v.refreshView",false);
        var action = component.get("c.createAccountServer");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.refreshView",true);
            var state = response.getState();
            if (state == "SUCCESS") {
                component.find("caseRecord").reloadRecord(true);              
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("$Label.c.Convsta_succes"),
                    "type":"success",
                    "message": "Entreprise créée"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            else{
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    console.log("error"+JSON.stringify(errors));
                }
                var toastEvent2 = $A.get("e.force:showToast");
                toastEvent2.setParams({
                    "title": $A.get("$Label.c.Convsta_erreur"),
                    "type":"error",
                    "message": message
                });
                toastEvent2.fire();
            }
        });
        
        $A.enqueueAction(action);    
    }, 
    createRespAdmin: function(component, event, helper){
        component.set("v.refreshView",false);
        var action = component.get("c.createRespAdminServer");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.refreshView",true);
            var state = response.getState();
            if (state == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("$Label.c.Convsta_succes"),
                    "type":"success",
                    "message": "Responsable administratif créé"
                });
                toastEvent.fire();
                component.find("caseRecord").reloadRecord(true);
            }
            else{
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    console.log("error"+JSON.stringify(errors));
                }
                var toastEvent2 = $A.get("e.force:showToast");
                toastEvent2.setParams({
                    "title":  $A.get("$Label.c.Convsta_erreur"),
                    "type":"error",
                    "message": message
                });
                toastEvent2.fire();
            }
        });
        
        $A.enqueueAction(action);    
    }, 
    createTuteur: function(component, event, helper){
        component.set("v.refreshView",false);
        var action = component.get("c.createTuteurEntrepriseServer");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.refreshView",true);
            var state = response.getState();
            if (state == "SUCCESS") {
                component.find("caseRecord").reloadRecord(true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("$Label.c.Convsta_succes"),
                    "type":"success",
                    "message": "Tuteur créé"
                });
                toastEvent.fire();
            }
            else{
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    console.log("error"+JSON.stringify(errors));
                }
                var toastEvent2 = $A.get("e.force:showToast");
                toastEvent2.setParams({
                    "title":  $A.get("$Label.c.Convsta_erreur"),
                    "type":"error",
                    "message": message
                });
                toastEvent2.fire();
            }
        });
        
        $A.enqueueAction(action);    
    },
    cancelCase : function(component, event, helper) {
        console.log("cancelCase");
        if(component.get("v.recordId")){
            var action = component.get("c.setCancelCase");
            action.setParams({
                caseId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                console.log("cancelCase callback 2");
                let resultsToast = $A.get("e.force:showToast");
                if (response.getState() === "SUCCESS") {
                    resultsToast.setParams({
                        "title": $A.get("$Label.c.Convsta_Annuler"),
                        "message": "!! demande supprimée.",
                        "type":"success"
                    });
                    resultsToast.fire();   
                    var navEvt = $A.get("e.force:navigateHome");
                    navEvt.setParams({
                        "isredirect": true
                    });
                    navEvt.fire();             
                } else if (response.getState() === "ERROR") {
                    console.log('Error: ' + JSON.stringify(response.getError()));
                    resultsToast.setParams({
                        "title": $A.get("$Label.c.Convsta_erreur"),
                        "message": $A.get("$Label.c.convsta_interditSuppression"),
                        "type":"error"
                    });
                    resultsToast.fire();
                }
            });
            $A.enqueueAction(action);    
        }
    },
    openConfirm: function(component, event, helper) {
        component.set("v.toConfirm", true);
    },
    closeConfirm: function(component, event, helper) {
        component.set("v.toConfirm", false);
    },
    refreshview: function(component, event, helper) {
        component.find("caseRecord").reloadRecord(true);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("$Label.c.Convsta_succes"),
            "type":"success",
            "message": "demande mise à jour"
        });
        toastEvent.fire();
    }
})