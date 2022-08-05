public with sharing class Contratos {

    public date mesInicio; 

    public Contratos() {
 
    }

    public static Contract finalizacionContrato(Contract contrato){
        
        if(contrato.StartDate.month() >=  1 && contrato.StartDate.month() <= 3){
            contrato.ContractTerm = 6;
           
        }else if(contrato.StartDate.month() >= 4 && contrato.StartDate.month() <=9){
            contrato.ContractTerm = 4;
        }else if(contrato.StartDate.month() >= 10 && contrato.StartDate.month() <=12  ){
            if((contrato.StartDate.month() == 12   && contrato.StartDate.day() >= 20) || (contrato.StartDate.month() == 1 && contrato.StartDate.day() <= 15 )){
                throw new contratoException('No se puede crear un contrato en esta fecha');
            }else{
                contrato.ContractTerm = 1;
                contrato.valor_total__c = contrato.valor_total__c*0.85;
                contrato.Descuento__c = 0.15; 

            }
        }

        insert contrato;
        return contrato;
    }
    public class contratoException extends Exception {}

}