import wollok.game.*
import tablero.*
import carta.*

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
		game.ground("assets/BG-003.png")
		cartasJugables.cartasPrimeraRonda()
		filaAsedioJugador.puntajeDeFila()
		filaArqueroJugador.puntajeDeFila()
		filaInfanteJugador.puntajeDeFila()
		filaArqueroRival.puntajeDeFila()
		filaInfanteRival.puntajeDeFila()
		filaAsedioRival.puntajeDeFila()
			// esto es temporal
		game.start()
	}

}

object jugador {

	method elegirBaraja() {
	// primera interfaz con tres cartas identificando a las tres barajas
	// cartasJugables.cartasPrimeraRonda(barajaElegida.mazo())
	}

	method jugarCarta() {
	}

}

