({
	sendSearch : function(component, event, helper) {
        // Getting the event
        var searchEvent = component.getEvent("formsubmit");
        
        // Setting the param on the event
        searchEvent.setParams({ 
            "SIRET"         : component.get("v.SIRET"),
            "companyName"   : component.get("v.companyName"),
            "zipOrCity"     : component.get("v.zipOrCity")
        });
            
        // Fire the event so all the components can hear it
        searchEvent.fire();
    }
})