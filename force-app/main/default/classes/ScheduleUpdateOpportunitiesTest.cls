@isTest 
public class ScheduleUpdateOpportunitiesTest
{
    @isTest public static void testSchedule() {
    	Test.startTest();
        
		ScheduleUpdateOpportunities schedule = new ScheduleUpdateOpportunities();
        String sch = '0 0 2 10 2 ? *'; 
        System.schedule('Test Territory Check', sch, schedule); 
        
        Test.stopTest();
    } 
}