import wollok.game.*

object tablero {

	method position() {
		return game.origin().up(10)
	}

	method image() {
	}

}

class FilaDeCombate {

	const cartas = new List()
	var puntaje = 0

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

// ver si hacer objeto rival o hacer clase
object tableroJugador {

	const filaAsedio = new FilaDeCombate()
	const filaArquero = new FilaDeCombate()
	const filaInfante = new FilaDeCombate()
	var puntajeTotal = 0

}

