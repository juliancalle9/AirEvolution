public class Vuelo {
    public static list<Product2> vuelosPartida(List<Product2> vuelos){
		List<Product2> vuelos_1Dia = new List<Product2>();
        datetime fechaActual = Datetime.now();
        for(Product2 v : vuelos){
            if(v.fecha_y_hora_de_partida__c.isSameDay(fechaActual)){
                vuelos_1Dia.add(v);
            }
        }
        return vuelos_1Dia;
    }
    
    public static list<Product2> vuelosLlegada(List<Product2> vuelos){
        List<Product2> vuelosDestino = new List<Product2>();
        datetime fechaActual = Datetime.now();
        for(Product2 v : vuelos){
            if(v.fecha_y_hora_de_partida__c < fechaActual.addHours(1) & v.fecha_y_hora_de_partida__c >= fechaActual){
                vuelosDestino.add(v);
            }
        }
        return vuelosDestino;
    }
    
    public static void cambiarEstadoEnVuelo(List<Product2> vuelos){
        List<Product2> vuelosActualizar = new List<Product2>();
        datetime fechaActual = Datetime.now();
        for(Product2 v : vuelos){
            if(v.fecha_y_hora_de_partida__c < fechaActual){
                v.Estado__c = 'En vuelo';
                vuelosActualizar.add(v);
            }
        }
        update vuelosActualizar;
        
    }
}