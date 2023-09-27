import wollok.game.*
import numeros.*

//ver que onda, lo cree para lo de la imagen, pero si esto cambia, hay que revisar otras cosas
class Imagenes {

	const imagen
	var posx = 0
	var posy = 0

	method image() = imagen

	method position() = game.at(posx, posy)

	method setPosicion(x, y) {
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
	const imagenTipoDeCombate = new Imagenes(imagen = imgDeCombate.get(self.claseDeCombate()))
	const numeroPuntaje = new Numero(numero = self.puntaje())
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

	method setPosicion(x, y) {
		pos_x = x
		pos_y = y
		imagenTipoDeCombate.setPosicion(x + 5, y + 1)
		numeroPuntaje.setPosicion(x - 1, y + 6)
		imagenEspecialidad.setPosicion(x + 2, y + 1)
	}

	method getPosicionX() = pos_x

	method getPosicionY() = pos_y

	// method text() = "      " + puntaje.toString() + "\n"
	// method textColor() = "000000FF"
	method puntaje() = puntaje

	method claseDeCombate() = claseDeCombate

	method especialidad() = especialidad

	method mostrar() {
		if (game.hasVisual(self)) {
			self.esconder()
			imagenTipoDeCombate.esconder()
			numeroPuntaje.esconder()
			imagenEspecialidad.esconder()
		}
		game.addVisual(self)
		game.addVisual(imagenTipoDeCombate)
		game.addVisual(numeroPuntaje)
		game.addVisual(imagenEspecialidad)
	}

	method esconder() {
		game.removeVisual(self)
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

const ciri = new CartaDeUnidad(claseDeCombate = "infanteria", valor = 10, especialidad = lazoEstrecho, baraja = reinosDelNorte)

const geraltOfRivia = new CartaDeUnidad(claseDeCombate = "infanteria", valor = 8, especialidad = sinHabilidad, baraja = reinosDelNorte)

const yenneferOfVengerberg = new CartaDeUnidad(claseDeCombate = "arqueria", valor = 15, especialidad = medico, baraja = reinosDelNorte)

const trissMerigold = new CartaDeUnidad(claseDeCombate = "arqueria", valor = 12, especialidad = espia, baraja = reinosDelNorte)

const philippaEilhart = new CartaDeUnidad(claseDeCombate = "asedio", valor = 8, especialidad = sinHabilidad, baraja = reinosDelNorte)

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

// BARAJAS
// razon: porque la definicion los metodos del efecto de cada baraja son diferentes
object reinosDelNorte {

	const imagen = "assets/C-reinosDelNorte.png"
	const mazo = [ ciri, geraltOfRivia, yenneferOfVengerberg, trissMerigold, philippaEilhart ]
	const manoCartas = new List()

	method obtenerImagen() = imagen

	method mazo() = mazo

	method obtenerCartaRandom() {
		const unaCarta = mazo.anyOne()
		manoCartas.add(unaCarta)
		mazo.remove(unaCarta)
	}

//por alguna razon no funciona, por anyOne
	method setCartas(cantidadCartas) {
//		cantidadCartas.times({ i => self.obtenerCartaRandom()})
//		return manoCartas
		return mazo
	}

	method efectoFinDeRonda() {
	}

}

object imperioNiffgardiano {

	const imagen = "assets/C-imperioNiffgardiano.png"

	method efectoFinDeRonda() {
	}

}

object scoiatael {

	const imagen = "assets/C-scoiatael.png"

	method efectoFinDeRonda() {
	}

}

