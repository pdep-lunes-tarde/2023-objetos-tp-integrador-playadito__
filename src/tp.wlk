import wollok.game.*

object tpIntegrador {

	method jugar() {
		window.init()
	}

}

//object tablero {
//
//	const columns = 0
//	const rows = 0
//
//}
object window {

	method init() {
		game.width(32)
		game.height(18)
		game.cellSize(50)
		game.start()
	}

}

