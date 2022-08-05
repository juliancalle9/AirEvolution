public without sharing class VuelosTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private Integer triggerSize;

    public VuelosTriggerHandler(boolean triggerIsExecuting , Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Product2> newRecords){

    }
    public void beforeUpdate(List<Product2> oldRecords, List<Product2> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){
        desactivarVuelo(newRecords);

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
    public void desactivarVuelo(List<Product2> vuelos){
        for(Product2 v : vuelos){
            if(v.IsActive != false && (v.Estado__c == 'Terminado' || v.Estado__c == 'Cancelado')){
                v.IsActive = false;
                if(v.Estado__c == 'Cancelado' && String.isNotEmpty(v.Motivo_de_cancelacion__c)){
                    date fecha = date.today();
                    v.Fecha_de_cancelacion__c = fecha;
                }else if(v.Estado__c == 'Cancelado'){
                    v.Motivo_de_cancelacion__c.addError('Debe agregar un motivo de cancelación');
                }     
            }
        }
    }
}