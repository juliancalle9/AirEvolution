public with sharing class SchedulableVuelo24H implements Schedulable{
    public SchedulableVuelo24H() {

    }

    public void execute(SchedulableContext ctx){
        vuelos24HBatch myBatchObject = new vuelos24HBatch();
        Id batchId = Database.executeBatch(myBatchObject);
    }

}
