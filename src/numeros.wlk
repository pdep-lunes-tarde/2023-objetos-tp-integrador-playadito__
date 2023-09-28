import wollok.game.*

class Numero {

	var numero
	var posX = 0
	var posY = 0

	method text() = numero.toString()

	method textColor() = "000000FF"

	method modificarNumero(nuevoNumero) {
		numero = nuevoNumero
	}

	method position() = game.at(posX, posY)

	method actualizarPosicion(x, y) {
		posX = x
		posY = y
	}

	method esconder() {
		game.removeVisual(self)
	}

}

