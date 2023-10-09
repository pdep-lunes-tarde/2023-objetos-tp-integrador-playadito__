import wollok.game.*
import tablero.*
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

object ventana {

	method init() {
		game.width(170)
		game.height(96)
		game.cellSize(10)
		game.ground("assets/BG-002.png")
		partida.start()
		game.start()
	}

}

class Selector {

	var items = new List()
	const image
	const catcher // objeto al que le voy a devolver lo seleccionado
	var index = 0

	// wollok game req
	method image() = image

	// comenzar
	method setSelector(itemsList) {
		items = itemsList.copy()
		self.mostrarEn(self.obtenerPosicionItem(index))
	}

	// posicion segun el objeto a seleccionar
	method obtenerPosicionItem(itemIndex) {
		const item = items.get(itemIndex)
		return game.at(item.getPosicionX(), item.getPosicionY())
	}

	// mostrar / actualizar
	method mostrarEn(position) {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		}
		game.addVisualIn(self, position)
	}

	// listener y efectos
	method initialize() {
		keyboard.left().onPressDo{ self.moveLeft()}
		keyboard.right().onPressDo{ self.moveRight()}
		keyboard.enter().onPressDo{ self.select()}
	}

	method moveLeft() {
		if (index > 0) {
			index--
			self.mostrarEn(self.obtenerPosicionItem(index))
		}
	}

	method moveRight() {
		if (index < items.size() - 1) {
			index++
			self.mostrarEn(self.obtenerPosicionItem(index))
		}
	}

	method select() {
		game.removeVisual(self)
		items.remove(items.get(index))
		catcher.tomarSeleccion(index)
		index = 0
		self.mostrarEn(self.obtenerPosicionItem(index))
	}

}

// podria ser una instancia de la clase selector
object menuSelector {

}

object menu {

	// Display
	method position() {
	}

	method image() {
	}

}

object partida {

	var barajaJugador
	var barajaRival
	var ronda = 1

	method start() {
		// esta asignacion deberia salir del menu
		barajaJugador = self.asignarBarajaRandom()
		barajaJugador.actualizarPosicion(150, 18)
		barajaRival = self.asignarBarajaRandom()
		barajaRival.actualizarPosicion(150, 80)
		self.comenzarRonda()
	}

	method asignarBarajaRandom() {
		const unaBaraja = barajasDisponibles.anyOne()
		barajasDisponibles.remove(unaBaraja)
		return unaBaraja
	}

	method baraja() = barajaJugador

	method comenzarRonda() {
		if (ronda == 1) {
			filaCartasJugables.establecerManoCartas(barajaJugador.obtenerCartas(10))
			filaCartasRival.establecerManoCartas(barajaRival.obtenerCartas(10))
			tablero.establecerRelacionCombateFila()
			tablero.mostrar(barajaJugador, barajaRival)
		} else {
			var cartasSobrantesRondaAnterior = filaCartasJugables.listaCartas()
			filaCartasJugables.establecerManoCartas(cartasSobrantesRondaAnterior)
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

