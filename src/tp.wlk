import wollok.game.*

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
//		game.addVisual(tablero)
		game.ground("assets/BG-003.png")
		game.start()
	}

}

// razon: porque la definicion los metodos del efecto de cada baraja son diferentes
object reinosDelNorte {

	method efectoFinDeRonda() {
	}

}

object imperioNiffgardiano {

	method efectoFinDeRonda() {
	}

}

object scoiatael {

	method efectoFinDeRonda() {
	}

}

class CartaDeUnidad {

	const baraja // objeto
	const claseDeCombate // cadena, ej "infanteria"
	const valor // puntaje inicial u original (valor numerico)
	var puntaje = valor // puntaje modificable
	const especialidad // objeto de especialidad

}

class CartaHeroe {

}

class CartaEspecial {

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

object jugador {

	method jugarCarta() {
	}

}

// ver si hacer objeto rival o hacer clase
object tableroJugador {

	const filaAsedio = new FilaDeCombate()
	const filaArquero = new FilaDeCombate()
	const filaInfante = new FilaDeCombate()
	var puntajeTotal = 0

}

object tablero {

	method position() {
		return game.origin().up(10)
	}

	method image() {
		return "issues-01.png"
	}

}

