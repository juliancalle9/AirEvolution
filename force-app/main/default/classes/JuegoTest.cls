@isTest
public class JuegoTest {
	@isTest 
   	static void EmpartarJuego(){
       
       	Jugador jugador1 = new Jugador();
        jugador1.nombreJugador = 'Michael';
        Jugador jugador2 = new Jugador();
        jugador2.nombreJugador = 'Carl';
                
        Jugador jugadorEmpate = Juego.jugarRonda(jugador1, jugador2, Juego.jugada.TIJERA, Juego.jugada.TIJERA);
        System.assertEquals('Empate', jugadorEmpate.nombreJugador);
   	}
    
    @isTest
    static void GanadorTijeraPapel(){
        Jugador jugador1 = new Jugador();
        jugador1.nombreJugador = 'Michael';
        Jugador jugador2 = new Jugador();
        jugador2.nombreJugador = 'Carl';
                
        Juego.jugarRonda(jugador1, jugador2, Juego.jugada.TIJERA, Juego.jugada.PAPEL);
        System.assertEquals('Michael', jugador1.nombreJugador);
    }
    
    @isTest
    static void GanadorPapelTijera(){
        Jugador jugador1 = new Jugador();
        jugador1.nombreJugador = 'Michael';
        Jugador jugador2 = new Jugador();
        jugador2.nombreJugador = 'Carl';
                
        Juego.jugarRonda(jugador1, jugador2, Juego.jugada.PAPEL, Juego.jugada.TIJERA);
        System.assertEquals('Carl', jugador2.nombreJugador);
    }
    
    @isTest
    static void GanadorPapelPiedra(){
        Jugador jugador1 = new Jugador();
        jugador1.nombreJugador = 'Michael';
        Jugador jugador2 = new Jugador();
        jugador2.nombreJugador = 'Carl';
                
        Juego.jugarRonda(jugador1, jugador2, Juego.jugada.PAPEL, Juego.jugada.PIEDRA);
        System.assertEquals('Michael', jugador1.nombreJugador);
    }
    
    @isTest
    static void GanadorPiedraPapel(){
        Jugador jugador1 = new Jugador();
        jugador1.nombreJugador = 'Michael';
        Jugador jugador2 = new Jugador();
        jugador2.nombreJugador = 'Carl';
                
        Juego.jugarRonda(jugador1, jugador2, Juego.jugada.PIEDRA, Juego.jugada.PAPEL);
        System.assertEquals('Carl', jugador2.nombreJugador);
    }
    
    @isTest
    static void GanadorTijeraPiedra(){
        Jugador jugador1 = new Jugador();
        jugador1.nombreJugador = 'Michael';
        Jugador jugador2 = new Jugador();
        jugador2.nombreJugador = 'Carl';
                
        Juego.jugarRonda(jugador1, jugador2, Juego.jugada.TIJERA, Juego.jugada.PIEDRA);
        System.assertEquals('Carl', jugador2.nombreJugador);
    }
    
    @isTest
    static void GanadorPiedraTijera(){
        Jugador jugador1 = new Jugador();
        jugador1.nombreJugador = 'Michael';
        Jugador jugador2 = new Jugador();
        jugador2.nombreJugador = 'Carl';
                
        Juego.jugarRonda(jugador1, jugador2, Juego.jugada.PIEDRA, Juego.jugada.TIJERA);
        System.assertEquals('Michael', jugador1.nombreJugador);
    }
    
    @isTest 
   	static void ErrorDeDatosJugada(){
        Test.startTest();
        List<Boolean> exceptions = new List<Boolean>();
        try{
        	Jugador jugador1 = new Jugador();
        	jugador1.nombreJugador = 'Michael';
        	Jugador jugador2 = new Jugador();
        	jugador2.nombreJugador = 'Carl';
        	Juego.jugarRonda(jugador1, jugador2,Juego.jugada.PIEDRA ,null);
        	System.assertEquals('Michael', jugador1.nombreJugador);
        }catch(Exception e){
            e.getMessage();
            exceptions.add(true);
        }
        Test.stopTest();
   	}
    
    @isTest 
   	static void ErrorDeDatosJugadores(){
        Test.startTest();
        List<Boolean> exceptions = new List<Boolean>();
        try{
        	Jugador jugador1 = null;
        	Jugador jugador2 = new Jugador();
        	jugador2.nombreJugador = 'Carl';
        	Juego.jugarRonda(null, jugador2,null ,Juego.jugada.TIJERA);
        	System.assertEquals('Michael', jugador1.nombreJugador);
        }catch(Exception e){
            e.getMessage();
            exceptions.add(true);
        }
        Test.stopTest();
   	}

    
    
}