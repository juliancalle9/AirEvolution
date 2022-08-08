public class NullSerialSLA implements Database.Batchable<sObject> {
        public Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator(
            'SELECT ID FROM Account ' +
            'Where SLASerialNumber__c = null');
        }
    
        public static void execute(Database.BatchableContext BC, List<Account> accts){
            for(account c : accts){
                c.SLASerialNumber__c = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 10);
            }
            update accts;
        }
    
        public void finish(Database.BatchableContext BC){
            
        }
}