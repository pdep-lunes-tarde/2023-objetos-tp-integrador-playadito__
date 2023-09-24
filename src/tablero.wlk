import wollok.game.*
import carta.*
import tp.*

object tablero {

	method position() {
		return game.origin().up(10)
	}

	method image() {
	}

}

class FilaDeCombate {

	// 700px (35 celdas)
	// 120px (6)
	const cartas = new List()
	var puntaje = 0
	const pos_x = 24
	const pos_y
	const imagen
	const puntajeFila = new PuntajeFila(cartasFila = cartas, pos_y = pos_y + 2, imagen = imagen)

	method puntajeDeFila() {
		game.addVisual(puntajeFila)
	}

	method position() {
		return game.at(pos_x, pos_y)
	}

	method image() {
		return "assets/FC-002.png"
	}

	method puntajeFila() = puntaje

	method actualizarPuntaje() {
		puntaje = cartas.map({ carta => carta.puntaje() }).sum()
	}

	method insertarCarta(unaCarta) {
	// add a lista
	// mostar cambios 
	// actualizarPuntaje 
	}

	method listaCartas() = cartas

}

const filaAsedioJugador = new FilaDeCombate(pos_y = 9, imagen = "assets/PJ-01.png")

const filaArqueroJugador = new FilaDeCombate(pos_y = 15, imagen = "assets/PJ-01.png")

const filaInfanteJugador = new FilaDeCombate(pos_y = 21, imagen = "assets/PJ-01.png")

const filaAsedioRival = new FilaDeCombate(pos_y = 28, imagen = "assets/PR-01.png")

const filaArqueroRival = new FilaDeCombate(pos_y = 34, imagen = "assets/PR-01.png")

const filaInfanteRival = new FilaDeCombate(pos_y = 40, imagen = "assets/PR-01.png")

class PuntajeFila {

	var cartasFila
	var puntajeTotalFila = 0
	const pos_x = 22
	var pos_y
	const imagen

	method actualizarPuntajeTotal() {
		puntajeTotalFila = cartasFila.map({ carta => carta.puntaje() }).sum()
	}

	method puntajeTotalFila() = puntajeTotalFila

	method text() {
		return puntajeTotalFila.toString()
	}

	method textColor() {
		return "000000FF"
	}

	method image() {
		return imagen
	}

	method position() {
		return game.at(pos_x, pos_y)
	}

}

//3 en realidad deberia ser 10
object cartasJugables {

	const manoInicial = new List()
	const barajaElegida = reinosDelNorte.mazo()
	var cartaAleatoria

	method cartasPrimeraRonda() {
		if (manoInicial.size() < 3) {
			cartaAleatoria = barajaElegida.anyOne()
			barajaElegida.remove(cartaAleatoria)
			manoInicial.add(cartaAleatoria)
			self.cartasPrimeraRonda()
		}
		filaCartasJugables.manoInicial(manoInicial)
	}

	method cartasRondaNueva(cartasSobrantes) {
	// hacer
	}

}

object filaCartasJugables {

	var cartas = new List()
	var indice = 0
	var cantCartas
	var carta
	var pos_x = 25
	const pos_y = 2
	var seleccionador

	method position() {
		return game.at(24, 2)
	}

	method image() {
		return "assets/FC-002.png"
	}

	method mostrarCartas() {
		if (indice < cantCartas) {
			carta = cartas.get(indice)
			carta.setPosicion(pos_x, pos_y)
			game.addVisual(carta)
			pos_x = pos_x + 5
			indice = indice + 1
		}
			// 5 deberia ser 4, chequear
			// esta haciendo muchas cosas
			// se instancia adentro del metodo porque para cada actalizacion, se hace un nuevo selector
		seleccionador = new Selector(items = self.listaDeCartas(), image = "assets/S-02.png", catcher = self)
		seleccionador.setSelector()
	// esto es temporal
	}

	method manoInicial(nuevasCartas) {
		cartas = nuevasCartas
		cantCartas = cartas.size()
		self.mostrarCartas()
	}

	method listaDeCartas() {
		return cartas
	}

	method agregarCarta(unaCarta) {
	// metodo para cartas especiales
	}

	method siguiente() {
	// mover el selector
	}

	method takeSelection(index) {
	// se elimina la carta de la lista
	// mostrarCartas() -> muestra de nuevo la lista actualizada
	}

	method seleccionar() {
	}

}

class PuntajeTotal {

	const filasDeCombate
	var puntajeTotal = 0
	const pos_x = 16
	var pos_y
	const imagen

	method actualizarPuntajeTotal() {
		puntajeTotal = filasDeCombate.map({ fila => fila.puntajeFila() }).sum()
	}

	method puntajeTotal() = puntajeTotal

	method text() {
		return puntajeTotal.toString()
	}

	method textColor() {
		return "000000FF"
	}

	method image() {
		return imagen
	}

	method position() {
		return game.at(pos_x, pos_y)
	}

}

const puntajeTotalJugador = new PuntajeTotal(filasDeCombate = [ filaAsedioJugador, filaArqueroJugador, filaInfanteJugador ], pos_y = 14, imagen = "assets/PJ-02.png")

const puntajeTotalRival = new PuntajeTotal(filasDeCombate = [ filaAsedioRival, filaArqueroRival, filaInfanteRival ], pos_y = 35, imagen = "assets/PR-02.png")

// ver si hacer objeto rival o hacer clase
// cambiar nombre despues
// IDEA MING
//object jugador {
//
//	const filasDeCombate = [ filaAsedio, filaArquero, filaInfante ]
//	var puntajeTotal = 0
//	// objeto jugador info => display
//
//	method actualizarPuntajeTotal() {
//		puntajeTotal = filasDeCombate.map({ fila => fila.puntajeFila() }).sum()
//	}
//
//	method puntajeTotal() = puntajeTotal
//
//}    