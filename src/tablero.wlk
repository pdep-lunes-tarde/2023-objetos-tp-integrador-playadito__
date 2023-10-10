import wollok.game.*
import tp.*
import selector.*
import carta.*
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Fila {

	const cartas = new List()
	const centroFila = 70 / 2
	var property pos_x = 48
	var property pos_y

	method position() = game.at(pos_x, pos_y)

	// mostar centrado
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

}

class FilaDeCombate inherits Fila {

	// 700px (70 celdas)
	// 120px (6)
	const imagenPuntajeFila
	const puntajeFila = new PuntajeFila(cartasFila = cartas, pos_y = pos_y + 4, imagen = imagenPuntajeFila)

	method image() = "assets/FC-002.png"

	method puntajeDeFila() = puntajeFila.puntajeTotalFila()

	override method mostrar() {
		super()
		puntajeFila.mostrar()
	}

	override method insertarCarta(unaCarta) {
		puntajeFila.sumar(unaCarta.puntaje())
		puntajeTotalRival.actualizarPuntajeTotal()
		puntajeTotalJugador.actualizarPuntajeTotal()
		super(unaCarta)
	}

	override method removerCarta(unaCarta) {
		puntajeFila.restar(unaCarta.puntaje())
		puntajeTotalRival.actualizarPuntajeTotal()
		puntajeTotalJugador.actualizarPuntajeTotal()
		super(unaCarta)
	}

	override method vaciarFila() {
		super()
		puntajeTotalJugador.actualizarPuntajeTotal()
		puntajeTotalRival.actualizarPuntajeTotal()
	}

	// ver si se necesita para otra cosa que clima, o la modificamos
	method modificarPuntajeCartas(bloque) {
		cartas.forEach(bloque)
	}

}

// da error cuando es object
// porque pide inicializar valor de pos_y pero no c como se hace
class FilaCartasJugables inherits Fila {

	const selector = new Selector(imagen = "assets/S-05.png", catcher = self)

	method image() = "assets/FC-002.png"

	method establecerfilaCartasJugables(lasCartas) {
		// cambio de forma de asignacion porque en la superclase se usa const
		lasCartas.forEach({ carta => cartas.add(carta)})
	}

	override method mostrar() {
		super()
		selector.setSelector(cartas)
	}

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		tablero.cartaJugadaJugador(cartaElegida)
		cartas.remove(cartaElegida)
			// self.removerCarta(cartaElegida)
		game.schedule(700, {=> filaCartasRival.tomarSeleccion()}) // jugadaAutomaticaDelRival al segundo
		self.mostrar()
	}

}

const filaCartasJugables = new FilaCartasJugables(pos_y = 4)

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PuntajeFila {

	var cartasFila
	var puntajeTotalFila = 0
	const pos_x = 42
	var pos_y
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotalFila.toString())

	method mostrar() {
		if (!game.hasVisual(self)) {
			game.addVisual(self)
			game.addVisualIn(numeroPuntaje, game.at(pos_x - 1, pos_y - 1))
		}
	}

	method position() = game.at(pos_x, pos_y)

	method puntajeTotalFila() = puntajeTotalFila

	method image() = imagen

	method sumar(puntajeCartaNueva) {
		puntajeTotalFila = puntajeTotalFila + puntajeCartaNueva
		numeroPuntaje.modificarNumero(puntajeTotalFila)
	}

	method restar(puntajeCartaEliminada) {
		puntajeTotalFila = puntajeTotalFila - puntajeCartaEliminada
		numeroPuntaje.modificarNumero(puntajeTotalFila)
	}

	method resetearPuntaje() {
		puntajeTotalFila = 0
		numeroPuntaje.modificarNumero(puntajeTotalFila)
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PuntajeTotal {

	const filasDeCombate
	var puntajeTotal = 0
	const pos_x = 32
	var pos_y
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotal.toString())

	method actualizarPuntajeTotal() {
		puntajeTotal = filasDeCombate.map({ fila => fila.puntajeDeFila() }).sum()
		numeroPuntaje.modificarNumero(puntajeTotal)
	}

	method puntajeTotal() = puntajeTotal

	method image() = imagen

	method position() = game.at(pos_x, pos_y)

	method mostrar() {
		game.addVisual(self)
		game.addVisualIn(numeroPuntaje, game.at(pos_x, pos_y))
	}

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
object filaCartasRival {

	var cartas = new List()

	method establecerManoCartas(lasCartas) {
		cartas = lasCartas
	}

	// method listaDeCartas() = cartas
	method tomarSeleccion() {
		const cartaElegida = cartas.anyOne()
		tablero.cartaJugadaRival(cartaElegida)
		cartas.remove(cartaElegida)
	}

	method agregarCarta(unaCarta) {
	// metodo para cartas especiales
	}

	method listaCartas() = cartas.copy()

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
object pasarDeRonda {

	// const imagen = "assets/C-pasarDeRonda.png"
	const pos_x = 129
	const pos_y = -1

	// method position() = 
	// method image() = imagen
	method text() = "Pasar de ronda (r)"

	method textColor() = "F2F2D9FF"

	method mostrarYagregarListener() {
		game.addVisualIn(self, game.at(pos_x, pos_y))
		keyboard.r().onPressDo{ self.pasarRonda()}
	}

	method pasarRonda() {
		game.schedule(700, {=> filaCartasRival.tomarSeleccion()})
		game.schedule(2000, {=> partida.finalizarRonda()})
	}

}

