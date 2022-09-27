@isTest
public class VueloTest {
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
        Product2 vuelo = new Product2(Name = 'AE-0001', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addMinutes(1),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(1),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        Product2 vuelo2 = new Product2(Name = 'AE-0002', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addMinutes(-30),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(3),Aeropuerto_de_partida__c =aeropuertos[1].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[0].id, IsActive = true);
         Product2 vuelo3 = new Product2(Name = 'AE-0003', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addMinutes(30),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addHours(1),Aeropuerto_de_partida__c =aeropuertos[1].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[0].id, IsActive = true);
        insert vuelo;
        insert vuelo2;
        insert vuelo3;
    }
    
    @isTest static void vuelos(){
        List<Product2> vuelos = [SELECT id, fecha_y_hora_de_partida__c, Fecha_y_hora_real_de_llegada__c, Aeropuerto_de_partida__c, Aeropuerto_de_llegada__c, Estado__c from product2];
        List<Product2> resultado = Vuelo.vuelosPartida(vuelos);
        List<Product2> resultado2 = Vuelo.vuelosLlegada(vuelos);
        Vuelo.cambiarEstadoEnVuelo(vuelos);
        System.assertEquals(3, resultado.size());
        System.assertEquals(2, resultado2.size());
        Product2 actualizado = [SELECT id, estado__c from product2 where estado__c = 'En vuelo'];
        System.assertEquals('En vuelo', actualizado.Estado__c);
    } 
    
}