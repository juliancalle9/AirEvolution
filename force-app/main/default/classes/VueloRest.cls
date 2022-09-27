@RestResource(urlMapping='/Product2/*')
global class VueloRest {
    //Metodo get para consultar los vuelos que cumplen con las condiciones de fecha y ciudades
    @HttpGet
    global static ResultadoPeticionWrapper getVuelos() {
        
        string msj;
        boolean rsl;
        datetime fechaUno;
        datetime fechaDos;
        date fechaPartida;
        date fechaLlegada;
        ResultadoPeticionWrapper resp = new ResultadoPeticionWrapper();
        string fecha1 = '', fecha2 = '', ciudadPartida = '', ciudadDestino = '';
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        //Obtención de las fechas y un replace para su correcto formato
        fecha1 = restReq.params.get('fecha1').replace('-', '/');
        fecha2 = restReq.params.get('fecha2').replace('-', '/');
        ciudadPartida = restReq.params.get('ciudadPartida');
        ciudadDestino = restReq.params.get('ciudadDestino');
        
        Schema.DescribeFieldResult ciudad = Aeropuerto__c.Ciudad__c.getDescribe();
        List<Schema.PicklistEntry> listaCiudades = ciudad.getPicklistValues();
        List<String> ciu = new list<String>();
        for(Schema.PicklistEntry c : listaCiudades){
            ciu.add(c.getValue());
        }
        if(ciu.contains(ciudadPartida) == false){
            msj = 'No se encuentra esta ciudad de partida dentro de la lista de ciudades con vuelos';
            rsl = false;
            resp.respuesta = rsl;
            resp.mensaje  = msj;
            resp.vuelos = null;
            
        	return resp;
        }else if(ciu.contains(ciudadDestino) == false){
            msj = 'No se encuentra esta ciudad de destino dentro de la lista de ciudades con vuelos';
            rsl = false;
            resp.respuesta = rsl;
            resp.mensaje  = msj;
            resp.vuelos = null;
        	return resp;
        }
        
        
        try{
            fechaPartida = date.parse(fecha1); 
        }catch(Exception e){
            msj = 'Formato invalido para la fecha de partida. El formato es Dia-Mes-Año';
            rsl = false;
            resp.respuesta = rsl;
            resp.mensaje = msj;
        	return resp;
            
        }
        
        try{
            fechaLlegada = date.parse(fecha2);
        }catch(Exception e){
            msj = 'Formato invalido para la fecha de llegada. El formato es Dia-Mes-Año';
            rsl = false;
            
            resp.respuesta = rsl;
            resp.mensaje = msj;
            resp.vuelos = null;
        	return resp;
            
        }
        fechaUno = (datetime)fechaPartida;
        fechaDos = (datetime)fechaLlegada.addDays(1);
        
        try{
            //Se obtienen los vuelos que cumplen con los parametros
            PricebookEntry precios = new PricebookEntry();
            List<Product2> vuelo = [SELECT id, Name, fecha_y_hora_de_partida__c,Fecha_y_hora_real_de_llegada__c, Aeropuerto_de_partida__r.name, Aeropuerto_de_llegada__r.name, 
                                   (SELECT unitprice, id, Pricebook2.name FROM pricebookEntries) FROM Product2 WHERE (fecha_y_hora_de_partida__c >=: fechaUno 
                                    AND Fecha_y_hora_real_de_llegada__c <=: fechaDos) 
                                    AND Aeropuerto_de_partida__r.Ciudad__c =: ciudadPartida AND Aeropuerto_de_llegada__r.Ciudad__c =: ciudadDestino AND Estado__c = 'En venta'];
            if(vuelo.size() == 0){
                msj = 'No se han encontrado vuelos que coincidan con los parametros';
            }else{
                msj = 'Éxito';
                
                
            }
            resp.respuesta = true;
            resp.mensaje = msj;
            resp.vuelos = vuelo;
            
        }catch(Exception e){
            resp.mensaje = 'Ocurrio un error: '+ e ;
            resp.respuesta = false;
            resp.vuelos = null;
        }
        
        return resp;
        
        
        
    }
    
    global class ResultadoPeticionWrapper{
        public boolean respuesta;
        public List<Product2> vuelos;
        public string mensaje;
        public PricebookEntry entradalista;
        
        public ResultadoPeticionWrapper(){}
        
        
    }
}