@isTest
public class InclusionNullSerialTest {
	@TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(integer i = 0; i < 200; i++){
            accts.add(new Account(name = 'test'+i));
        }

        insert accts;
    }
    
    @isTest
    public static void testCuentas(){
        InclusionNullSerial prueba = new InclusionNullSerial();
        Test.startTest();
        System.enqueueJob(prueba);
        Test.stopTest();
        List<Account> accts = [SELECT Id 
                                FROM Account 
                                WHERE SLASerialNumber__c != null];
        System.assertEquals(200, accts.size());
    }

}