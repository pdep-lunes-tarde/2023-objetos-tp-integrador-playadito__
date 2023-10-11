import wollok.game.*
import tablero.*
import numeros.*
import constantes.*

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

	method position() = game.at(pos_x, pos_y)

	method image() = baraja.obtenerImagen()

	method mostrar() {
		if (game.hasVisual(self)) {
			self.esconder()
		}
		game.addVisual(self)
	}

	method esconder() {
		game.removeVisual(self)
	}

	method actualizarPosicion(x, y) {
		self.pos_x(x)
		self.pos_y(y)
	}

}

class CartaDeCombate inherits Carta {

	const claseDeCombate // cadena, ej "infanteria"
	const valor // puntaje original (valor numerico)
	var property puntaje = valor // puntaje modificable (constante por el momento porque no se implemento la modificacion)
	const imagenTipoDeCombate = new Imagenes(imagen = "assets/" + claseDeCombate + ".png")
	const numeroPuntaje = new Numero(numero = puntaje)

	method puntajeInicial() = valor

	method claseDeCombate() = claseDeCombate

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

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenTipoDeCombate.actualizarPosicion(x + 5, y + 1)
		numeroPuntaje.actualizarPosicion(x - 1, y + 6)
	}

}

class CartaDeUnidad inherits CartaDeCombate {

	// inicializar con (claseDeCombate, valor, especialidad, baraja)
	const especialidad // objeto de especialidad
	const imagenEspecialidad = new Imagenes(imagen = especialidad.obtenerImagen())

	method especialidad() = especialidad

	override method mostrar() {
		super()
		game.addVisual(imagenEspecialidad)
	}

	override method esconder() {
		super()
		imagenEspecialidad.esconder()
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenEspecialidad.actualizarPosicion(x + 2, y + 1)
	}

	method modificarPuntaje(num) {
		self.puntaje(num)
		numeroPuntaje.modificarNumero(puntaje)
	}

}

class CartaHeroe inherits CartaDeCombate {

	method modificarPuntaje(num) {
	}

}

class CartaClima inherits Carta {

//esto de la imagen solo funciona si hay una de cada clima unicamente
	const filasDeEfecto
	const tipoClima
	const imagenTipoClima = new Imagenes(imagen = "assets/" + tipoClima + ".png")

	method tipoClima() = tipoClima

	override method mostrar() {
		super()
		game.addVisual(imagenTipoClima)
	}

	override method esconder() {
		super()
		imagenTipoClima.esconder()
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenTipoClima.actualizarPosicion(x + 1, y + 8)
	}

	// pierde un poco el polimorfismo aca
	// porque el efecto de carta de buen tiempo
	// se aplica de forma diferente
	method aplicarEfecto() {
		filasDeEfecto.forEach({ filaAAfectar => filaAAfectar.modificarPuntajeCartas({ cartaDeCombate => cartaDeCombate.modificarPuntaje(1)})})
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

