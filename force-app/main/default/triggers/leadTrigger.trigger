trigger leadTrigger on Lead (before insert, before update) {

    if(trigger.isAfter){
        for(Lead l : trigger.new){
            List<Lead> lead = [Select id from Lead where Name=: l.Name];
            if(lead.size() > 0){
               l.addError('Error');
            } 
        }
    }

}