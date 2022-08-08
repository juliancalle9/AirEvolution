public class ProgramadoSerialSLA implements Schedulable{
    public static String CRON_EXP = '0 0 1 1/1 * ? *';
    public void execute(SchedulableContext SC) {
      NullSerialSLA batchClass = new NullSerialSLA(); 
      ID batchprocessid = Database.executeBatch(batchClass);
        
   }
}