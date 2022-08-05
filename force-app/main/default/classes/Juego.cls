public with sharing class Juego {
    public enum jugada {PIEDRA, PAPEL, TIJERA}


    public static Jugador jugarRonda(Jugador jugador1, Jugador jugador2, jugada eleccion1, jugada eleccion2){
        Jugador empate = new Jugador('Empate');
        Jugador ganador = new Jugador();
       
        try{
            if(eleccion1 == eleccion2){
                ganador = empate;
            }else if(eleccion1 == jugada.TIJERA && eleccion2 == jugada.PAPEL){
                ganador = jugador1;
            }else if(eleccion1 == jugada.PAPEL && eleccion2 == jugada.TIJERA){
                ganador = jugador2;
            }else if(eleccion1 == jugada.PAPEL && eleccion2 == jugada.PIEDRA){
                ganador = jugador1;
            }else if(eleccion1 == jugada.PIEDRA && eleccion2 == jugada.PAPEL){
                ganador = jugador2;
            }else if(eleccion1 == jugada.TIJERA && eleccion2 == jugada.PIEDRA){
                ganador = jugador2;
            }else if(eleccion1 == jugada.PIEDRA && eleccion2 == jugada.TIJERA){
                ganador = jugador1;
            }else if(jugador1 == null || jugador2 == null){
                throw new juegoException('Verificar información de los jugadores');
            }else if(eleccion1 == null || eleccion2 == null){
                throw new juegoException('Verificar información elección de jugada');
            }
            System.debug(ganador);
            return ganador;
        }catch(juegoException e){
            System.debug('Ocurrio un error no esperado: '+e.getMessage());
        	throw new juegoException('Ocurrio un error no esperado',e);
        }
        
    }
    public class juegoException extends Exception {}

}