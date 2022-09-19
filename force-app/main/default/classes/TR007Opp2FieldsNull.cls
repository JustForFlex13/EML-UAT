public class TR007Opp2FieldsNull{
    
    public static void initOpportunity(List<Opportunity> oList) { 
        for (Opportunity newO : oList)
        {
            newO.Code_Agresso_Opportunit__c= null;
            newO.InterfaceExternalId__c= null;
        }    
    }    
}