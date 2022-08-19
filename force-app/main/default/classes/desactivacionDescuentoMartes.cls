public class desactivacionDescuentoMartes implements Database.Batchable<sObject>{
    public Boolean seEnvioNotifiacion;
    
    	public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'select id, unitprice, Pricebook2Id from pricebookEntry where Descuento_de_martes__c = true AND Descuento_del_50__c = false AND IsActive = true';
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<pricebookEntry> precios){
            //devuelve el precio a su estado original
            for(pricebookEntry a: precios){
                a.UnitPrice = a.UnitPrice/0.65;
                a.Descuento_de_martes__c = false;
            }
            
            update precios;
            //Se envia la notificación avisando que se termino el descuento del martes
            List<Pricebook2> lista = [SELECT Id from Pricebook2];
            for(Pricebook2 l : lista){
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                CustomNotificationType notificationType = 
                [SELECT Id, DeveloperName FROM CustomNotificationType 
                WHERE DeveloperName='Martes_de_descuento'];
        
                // Create a new custom notification
                List<user> usuarios = [SELECT id, name FROM user WHERE UserRole.Name = 'Agente de ventas' AND IsActive = true];
                set<String> ids = new set<String>();
                for(user a: usuarios){
                ids.add(a.Id);
                }

                // Set the contents for the notification
                notification.setTitle('¡Inicio martes de descuento!');
                notification.setBody('Todos los tiquetes tienen 35% de descuento desde las 00:00 hasta las 15:00');

                // Set the notification type and target
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(l.Id);
                
            
                try{
                    notification.send(ids);
                }catch(Exception e){
                    System.debug('No se pudo enviar la notificación: ' + e.getMessage());
                }
            }
        }
    
        public void finish(Database.BatchableContext BC){
            // notificar acerca del proceso
            
        }

}