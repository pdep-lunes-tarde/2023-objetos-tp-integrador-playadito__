import wollok.game.*
import juego.*
import selector.*
import cartas.*
import numeros.*
import constantes.*

object tablero {

	const jugadores = new Dictionary()

	method establecerBandoJugador(faccion, jugador) {
		jugadores.put(faccion, jugador)
	}

	method mostrar(barajaJugador, barajaRival) {
		// MOSTRAR FILAS DE COMBATE
		lasFilasDeCombate.forEach({ filaCombate => game.addVisual(filaCombate)})
		lasFilasDeCombate.forEach({ filaCombate => filaCombate.mostrar()})
			// MOSTRAR FILA DE CARTAS CLIMA
		game.addVisual(filaCartasClima)
		filaCartasClima.mostrar()
			// MOSTRAR PUNTAJE TOTAL
		puntajeTotalJugador.mostrar()
		puntajeTotalRival.mostrar()
			// pasar de ronda, ver si va aca, y asi o con addVisual de una
		pasarDeRonda.mostrarYagregarListener()
			// ver si se puede obtener de jugador, para que el metodo no 
			// necesite recibir parametros
		barajaJugador.actualizarPosicion(150, 18)
		barajaRival.actualizarPosicion(150, 75)
		barajaJugador.mostrar()
		barajaRival.mostrar()
			// MOSTRAR FILA CARTAS JUGABLES
		game.addVisual(filaCartasJugador)
		filaCartasJugador.mostrar()
	}

	method resetearTablero() {
		filaCartasClima.vaciarFila()
		lasFilasDeCombate.forEach({ filaCombate => filaCombate.vaciarFila()})
	}

	method jugarCarta(carta) {
		const elJugador = jugadores.get(carta.faccion())
		elJugador.filaParaCarta(carta).insertarCarta(carta)
			// se podria tambien prescindir del booleano tieneEfecto()
			// y dejar efectos vacios
		if (carta.tieneEfecto()) {
			carta.aplicarEfecto()
		}
	}

	method repartirManoInicial() {
		jugadores.forEach({ faccion , jugador => jugador.asignarCartas(10)})
	}

	method sacarCartaPara(faccion) {
	}

	method recuperarCartaPara(faccion) {
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

	const cartas = new List()
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

}

class FilaDeCombate inherits Fila {

	// 700px (70 celdas)
	// 120px (6)
	const claseDeCombate
	var property climaExtremo = false
	const imagenPuntajeFila
	const puntajeFila = new PuntajeFila(pos_y = pos_y + 4, imagen = imagenPuntajeFila)

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
		// para una fila de combate, remover deberia ser "descartar" y no simplemente eliminarlo de la fila
		unaCarta.resetearPuntaje()
		super(unaCarta)
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

object filaCartasClima inherits Fila(cartas = new Set(), pos_x = 10, pos_y = 45, centroFila = 25 / 2) {

	method image() = "assets/FCC-001.png" // una img donde quepa 3 cartas unicamente

	override method removerCarta(cartaClima) {
	// sacar los efectos
	}

}

object filaCartasJugador inherits Fila(pos_y = 4) {

	const selector = new Selector(imagen = "assets/S-05.png", catcher = self)

	method image() = "assets/FC-002.png"

	override method mostrar() {
		super()
		selector.setSelector(cartas)
	}

	method establecerManoDeCartas(lasCartas) {
		lasCartas.forEach({ carta => cartas.add(carta)})
	}

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		tablero.jugarCarta(cartaElegida)
		cartas.remove(cartaElegida)
			// temporal, tendria q ir en tablero
		game.schedule(700, { => filaCartasRival.jugarCarta()})
		game.schedule(1200, { => imagenTurno.llamarMensaje()})
			// ver mejor lugar donde ponerlo
		self.mostrar()
	}

}

object filaCartasRival inherits Fila {

	method establecerManoDeCartas(lasCartas) {
		lasCartas.forEach({ carta => cartas.add(carta)})
	}

	method jugarCarta() {
		const carta = cartas.anyOne()
		tablero.jugarCarta(carta)
		cartas.remove(carta)
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

class Mensajes inherits Imagenes {

	method llamarMensaje() {
		self.actualizarPosicion(0, 42)
		game.addVisual(self)
		game.schedule(1000, {=> self.esconder()})
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
		imagenRondaPasada.llamarMensaje()
		game.schedule(1000, {=> filaCartasRival.jugarCarta()})
		game.schedule(2700, {=> partida.finalizarRonda()})
	}

}

