public with sharing class reservaPagada {
    public reservaPagada() {

    }
	//método para enviar el email cuando se paga la reserva.
    public static void enviarCorreo(Opportunity reserva){    
        string []correos = new list<string>();
        
        correos.add(reserva.Titular_de_reserva__r.Email);
        
        PageReference pagina = Page.TIQUETESPDF;
        pagina.getParameters().put('id',reserva.id);
        Blob b;
        //validación para cuando se llama el método desde un contexto de test
        if(Test.isRunningTest()) { 
  			b = blob.valueOf('Unit.Test');
		} else {
  			b = pagina.getContentAsPDF();
		}
        Messaging.SingleEmailMessage correo = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment adjunto = new Messaging.EmailFileAttachment();
        adjunto.setFileName('Tiquetes.pdf');
        adjunto.setBody(b);

        String addresses;
        correo.setSubject( 'Reserva pagada');
        
        correo.setToAddresses(correos);
       
        correo.setPlainTextBody('Hola ' + reserva.Titular_de_reserva__r.Name + ' muchas gracias por realizar el pago de tu reserva ' + reserva.name + '. En el archivo adjunto encontraras toda la información de esta y los tiquetes' );
        
        correo.setFileAttachments(new Messaging.EmailFileAttachment[] {adjunto});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {correo});

    }

}