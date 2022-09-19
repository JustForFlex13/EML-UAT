({
    closeConfirm: function(component, event, helper) {
        helper.closeConfirmHelper(component);
    },
    refreshPage: function(component,event, helper) {
        location.reload(true);
        helper.closeConfirmHelper(component);
    },
    logout : function(component, event, helper){
        window.location.replace("/internships/secur/logout.jsp?retUrl=%2Flogin");
    },
    changeFR : function(component, event, helper) {
        helper.changeLanguageHelper(component,'fr');
    },
    changeEN : function(component, event, helper) {
        helper.changeLanguageHelper(component,'en_US');
    },
    doInit : function(component, event, helper) {
		var browserType = navigator.sayswho= (function(){
			var ua= navigator.userAgent, tem,
				M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
			if(/trident/i.test(M[1])){
				tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
				return 'IE '+(tem[1] || '');
			}
			if(M[1]=== 'Chrome'){
				tem= ua.match(/\b(OPR|Edge)\/(\d+)/);
				if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
			}
			M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
			if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
			return M.join(' ');
		})();

		if (browserType.startsWith("IE")) {
			let resultsToast = $A.get("e.force:showToast");
			resultsToast.setParams({
				"title": "Warning",
				"message": $A.get("$Label.c.Convsta_AlertIE") ,
				"type": "warning"
			});
			resultsToast.fire();  
		}
        var getUserInfosAction = component.get("c.getUserInfos");
		getUserInfosAction.setCallback(this, function (response) {
			if (response.getState() === "SUCCESS") {
                var retVal = response.getReturnValue();
                if(retVal.Profile.UserType !='Guest'){
                    component.set("v.currUser", retVal);                    
                }
			}
		});
		$A.enqueueAction(getUserInfosAction);	
	},
})