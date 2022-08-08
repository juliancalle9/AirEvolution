public class SerialSLA {
    
	@future 
    public static void asignarSerial(ID idcuenta){
        
        Account cuenta = new Account(id = idcuenta);
        string random = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 4);
        List<Account> lista = [SELECT id FROM Account WHERE SLASerialNumber__c =: random];
        if(lista.size() == 0){
            cuenta.SLASerialNumber__c = random;
            update cuenta;
        }
 
    }
}