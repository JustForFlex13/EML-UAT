/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_SIS_Evaluation_methodsTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_SIS_Evaluation_methodsTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new SIS_Evaluation_methods__c());
    }
}