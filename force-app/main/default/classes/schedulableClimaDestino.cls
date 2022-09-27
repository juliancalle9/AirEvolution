public class schedulableClimaDestino implements Schedulable{
    public void execute(SchedulableContext ctx){
    	Future1Hora.clima();
    }

}