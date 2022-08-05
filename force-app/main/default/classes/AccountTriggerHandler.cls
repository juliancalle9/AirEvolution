public without sharing class AccountTriggerHandler implements TriggerHandler{

    private boolean triggerIsExecuting;
    private Integer triggerSize;

    public AccountTriggerHandler(boolean triggerIsExecuting , Integer triggerSize){
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    
    
    public void beforeInsert(List<Account> newRecords){
        /*priorityAccount(newRecords);
        ValidateYearStarted(newRecords);
        priorityValidation(newRecords);
        randomNumber(newRecords);*/
    }
    
    public void beforeUpdate(List<Account> oldRecords, List<Account> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){
        priorityAccount(newRecords);
        priorityValidation(newRecords);
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
    

    public static void 	ValidateYearStarted(List<Account> account) {
        for(Account a : account){
            System.debug(a.YearStarted);
            if(a.YearStarted == null){
                
                a.YearStarted = String.valueOf(Date.today().year());
                System.debug(a.YearStarted);
            }
        }
    }

    public static void randomNumber(List<Account> account){
        for(Account a : account){
            if(a.AccountNumber == null){
                a.AccountNumber = String.valueOf(Integer.valueOf(Math.random()*10000000));
                System.debug(a.AccountNumber);
            }
        }
    }

    public static void priorityAccount(List<Account> account){
        for(Account a : account){
                if(a.SLA__c == null){ 
                    switch on  a.CustomerPriority__c {
                        when 'High'{
                            a.SLA__c = 'Gold';
                        }
                        when 'Medium'{
                            a.SLA__c = 'Silver';
                        }
                        when 'Low'{
                            a.SLA__c = 'Bronze';
                        }
                        when else {
                            System.debug('Error');
                        }
                    }
                }
            
            System.debug(a.CustomerPriority__c + a.SLA__c);
        }
    }

    public static void priorityValidation(List<Account> account){
        for(Account a : account){
            if((a.CustomerPriority__c == 'High' && a.SLA__c != 'Gold' ) ||  (a.CustomerPriority__c == 'Medium' && a.SLA__c != 'Silver') ||
            (a.CustomerPriority__c == 'Low' && a.SLA__c != 'Bronze')){
                a.CustomerPriority__c.addError('Prioridad y SLA no coinciden');
                System.debug('Error');
            }
        }
    }

}