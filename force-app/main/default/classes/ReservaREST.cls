@RestResource(urlMapping='/Reserva/*')
global class ReservaREST {
    //Método post para crear o actualizar una reserva
    @HttpPost
    global static resultadoPostWrapper reservaPost(string idEntraPrecio, string nombre, string apellido, string email, string numIdent, string tipoIdent){
        pricebookEntry vuelo = [SELECT Product2Id,Pricebook2Id  FROM pricebookEntry where id =: idEntraPrecio];
        Product2 vuelos = new Product2(id = vuelo.Product2Id);
        date fecha = date.today();
        resultadoPostWrapper respuesta = new resultadoPostWrapper();
        List<Contact> cliente = [SELECT id FROM Contact WHERE Tipo_de_identificacion__c =: tipoIdent AND Numero_de_identificacion__c =: numIdent];
        //Validación del registro del cliente, si no existe se crea un nuevo cliente
        if(cliente.size() == 0){
            Contact nuevoCliente = new Contact(FirstName = nombre, LastName = apellido, Email = email, Numero_de_identificacion__c = numIdent, Tipo_de_identificacion__c = tipoIdent);
            insert nuevoCliente;
            Opportunity nuevaReserva = new Opportunity(Titular_de_reserva__c = nuevoCliente.id, StageName = 'pre-venta', 
                                                           CloseDate = fecha, Name = 'Nombre', Pricebook2Id = vuelo.Pricebook2Id);
            insert nuevaReserva;
            respuesta.reserva = nuevaReserva;
            respuesta.vuelo = vuelos;
            respuesta.mensaje = 'Cliente nuevo creado';
            OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = nuevaReserva.id, Product2Id = vuelo.id, Pasajero__c = nuevoCliente.id, Quantity = 1);
            insert tiquete;
        }else{
            
            List<Opportunity> reserva = [SELECT id FROM Opportunity WHERE Titular_de_reserva__c =: cliente[0].id AND StageName NOT IN ('Pagado', 'No pagado') limit 1];
            //Validación de las reservas del cliente
            if(reserva.size() == 0){
                Opportunity nuevaReserva = new Opportunity(Titular_de_reserva__c = cliente[0].id, StageName = 'pre-venta', 
                                                           CloseDate = fecha, Name = 'Nombre', Pricebook2Id = vuelo.Pricebook2Id);
                insert nuevaReserva;
                OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = nuevaReserva.id, Product2Id = vuelo.id, Pasajero__c = cliente[0].id, Quantity = 1);
                insert tiquete;
                
                respuesta.reserva = nuevaReserva;
                respuesta.vuelo = vuelos;
                respuesta.tiquete = tiquete;
                respuesta.mensaje = 'Se ha creado una reserva';

                
            }else{
                Opportunity actualizarReserva = new Opportunity(id = reserva[0].id, Pricebook2Id = vuelo.Pricebook2Id, CloseDate = fecha,StageName = 'Completado');
                OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = reserva[0].id, Product2Id = vuelo.id, Pasajero__c = cliente[0].id, Quantity = 1);
                insert tiquete;
                update actualizarReserva;
                respuesta.reserva = actualizarReserva;
                respuesta.vuelo = vuelos;
                respuesta.tiquete = tiquete;
               	respuesta.mensaje = 'Reserva actualizada';
				            
            }
        }
      
        return respuesta;
    }
    //Patch para validar el pago de la reserva
    @httpPatch
    global static string reservaPagada(string idReserva, string pago){
        string mensaje;
        List<Opportunity> reserva = [SELECT id, Titular_de_reserva__r.Email, Titular_de_reserva__r.Name, name, stageName, Valor_total__c FROM Opportunity WHERE id =: idReserva limit 1];
        if(pago.equals('Autorizado') & reserva.size() > 0){
            reserva[0].stageName = 'Pagado';
            update reserva;
            mensaje = 'Pago realizado con éxito';
            reservaPagada.enviarCorreo(reserva[0]);
            
        }else if(reserva.size() == null){
            mensaje = 'No se ha encontrado una reserva con el ID suministrado';
        }else if(!pago.equals('Autorizado')){
            mensaje = 'Pago no autorizado, por favor validar la información';
        }
        return mensaje;
    }
    
    
    
    global class resultadoPostWrapper{
        public Opportunity reserva;
        public Product2 vuelo;
        public OpportunityLineItem tiquete;
      	public string mensaje;    
        public resultadoPostWrapper(){}
        
    }

}