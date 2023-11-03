import wollok.game.*
import juego.*
import selector.*
import cartas.*
import numero.*
import imagen.*
import constantes.*
import jugador.*
import fila.*

object tablero {

	const jugadores = new Dictionary()
	var property jugadorDeTurno = jugador

	method mostrar() {
		filaCartasClima.mostrar()
		pasarDeMano.mostrarYagregarListener()
		jugadores.forEach({ faccion , elJugador => elJugador.mostrarComponentes()})
	}

	method establecerBandoJugador(faccion, elJugador) {
		jugadores.put(faccion, elJugador)
	}

	method repartirManoInicial() {
		jugadores.forEach({ faccion , elJugador => elJugador.repartirCartaLider()})
		jugadores.forEach({ faccion , elJugador => elJugador.asignarCartas(10)})
	}

	method resetearTablero() {
		filaCartasClima.vaciarFila()
		jugadores.forEach({ faccion , elJugador => elJugador.vaciarFilasDeCombate()})
		self.actualizarDatosJugadores()
		filaCartasJugador.actualizarVisual() // refresca la vista del selector, 
	}

	method actualizarDatosJugadores() {
		seccionDatosJugador.actualizarInfo()
		seccionDatosRival.actualizarInfo()
	}

	method rivalJuega() {
		game.schedule(700, { => filaCartasRival.jugarCarta()})
		game.schedule(1200, { => imagenTurno.llamarMensaje()})
	}

	method jugarCarta(unaCarta) {
		jugadorDeTurno.jugarCarta(unaCarta)
		if (unaCarta.tieneEfecto()) {
			unaCarta.aplicarEfecto()
		}
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

	const posEnX = 136
	const posEnY = -1

	method text() = "Pasar de Mano (r)"

	method textColor() = "F2F2D9FF"

	method mostrarYagregarListener() {
		game.addVisualIn(self, game.at(posEnX, posEnY))
		keyboard.r().onPressDo{ self.jugadorPasa()}
	}

	method jugadorPasa() {
		tablero.jugadorDeTurno(rival)
		imagenPasoDeManoJugador.llamarMensaje()
		game.schedule(1000, {=> tablero.rivalJuega()})
		game.schedule(2700, {=> partida.finalizarRonda()}) // cambiar esto, no va asi
	}

	method rivalPasa() {
		tablero.jugadorDeTurno(jugador)
		imagenPasoDeManoRival.llamarMensaje()
	}

}

object pasarDeRonda {

}

