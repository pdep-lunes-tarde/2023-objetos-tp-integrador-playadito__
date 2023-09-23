import wollok.game.*

class CartaDeUnidad {

	// 80px
	// 110px
	const baraja // objeto
	const claseDeCombate // cadena, ej "infanteria"
	const valor // puntaje inicial u original (valor numerico)
	var puntaje = valor // puntaje modificable
	const especialidad // objeto de especialidad
	var pos_x = 0
	var pos_y = 0

	method position() {
		return game.at(pos_x, pos_y)
	}

	method setPosicion(x, y) {
		pos_x = x
		pos_y = y
	}

//cambiar si encontramos algo mejor
	method getPosicionX() {
		return pos_x
	}

	method getPosicionY() {
		return pos_y
	}

	method image() {
		return "assets/C-01.png"
	}

	method text() {
		return puntaje.toString()
	}

	method textColor() {
		return "000000FF"
	}

	method puntaje() = puntaje

	method jugar() {
	}

}

class CartaHeroe {

}

class CartaEspecial {

}

class CartaLider {

}

const cartaUno = new CartaDeUnidad(baraja = reinosDelNorte, claseDeCombate = "infanteria", valor = 5, especialidad = espia)

const cartaDos = new CartaDeUnidad(baraja = reinosDelNorte, claseDeCombate = "arqueria", valor = 8, especialidad = nulo)

const cartaTres = new CartaDeUnidad(baraja = reinosDelNorte, claseDeCombate = "asedio", valor = 6, especialidad = medico)

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

object nulo {

	method aplicar() {
	}

}

// BARAJAS
// razon: porque la definicion los metodos del efecto de cada baraja son diferentes
object reinosDelNorte {

	const mazo = [ cartaUno, cartaDos, cartaTres ]

	method mazo() {
		return mazo
	}

	method setCartas() {
		mazo.clear()
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

