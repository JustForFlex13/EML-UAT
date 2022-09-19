/*--------------------------------------------------------------------
-- - Purpose           : Trigger on Opportunity Line Item
--            
-- Maintenance History :
--
-- Date         Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  ------------------------------
-- 19/01/2018  T.CH  MODIS    1.0 	   Creation
-- 23/05/2018  T.CH  MODIS    2.0      Remove logic 
--                                     attachSession & createOppLineItem in Before
--------------------------------------------------------------------*/
trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, after insert, before update, after update, before delete) {

    if(Trigger.isBefore && Trigger.isInsert){          
        if (PAD.canTrigger('TR006OppLineItem2FieldsNull')){
            TR006OppLineItem2FieldsNull.initOpportunityLineItem(Trigger.new);
            TR006OppLineItem2FieldsNull.initFieldOpportunityLineItem(Trigger.new);
        }
        
        if (PAD.canTrigger('TR002ManageOpportunityLineItem')){
            TR002ManageOpportunityLineItem.addProductFilter(Trigger.new);
            TR002ManageOpportunityLineItem.checkIncrementCompteurOPPLine(Trigger.new, false);
            TR002ManageOpportunityLineItem.attachSession(Trigger.new);  
            TR002ManageOpportunityLineItem.createOppLineItem(Trigger.new);
        }
    }// End BeforeInsert
        
    if(Trigger.isAfter && Trigger.isInsert){        
        if(PAD.canTrigger('TR003ManageOpportunities')){
         	TR003ManageOpportunities.AssignOwnerToOppty(Trigger.newMap);   
        }
    }// End AfterInsert
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        if (PAD.canTrigger('TR002ManageOpportunityLineItem')){
            TR002ManageOpportunityLineItem.checkIncrementCompteurOPPLine(Trigger.new, false);
            TR002ManageOpportunityLineItem.attachSession(Trigger.new);
        }
    }// End BeforeUpdate
        
    if(Trigger.isAfter && Trigger.isUpdate){
        if (PAD.canTrigger('TR003ManageOpportunities')) {
            TR003ManageOpportunities.AssignOwnerToOppty(Trigger.newMap);
        }
    }// End AfterUpdate
}