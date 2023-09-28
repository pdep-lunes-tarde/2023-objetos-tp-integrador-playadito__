import wollok.game.*
import carta.*
import tp.*
import numeros.*
import constantes.*

object tablero {

	const filasJugador = new Dictionary()
	const filasRival = new Dictionary()

	method inicializarTablero() {
		filasJugador.put("infanteria", filaInfanteJugador)
		filasJugador.put("arqueria", filaArqueroJugador)
		filasJugador.put("asedio", filaAsedioJugador)
		filasRival.put("infanteria", filaInfanteRival)
		filasRival.put("arqueria", filaArqueroRival)
		filasRival.put("asedio", filaAsedioRival)
		self.mostrar()
	}

	method mostrar() {
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
		puntajeTotalJugador.mostrar()
		puntajeTotalRival.mostrar()
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
		filasRival.get(unaCarta.claseDeCombate()).insertarCarta(unaCarta)
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class FilaDeCombate {

	// 700px (35 celdas)
	// 120px (6)
	const cartas = new List()
	const pos_x = 48
	const pos_y
	const imagenPuntajeFila
	const puntajeFila = new PuntajeFila(cartasFila = cartas, pos_y = pos_y + 4, imagen = imagenPuntajeFila)

	method puntajeDeFila() = puntajeFila.puntajeTotalFila()

	method position() = game.at(pos_x, pos_y)

	method image() = "assets/FC-002.png"

	method insertarCarta(unaCarta) {
		cartas.add(unaCarta)
		puntajeFila.sumar(unaCarta.puntaje())
		puntajeTotalRival.actualizarPuntajeTotal()
		puntajeTotalJugador.actualizarPuntajeTotal()
		self.mostrar()
	}

	// method listaCartas() = cartas
	method mostrar() {
		if (!cartas.isEmpty()) {
			contador.setear()
			cartas.forEach({ carta => carta.actualizarPosicion(self.calcularPosicionEnXCarta(pos_x), pos_y)})
			cartas.forEach({ carta => carta.mostrar()})
		}
		puntajeFila.mostrar()
	}

	method calcularPosicionEnXCarta(fila_x) = (fila_x - 6) + contador.contar(8)

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
object filaCartasJugables {

	var cartas = new List()
	const pos_x = 50
	const pos_y = 4
	var seleccionador

	method position() = game.at(48, 4)

	method image() = "assets/FC-002.png"

	// muestra / actualiza las cartas
	method mostrar() {
		contador.setear()
		cartas.forEach({ carta => carta.actualizarPosicion(self.calcularPosicionEnXCarta(pos_x), pos_y)})
		cartas.forEach({ carta => carta.mostrar()})
		seleccionador = new Selector(image = "assets/S-02.png", catcher = self)
		seleccionador.setSelector(cartas) // aca iba self.listaDeCartas()
	}

	// metodo repetido,
	method calcularPosicionEnXCarta(fila_x) = (fila_x - 6) + contador.contar(8)

	method establecerManoCartas(lasCartas) {
		cartas = lasCartas
	}

	// method listaDeCartas() = cartas
	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		tablero.cartaJugadaJugador(cartaElegida)
		cartas.remove(cartaElegida)
		filaCartasRival.tomarSeleccion()
	// seleccionador.vaciarListaItems()
	// self.mostrar()
	}

	method agregarCarta(unaCarta) {
	// metodo para cartas especiales
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PuntajeFila {

	var cartasFila
	var puntajeTotalFila = 0
	const pos_x = 44
	var pos_y
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotalFila.toString())

	method mostrar() {
		if (game.hasVisual(self)) {
		} else {
			game.addVisual(self)
			game.addVisualIn(numeroPuntaje, game.at(pos_x - 1, pos_y - 1))
		}
	}

	method position() = game.at(pos_x, pos_y)

	method puntajeTotalFila() = puntajeTotalFila

	method image() = imagen

	method sumar(puntajeCartaNueva) {
		puntajeTotalFila = puntajeTotalFila + puntajeCartaNueva
		numeroPuntaje.modificarNumero(puntajeTotalFila)
	}

	method restar(puntajeCartaEliminada) {
		puntajeTotalFila = puntajeTotalFila - puntajeCartaEliminada
		numeroPuntaje.modificarNumero(puntajeTotalFila)
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PuntajeTotal {

	const filasDeCombate
	var puntajeTotal = 0
	const pos_x = 32
	var pos_y
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotal.toString())

	method actualizarPuntajeTotal() {
		puntajeTotal = filasDeCombate.map({ fila => fila.puntajeDeFila() }).sum()
		numeroPuntaje.modificarNumero(puntajeTotal)
	}

	method puntajeTotal() = puntajeTotal

	method image() = imagen

	method position() = game.at(pos_x, pos_y)

	method mostrar() {
		game.addVisual(self)
		game.addVisualIn(numeroPuntaje, game.at(pos_x, pos_y))
	}

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
object filaCartasRival {

	var cartas = new List()

	method establecerManoCartas(lasCartas) {
		cartas = lasCartas
	}

	// method listaDeCartas() = cartas
	method tomarSeleccion() {
		const cartaElegida = cartas.anyOne()
		tablero.cartaJugadaRival(cartaElegida)
		cartas.remove(cartaElegida)
	}

	method agregarCarta(unaCarta) {
	// metodo para cartas especiales
	}

}

