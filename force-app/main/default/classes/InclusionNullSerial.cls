public class InclusionNullSerial implements Queueable{
    
	public void execute(QueueableContext context) {
        
        List<Account> cuentas = [SELECT ID FROM Account Where SLASerialNumber__c = null];
        for(Account c : cuentas){
            c.SLASerialNumber__c = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 10);
        }
        update cuentas;
    }    

}