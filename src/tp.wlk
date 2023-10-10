import wollok.game.*
import tablero.*
import menu.*
import carta.*
import constantes.*

/* ARREGLAR
 * realizar los tests:(here)
 * cambiar los contadores por times() (here)
 * no el addvisual 2 veces/ mover los objetos con game.at() (?
 * 
 * preguntar si se puede ingresar un operador como parametro y utilizar para operar
 */
object tpIntegrador {

	method jugar() {
		ventana.init()
	}

}

// se podria prescindir de ventana.init() y ejecutar directo
object ventana {

	method init() {
		game.width(170)
		game.height(96)
		game.cellSize(10)
		game.ground("assets/BG-002.png")
		menu.mostrarMenu()
			// partida.start(reinosDelNorte)
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
		barajaJugador.actualizarPosicion(150, 18) // deberia ir aca???
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
			filaCartasJugables.establecerfilaCartasJugables(barajaJugador.obtenerCartas(10))
			filaCartasRival.establecerManoCartas(barajaRival.obtenerCartas(10))
			tablero.establecerRelacionCombateFila()
			tablero.mostrar(barajaJugador, barajaRival)
		} else {
			var cartasSobrantesRondaAnterior = filaCartasJugables.listaCartas()
			filaCartasJugables.establecerfilaCartasJugables(cartasSobrantesRondaAnterior)
			cartasSobrantesRondaAnterior = filaCartasRival.listaCartas()
			filaCartasRival.establecerManoCartas(cartasSobrantesRondaAnterior)
		}
		tablero.resetearTablero()
	}

	method finalizarRonda() {
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

