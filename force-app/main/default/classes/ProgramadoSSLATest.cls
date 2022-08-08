@isTest
public class ProgramadoSSLATest {
	static testmethod void test() {
   	Test.startTest();
        	List<Account> accts = new List<Account>();
        	for(integer i = 0; i < 50; i++){
            	accts.add(new Account(name = 'test'+i));
        	}

        	insert accts;
    }   
}