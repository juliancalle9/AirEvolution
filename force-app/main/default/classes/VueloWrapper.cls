public with sharing class VueloWrapper {
    @AuraEnabled 
    public string codigo {get;set;}
    @AuraEnabled 
    public string id {get;set;}      
    @AuraEnabled 
    public decimal auxiliaresRequeridos {get;set;}
    @AuraEnabled 
    public decimal auxiliaresFaltantes {get;set;}        
    @AuraEnabled 
    public string piloto {get;set;}
    @AuraEnabled 
    public string copiloto {get;set;}  

    public VueloWrapper(Product2 vuelo, decimal faltantes) {
        id= vuelo.id;
        codigo= vuelo.Name;
        auxiliaresRequeridos= vuelo.Avion__r.Auxiliares_de_Vuelo_Requeridos__c; 
        auxiliaresFaltantes= faltantes;
        piloto= vuelo.Piloto__c;
        copiloto= vuelo.Copiloto__c;
    }
}