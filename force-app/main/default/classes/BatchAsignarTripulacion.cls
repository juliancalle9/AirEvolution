public with sharing class BatchAsignarTripulacion implements Database.Batchable<sObject>{
    Date fecha = date.today();
    public BatchAsignarTripulacion() {

    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(
            'SELECT Id, fecha_y_hora_de_partida__c, Name FROM Product2 WHERE IsActive = true AND fecha_y_hora_de_partida__c != null');
        }

    public void execute(Database.BatchableContext BC, List<Product2> vuelos){
        List<Product2> vuelosAsignar = new List<Product2>();
        Date fechaVuelo;
        for (Product2 v : vuelos) {
            Datetime f = v.fecha_y_hora_de_partida__c;
            fechaVuelo = f.date();
            if(fecha.daysBetween(fechaVuelo) == 7){
                vuelosAsignar.add(v);
            }
        }
        for(Product2 v : vuelosAsignar){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName FROM CustomNotificationType 
             WHERE DeveloperName='Recordatorio_asignar_tripulacion'];
        
            // Create a new custom notification
            List<user> usuarios = [SELECT id, name FROM user WHERE UserRole.Name = 'Supervisor de vuelo'];
            set<String> ids = new set<String>();
            for(user a: usuarios){
                ids.add(a.Id);
            }

            // Set the contents for the notification
            notification.setTitle('Asignar Tripulacion al vuelo:  '+ v.Name);
            notification.setBody('El vuelo esta proximo a salir! no olvide asignar la tripulacion');

            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(v.Id);
            
            // Actually send the notification
            try {
                notification.send(ids);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext BC){

    }
    /*
    BatchAsignarTripulacion myBatchObject = new BatchAsignarTripulacion();
    Id batchId = Database.executeBatch(myBatchObject);
    AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchId ];
    System.debug(job);
    */
}
