public with sharing class ReservaTerminarBatch implements Database.Batchable<sObject> {

    Datetime modificacion = Datetime.now().addMinutes(1);
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator('SELECT Id, StageName, LastModifiedDate  FROM Opportunity');
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> reservas){
        List<String> idReservas = new List<String>();
        try {
            for (opportunity reserva : reservas) {
                //reserva.LastModifiedDate <= modificacion 
                if ( reserva.LastModifiedDate <= modificacion && (reserva.StageName == 'pre-venta' || reserva.StageName == 'Completado')) {
                    reserva.StageName = 'No pagado';
                    idReservas.add(reserva.Id);
                }
            }
            update reservas;

            List<OpportunityLineItem> eliminar = [SELECT Id From OpportunityLineItem 
            WHERE OpportunityId IN : idReservas];
            delete eliminar;

        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }

    public void finish(Database.BatchableContext BC){
    }
}