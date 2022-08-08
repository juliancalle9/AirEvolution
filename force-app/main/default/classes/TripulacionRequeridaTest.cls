@isTest
public class TripulacionRequeridaTest {
 
    @TestSetup
    static void makeData(){
        Contact auxiliar = new contact(LastName = 'Juan', Nacionalidad__c = 'alemán', 
                                       Tipo_de_identificacion__c = 'Cédula de Ciudadania', Numero_de_identificacion__c = '23456', RecordTypeId = '0128a000000UxlbAAC');
        Contact auxiliar2 = new contact(LastName = 'Marta', Nacionalidad__c = 'alemán', 
                                       Tipo_de_identificacion__c = 'Cédula de Ciudadania', Numero_de_identificacion__c = '9566846', RecordTypeId = '0128a000000UxlbAAC');
        
        insert auxiliar;
        insert auxiliar2;
        Avion__c avion = new Avion__c(N_mero_de_pasajeros_clase_negocios__c = 20, N_mero_de_pasajeros_clase_turista__c = 20, Name  ='Airbus A330');
        insert avion;
        Aeropuerto__c aeropuerto1 = new Aeropuerto__c(name = 'prueba1', C_digo_IATA__c = 'AAA');
        Aeropuerto__c aeropuerto2 = new Aeropuerto__c(name = 'prueba2', C_digo_IATA__c = 'BBB');
        Product2 vuelo = new Product2(Name = 'AV-0001',
                                 Avion__c = avion.Id,
                                 Fecha_y_hora_de_partida__c = datetime.now()+8/7,
                                 Fecha_y_hora_estimada_de_llegada__c = (datetime.now()+8/7).addHours(1),
                                 Aeropuerto_de_partida__c = aeropuerto1.Id,
                                 Aeropuerto_de_llegada__c = aeropuerto2.id,
                                 IsActive = true,
                                 Estado__c = 'En venta');
        insert vuelo;
        Tripulacion__C tripulante = new Tripulacion__c(Contacto__c = auxiliar.id, Vuelo__c = vuelo.id);
        insert tripulante;
        
    }

    @isTest
    private static void obtieneUnVuelo(){
        
        
            List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.obtenerVuelos();
       		System.assertEquals(1, vuelos.size());
    }

    @isTest
    private static void obtieneMuchosVuelos(){
        List<Product2> lista = new List<Product2>();
        Aeropuerto__c aeropuerto1 = new Aeropuerto__c(name = 'prueba1', C_digo_IATA__c = 'AAA');
        Aeropuerto__c aeropuerto2 = new Aeropuerto__c(name = 'prueba2', C_digo_IATA__c = 'BBB');
        Avion__c avion = new Avion__c(N_mero_de_pasajeros_clase_negocios__c = 20, N_mero_de_pasajeros_clase_turista__c = 20, Name  ='Airbus A330');
        insert avion;
        for(integer i = 0; i < 199; i++){
            Product2 vuelos = new Product2(Name = 'AV-10'+ i,
                                Avion__c = avion.Id,
                                Fecha_y_hora_de_partida__c = datetime.now()+2,
                                Fecha_y_hora_estimada_de_llegada__c = (datetime.now()+2).addHours(1),
                                Aeropuerto_de_partida__c = aeropuerto1.Id,
                                 Aeropuerto_de_llegada__c = aeropuerto2.id,
                                IsActive = true,
                                Estado__c = 'En venta');
            lista.add(vuelos);
        }
        insert lista;
        Test.startTest();
        try{
            List<TripulacionRequerida.vuelo> pruebaVuelos = TripulacionRequerida.obtenerVuelos(); 
        	System.assertEquals(200, pruebaVuelos.size());
        }catch(exception e){
            
        }
        Test.stopTest();
        
    }
    
    @isTest
    private static void obtenerAuxiliaresTest(){
            List<Product2> vuelo = [select id from Product2 limit 1];
            for(Product2 v: vuelo){
                List<TripulacionRequerida.opcion> lista= TripulacionRequerida.opcion.getAuxiliares(v.id);
                System.assertEquals(3, lista.size());
            }
    }
    
    @isTest
    private static void saveAuxiliaresTest(){
        List<Contact> auxiliares = [Select id from contact limit 2];
        List<String> ids = new List<String>();
        for(Contact c: auxiliares){
            ids.add(c.id);
        }
        
        List<product2> vuelo = [select id from product2 limit 1];
        for(Product2 v: vuelo){
            TripulacionRequerida.saveAuxiliares(ids, v.id);
        }
        
        for(Product2 v: vuelo){
            List<TripulacionRequerida.opcion> lista= TripulacionRequerida.opcion.getAuxiliares(v.id);
            System.assertEquals(4, lista.size());
        }
    }
    
    private static void exceptionObtenerVuelos(){
        List<Avion__c> avion = [select id from avion__c limit 1];
        delete avion;
        
        try{
            List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.obtenerVuelos();
            
        }catch(Exception e){
            List<avion__c> vuelos = [Select id from avion__c limit 1]; 
       		System.assertEquals(1, vuelos.size());
        }
        
    }
}