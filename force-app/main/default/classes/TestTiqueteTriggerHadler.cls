@isTest
public class TestTiqueteTriggerHadler {
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
        //CONTACTOS
        Contact clienteVuelo = new Contact(firstName = 'Toño', LastName = 'Gonzoles',Numero_de_identificacion__c = '1',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'tono@correo.com');
        insert clienteVuelo;
        //RESERVAS
        Opportunity reservaTurista = new Opportunity(Titular_de_reserva__c =clienteVuelo.id , StageName = 'pre-venta', 
                                                     CloseDate = fecha, Name = 'Nombre', Pricebook2Id = negocio.Id);
        insert reservaTurista;
        //AVION
        Avion__c avion = new Avion__c(Name = 'Airbus A330', N_mero_de_pasajeros_clase_turista__c =0 , N_mero_de_pasajeros_clase_negocios__c = 1);
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
        //ENTRADA LISTA DE PRECIOS
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=100001,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        PricebookEntry entradaTurista = new PricebookEntry(Pricebook2Id = negocio.Id, UnitPrice=10000,Product2Id=vuelo.Id, IsActive = true);
        insert entradaTurista;
        OpportunityLineItem tiqueteNuevo = new OpportunityLineItem(OpportunityId = reservaTurista.Id, Quantity = 1,Product2Id = vuelo.Id, Pasajero__c = clienteVuelo.id, PricebookEntryId = entradaTurista.id);
        insert tiqueteNuevo;
    }
    
    @isTest					
    public static void TestAsignarClaseNegocios(){
       	OpportunityLineItem tiquete = [SELECT id, Equipaje_Permitido__c from OpportunityLineItem limit 1];
        System.assertEquals('Personal;Maleta de cabina;Maleta de bodega', tiquete.Equipaje_Permitido__c);
    }
    
    @isTest	
    static void TestSobreventa(){
        date fecha = date.today();
        Contact contacto = new contact(firstName = 'Lucas', LastName = 'Sanchez',Numero_de_identificacion__c = '2',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'lucas@correo.com');
        insert contacto;
        Pricebook2 lista = [select id from Pricebook2 where Name = 'Tiquete negocios'];
        PricebookEntry entrada = [SELECT id from PricebookEntry where unitPrice =10000];
        Opportunity reservaTurista = new Opportunity(Titular_de_reserva__c =contacto.id , StageName = 'pre-venta', 
                                                     CloseDate = fecha, Name = 'Nombre1', Pricebook2Id = lista.Id);
        insert reservaTurista;
        Product2 vuelo = [SELECT id from Product2 limit 1];
        try{
            OpportunityLineItem tiqueteNuevo = new OpportunityLineItem(OpportunityId = reservaTurista.Id, Quantity = 1,Product2Id = vuelo.Id, Pasajero__c = contacto.id, PricebookEntryId = entrada.id);
            insert tiqueteNuevo;
            OpportunityLineItem tiqueteNuevo2 = new OpportunityLineItem(OpportunityId = reservaTurista.Id, Quantity = 1,Product2Id = vuelo.Id, Pasajero__c = contacto.id, PricebookEntryId = entrada.id);
            insert tiqueteNuevo2;
        }catch(exception e){
            system.assert(e.getMessage().contains('No es posible sobrevender los tiquetes'));
        }
    }
    
    @isTest
    static void TestpasajeroDeReserva(){
        date fecha = date.today();
        Contact contacto = new contact(firstName = 'Lucas', LastName = 'Sanchez',Numero_de_identificacion__c = '2',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania', email = 'lucas@correo.com');
        insert contacto;
        Pricebook2 lista = [select id from Pricebook2 where Name = 'Tiquete negocios'];
        PricebookEntry entrada = [SELECT id from PricebookEntry where unitPrice =10000];
        Opportunity reservaTurista = new Opportunity(Titular_de_reserva__c =contacto.id , StageName = 'pre-venta', 
                                                     CloseDate = fecha, Name = 'Nombre1', Pricebook2Id = lista.Id);
        insert reservaTurista;
        Product2 vuelo = [SELECT id from Product2 limit 1];
        OpportunityLineItem tiqueteNuevo = new OpportunityLineItem(OpportunityId = reservaTurista.Id, Quantity = 1,Product2Id = vuelo.Id, PricebookEntryId = entrada.id);
        insert tiqueteNuevo;
        System.assertEquals(tiqueteNuevo.Pasajero__c, null);
        
    }
}