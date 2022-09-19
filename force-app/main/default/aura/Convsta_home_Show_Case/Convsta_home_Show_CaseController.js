({
    doInit : function(component, event, helper) {
        var action = component.get("c.getOpenCase");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                let respString = response.getReturnValue();
                if(respString!=='') {
                    let resp = JSON.parse(respString);
                    component.set("v.openCase", resp );
                    component.set("v.noCase", false);
                    component.set("v.ecole", resp.Convsta_TypeContrat__c ==='Convention de stage de l ecole');    
                }
                else{
                    component.set("v.noCase", true);
                    component.set("v.openCase", null );
                }
                component.set("v.initOk", true);
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
    },
    navigateToCase : function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.openCase").Id,
            "isredirect": true
        });
        navEvt.fire();
    }
})