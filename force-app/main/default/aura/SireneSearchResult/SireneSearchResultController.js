({
	doSearch : function(component, event, helper) {
		component.set("v.noSearch",		true);
		var params = event.getParam('arguments');
		console.log("in SireneSearchResult onSearch8 "+JSON.stringify(params));
        if (params) {
			// Apex method
			var action = component.get("c.search");
			let isCP = (Number(params.SIRET.zipOrCity)?true:false);
			action.setParams({
				"denomination"	: params.SIRET.companyName,
				"zipCode"		: isCP ? params.SIRET.zipOrCity : '',
				"city"			: isCP ? '' : params.SIRET.zipOrCity,
				"siret"			: params.SIRET.SIRET
			});

			action.setCallback(this, (response) => {
				var state = response.getState();
				if (state === "SUCCESS") {
					//assign the returned values
					console.log('yyoyo3'+response.getReturnValue())
					var record = JSON.parse(response.getReturnValue());
					component.set("v.noSearch",		false);
					component.set("v.debugString", 	response.getReturnValue());
					component.set("v.returnRes", 	record);
					component.set("v.tooMany",		record.header.statut==200 && record.header.nombre<record.header.total);
					component.set("v.zeroRes",		record.header.statut==404);
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
						}
					}
				}
				// Getting the event
				var loadedEvent = component.getEvent("dataLoaded");
				console.log("getting ready to fire !!"+loadedEvent);
				// Fire the event so all the components can hear it
				loadedEvent.fire();
				console.log('did you see it ?');
			});
			$A.enqueueAction(action);
        }
	},
	clickCompany: function(component, event, helper){
		let sourceValue =event.getSource().get("v.value");
		component.set("v.selectedSiret",sourceValue);
		let x;
		let companyList =component.get("v.returnRes").etablissements;
		for(x in companyList){
			if(sourceValue===companyList[x].siret){
				component.set("v.selectedCompany",	companyList[x]);
				component.set("v.debugString",		JSON.stringify(companyList[x]));
				break;
			}
		}
	}
})