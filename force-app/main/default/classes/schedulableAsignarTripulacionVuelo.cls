public with sharing class schedulableAsignarTripulacionVuelo implements Schedulable {
    public string idVuelo;

    public schedulableAsignarTripulacionVuelo(string idVuelo){
        this.idVuelo = idVuelo;
    }

    public void execute(SchedulableContext ctx){
        Messaging.CustomNotification notificacion = new Messaging.CustomNotification();
        CustomNotificationType notificacionPers = [SELECT Id, DeveloperName FROM CustomNotificationType 
        WHERE DeveloperName='Recordatorio_asignar_tripulacion'];
        List<user> usuarios = [SELECT id, name FROM user WHERE UserRole.Name = 'Supervisor de vuelo'];
        set<String> ids = new set<String>();
        for(user a: usuarios){
            ids.add(a.Id);
        }
        notificacion.setTitle('Asignar tripulacion');
        notificacion.setBody('Se debe asignar la tripulación a este vuelo');
        notificacion.setNotificationTypeId(notificacionPers.Id);
        notificacion.setTargetId(idVuelo);
        try{
            notificacion.send(ids);
        }catch(Exception e){
            System.debug('No se pudo enviar la notificación: ' + e.getMessage());
        }
    }
   
}