import wollok.game.*
import tablero.*
import cartas.*
import numeros.*
import constantes.*

class Faccion inherits Tipo {

	method imagen() = "assets/" + self.nombre() + ".png"

}

class Baraja {

	// tipo faccion
	const faccion
	// configuracion de la baraja
	const lider
	const cantInfanteUnidad
	const cantInfanteHeroe
	const cantArqueroUnidad
	const cantArqueroHeroe
	const cantAsedioUnidad
	const cantAsedioHeroe
	const climaExtra
	// mazo de cartas
	const mazo = mazoDeCartas.generar(faccion, cantInfanteUnidad, cantInfanteHeroe, cantArqueroUnidad, cantArqueroHeroe, cantAsedioUnidad, cantAsedioHeroe, climaExtra)
	var property posEnX = 0
	var property posEnY = 0
	var property cantidadEnMazo = 40
	const numeroPuntaje = new Numero(numero = cantidadEnMazo)

	method image() = faccion.imagen()

	method position() = game.at(posEnX, posEnY)

	method faccion() = faccion

	method mazo() = mazo.copy()

	method mostrar() {
		game.addVisual(self)
		game.addVisual(numeroPuntaje)
	}

	method obtenerCartaRandom() {
		const unaCarta = mazo.anyOne()
		mazo.remove(unaCarta)
		self.actualizarCantidadEnMazo()
		return unaCarta
	}

	method obtenerCartas(cantidadCartas) {
		const cartas = []
		cantidadCartas.times({ i => cartas.add(self.obtenerCartaRandom())})
		return cartas
	}

	method actualizarPosicion(x, y) {
		self.posEnX(x)
		self.posEnY(y)
		numeroPuntaje.actualizarPosicion(x + 1, y - 1)
	}

	method actualizarCantidadEnMazo() {
		cantidadEnMazo = mazo.size()
		numeroPuntaje.modificarNumero(cantidadEnMazo)
	}

	method lider() = lider

}

object mazoDeCartas {

	var property laFaccion // baraja

	method generar(faccion, numeroUnidadesInfante, numeroHeroesInfante, numeroUnidadesArquero, numeroHeroesArquero, numeroUnidadesAsedio, numeroHeroesAsedio, tipoDeClimaExtra) {
		const mazo = new List()
		self.laFaccion(faccion)
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
		tiposDeClima.forEach({ clima => elMazo.add(new CartaClima(tipoDeClima = clima, faccion = laFaccion))})
		elMazo.add(new CartaClima(tipoDeClima = tipoDeClimaExtra, faccion = laFaccion))
	}

	method generarCartasDeCombate(elMazo, cantidadDeUnidades, cantidadDeHeroes, clase, especialidadesPosibles, rangoDeValor) {
		cantidadDeUnidades.times({ n => elMazo.add(new CartaDeUnidad(especialidad = especialidadesPosibles.anyOne(), claseDeCombate = clase, valor = rangoDeValor.anyOne(), faccion = laFaccion))})
		cantidadDeHeroes.times({ n => elMazo.add(new CartaHeroe(claseDeCombate = clase, valor = (10 .. 15).anyOne(), faccion = laFaccion))})
	}

}

