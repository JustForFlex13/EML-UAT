@isTest 
public class SchdleInitDejaEuPremiereOpportuniteTest
{
    @isTest public static void testSchedule() {
    	Test.startTest();
        
		ScheduleInitDejaEuPremiereOpportunite schedule = new ScheduleInitDejaEuPremiereOpportunite();
        String sch = '0 0 2 1 9 ? *'; 
        System.schedule('Test Territory Check', sch, schedule); 
        
        Test.stopTest();
    }
 
}