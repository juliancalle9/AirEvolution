@isTest
public class ShedulableClimaPartidaTest {
    public static String CRON_EXP = '0 0 0 24 9 ? 2022';
    static testmethod void testScheduledJob() {
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
        List<Product2> vuelos = new List<Product2>();
        for(integer i = 0; i < 100; i++){
            Product2 vuelo = new Product2(Name = 'AE-000' + i, Avion__c = avion.id, Estado__c = 'En venta', fecha_y_hora_de_partida__c = fechaPartida,
                                          Fecha_y_hora_real_de_llegada__c = fechaLlegada.addDays(1),Aeropuerto_de_partida__c =aeropuertos[0].id, 
                                          Aeropuerto_de_llegada__c = aeropuertos[1].id, IsActive = true);
            vuelos.add(vuelo);
        }
        insert vuelos;
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('getClima');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new schedulableClimaPartida());
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id =: jobId];
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals('2022-09-24 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
        
    }

}