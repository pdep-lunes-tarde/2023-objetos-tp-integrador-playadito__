import wollok.game.*

class CartaDeUnidad {

	// 80px
	// 110px
	// const baraja // objeto
	// inicializar con (claseDeCombate, valor, especialidad, imagen)
	const claseDeCombate // cadena, ej "infanteria"
	const valor // puntaje inicial u original (valor numerico)
	const puntaje = valor // puntaje modificable (constante por el momento porque no se implemento la modificacion)
	const especialidad // objeto de especialidad
	const imagen // = "assets/C-01.png"
	var pos_x = 0
	var pos_y = 0

	method image() = imagen

	method position() = game.at(pos_x, pos_y)

	method setPosicion(x, y) {
		pos_x = x
		pos_y = y
	}

	method getPosicionX() = pos_x

	method getPosicionY() = pos_y

	method text() = puntaje.toString()

	method textColor() = "000000FF"

	method puntaje() = puntaje

	method claseDeCombate() = claseDeCombate

	method especialidad() = especialidad

	method mostrar() {
		game.addVisual(self)
	}

	method esconder() {
		game.removeVisual(self)
	}

	method modificarPuntaje() {
	}

}

class CartaHeroe {

}

class CartaEspecial {

}

class CartaLider {

}

const ciri = new CartaDeUnidad(claseDeCombate = "infanteria", valor = 10, especialidad = sinHabilidad, imagen = "assets/C-01.png")

const geraltOfRivia = new CartaDeUnidad(claseDeCombate = "infanteria", valor = 8, especialidad = sinHabilidad, imagen = "assets/C-01.png")

const yenneferOfVengerberg = new CartaDeUnidad(claseDeCombate = "arqueria", valor = 15, especialidad = sinHabilidad, imagen = "assets/C-01.png")

const trissMerigold = new CartaDeUnidad(claseDeCombate = "arqueria", valor = 12, especialidad = sinHabilidad, imagen = "assets/C-01.png")

const philippaEilhart = new CartaDeUnidad(claseDeCombate = "asedio", valor = 8, especialidad = sinHabilidad, imagen = "assets/C-01.png")

// Especialidades
object medico {

	method aplicar() {
	}

}

object espia {

	method aplicar() {
	}

}

object lazoEstrecho {

	method aplicar() {
	}

}

object sinHabilidad {

	method aplicar() {
	}

}

// BARAJAS
// razon: porque la definicion los metodos del efecto de cada baraja son diferentes
object reinosDelNorte {

	const mazo = [ ciri, geraltOfRivia, yenneferOfVengerberg, trissMerigold, philippaEilhart ]
	const manoCartas = new List()

	// ver que se vacie
	method mazo() = mazo

	method obtenerCartaRandom() {
		const unaCarta = mazo.anyOne()
		manoCartas.add(unaCarta)
		mazo.remove(unaCarta)
	}

	method setCartas(cantidadCartas) {
		cantidadCartas.times({ i => self.obtenerCartaRandom()})
		return manoCartas
	}

	method efectoFinDeRonda() {
	}

}

object imperioNiffgardiano {

	method efectoFinDeRonda() {
	}

}

object scoiatael {

	method efectoFinDeRonda() {
	}

}

