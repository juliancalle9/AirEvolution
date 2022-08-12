public class SchedulableMartesDescuento implements Schedulable{
    
    public void execute(SchedulableContext sc) {
      DescuentoMartes b = new DescuentoMartes(); 
      database.executebatch(b);
   }

}