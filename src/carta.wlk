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
	// inicializar con (claseDeCombate, valor, especialidad, baraja)
	const baraja
	var pos_x = 0
	var pos_y = 0

	method image() = baraja.obtenerImagen()

	method position() = game.at(pos_x, pos_y)

	method actualizarPosicion(x, y) {
		pos_x = x
		pos_y = y
	}

	method getPosicionX() = pos_x

	method getPosicionY() = pos_y

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

class CartaTipoCombate inherits Carta {

	const claseDeCombate // cadena, ej "infanteria"

	method claseDeCombate() = claseDeCombate

}

class CartaCombativa inherits CartaTipoCombate {

	const puntajeInicial // puntaje original (valor numerico)
	var puntaje = puntajeInicial // puntaje modificable (constante por el momento porque no se implemento la modificacion)
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

	method modificarPuntaje(num)

	method puntaje() = puntaje

	method puntajeInicial() = puntajeInicial

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

	override method modificarPuntaje(num) {
		puntaje = num
		numeroPuntaje.modificarNumero(puntaje)
	}

}

class CartaHeroe inherits CartaCombativa {

	override method modificarPuntaje(num) {
		puntaje = puntajeInicial // no se puede modificar el puntaje del heroe
	}

}

class CartaClima inherits CartaTipoCombate {

//esto de la imagen solo funciona si hay una de cada clima unicamente
	const imagenTipoClima = new Imagenes(imagen = "assets/" + self.toString() + ".png")
	const filasJugador = tablero.filasJugador()
	const filasRival = tablero.filasRival()

	method puntajeCartasAUno() {
		filasJugador.get(self.claseDeCombate()).modificarPuntajeCartas({ carta => carta.modificarPuntaje(1)})
		filasRival.get(self.claseDeCombate()).modificarPuntajeCartas({ carta => carta.modificarPuntaje(1)})
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenTipoClima.actualizarPosicion(x - 1, y + 6)
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

//object obtenerCartas {
//
//	const manoCartas = new List()
//
//	method obtenerCartaRandom(barajaElegida) {
//		const unaCarta = barajaElegida.mazo().anyOne()
//		manoCartas.add(unaCarta)
//		barajaElegida.mazo().remove(unaCarta)
//	}
//
//	method setCartas(barajaElegida, cantidadCartas) {
//		cantidadCartas.times({ i => self.obtenerCartaRandom(barajaElegida)})
//		return manoCartas
//	}
//
//}
