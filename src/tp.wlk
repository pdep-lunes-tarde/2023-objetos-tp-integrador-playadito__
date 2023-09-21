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
//		game.addVisual(tablero)
		game.ground("assets/BG-001.png")
		game.start()
	}

}

object jugador {

	method jugarCarta() {
	}

}

