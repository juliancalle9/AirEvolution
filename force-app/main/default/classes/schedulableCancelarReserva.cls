public with sharing class schedulableCancelarReserva implements Schedulable{
    public string idReserva;
    public schedulableCancelarReserva(string idReserva) {   
        this.idReserva = idReserva;
    }
    public void execute(SchedulableContext ctx){
        Opportunity reserva = [SELECT id, stageName FROM Opportunity WHERE id =: idReserva];
        List<OpportunityLineItem> tiquetes = [SELECT id FROM OpportunityLineItem WHERE OpportunityId =: idReserva];
        delete tiquetes;
        reserva.StageName = 'No pagado';
        update reserva;
    }
}