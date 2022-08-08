public with sharing class InactiveAccounts implements Database.Batchable<sObject>{
        public final String SLA;
        public final Date SLAExpiration;

        public InactiveAccounts(String sla, Date expiration ){
            SLA = sla;
            SLAExpiration= expiration;
        }

        public Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator( 'SELECT id FROM Account WHERE SLA__c=\'' + SLA + '\'' + ' AND SLAExpirationDate__c < '  + SLAExpiration + 'AND UpsellOpportunity__c = \'No\'');
        }
    
        public void execute(Database.BatchableContext BC, List<Account> accts){
            delete accts;
        }
    
        public void finish(Database.BatchableContext BC){
            // notificar acerca del proceso
        }
    }