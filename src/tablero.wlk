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
			// MOSTRAR FILA DE LIDERES Y SUS CARTAS
		game.addVisual(filaCartaLiderRival)
		game.addVisual(filaCartaLiderJugador)
		self.asignarLideres(barajaJugador, barajaRival)
			// MOSTRAR SECCION DATOS
		seccionDatosJugador.mostrar()
		seccionDatosRival.mostrar()
			// MOSTRAR PUNTAJE TOTAL
		puntajeTotalJugador.mostrar()
		puntajeTotalRival.mostrar()
			// seccion datos, numero cartas restantes
		seccionDatosRival.cartasJugablesRestantes()
		seccionDatosJugador.cartasJugablesRestantes()
			// pasar de ronda, ver si va aca, y asi o con addVisual de una
		pasarDeRonda.mostrarYagregarListener()
			// ver si se puede obtener de jugador, para que el metodo no 
			// necesite recibir parametros
		barajaJugador.actualizarPosicion(159, 30)
		barajaRival.actualizarPosicion(159, 68)
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

	method asignarLideres(barajaJugador, barajaRival) {
		filaCartaLiderJugador.insertarCarta(barajaJugador.lider())
		filaCartaLiderRival.insertarCarta(barajaRival.lider())
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
	var property pos_x = 55
	var property pos_y = 0
	var property pos_y_carta = pos_y
	const centroFila = 90 / 2 - 2

	method position() = game.at(pos_x, pos_y)

	method mostrar() {
		if (!cartas.isEmpty()) {
			const posicionPrimeraCarta = centroFila - (8 * cartas.size()) / 2
			contador.contador(posicionPrimeraCarta)
			cartas.forEach({ carta => carta.actualizarPosicion(self.calcularAbscisaDeCarta(pos_x), pos_y_carta)})
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

	method cantidadCartas() = cartas.size()

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

object filaCartasClima inherits Fila(cartas = new Set(), pos_x = 11, pos_y = 42, pos_y_carta = 43, centroFila = 26 / 2 - 2) {

	method image() = "assets/FCC-001.png" // una img donde quepa 3 cartas unicamente

//	override method removerCarta(cartaClima) {
//	// sacar los efectos
//	}
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
		seccionDatosJugador.cartasJugablesRestantes()
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
		seccionDatosRival.cartasJugablesRestantes()
	}

}

class FilaCartaLider inherits Fila(cartas = new Set(), pos_x = 11, centroFila = 10 / 2 - 2) {

	method image() = "assets/FCL-001.png"

}

class Gema inherits Imagenes (imagen = "assets/gema.png") {

	var property estado = true

	method rondaPerdida() {
		estado = false
		imagen = "assets/gemaPerdida.png"
	}

	method mostrar() {
		game.addVisual(self)
	}

}

class SeccionDatos {

	const pos_x = 4
	const pos_y
	const gema1 = new Gema(posx = pos_x + 24, posy = pos_y + 4)
	const gema2 = new Gema(posx = pos_x + 28, posy = pos_y + 4)
	const filaCartas
	var cartasJugablesRestantes = 0
	const numeroCartasRestantes = new Numero(numero = cartasJugablesRestantes.toString(), color = "F2F2D9FF")
	var property rondasPerdidas = 0

	method image() = "assets/FP-001.png"

	method position() = game.at(pos_x, pos_y)

	method mostrar() {
		game.addVisual(self)
		gema1.mostrar()
		gema2.mostrar()
		game.addVisualIn(numeroCartasRestantes, game.at(pos_x + 18, pos_y + 2))
	}

	method cartasJugablesRestantes() {
		cartasJugablesRestantes = filaCartas.cantidadCartas()
		numeroCartasRestantes.modificarNumero(cartasJugablesRestantes)
	}

	method perdioRonda() {
		rondasPerdidas++
		if (gema1.estado()) {
			gema1.rondaPerdida()
		} else if (gema2.estado()) {
			gema2.rondaPerdida()
		}
	}

	method perdioPartida() = rondasPerdidas === 2 or cartasJugablesRestantes === 0

	method faccionJugador() {
	// implementar
	}

}

class PuntajeFila {

	const pos_x = 50
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

	const pos_x = 40
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

	const pos_x = 136
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

