@isTest
public class reservaControllerTest {
	@testSetup
    static void makeData(){
        date fecha = date.today();
        datetime fechaPartida = datetime.now();
        datetime fechaLlegada = datetime.now();
        
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
        
        //CLIENTES Y PASAJEROS
        Contact clienteExistente = new Contact(firstName = 'Toño', LastName = 'Gonzoles',Numero_de_identificacion__c = '1',
                                               Tipo_de_identificacion__c = 'Cédula de ciudadania');
        Contact clienteExistente2 = new Contact(firstName = 'Tona', LastName = 'Gonzoles',Numero_de_identificacion__c = '2',
                                                Tipo_de_identificacion__c = 'Cédula de ciudadania');
        Contact clienteExistente3 = new Contact(firstName = 'Juan', LastName = 'Juan',Numero_de_identificacion__c = '3',
                                                Tipo_de_identificacion__c = 'Cédula de ciudadania');
        insert clienteExistente;
        insert clienteExistente2;
        insert clienteExistente3;
        //RESERVAS
        Opportunity reservaTurista = new Opportunity(Titular_de_reserva__c =clienteExistente.id , StageName = 'pre-venta', 
                                                     CloseDate = fecha, Name = 'Nombre', Pricebook2Id = turista.Id);
        Opportunity reservaTurista2 = new Opportunity(Titular_de_reserva__c =clienteExistente2.id , StageName = 'No pagado', 
                                                      CloseDate = fecha, Name = 'Nombre', Pricebook2Id = turista.Id);
        insert reservaTurista;
        insert reservaTurista2;
        
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
        Product2 vuelo = new Product2(Name = 'AE-0001', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addDays(8),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(9),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        insert vuelo;
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=5000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        
        PricebookEntry entradaTurista = new PricebookEntry(Pricebook2Id = turista.Id, UnitPrice=5000,Product2Id=vuelo.Id, IsActive = true);
        insert entradaTurista;
        
        OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = reservaTurista.id, Product2Id = vuelo.id, Pasajero__c = reservaTurista.Titular_de_reserva__c, Quantity = 1, Equipaje_permitido__c = 'Personal');
        insert tiquete;
    }
    
    @isTest public static void pruebaController(){
        Opportunity reserva = [SELECT id FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.TiquetesPDF;
        pageRef.getparameters().put('recordId', reserva.id);  
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController sc = new Apexpages.StandardController(reserva);
        tiquetesParaPDF ext = new  tiquetesParaPDF(sc);
        List<Object> tiq = ext.tiquetes;
        List<OpportunityLineItem> tiquete = [SELECT id FROM OpportunityLineItem];
        System.assertEquals(1, tiquete.size());
        
    }
    
}