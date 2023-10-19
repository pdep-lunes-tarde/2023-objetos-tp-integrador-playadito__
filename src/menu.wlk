import wollok.game.*
import juego.*
import cartas.*
import selector.*
import constantes.*

class CartaMenu inherits Carta(tipoDeCarta = cartaDeMenu) {

	override method position() = game.at(self.pos_x(), self.pos_y())

	override method image() = "assets/baraja-menu-" + self.faccion().nombre() + ".png"

}

const cartaImperioNiffgardiano = new CartaMenu(faccion = imperioNiffgardiano, pos_x = 46, pos_y = 13)

const cartaReinosDelNorte = new CartaMenu(faccion = reinosDelNorte, pos_x = 76, pos_y = 13)

const cartaScoiatael = new CartaMenu(faccion = scoiatael, pos_x = 106, pos_y = 13)

object menu {

	// se puede meter los new directamente, pero se hace un re choclo
	const cartasMenu = [ cartaImperioNiffgardiano, cartaReinosDelNorte, cartaScoiatael ]
	const selector = new Selector(imagen = "assets/S-07.png", catcher = self)

	method position() = game.at(0, 0)

	method image() = "assets/menu-bg2.png"

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
		const faccionElegida = cartasMenu.get(index).faccion()
		const barajaSeleccionada = lasBarajas.find({ baraja => baraja.faccion().equals(faccionElegida) })
		self.esconder()
		partida.start(barajaSeleccionada)
	}

}

