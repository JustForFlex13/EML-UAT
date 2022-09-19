({
	doInit: function (component, event, helper) {
		helper.loadRating(component, event, helper, true);
        helper.setBoldText(component, event, helper);
	}, 
 
	loadRating: function (component, event, helper) {
		helper.loadRating(component, event, helper, false);
	},
	doRate: function (component, event, helper) {
		if (component.get('v.isReadOnly') === true) {
			return;
		}
        
		var isNa = event.target.dataset.idx == 'n/a';
		var clickedRate;
		if (isNa) {
			clickedRate = 'n/a';
			var btn = component.find('na-btn');
			$A.util.addClass(btn, 'slds-button_destructive');

		}
		else {
			clickedRate = (event.target.dataset.idx * 1) + 1;
			var btn = component.find('na-btn');
			$A.util.removeClass(btn, 'slds-button_destructive');
		}

		helper.setRating(component, event, helper, clickedRate);

		var evt = $A.get('e.c:Convsta_eval_spinner');
		evt.setParams({
			'showSpinner': true
		});
		evt.fire();

		helper.upsertRating(component);
	}
})