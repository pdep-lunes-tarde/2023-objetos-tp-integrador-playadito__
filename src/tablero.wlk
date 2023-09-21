import wollok.game.*

object tablero {

	method position() {
		return game.origin().up(10)
	}

	method image() {
	}

}

class FilaDeCombate {

	const alto
	const ancho
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

// ver si hacer objeto rival o hacer clase
object tableroJugador {

	const filaAsedio = new FilaDeCombate()
	const filaArquero = new FilaDeCombate()
	const filaInfante = new FilaDeCombate()
	var puntajeTotal = 0

}

