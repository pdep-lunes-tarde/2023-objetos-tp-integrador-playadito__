import wollok.game.*

class Imagen {

	var property imagen
	var property posEnX = 0
	var property posEnY = 0

	method image() = imagen

	method position() = game.at(posEnX, posEnY)

	method mostrar() {
		game.addVisual(self)
	}

	method esconder() {
		game.removeVisual(self)
	}

	method actualizarPosicion(x, y) {
		self.posEnX(x)
		self.posEnY(y)
	}

}

