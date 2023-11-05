import wollok.game.*
import tablero.*
import numero.*
import constantes.*
import filas.*
import imagen.*

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

class Carta {

	// 80px (8 celdas)
	// 110px(11 celdas)
	const tipoDeCarta
	const faccion
	var property posEnX = 0
	var property posEnY = 0

	method position() = game.at(posEnX, posEnY)

	method image() = faccion.imagen()

	method tipoDeCarta() = tipoDeCarta

	method faccion() = faccion

	method jugador() = tablero.jugadorDeFaccion(faccion)

	method baraja() = lasBarajas.find({ baraja => baraja.faccion().equals(faccion) })

	method tieneEfecto() = false

	method mostrar() {
		game.addVisual(self)
	}

	method esconder() {
		game.removeVisual(self)
	}

	method actualizarPosicion(x, y) {
		self.posEnX(x)
		self.posEnY(y)
	}

	method aplicarEfecto() {
	}

	method removerEfecto() {
	}

}

class CartaDeCombate inherits Carta {

	const claseDeCombate
	const valor // puntaje original (valor numerico)
	var property puntaje = valor // puntaje modificable (constante por el momento porque no se implemento la modificacion)
	const imagenTipoDeCombate = new Imagen(imagen = "assets/" + claseDeCombate.nombre() + ".png")
	const numeroPuntaje = new Numero(numero = puntaje)

	method puntajeInicial() = valor

	method claseDeCombate() = claseDeCombate

	override method mostrar() {
		super()
		imagenTipoDeCombate.mostrar()
		numeroPuntaje.mostrar()
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

	method modificarPuntajeA(num)

	method duplicarPuntaje()

	method aumentarPuntaje(num)

	method resetearPuntaje() {
		self.puntaje(valor)
		numeroPuntaje.modificarNumero(puntaje)
	}

}

class CartaDeUnidad inherits CartaDeCombate(tipoDeCarta = cartaDeUnidad) {

	// inicializar con (claseDeCombate, valor, especialidad, baraja)
	const especialidad // objeto de especialidad
	const imagenEspecialidad = new Imagen(imagen = especialidad.obtenerImagen())

	method especialidad() = especialidad

	override method tieneEfecto() = especialidad != sinHabilidad

	override method mostrar() {
		super()
		imagenEspecialidad.mostrar()
	}

	override method esconder() {
		super()
		imagenEspecialidad.esconder()
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenEspecialidad.actualizarPosicion(x + 2, y + 1)
	}

	override method aplicarEfecto() {
		especialidad.aplicar(self.jugador().filaParaCarta(self))
	}

	override method removerEfecto() {
		especialidad.removerEfecto(self.jugador().filaParaCarta(self))
	}

	override method modificarPuntajeA(num) {
		self.puntaje(num)
		numeroPuntaje.modificarNumero(puntaje)
	}

	override method duplicarPuntaje() {
		self.puntaje(puntaje * 2)
		numeroPuntaje.modificarNumero(puntaje)
	}

	override method aumentarPuntaje(num) {
		self.puntaje(puntaje + num)
		numeroPuntaje.modificarNumero(puntaje)
	}

}

class CartaHeroe inherits CartaDeCombate(tipoDeCarta = cartaHeroe) {

	const imagenNumeroHeroe = new Imagen(imagen = "assets/numeroHeroe.png")

	override method mostrar() {
		super()
		imagenNumeroHeroe.mostrar()
	}

	override method esconder() {
		super()
		imagenNumeroHeroe.esconder()
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenNumeroHeroe.actualizarPosicion(x, y + 8)
	}

	override method modificarPuntajeA(num) {
	}

	override method duplicarPuntaje() {
	}

	override method aumentarPuntaje(num) {
	}

}

class CartaClima inherits Carta(tipoDeCarta = cartaDeClima) {

	const tipoDeClima
	const filasDeEfecto = tipoDeClima.filasDeEfecto()
	const imagenTipoClima = new Imagen(imagen = "assets/" + tipoDeClima.nombre() + ".png")

	method tipoDeClima() = tipoDeClima

	override method tieneEfecto() = true

	override method mostrar() {
		super()
		imagenTipoClima.mostrar()
	}

	override method esconder() {
		super()
		imagenTipoClima.esconder()
	}

	override method actualizarPosicion(x, y) {
		super(x, y)
		imagenTipoClima.actualizarPosicion(x + 1, y + 8)
	}

	override method aplicarEfecto() {
		// se podria meter alguna img aca
		if (tipoDeClima.equals(buenTiempo)) {
			filaCartasClima.vaciarFila()
		} else {
			filasDeEfecto.forEach({ fila => fila.tiempoFeo()})
		}
	}

	override method removerEfecto() {
		filasDeEfecto.forEach({ fila => fila.diaDespejado()})
	}

}

class CartaLider inherits Carta(tipoDeCarta = cartaLider) {

	override method image() = "assets/" + faccion.nombre() + "-lider.png"

}

object emhyrVarEmreis inherits CartaLider(faccion = imperioNiffgardiano) {

	override method aplicarEfecto() {
		self.jugador().recuperarUnaCartaDescartadaRival()
	}

}

object francescaFindabair inherits CartaLider(faccion = scoiatael) {

	override method aplicarEfecto() {
		self.jugador().filasDeCombate().forEach({ fila => fila.hayLiderBoost(true)})
	}

}

object foltest inherits CartaLider(faccion = reinosDelNorte) {

	override method aplicarEfecto() {
	}

}

object medico {

	const imagen = "assets/medico.png"

	method obtenerImagen() = imagen

	method aplicar(fila) {
		tablero.jugadorDeTurnoRecuperaCarta()
	}

	method removerEfecto(fila) {
	}

}

object espia {

	const imagen = "assets/espia.png"

	method obtenerImagen() = imagen

	method aplicar(fila) {
		2.times({ n => tablero.jugadorDeTurnoSacaCarta()})
	}

	method removerEfecto(fila) {
	}

}

object lazoEstrecho {

	const imagen = "assets/lazoEstrecho.png"

	method obtenerImagen() = imagen

	method aplicar(fila) {
		fila.hayLazoEstrecho(true)
	}

	method removerEfecto(fila) {
		fila.hayLazoEstrecho(false)
	}

}

//ver que hacer con la imagen
object sinHabilidad {

	const imagen = "assets/transparente.png"

	method obtenerImagen() = imagen

	method aplicar(fila) {
	}

	method removerEfecto(fila) {
	}

}

