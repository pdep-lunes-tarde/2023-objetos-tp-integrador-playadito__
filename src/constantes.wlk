import tablero.*
import cartas.*
import baraja.*

// ///////////////////////////// TIPOS /////////////////////////////
const imperioNiffgardiano = new Faccion(nombre = "imperio-niffgardiano")

const reinosDelNorte = new Faccion(nombre = "reinos-del-norte")

const scoiatael = new Faccion(nombre = "scoiatael")

const cartaDeMenu = new TipoDeCarta(nombre = "carta-menu")

const cartaDeClima = new TipoDeCarta(nombre = "clima")

const cartaDeUnidad = new TipoDeCarta(nombre = "unidad")

const cartaHeroe = new TipoDeCarta(nombre = "heroe")

const cartaLider = new TipoDeCarta(nombre = "lider")

const claseInfante = new ClaseDeCombate(nombre = "infanteria")

const claseArquera = new ClaseDeCombate(nombre = "arqueria")

const claseAsedio = new ClaseDeCombate(nombre = "asedio")

const buenTiempo = new TipoDeClima(nombre = "buenTiempo", filasDeEfecto = [ filaAsedioJugador, filaArqueroJugador, filaInfanteJugador, filaAsedioRival, filaArqueroRival, filaInfanteRival ]) // tendria q ser TODAS las filas

const escarcha = new TipoDeClima(nombre = "escarchaHeladora", filasDeEfecto = [ filaInfanteJugador, filaInfanteRival ])

const niebla = new TipoDeClima(nombre = "nieblaImpenetrable", filasDeEfecto = [ filaArqueroJugador, filaArqueroRival ])

const lluvia = new TipoDeClima(nombre = "lluviaTorrencial", filasDeEfecto = [ filaAsedioJugador, filaAsedioRival ])

const clasesDeCombate = [ claseInfante, claseArquera, claseAsedio ]

const tiposDeClima = [ buenTiempo, escarcha, niebla, lluvia ]

const especialidades = [ medico, espia, lazoEstrecho, sinHabilidad ]

// ///////////////////////////// CARTAS /////////////////////////////
const emhyrVarEmreis = new CartaLider(faccion = imperioNiffgardiano)

const foltest = new CartaLider(faccion = reinosDelNorte)

const francescaFindabair = new CartaLider(faccion = scoiatael)

// ///////////////////////////// FILAS /////////////////////////////
const filaAsedioJugador = new FilaDeCombate(claseDeCombate = claseAsedio, pos_y = 18, imagenPuntajeFila = "assets/PJ-01.png")

const filaArqueroJugador = new FilaDeCombate(claseDeCombate = claseArquera, pos_y = 30, imagenPuntajeFila = "assets/PJ-01.png")

const filaInfanteJugador = new FilaDeCombate(claseDeCombate = claseInfante, pos_y = 42, imagenPuntajeFila = "assets/PJ-01.png")

const filaAsedioRival = new FilaDeCombate(claseDeCombate = claseAsedio, pos_y = 80, imagenPuntajeFila = "assets/PR-01.png")

const filaArqueroRival = new FilaDeCombate(claseDeCombate = claseArquera, pos_y = 68, imagenPuntajeFila = "assets/PR-01.png")

const filaInfanteRival = new FilaDeCombate(claseDeCombate = claseInfante, pos_y = 56, imagenPuntajeFila = "assets/PR-01.png")

const lasFilasDeCombate = [ filaAsedioJugador, filaArqueroJugador, filaInfanteJugador, filaAsedioRival, filaArqueroRival, filaInfanteRival ]

const filaCartaLiderRival = new FilaCartaLider(pos_y = 74, pos_y_carta = 75)

const filaCartaLiderJugador = new FilaCartaLider(pos_y = 24, pos_y_carta = 25)

// ///////////////////////////// PUNTAJES /////////////////////////////
const puntajeTotalJugador = new PuntajeTotal(filasDeCombate = [ filaAsedioJugador, filaArqueroJugador, filaInfanteJugador ], pos_y = 27, imagen = "assets/PJ-02.png")

const puntajeTotalRival = new PuntajeTotal(filasDeCombate = [ filaAsedioRival, filaArqueroRival, filaInfanteRival ], pos_y = 77, imagen = "assets/PR-02.png")

// ///////////////////////////// BARAJAS /////////////////////////////
const barajaImpNiffg = new Baraja(faccion = imperioNiffgardiano, lider = emhyrVarEmreis, cantInfanteUnidad = 6, cantInfanteHeroe = 3, cantArqueroUnidad = 5, cantArqueroHeroe = 4, cantAsedioUnidad = 7, cantAsedioHeroe = 5, climaExtra = niebla)

const barajaReinosDelNorte = new Baraja(faccion = reinosDelNorte, lider = foltest, cantInfanteUnidad = 7, cantInfanteHeroe = 5, cantArqueroUnidad = 6, cantArqueroHeroe = 3, cantAsedioUnidad = 5, cantAsedioHeroe = 4, climaExtra = lluvia)

const barajaScoiatael = new Baraja(faccion = scoiatael, lider = francescaFindabair, cantInfanteUnidad = 5, cantInfanteHeroe = 4, cantArqueroUnidad = 7, cantArqueroHeroe = 5, cantAsedioUnidad = 6, cantAsedioHeroe = 3, climaExtra = escarcha)

const lasBarajas = [ barajaImpNiffg, barajaReinosDelNorte, barajaScoiatael ]

////////////////////////////// MENSAJES /////////////////////////////////
const imagenRondaPasada = new Mensajes(imagen = "assets/message-pasarRonda.png")

const imagenTurno = new Mensajes(imagen = "assets/message-turno.png")

const imagenRondaPerdida = new Mensajes(imagen = "assets/message-rondaperdida.png")

const imagenRondaGanada = new Mensajes(imagen = "assets/message-rondaganada.png")

///////////////////////////// SECCION DATOS /////////////////////////////
const seccionDatosJugador = new SeccionDatos(pos_y = 10, filaCartas = filaCartasJugador)

const seccionDatosRival = new SeccionDatos(pos_y = 80, filaCartas = filaCartasRival)

