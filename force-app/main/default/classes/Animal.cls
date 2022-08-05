public class Animal{
    public enum especies {VACA, PERRO, GATO}
    Integer numPatas;
    public String color {get; set;}
    Boolean esDomestico;
    public Double edad {get; set;}
    especies tipo;

    public Animal(Integer numPatas,String color,Boolean esDomestico, especies tipo){
        this.numPatas = numPatas;
        this.color = color;
        this.esDomestico = esDomestico;
        this.edad = edad;
        this.tipo = tipo;
        nacer();
    }
    
    public void nacer(){
        edad = 0;
    }

    public boolean comer(String alimento){
        if(String.isNotEmpty(alimento) ){
            return true;
        }else{
            return false;
        }
    }
    
    public Double crecer(){
        edad += 0.083;
        return edad;
    }
    
    public String sonido(){
        Switch on tipo{
            when VACA{
                return 'Muu';
            }
            when PERRO{
                return 'Guau';
            }
            when GATO{
                return 'Miau';
            }
            when else{
                return 'No tiene especie';
            }
            
        }
    }
}