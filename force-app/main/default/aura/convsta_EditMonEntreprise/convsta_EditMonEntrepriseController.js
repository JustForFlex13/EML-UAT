({
	onCheck: function(component) {

		component.set("v.otherString", component.get("v.otherString")?null:"sdvsdsvd");
	} , 
	doInit: function(component){
        // do custom rendering here
		component.set("v.otherString",component.get("v.otherAdress") );
	},
	handleSuccess: function(component){
		var savedEvent = component.getEvent("entrepriseSaved");
		// Fire the event so all the components can hear it
		savedEvent.fire();
	},
    handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        if( ! component.get("v.stageEnFranceBool") && !fields.Guide_des_bonnes_pratiques__c){
            
        }
        component.find('myRecordForm').submit(fields);
    },
})