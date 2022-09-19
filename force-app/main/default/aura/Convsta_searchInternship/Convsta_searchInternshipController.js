({
	searchJS : function(component, event, helper) {
		var inputCountry = 		component.get('v.inputCountry');
		var inputCity = 		component.get('v.inputCity');
		var inputProgram = 		component.get('v.inputProgram');
		var inputNaf = 			component.get('v.inputNaf');
		var inputCompanyName = 	component.get('v.inputCompanyName');
		var inputTitle = 		component.get('v.inputTitle');

		var action = component.get('c.search');
		var inputForm = {	country: 		inputCountry,
					 		city:    		inputCity,
					 		programme: 		inputProgram,
					 		naf	:			inputNaf,
					 		companyName: 	inputCompanyName,
					 		title: 			inputTitle};
		action.setParams({input: inputForm});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var returnValue = response.getReturnValue();                
                component.set("v.outputResults", returnValue.lOutputs); 
			}
		});
		$A.enqueueAction(action);
	}
})