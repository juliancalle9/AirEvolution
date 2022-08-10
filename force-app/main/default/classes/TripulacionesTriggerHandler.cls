public with sharing class TripulacionesTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private Integer triggerSize;

    public TripulacionesTriggerHandler(boolean triggerIsExecuting , Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Opportunity> newRecords){
        
    }
    public void beforeUpdate(List<Opportunity> oldRecords, List<Opportunity> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){
       
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
}
