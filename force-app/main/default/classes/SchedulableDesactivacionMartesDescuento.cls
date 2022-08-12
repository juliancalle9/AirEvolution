public class SchedulableDesactivacionMartesDescuento implements Schedulable{
	public void execute(SchedulableContext sc) {
      desactivacionDescuentoMartes b = new desactivacionDescuentoMartes(); 
      database.executebatch(b);
   }

}