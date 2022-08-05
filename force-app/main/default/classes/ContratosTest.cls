@isTest
public with sharing class ContratosTest {
    @isTest
    public static void contratoTrimestre3(){
        Contract contrato = new Contract(valor_total__c = 100, status = 'Activated', StartDate = Date.newInstance(2022, 07, 21) );
        Contract respuesta = Contratos.finalizacionContrato(contrato);
        System.assertEquals(85, contrato.Valor_total__c);
        System.assertEquals(1, contrato.ContractTerm);
    }
}