({
    doInit : function(component, event, helper) {
        console.log('Yo');
        var labelSubStr = component.get("v.labelName");
        console.log(labelSubStr);
        if(labelSubStr!==null && labelSubStr!==''){
            var labelReference = $A.getReference("$Label.c." + labelSubStr);
            console.log(labelReference.toString());
            component.set("v.tempLabelAttr", labelReference);
            console.log('AAAA');
			var dynamicLabel = component.get("v.tempLabelAttr");  
            console.log('AAAA'+dynamicLabel);
            component.set("v.labelcontent",dynamicLabel);    
        }
        
    }
})