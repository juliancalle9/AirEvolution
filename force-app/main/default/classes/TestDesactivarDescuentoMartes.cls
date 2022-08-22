@isTest
public class TestDesactivarDescuentoMartes {
	@TestSetup
    static void makeData(){
        
        Pricebook2 newPricebook = new Pricebook2(Name = 'Clase negocio');
        insert newPricebook;
        String pricebookId = Test.getStandardPricebookId();
        
        Avion__c plane = new Avion__c(N_mero_de_pasajeros_clase_turista__c = 30, N_mero_de_pasajeros_clase_negocios__c = 46, Name ='Airbus A330');
        insert plane;
        
        Aeropuerto__c airport = new Aeropuerto__c(Name = 'Airport1', C_digo_IATA__c = 'AI1');
        Aeropuerto__c airport2 = new Aeropuerto__c(Name = 'Airport2', C_digo_IATA__c = 'IA2');
        insert airport;
        insert airport2;
        
        Product2 flight = new Product2(Name = 'AE-2432', Avion__c = plane.Id, Fecha_y_hora_de_partida__c = datetime.now()+ 4, Fecha_y_hora_estimada_de_llegada__c = (datetime.now() + 4).addHours(4),
                                 Aeropuerto_de_partida__c = airport.Id, Aeropuerto_de_llegada__c = airport2.Id, IsActive = true, Estado__c = 'En venta');
        
        insert flight;
        PricebookEntry newPricEntry2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = flight.Id, UnitPrice = 234233, IsActive = true, Descuento_del_50__c = false, Descuento_de_martes__c= true);
        insert newPricEntry2;
      	PricebookEntry newPricEntry = new PricebookEntry(Pricebook2Id = newPricebook.Id, Product2Id = flight.Id, UnitPrice = 25325, IsActive = true, Descuento_del_50__c = false, Descuento_de_martes__c= true);
      	insert newPricEntry;
    }
    
    @isTest
    static void testBatch(){
        Test.startTest();
        desactivacionDescuentoMartes batchTest = new desactivacionDescuentoMartes();
        Id processId = Database.executeBatch(batchTest);
        Test.stopTest();
        List<PricebookEntry> pricEntry = [SELECT Id FROM PricebookEntry];
        System.assertEquals(2, pricEntry.size());
    }
}