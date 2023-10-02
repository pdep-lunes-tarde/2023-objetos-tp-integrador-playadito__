import wollok.game.*
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

class CartaDeUnidad {

	// 80px (8 celdas)
	// 110px(11 celdas)
	// inicializar con (claseDeCombate, valor, especialidad, baraja)
	const baraja
	const claseDeCombate // cadena, ej "infanteria"
	const valor // puntaje inicial u original (valor numerico)
	var puntaje = valor // puntaje modificable (constante por el momento porque no se implemento la modificacion)
	const especialidad // objeto de especialidad
	var pos_x = 0
	var pos_y = 0
	const imgDeCombate = self.designarImagenesTipoCombate()
	const imagenTipoDeCombate = new Imagenes(imagen = "assets/" + claseDeCombate + ".png")
	const numeroPuntaje = new Numero(numero = puntaje)
	const imagenEspecialidad = new Imagenes(imagen = especialidad.obtenerImagen())

//ver si conviene, o mejor hacerlo a mano con ifs
	method designarImagenesTipoCombate() {
		const imgCombate = new Dictionary()
		imgCombate.put("infanteria", "assets/infanteria.png")
		imgCombate.put("arqueria", "assets/arqueria.png")
		imgCombate.put("asedio", "assets/asedio.png")
		return imgCombate
	}

	method image() = baraja.obtenerImagen()

	method position() = game.at(pos_x, pos_y)

	method actualizarPosicion(x, y) {
		pos_x = x
		pos_y = y
		imagenTipoDeCombate.actualizarPosicion(x + 5, y + 1)
		numeroPuntaje.actualizarPosicion(x - 1, y + 6)
		imagenEspecialidad.actualizarPosicion(x + 2, y + 1)
	}

	method getPosicionX() = pos_x

	method getPosicionY() = pos_y

	method puntaje() = puntaje

	method claseDeCombate() = claseDeCombate

	method especialidad() = especialidad

	method mostrar() {
		if (game.hasVisual(self)) {
			self.esconder()
		}
		game.addVisual(self)
		game.addVisual(imagenTipoDeCombate)
		game.addVisual(numeroPuntaje)
		game.addVisual(imagenEspecialidad)
	}

	method esconder() {
		game.removeVisual(self)
		imagenTipoDeCombate.esconder()
		numeroPuntaje.esconder()
		imagenEspecialidad.esconder()
	}

	method modificarPuntaje(num) {
		puntaje = valor + num
		numeroPuntaje.modificarNumero(puntaje)
	}

	method imagenTipoCombate() {
	}

}

class CartaHeroe {

}

class CartaEspecial {

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
