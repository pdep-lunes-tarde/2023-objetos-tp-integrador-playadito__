object prueba {

	var cosas = new List()
	var sel

	method init() {
		cosas = [ ab, cd, ef, gh ]
		self.act()
	}

	method sell() = sel

	method cosas() = cosas

	method act() {
		sel = new Sel(catcher = self)
		sel.setSelector(cosas)
	}

	method tomarSeleccion(index) {
		const elegida = cosas.get(index)
		cosas.remove(elegida)
		self.act()
	}

}

class Car {

}

const ab = new Car()

const cd = new Car()

const ef = new Car()

const gh = new Car()

class Sel {

	var items = new List()
	const catcher
	var index = 0

	method setSelector(itemsList) {
		items = items + itemsList
	}

	method items() = items

	method select(num) {
//		items.remove(items.get(index))
		index = num
		catcher.tomarSeleccion(index)
	}

}

