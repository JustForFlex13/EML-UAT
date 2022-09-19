({
  doInit: function (component) {
    component.set("v.caseId", component.get("v.recordId"));
  }
});