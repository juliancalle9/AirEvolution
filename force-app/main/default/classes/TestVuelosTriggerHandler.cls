@isTest
public class TestVuelosTriggerHandler {
    
    @isTest
    public static void testDesactivarVuelo(){
        Avion__c avion = new Avion__c(Name = 'Avion');
        Product2 vuelos = new Product2(Name = 'Vuelo', Avion__c = avion.Id);
        
        
    }
}