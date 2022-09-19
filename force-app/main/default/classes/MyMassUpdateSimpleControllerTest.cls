/**
 * This class contains unit tests for validating the behavior of MassUpdateController
 * and triggers.
 */
@isTest
private class MyMassUpdateSimpleControllerTest {


    static testMethod void singleUpdateTest() {
    	Opportunity o = new Opportunity();
    	List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
    	setCtr.setSelected(new Opportunity[]{o});
        MyMassUpdateSimpleController controller = new MyMassUpdateSimpleController(setCtr);
		System.assertEquals(1, controller.getRecordSize());
		
		System.assert(controller.getFieldTypeOptions().size()>1);
		
		system.assertEquals(1, controller.objsToUpdate.size());
		
		String value = '123test';
		controller.fieldName='name';
		controller.valueToUpdate=value;	
		//controller.convertedFieldData = controller.convertUserInputToFieldData();	
		controller.step4();
		controller.step5();
		
		System.assert(o.name==value);
		
	    value ='123';
	    controller.step3();
	    controller.fieldName='amount';
	    controller.valueToUpdate=value;	
	    controller.step4();
	    controller.step5();
	    
	    System.assert(o.amount==decimal.valueOf(value));
	    
/*	    value ='true';
	    controller.fieldName='IsPrivate';
	    controller.step3();
	    controller.valueToUpdate=value;		
	    controller.step4();
	    controller.step5();
	    
	    System.assert(o.IsPrivate); */
	    // make sure no exception from display tips
	    System.assertEquals(controller.getFieldInfoToDisplay()!=null,true);
	    	    
	    value ='2009-4-7';
	    controller.fieldName='CloseDate';
	    controller.valueToUpdate=value;		
	    controller.step4();
	    controller.step5();
	    System.assert(o.CloseDate==Date.valueOf(value));
	    
	    value ='Closed';
	    controller.fieldName='StageName';
	    controller.valueToUpdate=value;		
	    controller.step4();
	    controller.step5();
	    System.assert(o.StageName=='Closed');
    }
    
 
    static testMethod void linkTest() {
    	Opportunity o = new Opportunity();
    	List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
    	setCtr.setSelected(new Opportunity[]{o});
        MyMassUpdateSimpleController controller = new MyMassUpdateSimpleController(setCtr);
		
		// verify following exceptions will not cause exception
		System.assert(controller.step1()!=null);
		System.assert(controller.step2()!=null);
		System.assert(controller.step3()!=null);
		System.assert(controller.step4()!=null);
		System.assert(controller.step5()!=null);
		//System.assert(controller.cancel()!=null);
		
		System.assert(controller.getFieldTypeOptions()!=null);
    }
    
    static testMethod void fieldTest() {
    	
    	List<Opportunity> oppList = new Opportunity[]{};
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        MyMassUpdateSimpleController controller = new MyMassUpdateSimpleController(setCtr);
        System.assert(controller.cancel()!=null);
		System.assert(controller.getFieldTypeOptions()==null);
    }
    
    static testMethod void miscTest() {
    	
    	List<Opportunity> oppList = new Opportunity[]{};
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        MyMassUpdateSimpleController controller = new MyMassUpdateSimpleController(setCtr);
		
		System.assert(controller.getNow(true)!=null);
		System.assert(controller.getNow(false)!=null);
		System.assert(controller.getRecordSize()==0);
		System.assert(controller.getPicklistValues()==null);
    }
}