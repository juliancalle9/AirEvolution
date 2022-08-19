@isTest
public class TestBatchAsignarTripulacion {
	@testSetup
    static void setup(){
        datetime fechaPartida = datetime.now();
        datetime fechaLlegada = datetime.now();
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
        Product2 vuelo = new Product2(Name = 'AE-0001', Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida.addDays(7),
                                       Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(8),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                      Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
        insert vuelo;
    }
    
    @isTest
    public static void encontrarVuelos(){
        Test.startTest();
        BatchAsignarTripulacion batch = new BatchAsignarTripulacion();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        List<Product2> vuelo = [Select id from Product2];
        
        System.assertEquals(1, vuelo.size());    
    }
}