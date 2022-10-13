/**
* @author SEASON
* @date 2022
* @description Unit tests for SIS_CTRL_CustomRelatedList class.
*/
@isTest
private class SIS_CTRL_CustomRelatedList_TEST {
    // OK scenarios are tested in classes setup to be called by this utility class.
    
    /************************************************************************************************************
    * @description : Runs the fetchRecords method with invalid parameters. 
    * @result      : A managed error is thrown.
    *************************************************************************************************************/
    @isTest
    public static void fetchRecords_KO_TestCase() {
        String lv_errorMsg;

        Test.startTest();
        try {
            SIS_CTRL_CustomRelatedList.fetchRecords('fakeClassName', 'fakeMethodName', 'fakeParam');
        } catch (Exception ex) {
            lv_errorMsg = ex.getMessage();
        }
        Test.stopTest();

        System.assertNotEquals(null, lv_errorMsg);
    }
}