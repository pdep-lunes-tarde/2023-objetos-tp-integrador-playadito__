import wollok.game.*
import tablero.*
import cartas.*
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
		filasDeCombate.forEach({ filaCombate => filaCombate.mostrar()})
		filaCartaLider.mostrar()
		cartasDescartadas.mostrar()
		puntajeTotal.mostrar()
		laBaraja.mostrar()
	}

	method oponente() = elRival

	method asignarBaraja(baraja) {
		self.laBaraja(baraja)
	}

	method filasDeCombate() = filasDeCombate.copy()

	method puntajeTotal() = puntajeTotal.puntajeTotal()

	method pierdeRonda() {
		rondasPerdidas++
	}

	method perdioPartida() = rondasPerdidas == 2

	method repartirCartaLider() {
		filaCartaLider.insertarCarta(laBaraja.lider())
	}

	method asignarCartas(numeroDeCartas) {
		filaManoDeCartas.insertarListaDeCartas(laBaraja.obtenerCartas(numeroDeCartas))
	}

	method cartasDeJuegosSobrantes() = filaManoDeCartas.cantidadCartas()

	method sacarCarta() {
		filaManoDeCartas.insertarCarta(laBaraja.obtenerCartaRandom())
	}

	method recuperarUnaCartaDescartada() {
		try {
			const cartaARecuperar = cartasDescartadas.listaCartas().anyOne()
			cartasDescartadas.removerCarta(cartaARecuperar)
			filaManoDeCartas.insertarCarta(cartaARecuperar)
		} catch err : Exception {
		}
	}

	method recuperarUnaCartaDescartadaRival() {
		try {
			const carta = elRival.cartasDescartadas().listaCartas().anyOne()
			elRival.cartasDescartadas().removerCarta(carta)
		} catch error : Exception {
		}
	}

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

	method cartasDescartadas() = cartasDescartadas

}

object jugador inherits Jugador(elRival = rival, filaManoDeCartas = filaCartasJugador, filaCartaLider = filaCartaLiderJugador, filasDeCombate = [ filaInfanteJugador, filaArqueroJugador, filaAsedioJugador ], cartasDescartadas = filaDescartadosJugador, puntajeTotal = puntajeTotalJugador) {

	override method mostrarComponentes() {
		super()
		seccionDatosJugador.mostrar()
		laBaraja.actualizarPosicion(159, 30)
		filaManoDeCartas.mostrar()
	}

}

object rival inherits Jugador(elRival = jugador, filaManoDeCartas = filaCartasRival, filaCartaLider = filaCartaLiderRival, filasDeCombate = [ filaInfanteRival, filaArqueroRival, filaAsedioRival ], cartasDescartadas = filaDescartadosRival, puntajeTotal = puntajeTotalRival) {

	override method mostrarComponentes() {
		super()
		seccionDatosRival.mostrar()
		laBaraja.actualizarPosicion(159, 68)
	}

}

