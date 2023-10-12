import wollok.game.*
import tablero.*
import numeros.*
import constantes.*

class TipoDeCarta {

	const nombre

	method nombre() = nombre

}

class ClaseDeCombate inherits TipoDeCarta {

}

class TipoDeClima inherits TipoDeCarta {

	const filasDeEfecto

	method filasDeEfecto() = filasDeEfecto.copy()

}

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
	const tipoDeCarta
	var property baraja
	var property pos_x = 0
	var property pos_y = 0

	method position() = game.at(pos_x, pos_y)

	method image() = baraja.obtenerImagen()

	method tipoDeCarta() = tipoDeCarta

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

	method modificarPuntaje(num) {
		self.puntaje(num)
		numeroPuntaje.modificarNumero(puntaje)
	}

	method aplicarEfecto() {
	}

}

class CartaHeroe inherits CartaDeCombate(tipoDeCarta = cartaHeroe) {

	method modificarPuntaje(num) {
	}

}

class CartaClima inherits Carta(tipoDeCarta = cartaDeClima) {

//esto de la imagen solo funciona si hay una de cada clima unicamente
	const tipoDeClima
//	const claseDeEfecto // clase de combate
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

	// pierde un poco el polimorfismo aca
	// porque el efecto de carta de buen tiempo
	// se aplica de forma diferente
	method aplicarEfecto() {
		filasDeEfecto.forEach({ filaAAfectar => filaAAfectar.modificarPuntajeCartas({ cartaDeCombate => cartaDeCombate.modificarPuntaje(1)})})
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

object unMazo {

	var property laBaraja // baraja

	method generar(baraja, lider, numeroUnidadesInfante, numeroHeroesInfante, numeroUnidadesArquero, numeroHeroesArquero, numeroUnidadesAsedio, numeroHeroesAsedio, tipoDeClimaExtra) {
		const mazo = new List()
		self.laBaraja(baraja)
		mazo.add(lider)
		self.generarCartasEspeciales(mazo)
		self.generarCartasDeClima(mazo, tipoDeClimaExtra)
		self.generarCartasDeCombate(mazo, numeroUnidadesInfante, numeroHeroesInfante, claseInfante, [ espia, lazoEstrecho, sinHabilidad ], (1 .. 7))
		self.generarCartasDeCombate(mazo, numeroUnidadesArquero, numeroHeroesArquero, claseArquera, [ medico, lazoEstrecho, sinHabilidad ], (4 .. 7))
		self.generarCartasDeCombate(mazo, numeroUnidadesAsedio, numeroHeroesAsedio, claseAsedio, [ medico, sinHabilidad ], (6 .. 8))
		return mazo.copy()
	}

	method generarCartasEspeciales(elMazo) {
	}

	method generarCartasDeClima(elMazo, tipoDeClimaExtra) {
		tiposDeClima.forEach({ clima => elMazo.add(new CartaClima(tipoDeClima = clima, baraja = laBaraja))})
		elMazo.add(new CartaClima(tipoDeClima = tipoDeClimaExtra, baraja = laBaraja))
	}

	method generarCartasDeCombate(elMazo, cantidadDeUnidades, cantidadDeHeroes, clase, especialidadesPosibles, rangoDeValor) {
		cantidadDeUnidades.times({ n => elMazo.add(new CartaDeUnidad(especialidad = especialidadesPosibles.anyOne(), claseDeCombate = clase, valor = rangoDeValor.anyOne(), baraja = laBaraja))})
		cantidadDeHeroes.times({ n => elMazo.add(new CartaHeroe(claseDeCombate = clase, valor = (10 .. 15).anyOne(), baraja = laBaraja))})
	}

}

class Baraja {

	const nombre
	const lider
	const cantInfanteUnidad
	const cantInfanteHeroe
	const cantArqueroUnidad
	const cantArqueroHeroe
	const cantAsedioUnidad
	const cantAsedioHeroe
	const climaExtra
	const mazo = unMazo.generar(self, lider, cantInfanteUnidad, cantInfanteHeroe, cantArqueroUnidad, cantArqueroHeroe, cantAsedioUnidad, cantAsedioHeroe, climaExtra)
	const manoCartas = new List()
	var property pos_x = 0
	var property pos_y = 0
	var property cantidadEnMazo = 40
	const numeroPuntaje = new Numero(numero = cantidadEnMazo)

	method image() = "assets/" + nombre + ".png"

	method position() = game.at(pos_x, pos_y)

	method nombre() = nombre

	// const efectoFinDeRonda
	method obtenerImagen() = self.image()

	method mazo() = mazo.copy()

	method mostrar() {
		game.addVisual(self)
		game.addVisual(numeroPuntaje)
	}

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

	method actualizarPosicion(x, y) {
		self.pos_x(x)
		self.pos_y(y)
		numeroPuntaje.actualizarPosicion(x + 1, y - 1)
	}

	method actualizarCantidadEnMazo() {
		cantidadEnMazo = mazo.size()
		numeroPuntaje.modificarNumero(cantidadEnMazo)
	}

}

