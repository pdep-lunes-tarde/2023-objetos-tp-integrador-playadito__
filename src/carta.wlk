import wollok.game.*
import numeros.*
import constantes.*
import tablero.*

//ver que onda, lo cree para lo de la imagen, pero si esto cambia, hay que revisar otras cosas
class Imagenes {

	const imagen
	var posx = 0
	var posy = 0

	method image() = imagen

	method position() = game.at(posx, posy)

	method actualizarPosicion(x, y) {
		posx = x
		posy = y
	}

	method esconder() {
		game.removeVisual(self)
	}

}

class Carta {

	// 80px (8 celdas)
	// 110px(11 celdas)
	var property baraja
	var property pos_x = 0
	var property pos_y = 0

	method image() = baraja.obtenerImagen()

	method position() = game.at(pos_x, pos_y)

	method actualizarPosicion(x, y) {
		self.pos_x(x)
		self.pos_y(y)
	}

	method mostrar() {
		if (game.hasVisual(self)) {
			self.esconder()
		}
		game.addVisual(self)
	}

	method esconder() {
		game.removeVisual(self)
	}

}

class CartaCombativa inherits Carta {

	const claseDeCombate // cadena, ej "infanteria"
	const puntajeInicial // puntaje original (valor numerico)
	var property puntaje = puntajeInicial // puntaje modificable (constante por el momento porque no se implemento la modificacion)
	const imagenTipoDeCombate = new Imagenes(imagen = "assets/" + claseDeCombate + ".png")
	const numeroPuntaje = new Numero(numero = puntajeInicial)

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenTipoDeCombate.actualizarPosicion(x + 5, y + 1)
		numeroPuntaje.actualizarPosicion(x - 1, y + 6)
	}

	override method mostrar() {
		super()
		game.addVisual(imagenTipoDeCombate)
		game.addVisual(numeroPuntaje)
	}

	override method esconder() {
		super()
		imagenTipoDeCombate.esconder()
		numeroPuntaje.esconder()
	}

	method puntajeInicial() = puntajeInicial

	method claseDeCombate() = claseDeCombate

}

class CartaDeUnidad inherits CartaCombativa {

	// inicializar con (claseDeCombate, valor, especialidad, baraja)
	const especialidad // objeto de especialidad
	const imagenEspecialidad = new Imagenes(imagen = especialidad.obtenerImagen())

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenEspecialidad.actualizarPosicion(x + 2, y + 1)
	}

	method especialidad() = especialidad

	override method mostrar() {
		super()
		game.addVisual(imagenEspecialidad)
	}

	override method esconder() {
		super()
		imagenEspecialidad.esconder()
	}

	method modificarPuntaje(num) {
		self.puntaje(num)
		numeroPuntaje.modificarNumero(puntaje)
	}

}

class CartaHeroe inherits CartaCombativa {

}

class CartaClima inherits Carta {

//esto de la imagen solo funciona si hay una de cada clima unicamente
	const filaJugador
	const filaRival
	const tipoClima
	const imagenTipoClima = new Imagenes(imagen = "assets/" + tipoClima + ".png")

	method puntajeCartasAUno() {
		filaJugador.modificarPuntajeCartas({ carta => carta.modificarPuntaje(1)})
		filaRival.modificarPuntajeCartas({ carta => carta.modificarPuntaje(1)})
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenTipoClima.actualizarPosicion(x + 1, y + 8)
	}

	override method mostrar() {
		super()
		game.addVisual(imagenTipoClima)
	}

	override method esconder() {
		super()
		imagenTipoClima.esconder()
	}

}

class CartaLider {

}

// Especialidades
//class especialidad {
//	const imagen 
//
//	method obtenerImagen() = imagen
//
//	method aplicar() {
//	}
//}
object medico {

	const imagen = "assets/medico.png"

	method obtenerImagen() = imagen

	method aplicar() {
	}

}

object espia {

	const imagen = "assets/espia.png"

	method obtenerImagen() = imagen

	method aplicar() {
	}

}

object lazoEstrecho {

	const imagen = "assets/lazoEstrecho.png"

	method obtenerImagen() = imagen

	method aplicar() {
	}

}

//ver que hacer con la imagen
object sinHabilidad {

	const imagen = "assets/transparente.png"

	method obtenerImagen() = imagen

	method aplicar() {
	}

}

class Baraja {

	const imagen
	const mazo
	const manoCartas = new List()
	var pos_x = 0
	var pos_y = 0
	var cantidadEnMazo = 40
	const numeroPuntaje = new Numero(numero = cantidadEnMazo)

	// const efectoFinDeRonda
	method obtenerImagen() = imagen

	method mazo() = mazo.copy()

	method obtenerCartaRandom() {
		const unaCarta = mazo.anyOne()
		manoCartas.add(unaCarta)
		mazo.remove(unaCarta)
	}

	method obtenerCartas(cantidadCartas) {
		cantidadCartas.times({ i => self.obtenerCartaRandom()})
		self.actualizarCantidadEnMazo()
		return manoCartas
	}

	method efectoFinDeRonda() {
	// efectoFinDeRonda
	}

	method image() = imagen

	method position() = game.at(pos_x, pos_y)

	method actualizarPosicion(x, y) {
		pos_x = x
		pos_y = y
		numeroPuntaje.actualizarPosicion(x + 1, y - 1)
	}

	method actualizarCantidadEnMazo() {
		cantidadEnMazo = mazo.size()
		numeroPuntaje.modificarNumero(cantidadEnMazo)
	}

	method mostrar() {
		game.addVisual(self)
		game.addVisual(numeroPuntaje)
	}

}

