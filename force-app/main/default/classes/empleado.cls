public class empleado{
    
    public static integer horasTrabajadas(string tipoContrato){
        if(tipoContrato.equals('completo')){
            return EmpleadoTiempoCompleto.horasTrabajadas();
        }else{
            return EmpleadoMedioTiempo.horasTrabajadas();
        }
    }

}