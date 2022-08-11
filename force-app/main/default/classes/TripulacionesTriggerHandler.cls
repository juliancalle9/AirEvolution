public with sharing class TripulacionesTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private Integer triggerSize;

    public TripulacionesTriggerHandler(boolean triggerIsExecuting , Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Tripulacion__c> newRecords){
        validarCantidadTripulantes(newRecords);
    }
    public void beforeUpdate(List<Tripulacion__c> oldRecords, List<Tripulacion__c> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){
       
    }
    public void beforeDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap){

    }
    public void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap){

    }
    public void afterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){

    }
    public void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap){

    }
    public void afterUndelete(List<SObject> newRecords, Map<ID, SObject> newRecordMap){

    }

    public static void validarCantidadTripulantes(List<Tripulacion__c> tripulacion){
        set<Id> tripulantes = new set<Id>();
        string idVuelo;
        for(Tripulacion__c t : tripulacion){
            tripulantes.add(t.id);
            idVuelo = t.Vuelo__c;
        }
        Product2 cantidadTripulante = [SELECT id, Avion__r.Auxiliares_de_Vuelo_Requeridos__c FROM Product2 WHERE id =: idVuelo];
        System.debug('Cantidad tripulantes' + cantidadTripulante.Avion__r.Auxiliares_de_Vuelo_Requeridos__c);
        for(Tripulacion__c t : tripulacion){
            if(tripulantes.size() >= cantidadTripulante.Avion__r.Auxiliares_de_Vuelo_Requeridos__c){
                System.debug('Entro aqui');
                t.vuelo__c.addError('No se puede agregar más tripulantes a este vuelo');
            }else{
                System.debug('entro en el else');
            }
        }
       

    }


}
