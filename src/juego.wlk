import wollok.game.*
import menu.*
import tablero.*
import jugador.*
import constantes.*

/* TODO
 * 
 * ///////////////////////////// GENERALES /////////////////////////////
 * - TESTS !!!!!!!
 * - arreglar selector 
 * 		- coexisten listeners y reacionan a mismas instrucciones: menu y juego
 * 		- error cuando se selecciona la ultima carta de la fila
 * - revisar codigo (y refactorizar en caso de ser necesario):
 * 		- logica repetida
 * 		- faltas de encapsulamiento
 * 		- funciones estilo C
 * 
 * ///////////////////////////// CARTAS /////////////////////////////
 * 
 * (logica)
 * - LISTO repensar relacion: CARTA - BARAJA - MAZO
 * - implementar los aplicarEfecto(); clima y especialidad (tienen que ser polimorficas)
 * - implementar cartaLider (caso particular de carta jugable, efecto)
 * - implementar o sacar efectos de baraja
 * 
 * (visual)
 * - LISTO  icono de clima buen tiempo
 * - LISTO  (medio fea)icono carta heroe (en lo posible)
 * 
 * ///////////////////////////// TABLERO /////////////////////////////
 * 
 * (logica)
 * - LISTO repensar relacion de los objetos: TABLERO - JUGADOR - FILAS DE JUEGO - FILA DE CARTAS - PUNTAJE
 * - arreglar juego de carta clima (se puede jugar multiples cartas de un mismo clima)
 * - ERROR arreglar problemas multiples luego de pasar de ronda
 * - implementar de informacion de cada jugador (numero de cartas restantes y rondas perdidas)
 * - implementar seccion cartas descartadas
 * - implementar chequeo de fin de ronda (cuando alguien se queda sin cartas)
 * - ver si es mejor seccion de datos crearla como global o dentro del jugador
 * - el ganador de ronda, que utiliza seccion de datos, ver una mejor implementacion
 * - ERROR ver fin de partida
 * 
 * 
 * (visual)
 * - LISTO  recalcular las posiciones de las cartas respecto de las filas (estan semi-corridas)
 * - display de info de jugadores: 
 * 	LISTO 	- gemas(2 para cada jugador)
 * 	LISTO 	- cartas jugables restantess
 * - LISTO  carteles de fin de ronda, fin de partida, paso de mano
 * 
 * ///////////////////////////// OTRO /////////////////////////////
 * 
 * ver implementacion para futuro de un scoreboard con los puntajes del jugador (nuevo objeto)
 * 
 */
object juego {

	method jugar() {
		game.width(170)
		game.height(96)
		game.cellSize(10)
		game.ground("assets/BG-004.png")
		menu.mostrarMenu()
//		partida.start(imperioNiffgardiano)
		game.start()
	}

}

object partida {

	var property barajaJugador
	var property barajaRival
	var property ronda = 1

	method start(barajaSeleccionado) {
		self.barajaJugador(barajaSeleccionado)
		self.barajaRival(self.asignarBarajaRandom())
			// crear los jugadores
			// asignarselos al tablero
		const jugador = new Jugador(baraja = barajaJugador, manoDeCartas = filaCartasJugador, filasDeCombate = [ filaInfanteJugador, filaArqueroJugador, filaAsedioJugador ])
		const rival = new Jugador(baraja = barajaRival, manoDeCartas = filaCartasRival, filasDeCombate = [ filaInfanteRival, filaArqueroRival, filaAsedioRival ])
		jugador.asignarRival(rival)
		rival.asignarRival(jugador)
		tablero.establecerBandoJugador(barajaJugador.faccion(), jugador)
		tablero.establecerBandoJugador(barajaRival.faccion(), rival)
		self.comenzarRonda()
	}

	method asignarBarajaRandom() {
		lasBarajas.remove(barajaJugador)
		return lasBarajas.anyOne()
	}

	method baraja() = barajaJugador

	method comenzarRonda() {
		if (ronda == 1) {
			tablero.repartirManoInicial()
			tablero.mostrar(barajaJugador, barajaRival)
		} else {
			var cartasSobrantesRondaAnterior = filaCartasJugador.listaCartas()
			filaCartasJugador.establecerManoDeCartas(cartasSobrantesRondaAnterior)
			cartasSobrantesRondaAnterior = filaCartasRival.listaCartas()
			filaCartasRival.establecerManoDeCartas(cartasSobrantesRondaAnterior)
		}
		tablero.resetearTablero()
	}

	method finalizarRonda() {
		// deberian ir los efectos de baraja 
		self.ganadorRonda()
		ronda++
		if (ronda <= 4 and !(seccionDatosRival.perdioPartida()) and !(seccionDatosJugador.perdioPartida())) {
			game.schedule(2000, { => self.comenzarRonda()})
		} else {
			self.finDePartida()
		}
	}

	method ganadorRonda() {
		if (puntajeTotalJugador.puntajeTotal() > puntajeTotalRival.puntajeTotal()) {
			game.schedule(1200, { => imagenRondaGanada.llamarMensaje()})
			game.schedule(1200, { => seccionDatosRival.perdioRonda()})
		} else {
			game.schedule(1200, { => imagenRondaPerdida.llamarMensaje()})
			game.schedule(1200, { => seccionDatosJugador.perdioRonda()})
		}
	}

	method finDePartida() {
		if (seccionDatosRival.perdioPartida()) {
			game.schedule(1200, { => imagenPartidaGanada.llamarMensaje()})
		} else {
			game.schedule(1200, { => imagenPartidaPerdida.llamarMensaje()})
		}
	}

}

