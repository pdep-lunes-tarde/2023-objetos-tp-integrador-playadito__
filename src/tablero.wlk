import wollok.game.*
import juego.*
import selector.*
import cartas.*
import numeros.*
import constantes.*

object tablero {

	const filasJugador = new Dictionary()
	const filasRival = new Dictionary()

	method establecerRelacionCombateFila() {
		filasRival.put("asedio", filaAsedioRival)
		filasRival.put("arqueria", filaArqueroRival)
		filasRival.put("infanteria", filaInfanteRival)
		filasJugador.put("infanteria", filaInfanteJugador)
		filasJugador.put("arqueria", filaArqueroJugador)
		filasJugador.put("asedio", filaAsedioJugador)
	}

	method resetearTablero() {
		filasJugador.forEach({ claseCombate , filaCombate => filaCombate.vaciarFila()})
		filasRival.forEach({ claseCombate , filaCombate => filaCombate.vaciarFila()})
	}

	method mostrar(barajaJugador, barajaRival) {
		filasJugador.forEach({ claseCombate , filaCombate => game.addVisual(filaCombate)})
		filasRival.forEach({ claseCombate , filaCombate => game.addVisual(filaCombate)})
			// mostar fila cartas jugables/////
		game.addVisual(filaCartasJugables)
		filaCartasJugables.mostrar()
			// mostar fila de cartas clima
		game.addVisual(filaCartasClima)
		filaCartasClima.mostrar()
			// /// mostar filas////
		filasJugador.forEach({ claseCombate , filaCombate => filaCombate.mostrar()})
		filasRival.forEach({ claseCombate , filaCombate => filaCombate.mostrar()})
		puntajeTotalJugador.mostrar()
		puntajeTotalRival.mostrar()
			// pasar de ronda, ver si va aca, y asi o con addVisual de una
		pasarDeRonda.mostrarYagregarListener()
			// //
		barajaJugador.mostrar()
		barajaRival.mostrar()
	}

	method cartaJugadaJugador(laCarta) {
		filasJugador.get(laCarta.claseDeCombate()).insertarCarta(laCarta)
	}

	method cartaJugadaRival(unaCarta) {
		filasRival.get(unaCarta.claseDeCombate()).insertarCarta(unaCarta)
	}

}

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

	var cartas = new List()
	var property pos_x = 48
	var property pos_y = 0
	const centroFila = 70 / 2

	method position() = game.at(pos_x, pos_y)

	method mostrar() {
		if (!cartas.isEmpty()) {
			const posicionPrimeraCarta = centroFila - (8 * cartas.size()) / 2
			contador.contador(posicionPrimeraCarta)
			cartas.forEach({ carta => carta.actualizarPosicion(self.calcularAbscisaDeCarta(pos_x), pos_y)})
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

	method calcularAbscisaDeCarta(fila_x) = (fila_x - 6) + contador.contar(8)

	method establecerManoDeCartas(lasCartas) {
		cartas = lasCartas
	}

}

class FilaCartasClima inherits Fila {

	method image() = "assets/FCC-001.png" // una img donde quepa 3 cartas unicamente

	override method insertarCarta(cartaClima) {
		if (cartaClima.tipoClima() == "buenDia") {
			self.jugarCartaDeBuenDia()
		} else {
			self.jugarCartaDeMalTiempo(cartaClima)
		}
	}

	override method removerCarta(cartaClima) {
	// sacar los efectos
	}

	method jugarCartaDeBuenDia() {
		if (!cartas.isEmpty()) {
			self.vaciarFila()
		}
	}

	method jugarCartaDeMalTiempo(cartaClima) {
		const cartasClimaJugadas = cartas.map({ carta => carta.tipoClima() })
		if (!cartasClimaJugadas.contains(cartaClima.tipoClima())) {
			cartas.add(cartaClima)
			self.mostrar()
			cartaClima.aplicarEfecto()
		}
	}

}

class FilaDeCombate inherits Fila {

	// 700px (70 celdas)
	// 120px (6)
	const imagenPuntajeFila
	const puntajeFila = new PuntajeFila(pos_y = pos_y + 4, imagen = imagenPuntajeFila)

	method image() = "assets/FC-002.png"

	method puntajeDeFila() = puntajeFila.puntajeTotalFila()

	override method mostrar() {
		super()
		puntajeFila.mostrar()
	}

	override method insertarCarta(unaCarta) {
		super(unaCarta)
		puntajeFila.actualizarPuntaje(cartas.copy())
	}

	override method removerCarta(unaCarta) {
		// para una fila de combate, remover deberia ser "descartar" y no simplemente eliminarlo de la fila
		super(unaCarta)
		puntajeFila.actualizarPuntaje(cartas.copy())
	}

	// ver si se necesita para otra cosa que clima, o la modificamos
	method modificarPuntajeCartas(bloque) {
		cartas.forEach(bloque)
	}

}

class FilaCartasJugables inherits Fila {

	const selector = new Selector(imagen = "assets/S-05.png", catcher = self)

	method image() = "assets/FC-002.png"

	override method mostrar() {
		super()
		selector.setSelector(cartas)
	}

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		tablero.cartaJugadaJugador(cartaElegida)
		cartas.remove(cartaElegida) // self.removerCarta(cartaElegida)
		game.schedule(700, { => filaCartasRival.jugarCarta()})
		self.mostrar()
	}

}

class FilaCartasRival inherits Fila {

	method jugarCarta() {
		const cartaElegida = cartas.anyOne()
		tablero.cartaJugadaRival(cartaElegida)
		cartas.remove(cartaElegida)
	}

}

class PuntajeFila {

	const pos_x = 42
	const pos_y
	var property puntajeTotalFila = 0
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotalFila.toString())

	method position() = game.at(pos_x, pos_y)

	method image() = imagen

	method mostrar() {
		if (!game.hasVisual(self)) {
			game.addVisual(self)
			game.addVisualIn(numeroPuntaje, game.at(pos_x - 1, pos_y - 1))
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

class PuntajeTotal {

	const pos_x = 32
	const pos_y
	const filasDeCombate
	var property puntajeTotal = 0
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotal.toString())

	method position() = game.at(pos_x, pos_y)

	method image() = imagen

	method mostrar() {
		game.addVisual(self)
		game.addVisualIn(numeroPuntaje, game.at(pos_x, pos_y))
	}

	method actualizarPuntajeTotal() {
		self.puntajeTotal(filasDeCombate.map({ fila => fila.puntajeDeFila()}).sum())
		numeroPuntaje.modificarNumero(puntajeTotal)
	}

}

object pasarDeRonda {

	const pos_x = 129
	const pos_y = -1

	method text() = "Pasar de ronda (r)"

	method textColor() = "F2F2D9FF"

	method mostrarYagregarListener() {
		game.addVisualIn(self, game.at(pos_x, pos_y))
		keyboard.r().onPressDo{ self.pasarRonda()}
	}

	method pasarRonda() {
		game.schedule(700, {=> filaCartasRival.jugarCarta()})
		game.schedule(2000, {=> partida.finalizarRonda()})
	}

}

