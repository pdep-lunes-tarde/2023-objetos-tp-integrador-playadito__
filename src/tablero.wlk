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
		filaCartasJugables.mostrar()
			// mostar filas
		game.addVisual(puntajeTotalJugador)
		game.addVisual(puntajeTotalRival)
		filaAsedioJugador.mostrar()
		filaArqueroJugador.mostrar()
		filaInfanteJugador.mostrar()
		filaAsedioRival.mostrar()
		filaArqueroRival.mostrar()
		filaInfanteRival.mostrar()
	}

	method cartaJugadaJugador(laCarta) {
		filasJugador.get(laCarta.claseDeCombate()).insertarCarta(laCarta)
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
		puntajeFila.sumar(unaCarta.puntaje())
		self.mostrar()
	}

	method listaCartas() = cartas

	method mostrar() {
		if (!cartas.isEmpty()) {
			contador.setear()
			cartas.forEach({ carta => carta.setPosicion(self.calcularPosicionEnXCarta(pos_x), pos_y)})
			cartas.forEach({ carta => carta.mostrar()})
		}
		puntajeFila.mostrar()
	}

	method calcularPosicionEnXCarta(fila_x) = (fila_x - 3) + contador.contar(4)

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

	method mostrar() {
		game.addVisual(self)
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

////////Opcion fuera de los tipos de barajas////////////////
//object cartasJugables {
//
//	const manoCartas = new List()
//	var cartaAleatoria
//
//	method obtenerCartaRandom(barajaElegida) {
//		const unaCarta = barajaElegida.anyOne()
//		manoCartas.add(unaCarta)
//		barajaElegida.remove(unaCarta)
//	}
//
//	method setCartas(barajaElegida, cantidadCartas) {
//		cantidadCartas.times({ i => self.obtenerCartaRandom(barajaElegida)})
//		return manoCartas
//	}
//
//}
object filaCartasJugables {

	var cartas = new List()
	var pos_x = 25
	const pos_y = 2
	var seleccionador

	method position() = game.at(24, 2)

	method image() = "assets/FC-002.png"

	// muestra / actualiza las cartas
	method mostrar() {
		contador.setear()
		cartas.forEach({ carta => carta.setPosicion(self.calcularPosicionEnXCarta(pos_x), pos_y)})
		cartas.forEach({ carta => carta.mostrar()})
		seleccionador = new Selector(image = "assets/S-02.png", catcher = self)
		seleccionador.setSelector(self.listaDeCartas())
	}

	// metodo repetido,
	method calcularPosicionEnXCarta(fila_x) = (fila_x - 3) + contador.contar(4)

	method establecerManoCartas(lasCartas) {
		cartas = lasCartas
	}

	method listaDeCartas() = cartas

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		tablero.cartaJugadaJugador(cartaElegida)
		self.listaDeCartas().remove(cartaElegida)
			// seleccionador.vaciarListaItems()
		self.mostrar()
	}

	method agregarCarta(unaCarta) {
	// metodo para cartas especiales
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