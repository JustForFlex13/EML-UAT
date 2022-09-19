({
	doInit: function(component) {
        var action = component.get("c.isEvaluee");
        action.setParams({ demandeId : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var temp = response.getReturnValue();
                var doc = new DOMParser().parseFromString(temp, "text/xml");
                var url = doc.firstChild.getAttribute('href');
				
                console.log('url pour Evaluation : ', url);
                component.set("v.evalLien", url); 
                
        		$A.enqueueAction(component.get('c.setEvalDownloadLink'));
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    setEvalDownloadLink: function(component) {
        var action = component.get("c.getEvalDownloadLink");
        action.setParams({ demandeId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var temp = response.getReturnValue();
                var doc = new DOMParser().parseFromString(temp, "text/xml");
                var url = doc.firstChild.getAttribute('href');

                component.set("v.evalDownloadLien", url); 
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})