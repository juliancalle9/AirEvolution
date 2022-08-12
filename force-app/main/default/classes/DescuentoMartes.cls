public class DescuentoMartes implements Database.Batchable<sObject>{
    
		public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'select id, unitprice from PricebookEntry where Descuento_de_martes__c = false AND Descuento_del_50__c = false AND IsActive = true';
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<pricebookEntry> precios){
            for(pricebookEntry a: precios){
                decimal precio = a.unitprice;
                a.UnitPrice = precio - (precio * 0.35);
                a.Descuento_de_martes__c = True;
            }
            update precios;
            set<string> usuarios = new set<string>();
            Profile perfil = [select id from Profile where Name = 'Gestión de ventas'];
            List<User> listaUsuarios = [Select Id from user where ProfileId =: perfil.Id];
            for(user u : listaUsuarios){
                 usuarios.add(u.Id);
            }
            List<Pricebook2> listaPrecios = new List<Pricebook2>();
            CustomNotificationType notificacionPers = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Martes_de_descuento'];
            Messaging.CustomNotification notificacion = new Messaging.CustomNotification();
            notificacion.setTitle('Inicia martes de descuento');
            notificacion.setBody('Descuento del 15% en todos los tiquetes desde las 00:00 hasta las 15:00 (no aplica para los vuelos que salen en las próximas 24 horas)');
            notificacion.setNotificationTypeId(notificacionPers.Id);
            for(Pricebook2 p : listaPrecios){
                notificacion.setTargetId(p.id);
            }
            try{
                notificacion.send(usuarios);
            }catch(Exception e){
                System.debug('No se pudo enviar la notificación: ' + e.getMessage());
            }
        }
    
        public void finish(Database.BatchableContext BC){
            // notificar acerca del proceso
        }
}