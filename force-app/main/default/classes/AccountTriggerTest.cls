@isTest
public class AccountTriggerTest {
    
    @isTest
    public static void insercionDeCaso(){
        Account cuenta = new Account(Name = 'prueba');
        insert cuenta;
        Case caso = [Select status from Case limit 1];
        System.assertEquals('Dedupe this Account', caso.subject);
        
    }
    
    @isTest
    public static void insercionMasiva(){
        List<Account> lista = new List<Account>();
        for(Integer i = 0; i < 100; i++){
            Account cuenta = new Account(Name = 'prueba' + i);
            lista.add(cuenta);
        }
        insert lista;
        System.assertEquals(100, [select count() from Case where subject = 'Dedupe this Account']);
        
    }
}