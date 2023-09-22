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
		game.height(50)
		game.cellSize(20)
		game.addVisual(cartaUno)
		game.addVisual(filaAsedio)
		game.ground("assets/test_img.png")
		game.start()
	}

}

object jugador {

	method jugarCarta() {
	}

}

