import wollok.game.*
import tablero.*
import carta.*
import constantes.*

/* ARREGLAR
 * 
 * Revisar Selector, error por index
 * Revisar selector, nuevas instancias?
 * anyOne cuando se quiere obtener la mano de cartas aleatorias                      LISTO
 * la imagen del tipoDeCombate en la carta, y como asignarla                         LISTO
 * realizar los tests:(here)
 * -ver comportamientos de las listas
 * -cada metodo de los objetos y clases principales
 * cambiar los contadores por times() (here)
 * no el addvisual 2 veces/ mover los objetos con game.at() (?
 * numero de las cosas como objeto                                                   LISTO
 * barajas como clases                                                               LISTO
 */
/* OPCIONAL
 * 
 * revistar forma de calcular el total de  puntajeFila
 * 
 */
/* Proxima entrega
 * 
 * el enemigo tenga sus cartas y haga sus cosas
 * especialidades de las cartas 
 * -imagenes                                                                       LISTO
 * -aplicar metodos
 * cartas especiales
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

// * los listener de las keys son manejados por la instancia
// * ver si hay un lugar mas apropiado para meter esta clase (para q no quede en el archivo "tp")
class Selector {

	var items = new List()
	const image
	const catcher // objeto al que le voy a devolver lo seleccionado (referencia o index)
	var index = 0

	// wollok game req
	method image() = image

	// comenzar 
	method setSelector(itemsList) {
		items = items + itemsList
		self.mostrarEn(self.obtenerPosicionItem(index))
		self.agregarListener()
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
	method agregarListener() {
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
//		items.remove(items.get(index))
		game.removeVisual(self)
		catcher.tomarSeleccion(index)
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
		barajaJugador = reinosDelNorte
		barajaRival = scoiatael
		self.comenzarRonda()
	}

	method baraja() = barajaJugador

	method comenzarRonda() {
		if (ronda == 1) {
			filaCartasJugables.establecerManoCartas(barajaJugador.setCartas(4))
			filaCartasJugables.establecerManoCartas(barajaRival.setCartas(4))
		} else {
			var cartasSobrantesRondaAnterior = filaCartasJugables.listaDeCartas()
			filaCartasJugables.establecerManoCartas(barajaJugador.setCartas(3) + cartasSobrantesRondaAnterior)
		// cartasSobrantesRondaAnterior = filaCartasRival.listaDeCartas()
		// filaCartasJugables.establecerManoCartas(barajaRival.setCartas(3) + cartasSobrantesRondaAnterior)
		}
		tablero.inicializarTablero()
	}

}

