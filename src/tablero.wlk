import wollok.game.*
import carta.*
import tp.*

object tablero {

	const filasJugador = new Dictionary()
	const filasRival = new Dictionary()

	method inicializarTablero() {
		filasJugador.put("infanteria", filaInfanteJugador)
		filasJugador.put("arqueria", filaArqueroJugador)
		filasJugador.put("asedio", filaAsedioJugador)
		self.mostar()
	}

	method mostar() {
		game.addVisual(filaAsedioJugador)
		game.addVisual(filaArqueroJugador)
		game.addVisual(filaInfanteJugador)
		game.addVisual(filaAsedioRival)
		game.addVisual(filaArqueroRival)
		game.addVisual(filaInfanteRival)
			// mostar fila cartas jugables
		game.addVisual(filaCartasJugables)
			// filaCartasJugables.mostrar()
			// mostar filas
		filaAsedioJugador.mostrar()
		filaArqueroJugador.mostrar()
		filaInfanteJugador.mostrar()
		filaAsedioRival.mostrar()
		filaArqueroRival.mostrar()
		filaInfanteRival.mostrar()
	}

	method cartaJugadaJugador(laCarta) {
		filasJugador.get(laCarta.claseDeCombate().insertarCarta(laCarta))
	}

	method cartaJugadaRival(unaCarta) {
	}

}

class FilaDeCombate {

	// 700px (35 celdas)
	// 120px (6)
	const cartas = new List()
	const pos_x = 24
	const pos_y
	const imagenPuntajeFila
	const puntajeFila = new PuntajeFila(cartasFila = cartas, pos_y = pos_y + 2, imagen = imagenPuntajeFila)

	method puntajeDeFila() {
		game.addVisual(puntajeFila)
	}

	method position() {
		return game.at(pos_x, pos_y)
	}

	method image() {
		return "assets/FC-002.png"
	}

//	method actualizarPuntaje() {
//		puntaje = cartas.map({ carta => carta.puntaje() }).sum()
//	}
	method insertarCarta(unaCarta) {
		cartas.add(unaCarta)
		puntajeFila.sum(unaCarta.puntaje())
		self.mostrar()
	}

	method listaCartas() = cartas

	method mostrar() {
		if (!cartas.isEmpty()) {
			contador.setear()
			cartas.forEach({ carta => carta.setPosition(self.calcularPosicionEnXCarta(pos_x), pos_y)})
			cartas.forEach({ carta => carta.mostrar()})
		}
		puntajeFila.mostrar()
	}

	method calcularPosicionEnXCarta(fila_x) = (fila_x - 3) + contador.contar(4)

	// inserta una carta en la linea (cuando se juega una carta)
	method agregarCarta(unaCarta) {
		cartas.add(unaCarta)
		puntajeFila.sum(unaCarta.puntaje())
		self.mostrar()
	}

	// para mas adelante (efecto de algunas cartas especiales)
	method removerCarta() {
		// ...
		self.mostrar()
	}

	// limpia la fila (para fin de ronda)
	method vaciarFila() {
		cartas.clear()
		self.mostrar()
	}

}

//usar times
// ES MALO ESTO, PENSAR OTRA FORMA
// es para el display formateado
object contador {

	var contador = 0

	method contar(aumento) {
		contador = contador + aumento
		return contador
	}

	method setear() {
		contador = 0
	}

}

const filaAsedioJugador = new FilaDeCombate(pos_y = 9, imagenPuntajeFila = "assets/PJ-01.png")

const filaArqueroJugador = new FilaDeCombate(pos_y = 15, imagenPuntajeFila = "assets/PJ-01.png")

const filaInfanteJugador = new FilaDeCombate(pos_y = 21, imagenPuntajeFila = "assets/PJ-01.png")

const filaAsedioRival = new FilaDeCombate(pos_y = 28, imagenPuntajeFila = "assets/PR-01.png")

const filaArqueroRival = new FilaDeCombate(pos_y = 34, imagenPuntajeFila = "assets/PR-01.png")

const filaInfanteRival = new FilaDeCombate(pos_y = 40, imagenPuntajeFila = "assets/PR-01.png")

class PuntajeFila {

	var cartasFila
	var puntajeTotalFila = 0
	const pos_x = 22
	var pos_y
	const imagen

	method actualizarPuntajeTotal() {
		puntajeTotalFila = cartasFila.map({ carta => carta.puntaje() }).sum()
	}

	method position() = game.at(pos_x, pos_y)

	method puntajeTotalFila() = puntajeTotalFila

	method text() = puntajeTotalFila.toString()

	method textColor() = "000000FF"

	method image() = imagen

	method sumar(puntajeCartaNueva) {
		puntajeTotalFila = puntajeTotalFila + puntajeCartaNueva
	}

	method restar(puntajeCartaEliminada) {
		puntajeTotalFila = puntajeTotalFila - puntajeCartaEliminada
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
		seleccionador = new Selector(image = "assets/S-02.png", catcher = self)
		seleccionador.setSelector(self.listaDeCartas())
	// esto es temporal
	}

	method establecerManoCartas(lasCartas) {
		cartas = lasCartas
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
//		const selectedCard = cartas.get(index)
//		board_.playerPlay(selectedCard)
//		remainingCards.remove(selectedCard)
//		self.displayCards()
	// se elimina la carta de la lista
	// mostrarCartas() -> muestra de nuevo la lista actualizada
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