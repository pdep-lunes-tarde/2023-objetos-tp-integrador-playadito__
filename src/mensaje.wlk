import imagen.*
import wollok.game.*

class Mensaje inherits Imagen (posEnX = 0, posEnY = 42) {

	method llamarMensaje() {
		game.addVisual(self)
		game.schedule(1000, {=> self.esconder()})
	}

}

class MensajeFinPartida inherits Imagen (posEnX = 0, posEnY = 0) {

	method llamarMensaje() {
		game.addVisual(self)
	}

}

