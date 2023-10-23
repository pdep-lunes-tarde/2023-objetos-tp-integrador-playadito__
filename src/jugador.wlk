import tablero.*
import cartas.*
import constantes.*

class Jugador {

	var property laBaraja = null
	const elRival
	const manoDeCartas
	const filasDeCombate
	const cartasDescartadas
	const filaClima = filaCartasClima

	method asignarBaraja(baraja) {
		self.laBaraja(baraja)
	}

	method jugarCarta(carta) {
		self.filaParaCarta(carta).insertarCarta(carta)
	}

	method descartarCarta(carta) {
		cartasDescartadas.insertarCarta(carta)
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

	method asignarCartas(numeroDeCartas) {
		manoDeCartas.establecerManoDeCartas(laBaraja.obtenerCartas(numeroDeCartas))
	}

}

