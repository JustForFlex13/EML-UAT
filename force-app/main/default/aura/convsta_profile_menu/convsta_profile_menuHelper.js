({
    closeConfirmHelper : function(component) {
        component.set("v.toConfirm", false);
    },
        changeLanguageHelper : function(component,language) {
        console.log("changeLanguageHelper"+language);
        var action = component.get("c.switchLanguage");
        action.setParams({
            newLanguage: language
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.toConfirm", true); 
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
})