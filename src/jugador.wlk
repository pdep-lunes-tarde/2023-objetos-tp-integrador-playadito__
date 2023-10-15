import tablero.*
import cartas.*
import constantes.*

// solucion temporal no tan limpia
// pero la idea es esta
class Jugador {

	// este objeto no cumple con encapsulamiento
	// hay q ver si implementar todo para que cumpla con encapsulamiento 
	// (q implica que los objetos se conozcan de forma deferente)
	var property rival = null
	const baraja
	const manoDeCartas
	const filasDeCombate
	const filaClima = filaCartasClima

	method asignarRival(elRival) {
		self.rival(elRival)
	}

	// conceptualmente esta medio feo preguntarle al jugador donde deberia caer la carta
	method filaParaCarta(carta) {
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

	method asignarCartas(numeroDeCartas) {
//		const baraja = lasBarajas.find({ baraja => baraja.faccion().equals(faccion) })
		manoDeCartas.establecerManoDeCartas(baraja.obtenerCartas(numeroDeCartas))
	}

//	method manoDeCartas() = manoDeCartas
}

