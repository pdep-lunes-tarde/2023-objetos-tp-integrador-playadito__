import wollok.game.*
import menu.*
import tablero.*
import jugador.*
import constantes.*
import selector.*

/* TODO
 * 
 * ///////////////////////////// TESTS /////////////////////////////
 * FILA (falta terminar)
 * ** Y el resto de archivos
 * - caso empate(1-1), y sin cartas ni jugador ni rival, juego estancado
 * 
 * ///////////////////////////// GENERALES /////////////////////////////
 * - !! hacer diferencia entre "mostrar visual" y "actualizar vista"
 * 
 * - revisar flujo de programa (el orden de muestra afecta la capa del visual)
 *   mostrar visuales (el tablero -> la info(seccion de datos)) -> reparto de mano inicial -> arranca el juego
 * 
 * - revisar codigo (y refactorizar en caso de ser necesario):
 * 		- logica repetida
 * 		- faltas de encapsulamiento
 * 		- funciones estilo C
 * 
 * ///////////////////////////// PARTIDA /////////////////////////////
 * - mejorar ganadorRonda
 * 
 * ///////////////////////////// CARTAS /////////////////////////////
 * 
 * (logica)
 * - implementar cartaLider (caso particular de carta jugable, efecto)
 * 
 * ///////////////////////////// TABLERO /////////////////////////////
 * 
 * ///////////////////////////// OTRO /////////////////////////////
 * 
 * ver implementacion para futuro de un scoreboard con los puntajes del jugador (nuevo objeto)
 * fin de juego, volver a jugar
 * 
 */
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
		keyboard.l().onPressDo{ filaCartaLiderJugador.jugarCartaLider()}
		menu.mostrarMenu()
		game.start()
	}

}

object partida {

	var property ronda = 1

	method start(barajaSeleccionado) {
		const barajaJugador = barajaSeleccionado
		const barajaRival = self.asignarOtraBarajaRandom(barajaJugador)
		jugador.asignarBaraja(barajaJugador)
		rival.asignarBaraja(barajaRival)
		tablero.establecerBandoJugador(barajaJugador.faccion(), jugador)
		tablero.establecerBandoJugador(barajaRival.faccion(), rival)
		self.comenzarRonda()
	}

	method asignarOtraBarajaRandom(baraja) {
		lasBarajas.remove(baraja)
		return lasBarajas.anyOne()
	}

	method comenzarRonda() {
		if (ronda == 1) {
			tablero.mostrar()
			tablero.repartirManoInicial()
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
		if (rival.perdioPartida()) {
			game.schedule(2200, { => imagenPartidaGanada.llamarMensaje()})
		} else if (jugador.perdioPartida()) {
			game.schedule(2200, { => imagenPartidaPerdida.llamarMensaje()})
		}
	}

}

