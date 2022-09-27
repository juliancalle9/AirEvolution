public class tiquetesParaPDF {
    public List<OpportunityLineItem> tiquetes {get; set;}
   
    
    public tiquetesParaPDF(ApexPages.StandardController std){
        if(std.getRecord().id != null){
            string idReserva = std.getRecord().id;
            tiquetes = [Select id, name, pasajero__r.name, Product2.name, Product2.Aeropuerto_de_llegada__r.name, Opportunity.closeDate,
                        Product2.Aeropuerto_de_partida__r.name  ,unitPrice, equipaje_permitido__c, Asiento__c, Product2.fecha_y_hora_de_partida__c, Product2.Fecha_y_hora_real_de_llegada__c 
                        from OpportunityLineItem WHERE Opportunityid =:idReserva];
        }
        
    }
}