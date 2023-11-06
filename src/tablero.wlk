import wollok.game.*
import juego.*
import selector.*
import cartas.*
import numero.*
import imagen.*
import constantes.*
import jugador.*
import filas.*

object tablero {

	const jugadores = new Dictionary()
	var property jugadorDeTurno = jugador
	var property listenerTeclaL = filaCartaLiderJugador
	var property listenerTeclaP = pasarDeMano

	// method image() = "assets/GAME-BG.png"
	method jugadorDeFaccion(faccion) {
		return jugadores.get(faccion)
	}

	method mostrar() {
		// game.addVisualIn(self, game.at(0, 0))
		filaCartasClima.mostrar()
		pasarDeMano.mostrar()
		jugadores.forEach({ faccion , elJugador => elJugador.mostrarComponentes()})
		keyboard.l().onPressDo{ listenerTeclaL.jugarCartaLider()}
		keyboard.p().onPressDo{ listenerTeclaP.jugadorPasa()}
	}

	method establecerBandoJugador(faccion, elJugador) {
		jugadores.put(faccion, elJugador)
	}

	method repartirManoInicial() {
		jugadores.forEach({ faccion , elJugador => elJugador.repartirCartaLider()})
		jugadores.forEach({ faccion , elJugador => elJugador.asignarCartas(10)})
	}

	method resetearTablero() {
		self.jugadorDeTurno(jugador)
		filaCartasClima.vaciarFila()
		jugadores.forEach({ faccion , elJugador => elJugador.vaciarFilasDeCombate()})
		self.actualizarDatosJugadores()
		filaCartasJugador.actualizarVisual() // refresca la vista del selector, 
		pasarDeMano.jugadorPaso(false)
	}

	method actualizarDatosJugadores() {
		seccionDatosJugador.actualizarInfo()
		seccionDatosRival.actualizarInfo()
	}

	method rivalJuega() {
		game.schedule(700, { => filaCartasRival.jugarCarta()})
		if (!pasarDeMano.jugadorPaso()) {
			game.schedule(1200, { => imagenTurno.llamarMensaje()})
		}
	}

	method jugarCarta(unaCarta) {
		jugadorDeTurno.jugarCarta(unaCarta)
		self.jugadorDeTurno(jugadorDeTurno.oponente())
			// logica para la disparar el juego de la computadora
		if (jugadorDeTurno.equals(rival)) {
			self.rivalJuega()
		}
	}

	method jugadorDeTurnoSacaCarta() {
		jugadorDeTurno.sacarCarta()
	}

	method jugadorDeTurnoRecuperaCarta() {
		jugadorDeTurno.recuperarUnaCartaDescartada()
	}

	method bloquearTeclas() {
		self.listenerTeclaL(bloqueoDeTecla)
		self.listenerTeclaP(bloqueoDeTecla)
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

class Gema inherits Imagen (imagen = "assets/gema.png") {

	var property estado = true

	method apagar() {
		self.estado(false)
		self.imagen("assets/gemaPerdida.png")
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

object pasarDeMano {

	var property jugadorPaso = false
	const posEnX = 136
	const posEnY = -1

	method text() = "Pasar de Mano (P)"

	method textColor() = "F2F2D9FF"

	method mostrar() {
		game.addVisualIn(self, game.at(posEnX, posEnY))
	}

	method jugadorPasa() {
		self.jugadorPaso(true)
		tablero.jugadorDeTurno(rival)
		filaCartasJugador.anularSelector()
		imagenPasoDeManoJugador.llamarMensaje()
		game.schedule(1000, {=> tablero.rivalJuega()})
		game.schedule(2700, {=> partida.finalizarRonda()})
	}

	method rivalPasa() {
		tablero.jugadorDeTurno(jugador)
		imagenPasoDeManoRival.llamarMensaje()
	}

}

object bloqueoDeTecla {

	method jugadorPasa() {
	}

	method jugarCartaLider() {
	}

}

