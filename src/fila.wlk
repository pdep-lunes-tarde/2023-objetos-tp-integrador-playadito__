import wollok.game.*
import juego.*
import selector.*
import tablero.*
import constantes.*
import numeros.*

//usar times
// ES MALO ESTO, PENSAR OTRA FORMA
// es para el display formateado
object contador {

	var property contador = 0

	method contar(aumento) {
		contador = contador + aumento
		return contador
	}

}

class Fila {

	const cartas = new List()
	var property posEnX = 55
	var property posEnY = 0
	var property posEnYCarta = posEnY
	const centroFila = 90 / 2 - 2

	method position() = game.at(posEnX, posEnY)

	method mostrar() {
		if (!cartas.isEmpty()) {
			const posicionPrimeraCarta = centroFila - (8 * cartas.size()) / 2
			contador.contador(posicionPrimeraCarta)
			cartas.forEach({ carta => carta.actualizarPosicion(self.calcularAbscisaDeCarta(posEnX), posEnYCarta)})
			cartas.forEach({ carta => carta.mostrar()})
		}
	}

	method listaCartas() = cartas.copy()

	method insertarCarta(unaCarta) {
		cartas.add(unaCarta)
		self.mostrar()
	}

	method removerCarta(unaCarta) {
		unaCarta.esconder()
		cartas.remove(unaCarta)
	}

	method vaciarFila() {
		cartas.forEach({ carta => self.removerCarta(carta)})
	}

	method calcularAbscisaDeCarta(filaEnX) = (filaEnX - 6) + contador.contar(8)

	method cantidadCartas() = cartas.size()

	method tieneCartas() = !cartas.isEmpty()

}

class FilaDeCombate inherits Fila {

	// 700px (70 celdas)
	// 120px (6)
	const claseDeCombate
	const jugadorDeFila
	var property climaExtremo = false
	const imagenPuntajeFila
	const puntajeFila = new PuntajeFila(posEnY = posEnY + 4, imagen = imagenPuntajeFila)

	method image() = "assets/FC-002.png"

	method puntajeDeFila() = puntajeFila.puntajeTotalFila()

	method claseDeCombate() = claseDeCombate

	override method mostrar() {
		super()
		puntajeFila.mostrar()
	}

	override method insertarCarta(unaCarta) {
		if (climaExtremo) {
			unaCarta.modificarPuntajeA(1)
		}
		super(unaCarta)
		puntajeFila.actualizarPuntaje(cartas.copy())
	}

	override method removerCarta(unaCarta) {
		unaCarta.resetearPuntaje()
		super(unaCarta)
		jugadorDeFila.descartarCarta(unaCarta)
		puntajeFila.actualizarPuntaje(cartas.copy())
	}

	method modificarPuntajeCartas(bloque) {
		cartas.forEach(bloque)
		puntajeFila.actualizarPuntaje(cartas.copy())
	}

	method tiempoFeo() {
		self.climaExtremo(true)
		self.modificarPuntajeCartas({ carta => carta.modificarPuntajeA(1)})
	}

	method diaDespejado() {
		self.climaExtremo(false)
		self.modificarPuntajeCartas({ carta => carta.resetearPuntaje()})
	}

}

object filaCartasClima inherits Fila(posEnX = 11, posEnY = 42, posEnYCarta = 43, centroFila = 26 / 2 - 2) {

	method image() = "assets/FCC-001.png" // una img donde quepa 3 cartas unicamente

	override method insertarCarta(unaCarta) {
		const cartasEnFila = cartas.map({ carta => carta.tipoDeClima() })
		if (!cartasEnFila.contains(unaCarta.tipoDeClima())) {
			super(unaCarta)
		}
	}

	override method removerCarta(unaCarta) {
		unaCarta.removerEfecto()
		super(unaCarta)
	}

}

object filaCartasJugador inherits Fila(posEnY = 4) {

	const selector = new Selector(imagen = "assets/S-05.png", catcher = self)

	method image() = "assets/FC-002.png"

	override method mostrar() {
		super()
		selector.setSelector(cartas)
		juego.selectorActual(selector)
		if (cartas.isEmpty()) {
			pasarDeMano.jugadorPasa()
		}
	}

	method establecerManoDeCartas(lasCartas) {
		lasCartas.forEach({ carta => cartas.add(carta)})
	}

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		self.removerCarta(cartaElegida)
		tablero.jugarCarta(cartaElegida)
		seccionDatosJugador.actualizarInfo()
		self.mostrar()
	}

}

object filaCartasRival inherits Fila {

	method establecerManoDeCartas(lasCartas) {
		lasCartas.forEach({ carta => cartas.add(carta)})
	}

	override method mostrar() {
	}

	method jugarCarta() {
		try {
			const carta = cartas.anyOne()
			tablero.jugarCarta(carta)
			cartas.remove(carta)
			seccionDatosRival.actualizarInfo()
		} catch e : Exception {
			// cuando el rival no tenga mas cartas,
			// habra excepcion, se atrapa y pasa de mano
			pasarDeMano.rivalPasa()
		}
	}

}

class FilaCartaLider inherits Fila(posEnX = 11, centroFila = 10 / 2 - 2) {

	method image() = "assets/FCL-001.png"

}

class FilaCartasDescartadas inherits Fila(posEnX = 147, centroFila = 10 / 2 - 2) {

//	const numeroDescartadas = new Numero(numero = 0)
	method image() = "assets/FCL-001.png"

	override method removerCarta(unaCarta) {
		cartas.remove(unaCarta)
		self.mostrar()
	}

	override method mostrar() {
		if (!cartas.isEmpty()) {
			cartas.last().actualizarPosicion(posEnX + 1, posEnYCarta)
			cartas.last().mostrar()
		}
	}

}

class PuntajeFila {

	const posEnX = 50
	const posEnY
	var property puntajeTotalFila = 0
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotalFila)

	method position() = game.at(posEnX, posEnY)

	method image() = imagen

	method mostrar() {
		if (!game.hasVisual(self)) {
			game.addVisual(self)
			game.addVisualIn(numeroPuntaje, game.at(posEnX - 1, posEnY - 1))
		}
	}

	method actualizarPuntaje(filaDeCartas) {
		puntajeTotalFila = filaDeCartas.map({ carta => carta.puntaje() }).sum()
		numeroPuntaje.modificarNumero(puntajeTotalFila)
		puntajeTotalRival.actualizarPuntajeTotal()
		puntajeTotalJugador.actualizarPuntajeTotal()
	}

	method resetearPuntaje() {
		puntajeTotalFila = 0
		numeroPuntaje.modificarNumero(puntajeTotalFila)
	}

}

