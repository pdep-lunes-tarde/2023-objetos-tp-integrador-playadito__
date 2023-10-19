import wollok.game.*

class Numero {

	var numero
	var posX = 0
	var posY = 0
	var color = "000000FF"

	method text() = numero.toString()

	method textColor() = color

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

