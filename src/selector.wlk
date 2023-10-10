import wollok.game.*

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
		self.mostrarEn(self.obtenerPosicionItem(index))
	}

	// posicion segun el objeto a seleccionar
	method obtenerPosicionItem(itemIndex) {
		const item = items.get(itemIndex)
		return game.at(item.pos_x(), item.pos_y())
	}

	// mostrar / actualizar
	method mostrarEn(position) {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		}
		game.addVisualIn(self, position)
	}

	// esto es temporal, el selector para el menu sigue existiendo
	// hay q ver como desreferenciarlo por completo
	method esconder() {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		}
		items.clear()
	}

	// listener y efectos
	method initialize() {
		keyboard.left().onPressDo{ self.moveLeft()}
		keyboard.right().onPressDo{ self.moveRight()}
		keyboard.enter().onPressDo{ self.select()}
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
		index = 0
		self.mostrarEn(self.obtenerPosicionItem(index))
	}

}

