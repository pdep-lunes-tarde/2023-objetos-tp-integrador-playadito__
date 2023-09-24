import wollok.game.*
import tablero.*
import carta.*

//import temp.*
object tpIntegrador {

	method jugar() {
		ventana.init()
	}

}

object ventana {

	method init() {
		game.width(85)
		game.height(48)
		game.cellSize(20)
		game.addVisual(filaAsedioJugador)
		game.addVisual(filaArqueroJugador)
		game.addVisual(filaInfanteJugador)
		game.addVisual(filaAsedioRival)
		game.addVisual(filaArqueroRival)
		game.addVisual(filaInfanteRival)
		game.addVisual(filaCartasJugables)
		game.addVisual(puntajeTotalJugador)
		game.addVisual(puntajeTotalRival)
		game.ground("assets/BG-002.png")
		cartasJugables.cartasPrimeraRonda()
		filaAsedioJugador.puntajeDeFila()
		filaArqueroJugador.puntajeDeFila()
		filaInfanteJugador.puntajeDeFila()
		filaArqueroRival.puntajeDeFila()
		filaInfanteRival.puntajeDeFila()
		filaAsedioRival.puntajeDeFila()
			// esto es temporal
//		match.start()
		game.start()
	}

}

// * los listener de las keys son manejados por la instancia
// * falta implementar la devolucion del seleccionado
// * ver si hay un lugar mas apropiado para meter esta clase (para q no quede en el archivo "tp")
class Selector {

	const items
	const image
	const catcher // objeto al que le voy a devolver lo seleccionado (referencia o index)
	var index = 0

	// wollok game req
	method image() = image

	// comenzar 
	method setSelector() {
		self.displayOn(self.getItemPosition(index))
		self.addListener()
	}

	// posicion segun el objeto a seleccionar
	method getItemPosition(itemIndex) {
		const item = items.get(itemIndex)
		return game.at(item.getPosicionX(), item.getPosicionY())
	}

	// mostrar / actualizar
	method displayOn(position) {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		}
		game.addVisualIn(self, position)
	}

	// listener y efectos
	method addListener() {
		keyboard.left().onPressDo{ self.moveLeft()}
		keyboard.right().onPressDo{ self.moveRight()}
		keyboard.enter().onPressDo{ self.select()}
	}

	method moveLeft() {
		if (index > 0) {
			index--
			self.displayOn(self.getItemPosition(index))
		}
	}

	method moveRight() {
		if (index < items.size() - 1) {
			index++
			self.displayOn(self.getItemPosition(index))
		}
	}

	method select() {
		catcher.takeSelection(index)
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

object jugador {

	// En principio el objeto jugador deberia ser unicamente para contener informacion
	method elegirBaraja() {
	// primera interfaz con tres cartas identificando a las tres barajas
	// cartasJugables.cartasPrimeraRonda(barajaElegida.mazo())
	}

}

