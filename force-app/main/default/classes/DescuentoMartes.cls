public class DescuentoMartes implements Database.Batchable<sObject>{
    
		public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'select id, unitprice, Pricebook2Id from PricebookEntry where Descuento_de_martes__c = false AND Descuento_del_50__c = false AND IsActive = true';
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<pricebookEntry> precios){
            //Le aplica el descuento a las entradas de lista de precios
            for(pricebookEntry a: precios){
                decimal precio = a.unitprice;
                a.UnitPrice = precio - (precio * 0.35);
                a.Descuento_de_martes__c = True;
            }
            update precios;
            //Se envia la notificación de inicio de martes de descuento
            List<Pricebook2> lista = [SELECT Id from Pricebook2];
            for(Pricebook2 l : lista){
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                CustomNotificationType notificationType = 
                [SELECT Id, DeveloperName FROM CustomNotificationType 
                WHERE DeveloperName='Martes_de_descuento'];
                List<user> usuarios = [SELECT id, name FROM user WHERE UserRole.Name = 'Agente de ventas' AND IsActive = true];
                set<String> ids = new set<String>();
                for(user a: usuarios){
                ids.add(a.Id);
                }
                notification.setTitle('¡Inicio martes de descuento!');
                notification.setBody('Todos los tiquetes tienen 35% de descuento desde las 00:00 hasta las 15:00');
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