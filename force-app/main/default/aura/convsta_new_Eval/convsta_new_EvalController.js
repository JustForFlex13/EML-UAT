({
  handleClick: function (component, event, helper) {
    var action = component.get("c.createEvalBackOffice");
    action.setParams({
      caseId: component.get("v.recordId")
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state == "SUCCESS") {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: $A.get("$Label.c.Convsta_succes"),
          type: "success",
          message: "évaluation créée"
        });
        toastEvent.fire();
        $A.get("e.force:refreshView").fire();
      } else {
        let errors = response.getError();
        let message = "Unknown error"; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors[0].message;
          console.log("error" + JSON.stringify(errors));
        }
        var toastEvent2 = $A.get("e.force:showToast");
        toastEvent2.setParams({
          title: $A.get("$Label.c.Convsta_erreur"),
          type: "error",
          message: message
        });
        toastEvent2.fire();
      }
    });

    $A.enqueueAction(action);
  }
});