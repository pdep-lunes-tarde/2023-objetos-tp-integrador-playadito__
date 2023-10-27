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
 * 		- error cuando se selecciona la ultima carta de la fila
 * - revisar objeto partida y como se arranca, hay muchas cosas que se pueden simplificar
 * - revisar codigo (y refactorizar en caso de ser necesario):
 * 		- logica repetida
 * 		- faltas de encapsulamiento
 * 		- funciones estilo C
 * 
 * ///////////////////////////// PARTIDA /////////////////////////////
 * - en general hay bastante pasaje de variables e informacion que no es necesario, se puede simplificar bastante
 * - mejorar ganadorRonda()
 * - mejorar start
 * - terminar de ver fin de partida
 * 
 * ///////////////////////////// CARTAS /////////////////////////////
 * 
 * (logica)
 * - implementar los aplicarEfecto() de especialidad
 * - implementar cartaLider (caso particular de carta jugable, efecto)
 * - implementar o sacar efectos de baraja
 * 
 * (visual)
 * - imagen particular para carta lider
 * 
 * ///////////////////////////// TABLERO /////////////////////////////
 * 
 * (logica)
 * - revisar logica de pasaje de ronda (apaso de ronda o paso de turno), esto tiene q ver mas con regla de juego
 * - revisar el descartado de carta [tablero ln(41~44), ln(145)]
 * - IMPLEMENTACION TEMPORAL CUANDO JUGADOR SE QUEDA SIN CARTAS(revisar y cambiar, actualizar gemas, primero un mensaje, etc)
 * 
 * 
 * ///////////////////////////// OTRO /////////////////////////////
 * 
 * ver implementacion para futuro de un scoreboard con los puntajes del jugador (nuevo objeto)
 * 
 */
object noHaySelector {

	method moveLeft() {
	}

	method moveRight() {
	}

	method select() {
	}

}

object juego {

	var property selectorActual = noHaySelector

	method seApretoIzquierda() {
		selectorActual.moveLeft()
	}

	method seApretoDerecha() {
		selectorActual.moveRight()
	}

	method seApretoSelect() {
		selectorActual.select()
	}

	method jugar() {
		game.width(170)
		game.height(96)
		game.cellSize(10)
		game.ground("assets/BG-002.png")
		keyboard.left().onPressDo{ self.seApretoIzquierda()}
		keyboard.right().onPressDo{ self.seApretoDerecha()}
		keyboard.enter().onPressDo{ self.seApretoSelect()}
		menu.mostrarMenu()
		game.start()
	}

}

object partida {

	var property barajaJugador
	var property barajaRival
	var property ronda = 1

	method start(barajaSeleccionado) {
		// NO ESTA LIMPIO
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
		tablero.resetearTablero()
	}

	method finalizarRonda() {
		// deberian ir los efectos de baraja 
		self.ganadorRonda()
		if (jugador.perdioPartida() or rival.perdioPartida()) {
			self.finDePartida()
		} else {
			ronda++
			game.schedule(2000, { => self.comenzarRonda()})
		}
	}

	method ganadorRonda() {
		// codigo medio repetido (?
		if (jugador.puntajeTotal() > rival.puntajeTotal()) {
			rival.pierdeRonda()
			game.schedule(1200, { => tablero.actualizarDatosJugadores()})
			game.schedule(1200, { => imagenRondaGanada.llamarMensaje()})
		} else if (jugador.puntajeTotal() < rival.puntajeTotal()) {
			jugador.pierdeRonda()
			game.schedule(1200, { => tablero.actualizarDatosJugadores()})
			game.schedule(1200, { => imagenRondaPerdida.llamarMensaje()})
		} else {
			// caso empate (pierden los dos)
			rival.pierdeRonda()
			jugador.pierdeRonda()
			game.schedule(1200, { => tablero.actualizarDatosJugadores()})
			game.schedule(1200, { => imagenRondaPerdida.llamarMensaje()})
		}
	}

	method finDePartida() {
		// ...
		game.schedule(1200, { => imagenPartidaGanada.llamarMensaje()})
	}

}

//		if (seccionDatosRival.perdioPartida()) {
//			game.schedule(1200, { => imagenPartidaGanada.llamarMensaje()})
//		} else if (seccionDatosJugador.perdioPartida()) {
//			game.schedule(1200, { => imagenPartidaPerdida.llamarMensaje()})
//		} else if (seccionDatosRival.noTieneCartas()) {
//			game.schedule(1200, { => imagenPartidaGanada.llamarMensaje()})
//		} else if (seccionDatosJugador.noTieneCartas()) {
//			game.schedule(1200, { => imagenPartidaPerdida.llamarMensaje()})
//		}     