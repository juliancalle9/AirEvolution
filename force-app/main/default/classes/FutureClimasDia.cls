public class FutureClimasDia {
    
    @future (callout=true)
    public static void climaPartida(){
        List<Clima__C> climas = new list<Clima__c>();
        List<Product2> vuelos = [SELECT id, Aeropuerto_de_partida__r.localizacion__latitude__s , Aeropuerto_de_partida__r.localizacion__longitude__s, Aeropuerto_de_partida__r.id,
                                 fecha_y_hora_de_partida__c, Fecha_y_hora_real_de_llegada__c FROM Product2 WHERE fecha_y_hora_de_partida__c != null AND Fecha_y_hora_real_de_llegada__c !=null AND isActive = true];
        List<Product2> vuelosPartida = Vuelo.vuelosPartida(vuelos);
        for(Product2 v : vuelos){
            climas.add(ClimaRest.llamadaOpenweather(v.Aeropuerto_de_partida__r.localizacion__latitude__s, v.Aeropuerto_de_partida__r.localizacion__longitude__s, v.Aeropuerto_de_partida__r.id));
        }
        insert climas;
    }

}