({
  handleUploadFinished: function (component, event, helper) {
    console.log("handleUploadFinished start");
    var action = component.get("c.uploadAvenant");
    var uploadedFiles = event.getParam("files");
    action.setParams({
      avenantId: component.get("v.recordId"),
      avenantcontentDocumentId: uploadedFiles[0].documentId
    });
    action.setCallback(that, function (response) {
      console.log("avenant upload finished");
      $A.get("e.force:refreshView").fire();
    });
    $A.enqueueAction(action);
    console.log("handleUploadFinished finished");
  }
});