@isTest
public class SerialSLATest {
    
    @isTest
    public static void actualizarSerialSLA(){
        Account nuevaCuenta = new Account(Name = 'Test');
        insert nuevaCuenta;
        Test.startTest();
        SerialSLA.asignarSerial(nuevaCuenta.Id);
        Test.stopTest();
        List<Account> lista = [SELECT  id FROM Account where SLASerialNumber__c != null];
        System.assertEquals(1,lista.size());
    }
}