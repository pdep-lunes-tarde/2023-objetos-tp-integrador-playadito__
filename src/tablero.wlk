import wollok.game.*
import juego.*
import selector.*
import cartas.*
import numeros.*
import imagen.*
import constantes.*

object tablero {

	const jugadores = new Dictionary()
	var property esTurnoDelRival = false

	method establecerBandoJugador(faccion, elJugador) {
		jugadores.put(faccion, elJugador)
	}

	method mostrar(barajaJugador, barajaRival) {
		game.addVisual(filaCartasClima)
		filaCartasClima.mostrar()
		pasarDeRonda.mostrarYagregarListener()
		seccionDatosJugador.mostrar()
		seccionDatosRival.mostrar()
			// ver si se puede obtener de jugador, para que el metodo no 
			// necesite recibir parametros
		barajaJugador.actualizarPosicion(159, 30)
		barajaRival.actualizarPosicion(159, 68)
		jugadores.forEach({ faccion , elJugador => elJugador.mostrarComponentes()})
	}

	method resetearTablero() {
		filaCartasClima.vaciarFila()
		jugadores.forEach({ faccion , elJugador => elJugador.vaciarFilasDeCombate()})
		self.actualizarDatosJugadores()
	}

	method actualizarDatosJugadores() {
		seccionDatosJugador.actualizarInfo()
		seccionDatosRival.actualizarInfo()
	}

	method rivalJuega() {
		game.schedule(700, { => filaCartasRival.jugarCarta()})
		game.schedule(1200, { => imagenTurno.llamarMensaje()})
	}

	method jugarCarta(carta) {
		const elJugador = jugadores.get(carta.faccion())
		elJugador.jugarCarta(carta)
		if (carta.tieneEfecto()) {
			carta.aplicarEfecto()
		}
			// ver que tan buena es esta solucion
		if (esTurnoDelRival) {
			self.rivalJuega()
		}
	}

	method descartarCarta(carta) {
		const elJugador = jugadores.get(carta.faccion())
		elJugador.descartarCarta(carta)
	}

	method repartirManoInicial() {
		jugadores.forEach({ faccion , elJugador => elJugador.repartirCartaLider()})
		jugadores.forEach({ faccion , elJugador => elJugador.asignarCartas(10)})
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

}

class FilaDeCombate inherits Fila {

	// 700px (70 celdas)
	// 120px (6)
	const claseDeCombate
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
		tablero.descartarCarta(unaCarta)
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
	}

	method establecerManoDeCartas(lasCartas) {
		lasCartas.forEach({ carta => cartas.add(carta)})
	}

	method tomarSeleccion(index) {
		const cartaElegida = cartas.get(index)
		tablero.esTurnoDelRival(true)
		tablero.jugarCarta(cartaElegida)
		cartas.remove(cartaElegida)
		seccionDatosJugador.actualizarInfo()
		self.mostrar()
	}

}

object filaCartasRival inherits Fila {

	method establecerManoDeCartas(lasCartas) {
		lasCartas.forEach({ carta => cartas.add(carta)})
	}

	method jugarCarta() {
		if (cartas.isEmpty()) {
			pasarDeRonda.pasarRondaRival()
		} else {
			const carta = cartas.anyOne()
			tablero.esTurnoDelRival(false)
			tablero.jugarCarta(carta)
			cartas.remove(carta)
			seccionDatosRival.actualizarInfo()
		}
	}

}

class FilaCartaLider inherits Fila(posEnX = 11, centroFila = 10 / 2 - 2) {

	method image() = "assets/FCL-001.png"

}

class FilaCartasDescartadas inherits Fila(posEnX = 147, centroFila = 10 / 2 - 2) {

	const numeroDescartadas = new Numero(numero = 0)

	method image() = "assets/FCL-001.png" // es el fondo

	override method mostrar() {
		if (!cartas.isEmpty()) {
			cartas.last().actualizarPosicion(posEnX + 1, posEnYCarta)
			cartas.last().mostrar()
		}
		numeroDescartadas.modificarNumero(self.cantidadCartas())
	}

}

class Gema inherits Imagen (imagen = "assets/gema.png") {

	var property estado = true

	method apagar() {
		self.estado(false)
		self.imagen("assets/gemaPerdida.png")
	}

	method mostrar() {
		game.addVisual(self)
	}

}

class SeccionDatos {

	const posEnX = 4
	const posEnY
	const elJugador
	const gemas = [ new Gema(posEnX = posEnX + 24, posEnY = posEnY + 4), new Gema(posEnX = posEnX + 28, posEnY = posEnY + 4) ]
	const numeroCartasRestantes = new Numero(numero = 0, color = "F2F2D9FF")

	method position() = game.at(posEnX, posEnY)

	method image() = "assets/FP-001.png"

	method mostrar() {
		game.addVisual(self)
		gemas.forEach({ gema => gema.mostrar()})
		self.actualizarInfo()
		game.addVisualIn(numeroCartasRestantes, game.at(posEnX + 18, posEnY + 2))
	}

	method manoDeCartasRestantes() {
		numeroCartasRestantes.modificarNumero(elJugador.cartasDeJuegosSobrantes())
	}

	method mostrarGemasSegunRondas() {
		elJugador.rondasPerdidas().times({ i => gemas.get(i - 1).apagar()})
	}

	method actualizarInfo() {
		self.manoDeCartasRestantes()
		self.mostrarGemasSegunRondas()
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

class PuntajeTotal {

	const posEnX = 40
	const posEnY
	const filasDeCombate
	var property puntajeTotal = 0
	const imagen
	const numeroPuntaje = new Numero(numero = puntajeTotal)

	method position() = game.at(posEnX, posEnY)

	method image() = imagen

	method mostrar() {
		game.addVisual(self)
		game.addVisualIn(numeroPuntaje, game.at(posEnX, posEnY))
	}

	method actualizarPuntajeTotal() {
		self.puntajeTotal(filasDeCombate.map({ fila => fila.puntajeDeFila()}).sum())
		numeroPuntaje.modificarNumero(puntajeTotal)
	}

}

object pasarDeRonda {

	const posEnX = 136
	const posEnY = -1

	method text() = "Pasar de ronda (r)"

	method textColor() = "F2F2D9FF"

	method mostrarYagregarListener() {
		game.addVisualIn(self, game.at(posEnX, posEnY))
		keyboard.r().onPressDo{ self.pasarRondaJugador()}
	}

	method pasarRondaJugador() {
		imagenRondaPasadaJugador.llamarMensaje()
		game.schedule(1000, {=> filaCartasRival.jugarCarta()})
		game.schedule(2700, {=> partida.finalizarRonda()})
	}

	method pasarRondaRival() {
		imagenRondaPasadaRival.llamarMensaje()
		game.schedule(1700, {=> partida.finalizarRonda()})
	}

}

