@isTest
public class TestReservaREST {
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
        Contact clienteExistente = new Contact(firstName = 'Toño', LastName = 'Gonzoles',Numero_de_identificacion__c = '1',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email ='correo@gmail.com');
        insert clienteExistente;
        Contact clienteExistente2 = new Contact(firstName = 'Tami', LastName = 'Gonzoles',Numero_de_identificacion__c = '2',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email ='correo@gmail.com');
        insert clienteExistente2;        
        //AVION
        Avion__c avion = new Avion__c(Name = 'Airbus A330', N_mero_de_pasajeros_clase_turista__c = 20, N_mero_de_pasajeros_clase_negocios__c = 20);
        insert avion;
        //AEROPUERTO
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(C_digo_IATA__c = 'AAA', Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Cali');
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        Product2 vuelo = new Product2(Name = 'AE-0001', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addDays(1),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(2),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        insert vuelo;
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=5000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        PricebookEntry entradaTurista = new PricebookEntry(Pricebook2Id = turista.Id, UnitPrice=10000,Product2Id=vuelo.Id, IsActive = true);
        insert entradaTurista;
        PricebookEntry entradanegocios = new PricebookEntry(Pricebook2Id = negocio.Id, UnitPrice=15000,Product2Id=vuelo.Id, IsActive = true);
        insert entradanegocios;
        //RESERVA
        Opportunity reservaTurista = new Opportunity(Titular_de_reserva__c =clienteExistente.id , StageName = 'pre-venta', 
                                                     CloseDate = fecha, Name = 'Nombre', Pricebook2Id = turista.Id);
        insert reservaTurista;
    }
    
    
    @isTest static void postActualizarReserva(){
        PricebookEntry entrada = [SELECT id FROM PricebookEntry WHERE UnitPrice=10000 limit 1];
        ReservaREST.resultadoPostWrapper result = ReservaREST.reservaPost(entrada.id, '', '', '', '1', 'Cédula de ciudadania');
        Opportunity reserva = [SELECT id, StageName FROM Opportunity];
        System.assertEquals('Completado', reserva.stageName);
        System.assertEquals('Reserva actualizada', result.mensaje);
    }
    @isTest static void postCrearClienteReserva(){
        PricebookEntry entrada = [SELECT id, Pricebook2Id FROM PricebookEntry WHERE UnitPrice=5000 limit 1];
        ReservaREST.resultadoPostWrapper result = ReservaREST.reservaPost(entrada.id, 'Juan', 'Lopez', 'lopez@correo.com', '3', 'Cédula de ciudadania');
        Opportunity reserva = [SELECT id, StageName FROM Opportunity where Pricebook2Id =: entrada.Pricebook2Id];
        System.assertEquals('pre-venta', reserva.stageName);
        System.assertEquals('Cliente nuevo creado', result.mensaje);
    }
    @isTest static void postCrearReserva(){
        PricebookEntry entrada = [SELECT id FROM PricebookEntry WHERE UnitPrice=10000 limit 1];
        ReservaREST.resultadoPostWrapper result = ReservaREST.reservaPost(entrada.id, '', '', '', '2', 'Cédula de ciudadania');
        System.assertEquals('Se ha creado una reserva', result.mensaje);
    }
    
    @isTest static void patchReservaPagada(){
        Product2 vuelo = [SELECT id FROM Product2 LIMIT 1];
        Opportunity reserva = [SELECT id, Titular_de_reserva__c, Titular_de_reserva__r.Email, Titular_de_reserva__r.Name, name, stageName, Valor_total__c FROM Opportunity limit 1];
        OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = reserva.id, Product2Id = vuelo.id, Pasajero__c = reserva.Titular_de_reserva__c, Quantity = 1, Equipaje_permitido__c = 'Personal');
        insert tiquete;
        RestRequest request = new RestRequest();
        request.requestUri = 'https://yourInstance.my.salesforce.com/services/apexrest/Product2/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"idReserva": "'+ reserva.id+'", "pago" : "Autorizado"}');
        RestContext.request = request;
        string respuesta = ReservaREST.reservaPagada(reserva.id, 'Autorizado');
        
        System.assertEquals('Pago realizado con éxito', respuesta);
    }
    
    
    @isTest static void patchReservaPagadaErrorPago(){
        Product2 vuelo = [SELECT id FROM Product2 LIMIT 1];
        Opportunity reserva = [SELECT id, Titular_de_reserva__c, Titular_de_reserva__r.Email, Titular_de_reserva__r.Name, name, stageName, Valor_total__c FROM Opportunity limit 1];
        OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = reserva.id, Product2Id = vuelo.id, Pasajero__c = reserva.Titular_de_reserva__c, Quantity = 1, Equipaje_permitido__c = 'Personal');
        insert tiquete;
        RestRequest request = new RestRequest();
        request.requestUri = 'https://yourInstance.my.salesforce.com/services/apexrest/Product2/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"idReserva": "'+ reserva.id+'", "pago" : "No Autorizado"}');
        RestContext.request = request;
        string respuesta = ReservaREST.reservaPagada(reserva.id, 'No Autorizado');
        System.assertEquals('Pago no autorizado, por favor validar la información', respuesta);
    }
	
}