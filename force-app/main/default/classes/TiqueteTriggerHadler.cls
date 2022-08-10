public without sharing class TiqueteTriggerHadler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private Integer triggerSize;

    public TiqueteTriggerHadler(boolean triggerIsExecuting , Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<OpportunityLineItem> newRecords){
        Sobreventa(newRecords);
        pasajeroDeReserva(newRecords);
       // AsignarClaseNegocios(newRecords);
    }
    public void beforeUpdate(List<OpportunityLineItem> oldRecords, List<OpportunityLineItem> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){

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


    public static void pasajeroDeReserva(List<OpportunityLineItem> opportunityLineItemNeW){
        List<Opportunity> opportunityNew = new List<Opportunity>([SELECT Id,Titular_de_reserva__c FROM Opportunity WHERE StageName = 'pre-venta']);
        for (Opportunity r: opportunityNew){
            for (OpportunityLineItem t : opportunityLineItemNew) {
                if(t.OpportunityId == r.Id && t.Pasajero__c == null){ 
                        t.Pasajero__c = r.Titular_de_reserva__c;
                }
            }
        }
    }


    public void Sobreventa(List<OpportunityLineItem> tiquetes){
        set <Id> idTiquetes = new set<Id>();
        for (opportunityLineItem Tiquete : tiquetes)
        {
            idTiquetes.add(Tiquete.Product2Id);
        }
        map<id , product2> productos = new map<id , product2>([select ID,avion__r.N_mero_de_pasajeros_clase_negocios__c,avion__r.N_mero_de_pasajeros_clase_turista__c 
                                                                from Product2 where Id IN :idTiquetes]); 
        AggregateResult[] groupedResults = [SELECT Count(Id),Product2Id FROM OpportunityLineItem where Product2Id IN :idTiquetes GROUP BY Product2Id  ];
        List<Product2> vuelos = new List<Product2>();
        for (AggregateResult ar : groupedResults){
            system.debug(ar.get('Product2Id'));
            system.debug(ar.get('expr0'));
            Decimal pasajerosTotales = productos.get((string)ar.get('Product2Id')).avion__r.N_mero_de_pasajeros_clase_negocios__c+productos.get((string)ar.get('Product2Id')).avion__r.N_mero_de_pasajeros_clase_turista__c;
            if ((pasajerosTotales*1.1)<(integer)ar.get('expr0')) {
                vuelos.add(new product2(id=(string)ar.get('Product2Id')));
            }
            
        }
        for(opportunityLineItem a: tiquetes){
            for(product2 p: vuelos){
                if (a.Product2Id==p.Id){
                    a.adderror('No es posible sobrevender los tiquetes');
                }
            }
        }
    }

   /* public static void AsignarClaseNegocios(List<OpportunityLineItem> tiquList){
        Set<Id> idVuelo = new Set<Id>();
        for (OpportunityLineItem tiq : tiquList){
            idVuelo.add(tiq.Product2Id);
        }
        string IdNegocios = [SELECT Id FROM Pricebook2 WHERE name = 'Tiquete negocios' Limit 1].Id;
        List<PricebookEntry> listEntrada = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id =: IdNegocios AND Product2Id IN : idVuelo];
        for (PricebookEntry EntradaPrecios : listEntrada) {
            for (OpportunityLineItem tiq : tiquList){
                if (tiq.Product2Id == EntradaPrecios.Product2Id) {
                    tiq.Equipaje_Permitido__c = 'Personal;Maleta de cabina;Maleta de bodega';
                }                
            
            }        
        }  

    }*/


}