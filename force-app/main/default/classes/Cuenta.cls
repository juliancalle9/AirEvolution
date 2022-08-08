public class Cuenta {
	
    public static void crearCuenta(string nombreCuenta){
        Account cuenta = new Account(Name = nombreCuenta);
        SerialSLA.asignarSerial(cuenta.Id);
    }
}