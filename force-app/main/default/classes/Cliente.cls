public with sharing class Cliente {

    //metodo para buscar un cliente por medio de su número de identificación y tipo de identificación
    @AuraEnabled
    public static string buscarCliente(string numeroIdentificacion, string tipoIdentificacion){
        try{
            date fecha = date.today();
            Contact cliente = [SELECT id, name FROM Contact 
                                WHERE Numero_de_identificacion__c = :numeroIdentificacion AND Tipo_de_identificacion__c =: tipoIdentificacion];
            //validarReservas(cliente);
            return cliente.Id;

        }catch(Exception e){
            return null;
        }
    }
    @AuraEnabled
    public static Boolean validarReservas(string idContacto){
        date fecha = date.today();
        List<Opportunity> reservaCreada = new List<Opportunity>();
        List<Opportunity> reservas = [SELECT Id, Name FROM Opportunity WHERE Titular_de_reserva__c =: idContacto AND StageName NOT IN ('Pagado', 'No pagado')];
        if(reservas.size() == 0){
            return true;
        }else{
            return false;
        }
    }

    @AuraEnabled(cacheable=true)
    public static list<vuelo> encontrarVuelos(string lista){
        
        try{
            Pricebook2 listaPrecio = [SELECT id FROM Pricebook2 WHERE Name =: lista];
            List<vuelo> vuelosLista = new List<vuelo>();
            List<Product2> vuelos = [SELECT Name, fecha_y_hora_de_partida__c, Fecha_y_hora_estimada_de_llegada__c, Aeropuerto_de_llegada__r.Name, Aeropuerto_de_partida__r.Name,
            (select unitprice from pricebookEntries WHERE Pricebook2Id =: listaPrecio.Id) FROM Product2 
            WHERE Estado__c = 'En venta'];
            for(Product2 v : vuelos){
                if(v.PricebookEntries.size() > 0){
                    vuelosLista.add(new vuelo((string)v.id, v.Name, v.fecha_y_hora_de_partida__c, v.Fecha_y_hora_estimada_de_llegada__c,
                    v.Aeropuerto_de_partida__r.Name, v.Aeropuerto_de_llegada__r.Name, v.pricebookEntries[0].unitprice));
                }
            }
            return vuelosLista;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string crearReserva(string idContacto, string tipoTiquete){
        date fecha = date.today();
        List<Pricebook2> listasPrecios = [Select Id, Name from Pricebook2];
        Id idLista;
        for(Pricebook2 l : listasPrecios){
            if(l.Name == tipoTiquete){
                idLista = l.Id;
            }
        }
        Opportunity nuevaReserva = new Opportunity(Titular_de_reserva__c = idContacto, StageName = 'pre-venta', CloseDate = fecha, Name = 'Nombre', Pricebook2Id = idLista);
        insert nuevaReserva;
        return nuevaReserva.Id;
    }

    @AuraEnabled
    public static OpportunityLineItem crearTiquete(string codigoVuelo, string idReserva, string pasajero, string equipaje){
        try{
            Product2 vuelo = [SELECT id FROM Product2 WHERE Name =: codigoVuelo];
            OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = idReserva, Product2Id = vuelo.id, Pasajero__c = pasajero, Quantity = 1, Equipaje_permitido__c = equipaje);
            insert tiquete;
            Opportunity reserva = [SELECT id, StageName FROM Opportunity WHERE id =: idReserva];
            reserva.StageName = 'Completado';
            update reserva;
            return tiquete;  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
               
    }

    @AuraEnabled
    public static Contact retornarContactos(String idcontacto){ 
        Contact contacto = [SELECT id, Name, Tipo_de_identificacion__c, Numero_de_identificacion__c FROM Contact WHERE id =: idcontacto];
        return contacto;
    }

    public class vuelo{
        @AuraEnabled
        public string idVuelo {get;set;} 
        @AuraEnabled
        public string codVuelo {get;set;}
        @AuraEnabled
        public Datetime fechaPartida {get;set;}
        @AuraEnabled
        public Datetime fechaEstimadaLlegada {get;set;}
        @AuraEnabled
        public string aeropuertoSalida {get;set;}
        @AuraEnabled
        public string aeropuertoLlegada {get;set;}
        @AuraEnabled
        public decimal precioUnitario {get;set;}
        
        
        public vuelo(string id, string name, Datetime fechaSalida, Datetime fechaEst, string aeroSalida, string aeroLlegada, decimal precio){
            idVuelo = id;
            codVuelo = name;
            fechaPartida = fechaSalida;
            fechaEstimadaLlegada = fechaEst;
            aeropuertoSalida = aeroSalida;
            aeropuertoLlegada = aeroLlegada;
            precioUnitario = precio;
        }
    }
}