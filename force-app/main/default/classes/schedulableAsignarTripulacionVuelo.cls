public with sharing class schedulableAsignarTripulacionVuelo implements Schedulable {
    public schedulableAsignarTripulacionVuelo(){
       
    }

    public void execute(SchedulableContext ctx){
        BatchAsignarTripulacion myBatchObject = new BatchAsignarTripulacion();
        Id batchId = Database.executeBatch(myBatchObject);
    }
   
}