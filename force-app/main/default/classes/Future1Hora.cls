public class Future1Hora {
    
    @future (callout=true)
    public static void clima(){
        List<Clima__C> climas = new list<Clima__c>();
        List<Product2> vuelos = [SELECT id, Aeropuerto_de_llegada__r.localizacion__latitude__s , Aeropuerto_de_llegada__r.localizacion__longitude__s, Aeropuerto_de_llegada__r.id,
                                 fecha_y_hora_de_partida__c, Fecha_y_hora_real_de_llegada__c FROM Product2 
                                 WHERE fecha_y_hora_de_partida__c != null AND Fecha_y_hora_real_de_llegada__c !=null AND isActive = true AND
                                 (Estado__c = 'En venta' OR Estado__c = 'Check in')];
        List<Product2> vuelosPartida = Vuelo.vuelosLlegada(vuelos);
        for(Product2 v : vuelos){
            climas.add(ClimaRest.llamadaOpenweather(v.Aeropuerto_de_llegada__r.localizacion__latitude__s, 
                                                    v.Aeropuerto_de_llegada__r.localizacion__longitude__s, v.Aeropuerto_de_llegada__r.id));
        }
        insert climas;
        Vuelo.cambiarEstadoEnVuelo(vuelos);
        
    }
}