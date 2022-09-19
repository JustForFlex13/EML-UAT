({
	handleUploadFinished:function(component,event){
		console.log("handleUploadFinished start");
		var uploadedFiles = event.getParam("files");
        var action = component.get("c.shareFileToCommunity");
        console.log(component.get("v.recordId"));
        action.setParams({
			caseId: component.get("v.recordId"),
			documentId: uploadedFiles[0].documentId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action); 
        console.log("handleUploadFinished finished");
    }
})