({
  handleUploadFinished: function (component, event, helper) {
    console.log("handleUploadFinished start");
    var action = component.get("c.evalSetEvaluee");
    action.setParams({
      evalId: component.get("v.recordId")
    });
    action.setCallback(that, function (response) {
      console.log("handleUploadFinished callback start");
      var uploadedFiles = event.getParam("files");
      var action = component.get("c.updateEvaluationDocumentId");
      action.setParams({
        evalId: component.get("v.recordId"),
        evalDocumentId: uploadedFiles[0].documentId
      });
      $A.enqueueAction(action);
      console.log("updateEvaluationDocumentId finished");
      var fileUploadedEvent = component.getEvent("fileUploaded");
      fileUploadedEvent.fire();
      $A.get("e.force:refreshView").fire();
    });
    $A.enqueueAction(action);
    console.log("handleUploadFinished finished");
  }
});