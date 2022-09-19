({
    handleClick : function (cmp, event, helper) {        
        var action = cmp.get("c.setDetailStatusSignataires");
        console.log("2"+cmp.get("v.recordId"));
        action.setParams({
            demandeId: cmp.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                var serverResponse = response.getReturnValue();
                $A.get("e.force:refreshView").fire();
            }
            else{
                let resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "appel en erreur" ,
                    "message": response.getError()+"si le problème persiste veuillez prendre contact avec votre administrateur",
                    "type":"error"
                });
                resultsToast.fire();  
            }            
        });
        $A.enqueueAction(action);
    },
    
    handleClickCancel : function (cmp, event, helper) {        
        var action = cmp.get("c.setCancelSignatures");
        console.log("Cancel Sign"+cmp.get("v.recordId"));
        action.setParams({
            demandeId: cmp.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                var serverResponse = response.getReturnValue();
                $A.get("e.force:refreshView").fire();
            }
            else{
                let resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "annulation en erreur" ,
                    "message": response.getError()+"si le problème persiste veuillez prendre contact avec votre administrateur",
                    "type":"error"
                });
                resultsToast.fire();  
            }            
        });
        $A.enqueueAction(action);
    }
})