import wollok.game.*
import selector.*
import tablero.*
import juego.*
import constantes.*
import fila.*

object modalRecuperarCarta {

	var cartas = []
	const selectorModal = new Selector(imagen = "assets/S-05.png", catcher = self)

	method position() = game.at(0, 0)

	method image() = "assets/modal.png"

	method mostrarModal(cartasDescartadas) {
		cartas = cartasDescartadas
		game.addVisual(self)
		self.mostrarCartas()
		selectorModal.setSelector(cartas)
		juego.selectorActual(selectorModal)
	// la ejecucion no se detiene a esperar 
	// throw new Exception(message = "llego a setear el selector, pero igual no muestra lo que tiene q mostrar")
	}

	method esconderModal() {
		selectorModal.esconder()
		cartas.forEach({ carta => carta.esconder()})
		cartas.clear()
		game.removeVisual(self)
	}

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		self.esconderModal()
		filaDescartadosJugador.removerCarta(cartaElegida)
		game.schedule(500, { => filaCartasJugador.insertarCarta(cartaElegida)})
	}

	method mostrarCartas() {
		// 85 es centro de pantalla
		const posicionPrimeraCarta = 85 - (10 * cartas.size()) / 2
		contador.contador(posicionPrimeraCarta)
			// Es un asco esto, ya c, pero bueno
		cartas.forEach({ carta => carta.esconder()})
		cartas.forEach({ carta => carta.actualizarPosicion(self.calcularAbscisaDeCarta(), 43)})
		cartas.forEach({ carta => carta.mostrar()})
	}

	method calcularAbscisaDeCarta() = contador.contar(10) - 4

}

