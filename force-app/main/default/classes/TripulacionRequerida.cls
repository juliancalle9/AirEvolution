public class TripulacionRequerida {
    @AuraEnabled(cacheable = true)
    	public static List<vuelo> obtenerVuelos(){
            try{
            
                DateTime limitDate = DateTime.now().addDays(7);
                //Obtiene los vuelos que salen en una semana 
                List<Product2> vuelos = [SELECT Id, Name, Copiloto__c, Piloto__c,  Avion__r.Auxiliares_de_Vuelo_Requeridos__c, (Select id from Tripulaciones__r)
                FROM Product2 WHERE IsActive = true AND Estado__c = 'En venta' AND
                                         Fecha_y_hora_de_partida__c > today 
                                         And Fecha_y_hora_de_partida__c <: limitDate];
                    
                List<vuelo> vuelosRta = new List<vuelo>();    
                for(Product2 v: vuelos){	 
                    vuelosRta.add(new vuelo((string )v.id, v.name, (integer)v.Avion__r.Auxiliares_de_Vuelo_Requeridos__c, 
                                            v.Copiloto__c, v.piloto__c, v.Tripulaciones__r.size()));
                 }
                system.debug(vuelosRta);
                return vuelosRta;
                }catch(Exception e){
                    throw new AuraHandledException(e.getMessage());
                }
        

    }
    
    @AuraEnabled
    public static void saveAuxiliares(List<string> auxiliares, string idvuelo){
        try {
            //estos son los tripulantes que ya existen
            List<Tripulacion__c> tripulantes = [SELECT id, Contacto__c, Contacto__r.Name 
                                                FROM Tripulacion__c
                                                WHERE Vuelo__c =: idVuelo];
            
            set<string> noEncontrados = new set<string>();
            for(Tripulacion__c t : tripulantes){
                for(integer i = 0; i < auxiliares.size(); i++){
                    // vamos a remover los existentes de la lista que llego para no duplicarlos
                    if(t.Contacto__c == auxiliares[i]){
                        auxiliares.remove(i);
                        if(noEncontrados.contains(t.id)){
                            noEncontrados.remove(t.id);
                        }
                    } else {
                        // si no lo encuentra lo agrega a una lista para luego eliminarlos
                        noEncontrados.add(t.id);
                    }
                }
            }
            
            //creamos los nuevos tripulantes
            List<Tripulacion__c> nuevosTripulantes = new List<Tripulacion__c>();
            for(string a : auxiliares){
                nuevosTripulantes.add(new Tripulacion__c(vuelo__c = idVuelo, Contacto__c = a));
            }
            system.debug('nuevosTripulantes-->'+nuevosTripulantes);
            insert nuevosTripulantes;

            //eliminamos los que ya no van
            system.debug('noEncontrados-->'+noEncontrados);
            List<Tripulacion__c> paraBorrar = new List<Tripulacion__c>();
            for(string idT : noEncontrados){
                paraBorrar.add(new Tripulacion__c(id = idT));
            }
            delete paraBorrar;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static List<opcion> getAuxiliares(string idVuelo){
        try{
            List<Contact> auxiliaresDisponibles = [SELECT Id, Name FROM Contact
                                                  WHERE RecordType.Name = 'Auxiliar de vuelo'
                                                  LIMIT 20];
            List<Tripulacion__c> tripulantes = [SELECT Id, 	Contacto__c,	Contacto__r.Name
                                               FROM Tripulacion__c
                                               where Vuelo__c =: idVuelo];
            list<opcion> opciones = new list<opcion>();
            for(contact c : auxiliaresDisponibles){
                opciones.add(new opcion(c.Name, c.id, false));
            }
            for(Tripulacion__c t : tripulantes){
                opciones.add(new opcion(t.Contacto__r.Name, t.Contacto__c, true));
            }
            return opciones;
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    public class opcion{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
        @AuraEnabled
        public boolean selected;
        public opcion(string label, string value, boolean selected){
            this.label = label;
            this.value = value;
            this.selected = selected;
            
        }
       
    }
    
    public class vuelo{
        @AuraEnabled
        public string idVuelo;
        @AuraEnabled
        public string codVuelo;
        @AuraEnabled
        public integer numAxiliaresRestantes;
        @AuraEnabled
        public integer numAuxiliares;
        @AuraEnabled
        public boolean copiloto;
        @AuraEnabled
        public boolean piloto;
        
        public vuelo(string id, string name, integer auxiliares, string copilotoId, string pilotoId, integer sizeTripulantes){
            idVuelo = id;
            codVuelo = name;
            numAuxiliares = auxiliares;
            numAxiliaresRestantes = auxiliares - sizeTripulantes;
            copiloto = !string.isBlank(copilotoId);
            piloto = !string.isBlank(pilotoId);
        }
    }
    
    
}