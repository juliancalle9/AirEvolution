@isTest
public with sharing class DescuentoTest {
    
   	@TestSetup
   	static void makeData(){
                               
        Contact clienteRecurrente = new Contact(LastName = 'Prueba Perez',
        Tipo_de_identificacion__c = 'Cédula de ciudadania',Numero_de_identificacion__c = '12345678909876'); 
        insert clienteRecurrente;
    }

   	@isTest 
   	static void dctoClienteRecurrenteTC(){
       
        Contact cliente  = [SELECT Id,Tipo_de_identificacion__c,  
        Numero_de_identificacion__c 
        FROM Contact LIMIT 1]; 	
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);
        System.assert(respuesta.resultado);
        System.assertEquals(80, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));

   	}
    
    @isTest 
   	static void dctoClienteRecurrenteEFECTIVO(){
        Contact cliente  = [SELECT Id,Tipo_de_identificacion__c,  
        Numero_de_identificacion__c 
        FROM Contact LIMIT 1]; 	
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.EFECTIVO, 100);
        System.assert(respuesta.resultado);
        System.assertEquals(70, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.EFECTIVO)));
   	}
    
    @isTest 
   	static void dctoClienteNuevoEfec(){
        Contact cliente = new Contact(LastName = 'Calle', Tipo_de_identificacion__c = 'Cédula de ciudadania', Numero_de_identificacion__c = '10265620484563');
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.EFECTIVO, 100);
        System.assert(respuesta.resultado);
        System.assertEquals(85, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.EFECTIVO)));
   	}
    
    @isTest 
   	static void dctoClienteNuevoTC(){
        Contact cliente = new Contact(LastName = 'Prueba otra', Tipo_de_identificacion__c = 'Cédula de ciudadania', Numero_de_identificacion__c = '1122336698874');
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);
        System.assert(respuesta.resultado);
        System.assertEquals(85, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
   	}
    
    @isTest 
   	static void dctoErrorMetodoPago(){
        Contact cliente  = [SELECT Id,Tipo_de_identificacion__c,  
        Numero_de_identificacion__c 
        FROM Contact LIMIT 1];
        Test.startTest();
        List<Boolean> exceptions = new List<Boolean>();
        try{
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, null, 100);
        System.assert(respuesta.resultado);
        System.assertEquals(85, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
        }catch(Exception e){
            e.getMessage();
            exceptions.add(true);
        }
        Test.stopTest();
   	}
    
    @isTest 
   	static void dctoErrorNoEsperado(){
        Contact cliente  = [SELECT Id,Tipo_de_identificacion__c,  
        Numero_de_identificacion__c 
        FROM Contact LIMIT 1];
        Test.startTest();
        List<Boolean> exceptions = new List<Boolean>();
        try{
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, null);
        System.assert(respuesta.resultado);
        System.assertEquals(85, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
        }catch(Exception e){
            e.getMessage();
            exceptions.add(true);
        }
        Test.stopTest();
   	}
    @isTest 
   	static void dctoErrorDeInsercion(){
        Contact cliente = new Contact(LastName = null, Tipo_de_identificacion__c = 'Cédula de ciudadania', Numero_de_identificacion__c = '1122336698874');
        Test.startTest();
        List<Boolean> exceptions = new List<Boolean>();
        try{
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);
        System.assert(respuesta.resultado);
        System.assertEquals(85, respuesta.valorConDcto);
        System.assert(respuesta.mensaje.contains(String.valueOf(Descuento.metodo.TC)));
        }catch(Exception e){
            e.getMessage();
            exceptions.add(true);
        }
        Test.stopTest();
   	}
    
    
    
}