@isTest
public class InactiveAccountsTest {
 @TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(integer i = 0; i < 50; i++){
            accts.add(new Account(name = 'test'+i, SLA__c = 'Gold', 
                        SLAExpirationDate__c = Date.today(), UpsellOpportunity__c = 'No'));
        }

        insert accts;
    }

    @IsTest
    static void methodName(){        
        Test.startTest();
        InactiveAccounts batchClass = new InactiveAccounts('Gold', Date.today()); 
        ID batchprocessid = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<Account> accts = [SELECT Id 
                                FROM Account 
                                WHERE SLA__c='Gold'
                                AND SLAExpirationDate__c <: Date.today()
                                AND UpsellOpportunity__c = 'No'];
        
        System.assertEquals(0,accts.size());
    }
}