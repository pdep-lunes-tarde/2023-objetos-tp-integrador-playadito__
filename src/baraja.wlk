import wollok.game.*
import tablero.*
import cartas.*
import numeros.*
import constantes.*

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
	const mazo = mazoDeCartas.generar(faccion, lider, cantInfanteUnidad, cantInfanteHeroe, cantArqueroUnidad, cantArqueroHeroe, cantAsedioUnidad, cantAsedioHeroe, climaExtra)
	const manoCartas = new List()
	var property pos_x = 0
	var property pos_y = 0
	var property cantidadEnMazo = 40
	const numeroPuntaje = new Numero(numero = cantidadEnMazo)

	method image() = faccion.imagen()

	method position() = game.at(pos_x, pos_y)

	method faccion() = faccion

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

object mazoDeCartas {

	var property laFaccion // baraja

	method generar(faccion, lider, numeroUnidadesInfante, numeroHeroesInfante, numeroUnidadesArquero, numeroHeroesArquero, numeroUnidadesAsedio, numeroHeroesAsedio, tipoDeClimaExtra) {
		const mazo = new List()
		self.laFaccion(faccion)
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
		tiposDeClima.forEach({ clima => elMazo.add(new CartaClima(tipoDeClima = clima, faccion = laFaccion))})
		elMazo.add(new CartaClima(tipoDeClima = tipoDeClimaExtra, faccion = laFaccion))
	}

	method generarCartasDeCombate(elMazo, cantidadDeUnidades, cantidadDeHeroes, clase, especialidadesPosibles, rangoDeValor) {
		cantidadDeUnidades.times({ n => elMazo.add(new CartaDeUnidad(especialidad = especialidadesPosibles.anyOne(), claseDeCombate = clase, valor = rangoDeValor.anyOne(), faccion = laFaccion))})
		cantidadDeHeroes.times({ n => elMazo.add(new CartaHeroe(claseDeCombate = clase, valor = (10 .. 15).anyOne(), faccion = laFaccion))})
	}

}

