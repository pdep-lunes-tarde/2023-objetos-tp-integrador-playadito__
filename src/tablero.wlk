import wollok.game.*
import juego.*
import selector.*
import cartas.*
import numeros.*
import constantes.*

// solucion temporal no tan limpia
// pero la idea es esta
class Jugador {

	// este objeto no cumple con encapsulamiento
	// hay q ver si implementar todo para que cumpla con encapsulamiento 
	// (q implica que los objetos se conozcan de forma deferente)
	const rival
	const manoDeCartas
	const filasDeCombate
	const filaClima = filaCartasClima

	// conceptualmente esta medio feo preguntarle al jugador donde deberia caer la carta
	method filaCorrespondiente(carta) {
		const tipo = carta.tipoDeCarta()
		if (tipo.equals(cartaDeClima)) {
			return filaClima
		}
		if (tipo.equals(cartaDeUnidad) && carta.especialidad().equals(espia)) {
			return rival.filaParaEspia(carta)
		} else {
			return filasDeCombate.find({ fila => fila.claseDeCombate() == carta.claseDeCombate() })
		}
	}

	method filaParaEspia(carta) = filasDeCombate.find({ fila => fila.claseDeCombate() == carta.claseDeCombate() })

	method manoDeCartas() = manoDeCartas

}

const jugador = new Jugador(rival = oponente, manoDeCartas = filaCartasJugador, filasDeCombate = [ filaInfanteJugador, filaArqueroJugador, filaAsedioJugador ])

const oponente = new Jugador(rival = jugador, manoDeCartas = filaCartasRival, filasDeCombate = [ filaInfanteRival, filaArqueroRival, filaAsedioRival ])

object tablero {

	// asi como esta, estas dos constantes sirven para:
	// 1. el reseteo (resetearTablero())
	// 2. los addVisual y los mostrar()
	// habria q borrarlos y buscar la alternativa para estos dos procesos
	const filasJugador = [ filaInfanteJugador, filaArqueroJugador, filaAsedioJugador ]
	const filasRival = [ filaInfanteRival, filaArqueroRival, filaAsedioRival ]

	method resetearTablero() {
		filaCartasClima.vaciarFila()
		filasJugador.forEach({ filaCombate => filaCombate.vaciarFila()})
		filasRival.forEach({ filaCombate => filaCombate.vaciarFila()})
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
			// //
		barajaJugador.mostrar()
		barajaRival.mostrar()
			// MOSTRAR FILA CARTAS JUGABLES
		game.addVisual(filaCartasJugador)
		filaCartasJugador.mostrar()
	}

	method cartaJugadaJugador(laCarta) {
		self.jugarCarta(laCarta, jugador)
		game.schedule(700, { => filaCartasRival.jugarCarta()})
	}

	method cartaJugadaRival(laCarta) {
		self.jugarCarta(laCarta, oponente)
	}

	method jugarCarta(carta, campoDeJuego) {
		campoDeJuego.filaCorrespondiente(carta).insertarCarta(carta)
			// se podria tambien prescindir del booleano tieneEfecto()
			// y dejar efectos vacios
		if (carta.tieneEfecto()) {
			carta.aplicarEfecto()
		}
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

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		tablero.cartaJugadaJugador(cartaElegida)
		cartas.remove(cartaElegida) // self.removerCarta(cartaElegida)// se tendria q ejecutar en tablero
		self.mostrar()
	}

}

object filaCartasRival inherits Fila {

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

