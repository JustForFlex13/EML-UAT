/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_SIS_Learning_HourTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_SIS_Learning_HourTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new SIS_Learning_Hour__c());
    }
}