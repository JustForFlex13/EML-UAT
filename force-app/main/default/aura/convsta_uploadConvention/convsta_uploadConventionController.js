({handleUploadFinished:function(component,event,helper){
        console.log("handleUploadFinished start");
        var action = component.get("c.caseSetDocumentAVerifier");
        action.setParams({
            caseId: component.get("v.caseId"),
            typeDocument: component.find("Convsta_Type_de_document__c").get("v.value")
        });
        action.setCallback(this, function(response) {
            console.log("handleUploadFinished callback start");
            var fileUploadedEvent = component.getEvent("fileUploaded");
            fileUploadedEvent.fire();
        });
        $A.enqueueAction(action); 
        console.log("handleUploadFinished finished");
    },
    disableUpload:function(component,event,helper){
        if(component.find("Convsta_Type_de_document__c").get("v.value") !== ""){
            component.set("v.uploadDisabled", false);
        }else{
            component.set("v.uploadDisabled", true);    
        }
    }
})