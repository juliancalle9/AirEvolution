public with sharing class vuelos24HBatch implements Database.Batchable<sObject> {
    
    public vuelos24HBatch() {
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id,Name,fecha_y_hora_de_partida__c, Aeropuerto_de_partida__c,'
        + 'Aeropuerto_de_llegada__c FROM Product2 WHERE fecha_y_hora_de_partida__c != null AND isActive = true AND' 
        +'(fecha_y_hora_de_partida__c > TODAY AND fecha_y_hora_de_partida__c <= TOMORROW)');
    }

    public void execute(Database.BatchableContext BC, List<Product2> vuelos){
        Datetime tiempo = Datetime.now();
        
        string plantillaPasajeroAntiguo = 'Pasajeros antiguos';
       
        List<Product2> vuelos24H = new List<Product2>();
        List<Product2> vuelosAntiguos = [SELECT Id, Aeropuerto_de_llegada__c,Aeropuerto_de_partida__c 
                                            FROM Product2 WHERE Estado__c = 'Terminado'];
        set <Id> idVuelo = new set<Id>(); 
        set <Id> idVueloAntiguo = new set<Id>(); 
        set <Id> pasajerosID = new set<Id>();
        List<string> pasajerosAntiguosID = new List<string>();
        try {
            //Se busca los vuelos que salen en 24 horas del dia siguiente.
            for (Product2 v : vuelos) {
                integer partida = (v.fecha_y_hora_de_partida__c).hourGMT();
                integer actual = tiempo.hourGmt(); 
                if(partida == actual){
                    idVuelo.add(v.Id);
                    
                    vuelos24H.add(v); 
                }
            }
           
            //Se buscan la entrada de lista de precios de los vuelos encontrados y se actualiza el precio
            List<PricebookEntry> entrada = [SELECT id, UnitPrice, Descuento_de_martes__c, Descuento_del_50__c
                                            FROM PricebookEntry WHERE Product2Id =: idvuelo];
            for(PricebookEntry t : entrada){
                if(t.Descuento_de_martes__c == true){
                    t.UnitPrice = t.UnitPrice/0.65;
                    t.Descuento_de_martes__c = false; 
                }
                t.UnitPrice = t.UnitPrice * 0.50;
                t.Descuento_del_50__c = true;
                System.debug(t.UnitPrice);  
            }
            update entrada;
            List<OpportunityLineItem> tiquetes = [SELECT id, Pasajero__c, Asiento__c,Equipaje_permitido__c FROM OpportunityLineItem 
                                                    WHERE Product2Id =: idVuelo];
            for(OpportunityLineItem tique : tiquetes){
                pasajerosID.add(tique.Pasajero__c);
                System.debug(tique.Pasajero__c);  
            }
            //Envio de email a los pasajeros
            Map<Id, Contact>  pasajeros = new Map<Id, Contact>([SELECT id, Name, Email FROM Contact WHERE Id =: pasajerosID]); 
            for(OpportunityLineItem t : tiquetes){
                String mensaje ='Hola '+ pasajeros.get(t.Pasajero__c).Name + ' hora de realizar el check-in. \n' +
                'Asiento: ' + t.Asiento__c+'\n'+ 'Equipaje: ' + t.Equipaje_permitido__c;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //Direccion de envio
                String[] toAddresses = new String[] { pasajeros.get(t.Pasajero__c).Email};   
                
                mail.setToAddresses(toAddresses);
                // Direccion de respuesta 
                mail.setReplyTo('juliancalle9@gmail.com');
                // Nombre para mostrar
                mail.setSenderDisplayName('Salesforce Support');
                //Asunto
                mail.setSubject('Realizar Check-In');
                //Cuerpo del mensaje
                mail.setPlainTextBody(mensaje);
                
                //Firma del mensaje
                mail.setUseSignature(false);
                //Mensaje
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail }); 
                 
            }

            //Se busca los pasajeros antiguos. Primero buscando los vuelos antiguos
            for(Product2 v : vuelos24H){
                for(Product2 vA : vuelosAntiguos){
                    if(vA.Aeropuerto_de_partida__c == v.Aeropuerto_de_partida__c && vA.Aeropuerto_de_llegada__c == v.Aeropuerto_de_llegada__c){
                        idVueloAntiguo.add(vA.Id);     
                    }
                }
            }
            
            List<OpportunityLineItem> tiquetesViejos = [SELECT id, Pasajero__c FROM OpportunityLineItem 
                                                    WHERE Product2Id =: idVueloAntiguo];
            for(OpportunityLineItem tique : tiquetesViejos){
                pasajerosAntiguosID.add(tique.Pasajero__c);
                  
            }
            enviarCorreo(pasajerosAntiguosID, plantillaPasajeroAntiguo);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC){
    }

    public void enviarCorreo(List<String> idPasajeros, string nombrePlantilla){
        EmailTemplate plantilla = [SELECT id from EmailTemplate WHERE name =: nombrePlantilla LIMIT 1];
        Messaging.MassEmailMessage correo = new Messaging.MassEmailMessage();
        correo.setTargetObjectIds(idPasajeros);
        correo.setSenderDisplayName('Administrador');
        correo.setTemplateId(plantilla.id);
        Messaging.sendEmail(new Messaging.MassEmailMessage[]{correo});  
    }

}