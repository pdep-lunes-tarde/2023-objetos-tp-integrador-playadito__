import wollok.game.*

class Numero {

	var numero
	var posEnX = 0
	var posEnY = 0
	var property color = "000000FF"

	method text() = numero.toString()

	method textColor() = color

	method modificarNumero(nuevoNumero) {
		numero = nuevoNumero
	}

	method position() = game.at(posEnX, posEnY)

	method actualizarPosicion(x, y) {
		posEnX = x
		posEnY = y
	}

	method mostrar() {
		if (!game.hasVisual(self)) {
			game.addVisual(self)
		}
	}

	method esconder() {
		game.removeVisual(self)
	}

}

