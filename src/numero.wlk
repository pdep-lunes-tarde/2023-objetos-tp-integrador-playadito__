import wollok.game.*

class Numero {

	var property numero
	var property posEnX = 0
	var property posEnY = 0
	var property color = "000000FF"

	method text() = numero.toString()

	method textColor() = color

	method modificarNumero(nuevoNumero) {
		self.numero(nuevoNumero)
	}

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

