public with sharing class schedulableCancelarReserva implements Schedulable{
    public schedulableCancelarReserva() {
           
    }
    public void execute(SchedulableContext ctx){
        ReservaTerminarBatch myBatchObject = new ReservaTerminarBatch();
        Id batchId = Database.executeBatch(myBatchObject);
    }
}