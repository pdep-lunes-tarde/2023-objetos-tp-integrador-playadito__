import wollok.game.*
import tp.* // para el selector

/*
 * IMPORTANTE
 * QUEDA POR HACER (EN ESTA IMPLEMENTACION):
 * 
 * FILA CARTAS RESTANTES
 * LOGICA DE DAR LAS PRIMERAS CARTAS RANDOM
 * PUNTAJE TOTAL
 * 
 * 
 * 
 * 
 * 
 * 
 */
///////////////////////////// PARTIDA /////////////////////////////
object match {

	var playerDeck
	var round = 1

	// hacer que contanga toda la info??
	// o que contenga referencias de players (va a ser mas complicado de trabajar)
	// var player
	// var computer
	// info minima: debe tener los puntajes y las barajas
	method start() {
		// detectar baraja elegida
		playerDeck = northernRealms
			// asignar baraja para la computadora
		self.startRound()
	}

	method startRound() {
		// seleccionar cartas random segun ronda (primera ronda = 10 cartas)
		if (round == 1) {
			remainingCardsRow.setHand(playerDeck.selectRandom(10))
		}
		board_.init()
	}

}

///////////////////////////// BARAJA /////////////////////////////
object northernRealms {

	// ver mejor forma de organizar esto
	const deck = [ ciri, geraltOfRivia, yenneferOfVengerberg, trissMerigold, philippaEilhart ]

	method deck() {
		return deck
	}

	method endOfRoundEffect() {
	}

//	method firstHand(randomCards, num) {
//		if (randomCards.size() < num) {
//			const card = deck.anyOne()
//			randomCards.add(card)
//			deck.remove(card)
//			self.firstHand(randomCards, num)
//		}
//	}
//		if (manoInicial.size() < 3) {
//			cartaAleatoria = barajaElegida.anyOne()
//			barajaElegida.remove(cartaAleatoria)
//			manoInicial.add(cartaAleatoria)
//			self.firstHand()
//		}
	method selectRandom(num) {
		return deck
	}

}

///////////////////////////// CARTAS /////////////////////////////
class Card_ {

	// inicializar con (combatClass, strengthPoints, ability, image)
	const combatClass
	const strengthPoints
	var strength = strengthPoints
	const ability
	const image
	var pos_x = 0
	var pos_y = 0

	method image() = image

	method position() = game.at(pos_x, pos_y)

	method setPosition(x, y) {
		pos_x = x
		pos_y = y
	}

	method getPosicionX() = pos_x

	method getPosicionY() = pos_y

	method text() = strength.toString()

	method textColor() = "000000FF"

	method display() {
		game.addVisual(self)
	}

	method hide() {
		game.removeVisual(self)
	}

	method strength() = strength

	method combatClass() = combatClass

	method ability() = ability

	// esta escrito para que no tire warning nomas
	// mas adelante se va a desarrollar para que modifique segun criterio
	method modifyStrenght() {
		strength++
	}

}

// uso de clousures ya que se espera que haya un solo metodo de aplicar especialidad
const medic = {
}

const spy = {
}

const tightBond = {
}

const noAbility = {
}

const ciri = new Card_(combatClass = "closeCombat", strengthPoints = 10, ability = noAbility, image = "assets/C-01.png")

const geraltOfRivia = new Card_(combatClass = "closeCombat", strengthPoints = 8, ability = noAbility, image = "assets/C-01.png")

const yenneferOfVengerberg = new Card_(combatClass = "ranged", strengthPoints = 15, ability = noAbility, image = "assets/C-01.png")

const trissMerigold = new Card_(combatClass = "ranged", strengthPoints = 12, ability = noAbility, image = "assets/C-01.png")

const philippaEilhart = new Card_(combatClass = "siege", strengthPoints = 8, ability = noAbility, image = "assets/C-01.png")

///////////////////////////// TABLERO /////////////////////////////
object board_ {

	const playerField = new Dictionary()

	// setear tambien opponentField
	method init() {
		// ver si se puede instanciar aca
		playerField.put("closeCombat", playerCloseCombat)
		playerField.put("ranged", playerRanged)
		playerField.put("siege", playerSiege)
		self.display()
	}

	method position() {
	}

	method image() {
	}

	method playerPlay(card) {
		playerField.get(card.combatClass()).addCard(card)
	}

	// Por el momento parece que no es necesario el objeto tablero
	// el method display se usaria para hacer llamada de los displays
	// de cada seccion. (cosa que se podria hacer en otro lado)
	method display() {
		// filas de combate
		game.addVisual(playerSiege)
		game.addVisual(playerRanged)
		game.addVisual(playerCloseCombat)
		game.addVisual(opponentSiege)
		game.addVisual(opponentRanged)
		game.addVisual(opponentCloseCombat)
			// fila de cartas restantes
		game.addVisual(remainingCardsRow)
		remainingCardsRow.displayCards()
	}

}

///////////////////////////// FILA COMBATE /////////////////////////////
class CombatRow_ {

	// 700px (35 celdas)
	// 120px (6)
	const cards = new List()
	const combatClass // string de clase de combate
	const pos_x = 24
	const pos_y
	const rowScore = new RowScore_(pos_y = pos_y + 2)

	// wollok game req
	method image() = "assets/FC-002.png" // la imagen es la misma para todas las instancias

	method position() = game.at(pos_x, pos_y)

	// muestra / actualiza la vista de toda la fila
	method display() {
		// son dos forEach sobre la lista actualizada (sea por remove, o add).
		if (!cards.isEmpty()) {
			counter.reset()
			cards.forEach({ card => card.setPosition(self.setCard_X(pos_x), pos_y)})
			cards.forEach({ card => card.display()})
		}
		rowScore.display()
	// en teoria el numero se actualiza solo, no hace falta refrescar
	// pero por si se quiere implementar el sistema rancio de numero con img
	}

	// medio rancio esto, pero lo hago en metodo aparte para 
	// ver si encuentro alguna forma dehacer algo inteligente 
	// y poder centrar o acomodar de forma linda.
	// ** el contador empieza desde 5, asi que resto 3 celdas de la primera pos (dejo 2 de espacio)
	// ** va de 5 en 5 porque las cartas son de 4, asi que se deja 1 celda entre medio (que capaz no es necesario)
	method setCard_X(row_x) = (row_x - 3) + counter.count(4)

	// inserta una carta en la linea (cuando se juega una carta)
	method addCard(card) {
		cards.add(card)
		rowScore.sum(card.strength())
		self.display()
	}

	// para mas adelante (efecto de algunas cartas especiales)
	method removeCard() {
		// ...
		self.display()
	}

	// limpia la fila (para fin de ronda)
	method cleanRow() {
		cards.clear()
		self.display()
	}

	method combatClass() = combatClass

}

// ES MALO ESTO, PENSAR OTRA FORMA
// es para el display formateado
object counter {

	var counter = 0

	method count(increment) {
		counter = counter + increment
		return counter
	}

	method reset() {
		counter = 0
	}

}

class RowScore_ {

	const pos_x = 22
	var pos_y
	var score = 0

	// la imagen es la misma para todas las instancias??
	// ver como hacer para que sea distinto entre jugadores.
	// ya se que ya esta implementado por valor de inicializacion, 
	// pero digo de buscar algo mas limpio
	method image() = "assets/PJ-01.png"

	method position() = game.at(pos_x, pos_y)

	method display() {
		game.addVisual(self)
	}

	method text() {
		return score.toString()
	}

	method textColor() {
		return "000000FF"
	}

	// creo que no se va a usar para nada, pero por las dudas, aca esta
	method score() = score

	method sum(num) {
		score = score + num
	}

	method sub(num) {
		score = score - num
	}

}

// Instancias de CombatRow, las instancias existen siempre,
// pero las visuales deben ser disparadas en algun momento concreto
const playerSiege = new CombatRow_(combatClass = "siege", pos_y = 9)

const playerRanged = new CombatRow_(combatClass = "ranged", pos_y = 15)

const playerCloseCombat = new CombatRow_(combatClass = "closeCombat", pos_y = 21)

const opponentSiege = new CombatRow_(combatClass = "siege", pos_y = 28)

const opponentRanged = new CombatRow_(combatClass = "ranged", pos_y = 34)

const opponentCloseCombat = new CombatRow_(combatClass = "closeCombat", pos_y = 40)

///////////////////////////// CARTAS DISPONIBLES /////////////////////////////
object remainingCardsRow {

	var remainingCards = new List()
	var selector
	const pos_x = 25
	const pos_y = 2

	method image() = "assets/FC-002.png"

	method position() = game.at(24, 2)

	method setHand(cards) {
		remainingCards = cards
	}

	method remainingCards() = remainingCards

	// muestra / actualiza las cartas
	method displayCards() {
		counter.reset()
		remainingCards.forEach({ card => card.setPosition(self.setCard_X(pos_x), pos_y)})
		remainingCards.forEach({ card => card.display()})
		selector = new Selector(items = self.remainingCards(), image = "assets/S-02.png", catcher = self)
		selector.setSelector()
	}

	// metodo repetido, -_-
	method setCard_X(row_x) = (row_x - 3) + counter.count(4)

	method takeSelection(index) {
		const selectedCard = remainingCards.get(index)
		board_.playerPlay(selectedCard)
		remainingCards.remove(selectedCard)
		self.displayCards()
	}

}

