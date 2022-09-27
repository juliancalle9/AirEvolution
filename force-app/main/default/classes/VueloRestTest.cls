@isTest
public class VueloRestTest {
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
     
    
    @isTest static void getVuelosTest(){
        string fecha1 = '14-09-2022';
        string fecha2 = '16-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fecha1', fecha1);
        request.addParameter('fecha2', fecha2);
        request.addParameter('ciudadPartida', 'Cali');
        request.addParameter('ciudadDestino', 'Cali');
        request.httpMethod = 'GET';
        RestContext.request = request;
        VueloRest.ResultadoPeticionWrapper result = VueloRest.getVuelos();
        boolean respuesta;
        System.assertEquals(true, result.respuesta);
        System.assertEquals('Éxito', result.mensaje);
        System.assert(result.vuelos != null);
    }
    
    @isTest static void getVuelosFecha1ErrorTest(){
        string fecha1 = '06-09-202';
        string fecha2 = '08-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fecha1', fecha1);
        request.addParameter('fecha2', fecha2);
        request.addParameter('ciudadPartida', 'Cali');
        request.addParameter('ciudadDestino', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        VueloRest.ResultadoPeticionWrapper result = VueloRest.getVuelos();
        System.assertEquals(false, result.respuesta);
        System.assertEquals('Formato invalido para la fecha de partida. El formato es Dia-Mes-Año', result.mensaje);
        System.assert(result.vuelos == null);
    }  
    @isTest static void getVuelosFecha2ErrorTest(){
        string fecha1 = '06-09-2022';
        string fecha2 = '08-09-202';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fecha1', fecha1);
        request.addParameter('fecha2', fecha2);
        request.addParameter('ciudadPartida', 'Cali');
        request.addParameter('ciudadDestino', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        VueloRest.ResultadoPeticionWrapper result = VueloRest.getVuelos();
        System.assertEquals(false, result.respuesta);        
        System.assertEquals('Formato invalido para la fecha de llegada. El formato es Dia-Mes-Año', result.mensaje);
        System.assert(result.vuelos == null);
    }
    @isTest static void getVuelosCiudadPartidaErrorTest(){
        string fecha1 = '06-09-2022';
        string fecha2 = '08-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fecha1', fecha1);
        request.addParameter('fecha2', fecha2);
        request.addParameter('ciudadPartida', 'Cal');
        request.addParameter('ciudadDestino', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        VueloRest.ResultadoPeticionWrapper result = VueloRest.getVuelos();
        System.assertEquals(false, result.respuesta);
        System.assertEquals('No se encuentra esta ciudad de partida dentro de la lista de ciudades con vuelos', result.mensaje);
        System.assert(result.vuelos == null);
    }
    @isTest static void getVuelosCiudadDestinoErrorTest(){
        string fecha1 = '06-09-2022';
        string fecha2 = '08-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fecha1', fecha1);
        request.addParameter('fecha2', fecha2);
        request.addParameter('ciudadPartida', 'Cali');
        request.addParameter('ciudadDestino', 'Cal');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        VueloRest.ResultadoPeticionWrapper result = VueloRest.getVuelos();
        System.assertEquals(false, result.respuesta);
        System.assertEquals('No se encuentra esta ciudad de destino dentro de la lista de ciudades con vuelos', result.mensaje);
        System.assert(result.vuelos == null);
    }
    @isTest static void getVuelosSinVuelosTest(){
        string fecha1 = '06-09-2022';
        string fecha2 = '08-09-2022';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fecha1', fecha1);
        request.addParameter('fecha2', fecha2);
        request.addParameter('ciudadPartida', 'Miami');
        request.addParameter('ciudadDestino', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        VueloRest.ResultadoPeticionWrapper result = VueloRest.getVuelos();
        System.assertEquals(true, result.respuesta);
        System.assertEquals('No se han encontrado vuelos que coincidan con los parametros', result.mensaje);
        System.assert(result.vuelos.size() == 0);
    }

}