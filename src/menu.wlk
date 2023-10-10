import wollok.game.*
import tp.*
import selector.*
import carta.*
import constantes.*

class CartaMenu inherits Carta {

	const imagen

	override method position() = game.at(self.pos_x(), self.pos_y())

	override method image() = imagen

}

const cartaImperioNiffgardiano = new CartaMenu(imagen = "assets/baraja-menu-imp-niffg2.png", baraja = imperioNiffgardiano, pos_x = 40, pos_y = 50)

const cartaReinosDelNorte = new CartaMenu(imagen = "assets/baraja-menu-reinos2.png", baraja = reinosDelNorte, pos_x = 70, pos_y = 50)

const cartaScoiatael = new CartaMenu(imagen = "assets/baraja-menu-scoiatael2.png", baraja = scoiatael, pos_x = 100, pos_y = 50)

object menu {

	// se puede meter los new directamente, pero se hace un re choclo
	const cartasMenu = [ cartaImperioNiffgardiano, cartaReinosDelNorte, cartaScoiatael ]
	const selector = new Selector(imagen = "assets/S-05.png", catcher = self)

	method position() = game.at(0, 0)

	method image() = "assets/menu-bg.png"

	method mostrarMenu() {
		game.addVisual(self)
		cartasMenu.forEach({ baraja => game.addVisual(baraja)})
		selector.setSelector(cartasMenu)
	}

	method esconder() {
		game.removeVisual(self)
		selector.esconder() // solucion temporal
		cartasMenu.forEach({ baraja => game.removeVisual(baraja)})
	}

	method tomarSeleccion(index) {
		// ...
		const barajaSeleccionada = cartasMenu.get(index).baraja()
		self.esconder()
		partida.start(barajaSeleccionada)
	}

}

