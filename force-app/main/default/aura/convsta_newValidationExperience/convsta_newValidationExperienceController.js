({
    handleSubmit : function(component, event, helper) {
        var fields = event.getParam('fields');
        console.log("before spinner");
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        console.log("after spinner");
        event.preventDefault();       // stop the form from submitting
        var action = component.get("c.createNewExperienceValidation");			
        action.setParams({
            "lieu"	 : fields.Convsta_Localisation_de_l_entreprise__c,
            "type"	 : fields.Convsta_Type_de_demande__c,
            "subtype": fields.Convsta_TypeContrat__c,
            "datedebut": fields.Convsta_DateStart__c
        });
        action.setCallback(this, function(response) {
            console.log("in call back 5");
            
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log("in call back SUCCESS");
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                let retVal = response.getReturnValue();
                console.log(retVal);

                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": retVal
                });
                navEvt.fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title":  !$Label.c.Convsta_succes,
                    "message": !$Label.c.CONVSTA_nouvelle_demande_cr_e,
                    "type": "success"
                });
                toastEvent.fire();
            }
            else{
                console.log("in call back error");
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                var errors = response.getError();
                console.log("coucou "+JSON.stringify(errors));
                if (errors) {
                    var toastEvent = $A.get("e.force:showToast");
                    if (errors[0] && errors[0].message) {
                        toastEvent.setParams({
                            "title": "Error",
                            "message": errors[0].message,
                            "type": "error"
                        });
                        console.log("Error message: " + errors[0].message);
                    }
                    else if(errors[0] && errors[0].pageErrors[0]){
                        toastEvent.setParams({
                            "title": "Error",
                            "message": errors[0].pageErrors[0].message,
                            "type": "error"
                        });
                        
                    }
                    toastEvent.fire();
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})