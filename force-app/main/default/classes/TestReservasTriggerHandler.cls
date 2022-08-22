@isTest
public class TestReservasTriggerHandler {
    
    @TestSetup
    static void makeData(){
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
		Contact clienteVuelo = new Contact(firstName = 'Toño', LastName = 'Gonzoles',Numero_de_identificacion__c = '1',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'tono@correo.com');
        insert clienteVuelo;
        Opportunity reserva = new Opportunity(Titular_de_reserva__c =clienteVuelo.id , StageName = 'pre-venta', CloseDate = fecha, Name = 'Nombre');
        Opportunity reserva2 = new Opportunity(Titular_de_reserva__c =clienteVuelo.id , StageName = 'pre-venta', CloseDate = fecha, Name = 'Nombre2', Pricebook2Id = pricebookId);
        insert reserva;
		insert reserva2;
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
		OpportunityLineItem tiqueteNuevo = new OpportunityLineItem(OpportunityId = reserva2.Id, Quantity = 1,Product2Id = vuelo.Id, Pasajero__c = clienteVuelo.id, PricebookEntryId = entrada.id);
		insert tiqueteNuevo;        
    }
    @isTest
    static void testValidacionVueloEnReserva(){
        try{
            Opportunity reserva = [SELECT id, StageName FROM Opportunity limit 1];
			reserva.StageName = 'Completado';
			update reserva;
        }catch(DmlException e){
           system.assert(e.getMessage().contains('Para completar o pagar una reserva, esta debe tener por lo menos un vuelo asignado.'));
        }    
    }
    
    @isTest
    static void testReservaPagada(){
        Opportunity reserva = [SELECT id, StageName, Fecha_de_pago__c FROM Opportunity WHERE Pricebook2Id != null];
        reserva.StageName = 'Pagado';
        update reserva;
        System.assertEquals('Pagado', reserva.StageName);
        
    }
}