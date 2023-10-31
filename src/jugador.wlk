import wollok.game.*
import tablero.*
import cartas.*
import modalCartasDescartadas.*
import fila.*
import constantes.*

class Jugador {

	var property laBaraja = null
	var property rondasPerdidas = 0
	const elRival
	const filaManoDeCartas
	const filaCartaLider
	const filasDeCombate
	const cartasDescartadas
	const puntajeTotal // es un objeto puntajeTotal
	const filaClima = filaCartasClima

	method mostrarComponentes() {
		// mostrar filas de combate
		filasDeCombate.forEach({ filaCombate => game.addVisual(filaCombate)})
		filasDeCombate.forEach({ filaCombate => filaCombate.mostrar()})
			// mostrar seccion carta lider
		game.addVisual(filaCartaLider)
		filaCartaLider.mostrar()
			// mostrar seccion cartas descartadas
		game.addVisual(cartasDescartadas)
			// mostrar puntaje total
		puntajeTotal.mostrar()
			// mostrar baraja
		laBaraja.mostrar()
	}

	method puntajeTotal() = puntajeTotal.puntajeTotal()

	method oponente() = elRival

	method asignarBaraja(baraja) {
		self.laBaraja(baraja)
	}

	method repartirCartaLider() {
		filaCartaLider.insertarCarta(laBaraja.lider())
	}

	method pierdeRonda() {
		rondasPerdidas++
	}

	method perdioPartida() = rondasPerdidas == 2

	method asignarCartas(numeroDeCartas) {
		filaManoDeCartas.establecerManoDeCartas(laBaraja.obtenerCartas(numeroDeCartas))
	}

	method cartasDeJuegosSobrantes() = filaManoDeCartas.cantidadCartas()

	method sacarCarta() {
		filaManoDeCartas.insertarCarta(laBaraja.obtenerCartaRandom())
	}

	method recuperarUnaCartaDescartada()

	method jugarCarta(carta) {
		self.filaParaCarta(carta).insertarCarta(carta)
	}

	method descartarCarta(carta) {
		cartasDescartadas.insertarCarta(carta)
	}

	method vaciarFilasDeCombate() {
		filasDeCombate.forEach({ filaCombate => filaCombate.vaciarFila()})
	}

	method filaParaCarta(carta) {
		const tipo = carta.tipoDeCarta()
		if (tipo.equals(cartaDeClima)) {
			return filaClima
		}
		if (tipo.equals(cartaDeUnidad) && carta.especialidad().equals(espia)) {
			return elRival.filaParaEspia(carta)
		} else {
			return filasDeCombate.find({ fila => fila.claseDeCombate() == carta.claseDeCombate() })
		}
	}

	method filaParaEspia(carta) = filasDeCombate.find({ fila => fila.claseDeCombate() == carta.claseDeCombate() })

}

object jugador inherits Jugador(elRival = rival, filaManoDeCartas = filaCartasJugador, filaCartaLider = filaCartaLiderJugador, filasDeCombate = [ filaInfanteJugador, filaArqueroJugador, filaAsedioJugador ], cartasDescartadas = filaDescartadosJugador, puntajeTotal = puntajeTotalJugador) {

	override method mostrarComponentes() {
		super()
		seccionDatosJugador.mostrar()
		laBaraja.actualizarPosicion(159, 30)
		game.addVisual(filaManoDeCartas)
		filaManoDeCartas.mostrar()
	}

	override method recuperarUnaCartaDescartada() {
		if (cartasDescartadas.tieneCartas()) {
			modalRecuperarCarta.mostrarModal(cartasDescartadas.listaCartas())
		}
	}

}

object rival inherits Jugador(elRival = jugador, filaManoDeCartas = filaCartasRival, filaCartaLider = filaCartaLiderRival, filasDeCombate = [ filaInfanteRival, filaArqueroRival, filaAsedioRival ], cartasDescartadas = filaDescartadosRival, puntajeTotal = puntajeTotalRival) {

	override method mostrarComponentes() {
		super()
		seccionDatosRival.mostrar()
		laBaraja.actualizarPosicion(159, 68)
	}

	override method recuperarUnaCartaDescartada() {
	}

}

