import wollok.game.*
import menu.*
import tablero.*
import jugador.*
import constantes.*
import selector.*

/* TODO
 * 
 * ///////////////////////////// TESTS /////////////////////////////
 * FILA (falta terminar)
 * ** Y el resto de archivos
 * 
 * ///////////////////////////// GENERALES /////////////////////////////
 * - !! hacer diferencia entre "mostrar visual" y "actualizar vista"
 * 
 * 
 * - revisar flujo de programa (el orden de muestra afecta la capa del visual)
 *   seteo de menu -> eleccion de baraja -> partida.empezar()
 *   mostrar visuales (el tablero -> la info(seccion de datos)) -> reparto de mano inicial -> arranca el juego
 * 
 * - revisar metodo duplicado de insertar lista de carta a una fila y el "establecerManoDeCartas" de las filas juglables
 * 
 * - revisar el manejo de 'mostrar' de las cosas con visual, 
 * 	 no es muy limpio el manejo, porque durante el flujo se hacen varios mostrar (es decir, no se tiene en cuenta el manejo de la visual)
 *   esto se lo esta evitando con "agregar si no hay visual, y si hay no hagas nada", y no esta bueno eso
 * 
 * - revisar los intervalos de tiempo donde aparecen carteles, parece que el programa sigue escuchando
 * 	 es decir, puedo jugar una carta, la accion se ejecuta, el rival juega,
 *   las visuales de las cartas superponen al cartel y queda como el orto
 * 
 * - revisar codigo (y refactorizar en caso de ser necesario):
 * 		- logica repetida
 * 		- faltas de encapsulamiento
 * 		- funciones estilo C
 * 
 * ///////////////////////////// PARTIDA /////////////////////////////
 * - en general hay bastante pasaje de variables e informacion que no es necesario, se puede simplificar bastante
 * 
 * - mejorar ganadorRonda()
 * 
 * - terminar de ver fin de partida
 * 
 * - caso empate(1-1), y sin cartas sin implementar
 * 
 * ///////////////////////////// CARTAS /////////////////////////////
 * 
 * (logica)
 * - implementar los aplicarEfecto() de especialidad
 * 		- (IMPLEMENTADO) Efecto de Espia
 * 		- (IMPLEMENTADO pero con bug) Efecto de Medico
 * 			Esto del medico esta medio rancio, se puede hacer mas facil,
 * 			pero la solucion planteada esta mejor y tampoco es tan compleja, solo hay q depurar
 * 		- Efecto de LazoEstrecho (modificarlo a otro efecto)
 * - implementar cartaLider (caso particular de carta jugable, efecto)
 * - implementar o sacar efectos de baraja
 * 
 * (visual)
 * - imagen particular para carta lider
 * 
 * ///////////////////////////// TABLERO /////////////////////////////
 * 
 * ** Modificar Nombre e Imagen de Paso de Mano (const imagenPasoDeManoJugador)
 * 
 * (logica)
 * - implementar Fila Carta Lider
 * - revisar logica de pasaje de ronda (apaso de ronda o paso de turno), esto tiene q ver mas con regla de juego
 * - revisar el descartado de carta [tablero ln(41~44), ln(145)]
 * - IMPLEMENTACION TEMPORAL CUANDO JUGADOR SE QUEDA SIN CARTAS(revisar y cambiar, actualizar gemas, primero un mensaje, etc)
 * 
 * 
 * ///////////////////////////// OTRO /////////////////////////////
 * 
 * ver implementacion para futuro de un scoreboard con los puntajes del jugador (nuevo objeto)
 * 
 */
object juego {

	var property selectorActual = noHaySelector

	method seApretoIzquierda() {
		selectorActual.moveLeft()
	}

	method seApretoDerecha() {
		selectorActual.moveRight()
	}

	method seApretoSelect() {
		selectorActual.select()
	}

	method jugar() {
		game.width(170)
		game.height(96)
		game.cellSize(10)
		game.ground("assets/BG-002.png")
		keyboard.left().onPressDo{ self.seApretoIzquierda()}
		keyboard.right().onPressDo{ self.seApretoDerecha()}
		keyboard.enter().onPressDo{ self.seApretoSelect()}
		menu.mostrarMenu()
		game.start()
	}

}

object partida {

	var property ronda = 1

	method start(barajaSeleccionado) {
		const barajaJugador = barajaSeleccionado
		const barajaRival = self.asignarOtraBarajaRandom(barajaJugador)
		jugador.asignarBaraja(barajaJugador)
		rival.asignarBaraja(barajaRival)
		tablero.establecerBandoJugador(barajaJugador.faccion(), jugador)
		tablero.establecerBandoJugador(barajaRival.faccion(), rival)
		self.comenzarRonda()
	}

	method asignarOtraBarajaRandom(baraja) {
		lasBarajas.remove(baraja)
		return lasBarajas.anyOne()
	}

	method comenzarRonda() {
		if (ronda == 1) {
			tablero.mostrar()
			tablero.repartirManoInicial()
		}
		tablero.resetearTablero()
	}

	method finalizarRonda() {
		// deberian ir los efectos de baraja 
		self.ganadorRonda()
		if (jugador.perdioPartida() or rival.perdioPartida()) {
			self.finDePartida()
		} else {
			ronda++
			game.schedule(2000, { => self.comenzarRonda()})
		}
	}

	method ganadorRonda() {
		// codigo medio repetido (?
		if (jugador.puntajeTotal() > rival.puntajeTotal()) {
			rival.pierdeRonda()
			game.schedule(1200, { => tablero.actualizarDatosJugadores()})
			game.schedule(1200, { => imagenRondaGanada.llamarMensaje()})
		} else if (jugador.puntajeTotal() < rival.puntajeTotal()) {
			jugador.pierdeRonda()
			game.schedule(1200, { => tablero.actualizarDatosJugadores()})
			game.schedule(1200, { => imagenRondaPerdida.llamarMensaje()})
		} else {
			// caso empate (pierden los dos)
			rival.pierdeRonda()
			jugador.pierdeRonda()
			game.schedule(1200, { => tablero.actualizarDatosJugadores()})
			game.schedule(1200, { => imagenRondaPerdida.llamarMensaje()})
		}
	}

	method finDePartida() {
		if (rival.perdioPartida()) {
			game.schedule(1200, { => imagenPartidaGanada.llamarMensaje()})
		} else if (jugador.perdioPartida()) {
			game.schedule(1200, { => imagenPartidaPerdida.llamarMensaje()})
		}
	}

}

