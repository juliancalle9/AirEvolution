public class EjemploDinamico {
    public static List<sObject> objeto(string objeto, string campo1, string valor1){
        List<sObject> objetos = database.query('select id from '+ objeto +' where ' + campo1+' =: '+ valor1);  
        System.debug(objetos);
        return objetos;
        
    }
}