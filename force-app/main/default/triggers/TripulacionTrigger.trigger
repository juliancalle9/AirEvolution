trigger TripulacionTrigger on OpportunityLineItem (before insert,  before update ,before delete
,after insert ,after update,after delete,after undelete) {

    TripulacionesTriggerHandler tripulacionesTriggerHandler = new TripulacionesTriggerHandler(Trigger.isExecuting, Trigger.size);

    Switch on trigger.operationType {
        when BEFORE_INSERT{
            System.debug('Esta es antes de insert');
        }
        when BEFORE_UPDATE{
            System.debug('Esta es antes de update');
        }
        when BEFORE_DELETE{
            System.debug('Esta es antes de delete');
        }
        when AFTER_INSERT{
            System.debug('Esta es después de insert');
        }
        when AFTER_UPDATE{
            System.debug('Esta es después de update');
        }
        when AFTER_DELETE{
            System.debug('Esta es después de delete');
        }
        when AFTER_UNDELETE{
            System.debug('Esta es después de UNDELETE');
        }
        when else{
            System.debug('No se activo');
        }
    }
}