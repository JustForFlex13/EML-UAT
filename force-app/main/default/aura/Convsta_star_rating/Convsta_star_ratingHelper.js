({
    /*round: function (value, step) {
		// rounds to the nearest "step" decimal. Here, step=0.5
		step || (step = 1.0);
		var inv = 1.0 / step;
		return Math.round(value * inv) / inv;

	}*/
	round: function (value) {
        if(value == 'n/a') {
            return value;
        }

		if (Math.floor(value) != value) {
			value = Math.floor(value) + 0.5;
		}
		return value;
	},
	loadRating: function (component, event, helper, isFromDoinit) {
		var nbStars = helper.round(component.get('v.rating'));
        //console.log('competence : ', JSON.parse(JSON.stringify(component.get('v.competence'))));
		helper.setRating(component, event, helper, nbStars, isFromDoinit);
	},
	setRating: function (component, event, helper, newRate, isFromDoinit) {
		if (newRate == 'n/a') {
			component.set('v.rating', 'n/a');
			var theCompetenceTemp = component.get('v.competence');
			theCompetenceTemp.rating__c = 'n/a';

			component.set('v.competence', theCompetenceTemp);
            var noStars = ['empty','empty','empty','empty','empty'];
            component.set('v.stars', noStars);
			return;
		}
		if (isNaN(newRate) ) {
			newRate = 0;
		}
		var stars = [];
		var ratingTemp = 0;
		for (var i = 0; i < newRate; i++) {
			stars.push("full");
			ratingTemp++;
		}

		if (ratingTemp == 0 && !isFromDoinit) {
			var btn = component.find('na-btn');
			$A.util.addClass(btn, 'slds-button_destructive');
		}
		component.set('v.rating', ratingTemp);
		var theCompetenceTemp = component.get('v.competence');
		//theCompetenceTemp.rating = ratingTemp;
		theCompetenceTemp.rating__c = ratingTemp;

		component.set('v.competence', theCompetenceTemp);

		if (stars.length < 5) {
			for (var i = stars.length; i < 5; i++) {
				stars.push("empty");
			}
		}
		component.set('v.stars', stars);
	},
	upsertRating: function (component) {
		if (component.get('v.isReadOnly') === true) {
			return;
		}
		var competenceStr = JSON.stringify(component.get("v.competence"));
		var action = component.get("c.upsertCompetence");
		action.setParams({
			'competenceStr': competenceStr
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var evt = $A.get('e.c:Convsta_eval_spinner');
				evt.setParams({
					'showSpinner': false
				});
				evt.fire();
				var evt = $A.get('e.c:Convsta_eval_ratingChanged');
				evt.fire();
			}
			else if (state === "INCOMPLETE") {
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " +
							errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},
    setBoldText: function (component, event, helper) {
        var oneComp = component.get('v.competence');
        var mission = component.get('v.mission');
        if(
            oneComp.type__c == '2Comportement' &&  
            (
                (oneComp.Label_fr__c =="Qualifier et identifier l'information" && mission.Qualifier_et_identifier_l_information__c== true)||
                (oneComp.Label_fr__c =='Etre précis et rigoureux au travail' && mission.Precision_et_rigueur_au_travail__c== true)||
                (oneComp.Label_fr__c =='Gérer son temps et les priorités' && mission.Gerer_son_temps_et_les_priorites__c== true)||
                (oneComp.Label_fr__c =='Mobiliser différentes sources' && mission. Mobiliser_differentes_sources__c== true)||
                (oneComp.Label_fr__c =='Élaborer un diagnostic' && mission.Elaborer_un_diagnostic__c== true)||
                (oneComp.Label_fr__c =='Gérer son stress' && mission.Gerer_son_stress__c == true)||
                (oneComp.Label_fr__c =='Démontrer un comportement assertif' && mission.Demontrer_un_comportement_assertif__c== true)||
                (oneComp.Label_fr__c =='Conceptualiser et modéliser' && mission.Conceptualiser_et_modeliser__c== true)
            )
        ){
            component.set( "v.selectedByStudent" ,true);
        }
    }

})