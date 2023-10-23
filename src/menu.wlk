import wollok.game.*
import juego.*
import cartas.*
import selector.*
import constantes.*

class CartaMenu inherits Carta(tipoDeCarta = cartaDeMenu) {

	override method position() = game.at(self.posEnX(), self.posEnY())

	override method image() = "assets/baraja-menu-" + self.faccion().nombre() + ".png"

}

const cartaImperioNiffgardiano = new CartaMenu(faccion = imperioNiffgardiano, posEnX = 46, posEnY = 13)

const cartaReinosDelNorte = new CartaMenu(faccion = reinosDelNorte, posEnX = 76, posEnY = 13)

const cartaScoiatael = new CartaMenu(faccion = scoiatael, posEnX = 106, posEnY = 13)

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

