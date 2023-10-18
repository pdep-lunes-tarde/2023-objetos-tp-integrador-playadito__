import wollok.game.*
import tablero.*
import numeros.*
import constantes.*

class Tipo {

	const nombre

	method nombre() = nombre

}

class TipoDeCarta inherits Tipo {

}

class ClaseDeCombate inherits Tipo {

}

class TipoDeClima inherits Tipo {

	const filasDeEfecto

	method filasDeEfecto() = filasDeEfecto.copy()

}

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
	const tipoDeCarta
	const faccion
	var property pos_x = 0
	var property pos_y = 0

	method position() = game.at(pos_x, pos_y)

	method image() = faccion.imagen()

	method tipoDeCarta() = tipoDeCarta

	method faccion() = faccion

	method baraja() = lasBarajas.find({ baraja => baraja.faccion().equals(faccion) })

	method tieneEfecto() = false

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

	const claseDeCombate
	const valor // puntaje original (valor numerico)
	var property puntaje = valor // puntaje modificable (constante por el momento porque no se implemento la modificacion)
	const imagenTipoDeCombate = new Imagenes(imagen = "assets/" + claseDeCombate.nombre() + ".png")
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

	method modificarPuntajeA(num) {
		self.puntaje(num)
		numeroPuntaje.modificarNumero(puntaje)
	}

	method resetearPuntaje() {
		self.puntaje(valor)
		numeroPuntaje.modificarNumero(puntaje)
	}

}

class CartaDeUnidad inherits CartaDeCombate(tipoDeCarta = cartaDeUnidad) {

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

	override method tieneEfecto() = especialidad != sinHabilidad

	method aplicarEfecto() {
		especialidad.aplicar(faccion)
	}

}

class CartaHeroe inherits CartaDeCombate(tipoDeCarta = cartaHeroe) {

	const imagenNumeroHeroe = new Imagenes(imagen = "assets/numeroHeroe.png")

	override method modificarPuntajeA(num) {
	}

	override method mostrar() {
		super()
		game.addVisual(imagenNumeroHeroe)
	}

	override method esconder() {
		super()
		imagenNumeroHeroe.esconder()
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenNumeroHeroe.actualizarPosicion(x + 1, y + 8)
	}

}

class CartaClima inherits Carta(tipoDeCarta = cartaDeClima) {

//esto de la imagen solo funciona si hay una de cada clima unicamente
	const tipoDeClima
	const filasDeEfecto = tipoDeClima.filasDeEfecto()
	const imagenTipoClima = new Imagenes(imagen = "assets/" + tipoDeClima.nombre() + ".png")

	method tipoDeClima() = tipoDeClima

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

	override method tieneEfecto() = true

	method aplicarEfecto() {
		// se podria meter alguna img aca
		if (tipoDeClima.equals(buenTiempo)) {
			filasDeEfecto.forEach({ fila => fila.diaDespejado()})
		} else {
			filasDeEfecto.forEach({ fila => fila.tiempoFeo()})
		}
	}

}

class CartaLider inherits Carta(tipoDeCarta = cartaLider) {

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

	method aplicar(faccion) {
		tablero.recuperarCartaPara(faccion)
	}

}

object espia {

	const imagen = "assets/espia.png"

	method obtenerImagen() = imagen

	method aplicar(faccion) {
		2.times({ n => tablero.sacarCartaPara(faccion)})
	}

}

object lazoEstrecho {

	const imagen = "assets/lazoEstrecho.png"

	method obtenerImagen() = imagen

	method aplicar(faccion) {
	}

}

//ver que hacer con la imagen
object sinHabilidad {

	const imagen = "assets/transparente.png"

	method obtenerImagen() = imagen

	method aplicar() {
	}

}

