import wollok.game.*
import tablero.*
import menu.*
import cartas.*
import constantes.*

/* ARREGLAR
 * realizar los tests:(here)
 * cambiar los contadores por times() (here)
 * no el addvisual 2 veces/ mover los objetos con game.at() (?
 * 
 * preguntar si se puede ingresar un operador como parametro y utilizar para operar
 * 
 * ver implementacion para futuro de un scoreboard con los puntajes del jugador (nuevo objeto)
 * 
 * 
 * 
 * TODO
 * 
 * recalcular las posiciones de las cartas respecto de las filas (estan semi-corridas)
 * Fin de Ronda
 * Cuando alguien se queda sin cartas
 * Cartel de Ganador de Ronda
 * Fin de Partida
 * Ver como hacer para jugar una carta clima (con tratamiento polimorfico)
 * tests
 * numero de las cartas restantes jugables
 * Especialidades de las Cartas
 * Cartas especiales
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
		barajaJugador.actualizarPosicion(150, 18) // ver si se puede mover
		barajaRival.actualizarPosicion(150, 80)
		self.comenzarRonda()
	}

	method asignarBarajaRandom() {
		barajasDisponibles.remove(barajaJugador)
		return barajasDisponibles.anyOne()
	}

	method baraja() = barajaJugador

	method comenzarRonda() {
		if (ronda == 1) {
			filaCartasJugables.establecerManoDeCartas(barajaJugador.obtenerCartas(10))
			filaCartasRival.establecerManoDeCartas(barajaRival.obtenerCartas(10))
			tablero.mostrar(barajaJugador, barajaRival)
		} else {
			var cartasSobrantesRondaAnterior = filaCartasJugables.listaCartas()
			filaCartasJugables.establecerManoDeCartas(cartasSobrantesRondaAnterior)
			cartasSobrantesRondaAnterior = filaCartasRival.listaCartas()
			filaCartasRival.establecerManoDeCartas(cartasSobrantesRondaAnterior)
		}
		tablero.resetearTablero()
	}

	method finalizarRonda() {
		// deberian ir los efectos de baraja 
		self.ganadorRonda()
		ronda++
		if (ronda <= 4) {
			self.comenzarRonda()
		} else {
		// implementar finDePartida()
		}
	}

	method ganadorRonda() {
		if (puntajeTotalJugador.puntajeTotal() > puntajeTotalRival.puntajeTotal()) {
		// return jugador // ver que poner
		} else {
		// return rival
		}
	}

}

class Cartel {

}

