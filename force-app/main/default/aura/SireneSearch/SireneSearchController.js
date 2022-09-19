({
	searchSiret : function(component, event, helper) {   	
        // The child component is the boat search result
        var childComponent = component.find('searchResult');
        // Call the public method search, on the child component
        childComponent.search({
			"SIRET" 		: event.getParam("SIRET"),
			"companyName" 	: event.getParam("companyName"),
			"zipOrCity" 	: event.getParam("zipOrCity")
		});
		helper.doToggle(component,event);
	},
	toggleSpinner :function (cmp, event, helper) {
        helper.doToggle(cmp,event);
    }
})