import wollok.game.*

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
	const pos_x = 28
	const pos_y

	method position() {
		return game.at(pos_x, pos_y)
	}

	method image() {
		return "assets/FC-001.png"
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

}

object filaCartasJugables {

	const cartas = new List()

	method position() {
	}

	method image() {
	}

	method mostrarCartas() {
	// display de cartas (wollok game display)
	}

	method manoInicial(nuevasCartas) {
	// comienzo de partida (10)
	// nueva ronda (5)
	}

	method agregarCarta(carta) {
	// metodo para cartas especiales
	}

	method siguiente() {
	// mover el selector
	}

	method seleccionar() {
	// se elimina la carta de la lista
	// mostrarCartas() -> muestra de nuevo la lista actualizada
	}

}

const filaAsedio = new FilaDeCombate(pos_y = 8)

const filaArquero = new FilaDeCombate(pos_y = 16)

const filaInfante = new FilaDeCombate(pos_y = 22)

object puntajeTotalJugador {

	const filasDeCombate = [ filaAsedio, filaArquero, filaInfante ]
	var puntajeTotal = 0

	method actualizarPuntajeTotal() {
		puntajeTotal = filasDeCombate.map({ fila => fila.puntajeFila() }).sum()
	}

	method puntajeTotal() = puntajeTotal

	method image() {
	}

	method position() {
	}

}

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
