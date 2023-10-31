import wollok.game.*
import juego.*

object noHaySelector {

	method moveLeft() {
	}

	method moveRight() {
	}

	method select() {
	}

}

class Selector {

	var items = new List()
	const imagen
	const catcher // objeto al que le voy a devolver lo seleccionado
	var index = 0

	// wollok game req
	method image() = imagen

	// comenzar
	method setSelector(itemsList) {
		items = itemsList.copy()
		index = 0
		self.mostrarEn(self.obtenerPosicionItem(index))
	}

	// posicion segun el objeto a seleccionar
	method obtenerPosicionItem(itemIndex) {
		const item = items.get(itemIndex)
		return game.at(item.posEnX(), item.posEnY())
	}

	// mostrar / actualizar
	method mostrarEn(posicion) {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		}
		game.addVisualIn(self, posicion)
	}

	method esconder() {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		}
		juego.selectorActual(noHaySelector)
	}

	method moveLeft() {
		if (index > 0) {
			index--
			self.mostrarEn(self.obtenerPosicionItem(index))
		}
	}

	method moveRight() {
		if (index < items.size() - 1) {
			index++
			self.mostrarEn(self.obtenerPosicionItem(index))
		}
	}

	method select() {
		game.removeVisual(self)
		items.remove(items.get(index))
		catcher.tomarSeleccion(index)
	}

}

