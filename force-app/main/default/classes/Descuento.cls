public with sharing class Descuento {
public enum metodo {TC, EFECTIVO}
public static respuestaDcto aplicarDescuento(contact cliente, metodo metodoPago, decimal valor){
    respuestaDcto respuesta = new respuestaDcto();
    try{
         contact[] recurrente = [SELECT id, Name 
                            FROM contact 
                            WHERE Tipo_de_identificacion__c =: cliente.Tipo_de_identificacion__c
                                AND Numero_de_identificacion__c =: cliente.Numero_de_identificacion__c
                            LIMIT 1];
    if(recurrente.size()>0 ){
        switch on metodoPago {
            when TC {
                respuesta.valorConDcto = valor * 0.8;
                respuesta.resultado = true;
                respuesta.mensaje = 'Se aplicó el descuento de cliente recurrente con '+metodoPago+' de 20%';
                system.debug(respuesta.valorConDcto + respuesta.mensaje + respuesta.resultado);
            }
            when EFECTIVO {
                respuesta.valorConDcto = valor * 0.7;
                respuesta.resultado = true;
                respuesta.mensaje = 'Se aplicó el descuento de cliente recurrente con '+metodoPago+' de 30%';
                system.debug(respuesta.valorConDcto + respuesta.mensaje + respuesta.resultado);
            }
            when else {
                throw new descuentoException();
     
            }
        }
    } else {
        respuesta.valorConDcto = valor * 0.85;
        respuesta.resultado = true;
        respuesta.mensaje = 'Se aplicó el descuento de cliente nuevo con '+metodoPago+' de 15%';
        system.debug(respuesta.valorConDcto + respuesta.mensaje + respuesta.resultado+ recurrente);
        insert cliente;
    }
    }catch(QueryException qe){
        System.debug('Ocurrio un error en la consulta: '+qe.getMessage());
        throw new descuentoException('Ocurrio un error en la consulta',qe);
    }catch(DMLException dmle){
        System.debug('Ocurrio un error en la inserción: '+dmle.getMessage());
        throw new descuentoException('Ocurrio un error en la inserción',dmle);
    }catch(descuentoException de){
        System.debug('El método de pago no corresponde');
        throw new descuentoException('El método de pago no corresponde');
    }catch (Exception e){
        System.debug('Ocurrio un error no esperado: '+e.getMessage());
        throw new descuentoException('Ocurrio un error no esperado',e);
    }
    
    return respuesta;
}

public class respuestaDcto{
    public boolean resultado;
    public string mensaje;
    public decimal valorConDcto; 
}

public class descuentoException extends Exception {}
}