@isTest
public class TestReservaTerminarBatch {
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
        
        //CONTACTO
        Contact cliente = new Contact(firstName = 'Toño', LastName = 'Gonzoles',Numero_de_identificacion__c = '1',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'tono@correo.com');
        insert cliente;
        //RESERVAS
        Opportunity reserva = new Opportunity(Titular_de_reserva__c =cliente.id , StageName = 'pre-venta', 
                                                     CloseDate = fecha, Name = 'Nombre', Pricebook2Id = negocio.Id);
        insert reserva;
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
        insert vuelo;
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=10000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        
        PricebookEntry entradaTurista = new PricebookEntry(Pricebook2Id = negocio.Id, UnitPrice=10000,Product2Id=vuelo.Id, IsActive = true);
        insert entradaTurista;
        //TIQUETES
        OpportunityLineItem tiqueteNuevo = new OpportunityLineItem(OpportunityId = reserva.Id, Quantity = 1,Product2Id = vuelo.Id, Pasajero__c = cliente.id, PricebookEntryId = entradaTurista.id);
        insert tiqueteNuevo;
    }
    
    @isTest
    public static void terminarReserva(){
        Test.startTest();
        ReservaTerminarBatch batch = new ReservaTerminarBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        List<Opportunity> reserva = [Select StageName from Opportunity where StageName = 'Terminado'];
        
        System.assertEquals(1, reserva.size());   
    }
}