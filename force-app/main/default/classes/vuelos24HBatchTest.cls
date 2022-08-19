@isTest
public class vuelos24HBatchTest {
	@testSetup
    static void setup(){
        datetime fechaPartida = datetime.now();
        datetime fechaLlegada = datetime.now();
        date fecha = date.today();
        //LISTA DE PRECIOS 
        string pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );
        Pricebook2 turista = new Pricebook2(Name = 'Turista',IsActive = true);
        insert turista;
        
        Pricebook2 negocio = new Pricebook2(Name = 'Tiquete negocios',IsActive = true);
        insert negocio;
        update standardPricebook;
        //CONTACTOS
        Contact clienteVuelo = new Contact(firstName = 'Toño', LastName = 'Gonzoles',Numero_de_identificacion__c = '1',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'tono@correo.com');
        Contact clienteVueloViejo = new Contact(firstName = 'Tammy', LastName = 'Gonzoles',Numero_de_identificacion__c = '2',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'tammy@correo.com');
        Contact clienteVuelo2 = new Contact(firstName = 'Ron', LastName = 'Lopez',Numero_de_identificacion__c = '3',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'ron@correo.com');
        insert clienteVuelo;
        insert clienteVuelo2;
        insert clienteVueloViejo;
        
        //RESERVAS
        Opportunity reservaTurista = new Opportunity(Titular_de_reserva__c =clienteVuelo.id , StageName = 'pre-venta', 
                                                     CloseDate = fecha, Name = 'Nombre', Pricebook2Id = negocio.Id);
        Opportunity reservaTurista2 = new Opportunity(Titular_de_reserva__c =clienteVueloViejo.id , StageName = 'pre-venta', 
                                                      CloseDate = fecha, Name = 'Nombre', Pricebook2Id = negocio.Id);
        Opportunity reservaTurista3= new Opportunity(Titular_de_reserva__c =clienteVuelo2.id , StageName = 'pre-venta', 
                                                      CloseDate = fecha, Name = 'Nombre', Pricebook2Id = pricebookId);
        insert reservaTurista;
        insert reservaTurista2;
        insert reservaTurista3;
        
        //AVION
        Avion__c avion = new Avion__c(Name = 'Airbus A330', N_mero_de_pasajeros_clase_turista__c = 20, N_mero_de_pasajeros_clase_negocios__c = 20);
        insert avion;
        
        //AEROPUERTO
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(C_digo_IATA__c = 'AAA', Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Antioquia');
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        
        //VUELO
        Product2 vuelo = new Product2(Name = 'AE-0001', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addDays(1),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(2),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        Product2 vuelo2 = new Product2(Name = 'AE-0003', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addDays(1),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(2),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        
        Product2 vueloAntiguo = new Product2(Name = 'AE-0002', Avion__c = avion.id, Estado__c = 'Terminado', fecha_y_hora_de_partida__c = fechaPartida.addDays(-3),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(-2),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        insert vuelo;
        insert vuelo2;
        insert vueloAntiguo;
        
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=10000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        
        PricebookEntry entrada2 = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=10000,Product2Id=vuelo2.Id,IsActive = true, Descuento_de_martes__c = true);
        insert entrada2;
        
        PricebookEntry entradaTurista = new PricebookEntry(Pricebook2Id = negocio.Id, UnitPrice=10000,Product2Id=vuelo.Id, IsActive = true);
        insert entradaTurista;
        
        //TIQUETES
        OpportunityLineItem tiqueteNuevo = new OpportunityLineItem(OpportunityId = reservaTurista.Id, Quantity = 1,Product2Id = vuelo.Id, Pasajero__c = clienteVuelo.id, PricebookEntryId = entradaTurista.id);
        OpportunityLineItem tiqueteDescuento = new OpportunityLineItem(OpportunityId = reservaTurista.Id, Quantity = 1,Product2Id = vuelo.Id, Pasajero__c = clienteVuelo.id, PricebookEntryId = entradaTurista.id);
        OpportunityLineItem tiqueteViejo = new OpportunityLineItem(OpportunityId = reservaTurista3.Id, Quantity = 1,Product2Id = vuelo2.Id, Pasajero__c = clienteVuelo2.id, PricebookEntryId = entrada2.id);
        insert tiqueteNuevo;
        insert tiqueteViejo;
    }
    
    @isTest					
    public static void aplicarDescuento50(){
    	Test.startTest();
        vuelos24HBatch batch = new vuelos24HBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        PricebookEntry entrada = [SELECT id, UnitPrice from PricebookEntry limit 1];
        
        System.assertEquals(5000, entrada.unitPrice);    
    }
    
   
    
    
}