({
    doInit : function(component, event, helper) {
        var action = component.get("c.getFileIdList");
        if(component.get("v.recordId")){
            action.setParams({
                caseId: component.get("v.recordIdTest")||component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    component.set("v.docList",response.getReturnValue())
                }
            });
            $A.enqueueAction(action);    
        }
    },
})