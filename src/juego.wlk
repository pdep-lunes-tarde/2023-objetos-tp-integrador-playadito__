import wollok.game.*
import menu.*
import tablero.*
import jugador.*
import constantes.*

/* TODO
 * 
 * ///////////////////////////// GENERALES /////////////////////////////
 * - TESTS !!!!!!!
 * - arreglar selector 
 * 		- coexisten listeners y reacionan a mismas instrucciones: menu y juego
 * 		- error cuando se selecciona la ultima carta de la fila
 * - revisar objeto partida y como se arranca, hay muchas cosas que se pueden simplificar
 * - revisar codigo (y refactorizar en caso de ser necesario):
 * 		- logica repetida
 * 		- faltas de encapsulamiento
 * 		- funciones estilo C
 * 
 * ///////////////////////////// CARTAS /////////////////////////////
 * 
 * (logica)
 * - implementar los aplicarEfecto() de  especialidad
 * - implementar cartaLider (caso particular de carta jugable, efecto)
 * - implementar o sacar efectos de baraja
 * - ERROR el efecto de las cartas clima no se elimina a pesar de haber pasado la ronda
 * 
 * (visual)
 * - imagen particular para carta lider
 * 
 * ///////////////////////////// TABLERO /////////////////////////////
 * 
 * (logica)
<<<<<<< HEAD
 * - ERROR arreglar problemas multiples luego de pasar de ronda
 * - implementar de informacion de cada jugador (numero de cartas restantes y rondas perdidas)
=======
 * - LISTO repensar relacion de los objetos: TABLERO - JUGADOR - FILAS DE JUEGO - FILA DE CARTAS - PUNTAJE
 * - arreglar juego de carta clima (se puede jugar multiples cartas de un mismo clima)
 * - LISTO ERROR arreglar problemas multiples luego de pasar de ronda
 * - LISTO implementar de informacion de cada jugador (numero de cartas restantes y rondas perdidas)
>>>>>>> 997b2ca3791f7620a8fe652609373e526276a413
 * - implementar seccion cartas descartadas
 * - LISTO implementar chequeo de fin de ronda (cuando alguien se queda sin cartas)
 * - IMPLEMENTACION TEMPORAL CUANDO JUGADOR SE QUEDA SIN CARTAS(revisar y cambiar, actualizar gemas, primero un mensaje, etc)
 * - ver si es mejor seccion de datos crearla como global o dentro del jugador
 * - el ganador de ronda, que utiliza seccion de datos, ver una mejor implementacion
 * - LISTO ERROR ver fin de partida
 * 
 * 
 * (visual)
 * - recalcular posicion de cartas descartadas, de nuevo, esta corrido
 * 
 * ///////////////////////////// OTRO /////////////////////////////
 * 
 * ver implementacion para futuro de un scoreboard con los puntajes del jugador (nuevo objeto)
 * 
 */
object juego {

	method jugar() {
		game.width(170)
		game.height(96)
		game.cellSize(10)
		game.ground("assets/BG-002.png")
		menu.mostrarMenu()
//		partida.start(imperioNiffgardiano)
		game.start()
	}

}

object partida {

	var property barajaJugador
	var property barajaRival
	var property ronda = 1

	method start(barajaSeleccionado) {
		self.barajaJugador(barajaSeleccionado)
		self.barajaRival(self.asignarBarajaRandom())
		jugador.asignarBaraja(barajaJugador)
		rival.asignarBaraja(barajaRival)
		tablero.establecerBandoJugador(barajaJugador.faccion(), jugador)
		tablero.establecerBandoJugador(barajaRival.faccion(), rival)
		self.comenzarRonda()
	}

	method asignarBarajaRandom() {
		lasBarajas.remove(barajaJugador)
		return lasBarajas.anyOne()
	}

	method baraja() = barajaJugador

	method comenzarRonda() {
		if (ronda == 1) {
			tablero.repartirManoInicial()
			tablero.mostrar(barajaJugador, barajaRival)
		}
//		else {
//			var cartasSobrantesRondaAnterior = filaCartasJugador.listaCartas()
//			filaCartasJugador.establecerManoDeCartas(cartasSobrantesRondaAnterior)
//			cartasSobrantesRondaAnterior = filaCartasRival.listaCartas()
//			filaCartasRival.establecerManoDeCartas(cartasSobrantesRondaAnterior)
//		}
		tablero.resetearTablero()
	}

	method finalizarRonda() {
		// deberian ir los efectos de baraja 
		self.ganadorRonda()
		ronda++
		if (ronda <= 4 and !(seccionDatosRival.perdioPartida()) and !(seccionDatosJugador.perdioPartida()) and !(seccionDatosJugador.noTieneCartas()) and !(seccionDatosRival.noTieneCartas())) {
			game.schedule(2000, { => self.comenzarRonda()})
		} else {
			self.finDePartida()
		}
	}

	method ganadorRonda() {
		if (puntajeTotalJugador.puntajeTotal() > puntajeTotalRival.puntajeTotal()) {
			game.schedule(1200, { => imagenRondaGanada.llamarMensaje()})
			game.schedule(1200, { => seccionDatosRival.perdioRonda()})
		} else {
			game.schedule(1200, { => imagenRondaPerdida.llamarMensaje()})
			game.schedule(1200, { => seccionDatosJugador.perdioRonda()})
		}
	}

	method finDePartida() {
		if (seccionDatosRival.perdioPartida()) {
			game.schedule(1200, { => imagenPartidaGanada.llamarMensaje()})
		} else if (seccionDatosJugador.perdioPartida()) {
			game.schedule(1200, { => imagenPartidaPerdida.llamarMensaje()})
		} else if (seccionDatosRival.noTieneCartas()) {
			game.schedule(1200, { => imagenPartidaGanada.llamarMensaje()})
		} else if (seccionDatosJugador.noTieneCartas()) {
			game.schedule(1200, { => imagenPartidaPerdida.llamarMensaje()})
		}
	}

}

