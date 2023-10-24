import wollok.game.*
import tablero.*
import cartas.*
import constantes.*

class Jugador {

	var property laBaraja = null
	var property rondasPerdidas = 0
	const elRival
	const filaManoDeCartas
	const filaCartaLider
	const filasDeCombate
	const cartasDescartadas
	const seccionDeDatos
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
			// mostrar seccion de datos
		seccionDeDatos.mostrar()
			// mostrar puntaje total
		puntajeTotal.mostrar()
			// mostrar baraja
		laBaraja.mostrar()
			// mostrar fila de cartas jugables solo del jugador
		if (filaManoDeCartas.equals(filaCartasJugador)) {
			game.addVisual(filaManoDeCartas)
			filaManoDeCartas.mostrar()
		}
	}

	method asignarBaraja(baraja) {
		self.laBaraja(baraja)
	}

	method puntajeTotal() = puntajeTotal.puntajeTotal()

	method repartirCartaLider() {
		filaCartaLider.insertarCarta(laBaraja.lider())
	}

	method asignarCartas(numeroDeCartas) {
		filaManoDeCartas.establecerManoDeCartas(laBaraja.obtenerCartas(numeroDeCartas))
	}

	method cartasDeJuegosSobrantes() = filaManoDeCartas.cantidadCartas()

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

