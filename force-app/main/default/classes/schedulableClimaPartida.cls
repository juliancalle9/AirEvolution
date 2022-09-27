public class schedulableClimaPartida implements Schedulable{
    
	public void execute(SchedulableContext ctx){
    	FutureClimasDia.climaPartida();
    }
    
}