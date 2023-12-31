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
 * 
 * ///////////////////////////// CARTAS /////////////////////////////
 * - implementar efecto foltest
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
		menuInicio.mostrarMenu()
		game.start()
	}

}

object partida {

	var property ronda = 1
	var property noHayTablero = true

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
		const barajasSobrates = lasBarajas.copy()
		barajasSobrates.remove(baraja)
		return barajasSobrates.anyOne()
	}

	method comenzarRonda() {
		if (noHayTablero) {
			tablero.mostrar()
			self.noHayTablero(false)
		}
		if (ronda == 1) {
			tablero.repartirManoInicial()
		}
		tablero.resetearTablero()
	}

	method finalizarRonda() {
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
		tablero.bloquearTeclas()
		var mensaje
		if (rival.perdioPartida()) {
			mensaje = imagenPartidaGanada
		} else if (jugador.perdioPartida()) {
			mensaje = imagenPartidaPerdida
		}
		game.schedule(2200, { => menuFinal.mostrar(mensaje)})
	}

}

