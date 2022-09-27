@isTest
public class ClimaRestTest {
	@testSetup
    static void setup(){
        datetime fechaPartida = datetime.now();
        datetime fechaLlegada = datetime.now();
        date fecha = date.today();
        //AVION
        Avion__c avion = new Avion__c(Name = 'Airbus A330', N_mero_de_pasajeros_clase_turista__c = 20, N_mero_de_pasajeros_clase_negocios__c = 20);
        insert avion;
        //AEROPUERTO
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(C_digo_IATA__c = 'AAA', Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Cali',
                                                         localizacion__latitude__s = 10.00, localizacion__longitude__s = 10.00);
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        //VUELO
        Product2 vuelo = new Product2(Name = 'AE-0001', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addDays(1),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(1),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        insert vuelo;
    }
    
    @isTest static void testGetClimaPartida(){
        Aeropuerto__c aero = [SELECT id,localizacion__latitude__s,localizacion__longitude__s from aeropuerto__c where name = 'aeropuerto0'];
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('getClima');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        clima__c result = ClimaRest.llamadaOpenweather(aero.localizacion__latitude__s, aero.localizacion__longitude__s, aero.id);
        Test.stopTest();
        System.assertEquals(25.4, result.Temperatura__c); 
        
    }
    
}