public class desactivacionDescuentoMartes implements Database.Batchable<sObject>{
    public Boolean seEnvioNotifiacion;
    
    	public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'select id, unitprice from pricebookEntry where Descuento_de_martes__c = true AND Descuento_del_50__c = false AND IsActive = true';
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<pricebookEntry> precios){
            for(pricebookEntry a: precios){
                a.UnitPrice = a.UnitPrice/0.65;
                a.Descuento_de_martes__c = false;
            }
            
            update precios;
            set<string> usuarios = new set<string>();
            Profile perfil = [SELECT id FROM Profile WHERE Name = 'Gestión de ventas'];
            List<User> listaUsuarios = [SELECT Id FROM user WHERE ProfileId =: perfil.Id];
            for(user u : listaUsuarios){
                 usuarios.add(u.Id);
            }
            List<Pricebook2> listaPrecios = new List<Pricebook2>();
            CustomNotificationType notificacionPers = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Finalizacion_de_martes_de_descuento'];
            Messaging.CustomNotification notificacion = new Messaging.CustomNotification();
            notificacion.setTitle('Finaliza martes de descuento');
            notificacion.setBody('Ha finalizado martes de descuento, los tiquetes vuelven a su precio normal');
            notificacion.setNotificationTypeId(notificacionPers.Id);
            for(Pricebook2 p : listaPrecios){
                notificacion.setTargetId(p.id);
            }
            try{
                notificacion.send(usuarios);
                seEnvioNotifiacion = true;
            }catch(Exception e){
                System.debug('No se pudo enviar la notificación: ' + e.getMessage());
                seEnvioNotifiacion = false;
            }
        }
    
        public void finish(Database.BatchableContext BC){
            // notificar acerca del proceso
            
        }

}