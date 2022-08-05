public with sharing class ReservasTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private Integer triggerSize;

    public ReservasTriggerHandler(boolean triggerIsExecuting , Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Opportunity> newRecords){
        ReservaPagada(newRecords);
        validacionVueloEnReserva(newRecords);
        NombreDeReserva(newRecords);
    }
    public void beforeUpdate(List<Opportunity> oldRecords, List<Opportunity> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){
        ReservaPagada(newRecords);
        validacionVueloEnReserva(newRecords);
        NombreDeReserva(newRecords);
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

    public static void ReservaPagada(List<Opportunity> reserva){
        for (Opportunity opp : reserva){
            if (opp.StageName == 'Pagado') {
                //Actualizar la fecha de pago
                opp.Fecha_de_pago__c = Date.newInstance(Date.today().year(), date.today().month(), Date.today().day());

                //Enviar correo de reserva                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //Direccion de envio
                String[] toAddresses = new String[] { 'juliancalle9@gmail.com' };                
                mail.setToAddresses(toAddresses);
                // Direccion de respuesta 
                mail.setReplyTo('support@acme.com');
                // Nombre para mostrar
                mail.setSenderDisplayName('Salesforce Support');
                //Asunto
                mail.setSubject('CONFIRMACION DE RESERVA');
                //Cuerpo del mensaje
                mail.setPlainTextBody('Hola '+ opp.Titular_de_reserva__c +' para nosotros es un placer informale que su reserva número ' 
                                    + opp.Numero_de_reserva__c + ' ha sido creada exitosamente');
                //Firma del mensaje
                mail.setUseSignature(false);
                //Mensaje
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });
                //Llamado a l metodo de prueba
                inspectResults(results);
            }            
        }
    }
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }

    public static void validacionVueloEnReserva(List<Opportunity> oportunidad){
        for(Opportunity reserva : oportunidad){
            if((reserva.Numero_de_vuelo1__c < 1 && reserva.StageName == 'Pagado')||(reserva.Numero_de_vuelo1__c < 1 && reserva.StageName == 'Completado')){
                reserva.Numero_de_vuelo1__c.addError('Para completar o pagar una reserva, esad debe tener por lo menos un vuelo asignado.');
            }
        }
    }

    public static void NombreDeReserva(List<Opportunity> opportunities) {
        set <Id> TitularesID = new set<Id>();
        for(Opportunity opp : opportunities){
            TitularesID.add(opp.Titular_de_Reserva__c);
        }
        Map<Id, Contact>  Titulares = new Map<Id, Contact>([SELECT Name FROM Contact WHERE Id = : TitularesID]);
        
        for (Opportunity opp : opportunities) {
            if(String.isNotEmpty(opp.Name)){
                String NumeroDeReserva = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 6);
                opp.Name = Titulares.get(opp.Titular_de_Reserva__c).Name.replace(' ', '') + NumeroDeReserva;
                System.debug('nombre de reserva: '+ opp.Name);
            }
        }
    }
}