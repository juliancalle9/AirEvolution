public with sharing class Cliente {

    //metodo para buscar un cliente por medio de su número de identificación y tipo de identificación
    @AuraEnabled
    public static Contact buscarCliente(string numeroIdentificacion, string tipoIdentificacion){
        try{
            date fecha = date.today();
            Contact cliente = [SELECT id, name FROM Contact 
                                WHERE Numero_de_identificacion__c = :numeroIdentificacion AND Tipo_de_identificacion__c =: tipoIdentificacion];
            validarReservas(cliente.id);
            return cliente;

        }catch(Exception e){
            return null;
        }
    }
    @AuraEnabled
    public static void validarReservas(string idContacto, string lista){
        date fecha = date.today();
        List<Opportunity> reservaCreada = new List<Opportunity>();
        List<Opportunity> reservas = [SELECT Id, Name FROM Opportunity WHERE Titular_de_reserva__c =: idContacto AND StageName NOT IN ('Pagado', 'No pagado')];
        if(reservas.size() == 0){
            Opportunity nuevaReserva = new Opportunity(Titular_de_reserva__c = idContacto, StageName = 'pre-venta', CloseDate = fecha, Name = 'a');
            insert nuevaReserva;
            
            reservaCreada.add(nuevaReserva);
            //return reservaCreada;
        }else{
            //return reservas;
        }
    }

    @AuraEnabled(cacheable=true)
    public static list<vuelo> encontrarVuelos(){
        try{
            List<vuelo> vuelosLista = new List<vuelo>();
            List<Product2> vuelos = [SELECT Name, fecha_y_hora_de_partida__c, Fecha_y_hora_estimada_de_llegada__c, Aeropuerto_de_llegada__r.Name, Aeropuerto_de_partida__r.Name FROM Product2 
            WHERE Estado__c = 'En venta'];
            for(Product2 v : vuelos){
                vuelosLista.add(new vuelo((string)v.id, v.Name, (datetime)v.fecha_y_hora_de_partida__c, (datetime)v.Fecha_y_hora_estimada_de_llegada__c, (string)v.Aeropuerto_de_partida__r.Name, (string)v.Aeropuerto_de_llegada__r.Name));
            }
            return vuelosLista;
        }catch(Exception e){
            return null;
        }
    }

    public class vuelo{
        @AuraEnabled
        public string idVuelo;
        @AuraEnabled
        public string codVuelo;
        @AuraEnabled
        public Datetime fechaPartida;
        @AuraEnabled
        public Datetime fechaEstimadaLlegada;
        @AuraEnabled
        public string aeropuertoSalida;
        @AuraEnabled
        public string aeropuertoLlegada;
        
        
        public vuelo(string id, string name, Datetime fechaSalida, Datetime fechaEst, string aeroSalida, string aeroLlegada){
            idVuelo = id;
            codVuelo = name;
            fechaPartida = fechaSalida;
            fechaEstimadaLlegada = fechaEst;
            aeropuertoSalida = aeroSalida;
            aeropuertoLlegada = aeroLlegada;
        }
    }
}