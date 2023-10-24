import wollok.game.*

class Imagen {

	var property imagen
	var posEnX = 0
	var posEnY = 0

	method image() = imagen

	method position() = game.at(posEnX, posEnY)

	method actualizarPosicion(x, y) {
		posEnX = x
		posEnY = y
	}

	method esconder() {
		game.removeVisual(self)
	}

}

