@isTest
public class TestVuelosTriggerHandler {
    
    @isTest
    public static void testDesactivarVuelo(){
        Avion__c avion = new Avion__c(Name = 'Avion');
        Product2 vuelo1 = new Product2(Name = 'Vuelo', Avion__c = avion.Id,Estado__c = 'En venta',IsActive = true);
        insert vuelo1;
        
        
        vuelo1.Estado__c = 'Terminado';
        Test.startTest();
        Database.saveResult resultado = database.update(vuelo1);
        Test.stopTest();
        
        System.assertEquals(true, resultado.isSuccess());
    }
    
    @isTest
    public static void terminarVuelo(){
        Avion__c avion = new Avion__c(Name = 'Avion');
        Product2 vuelo1 = new Product2(Name = 'Vuelo', Avion__c = avion.Id,Estado__c = 'En venta',IsActive = true);
        insert vuelo1;
        
        vuelo1.Estado__c = 'Cancelado';
        vuelo1.Motivo_de_cancelacion__c = 'Sobreventa';
        Test.startTest();
        Database.saveResult resultado = database.update(vuelo1);
        Test.stopTest();
        System.assertEquals(true, resultado.isSuccess());
    }
    
    
    
    
}