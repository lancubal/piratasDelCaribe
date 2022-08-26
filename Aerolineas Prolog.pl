/* Punto 1 */
% aeropuerto(CODIGO, CIUDAD, PAIS).
aeropuerto(aep, buenosAires, argentina).
aeropuerto(eze, buenosAires, argentina).
aeropuerto(gru, saoPaulo, brazil).
aeropuerto(scl, santiagoDeChile, chile).
aeropuerto(brc, bariloche, argentina).
aeropuerto(igr, iguazu, argentina).
aeropuerto(mdq, marDelPlata, argentina).

% ciudad(CIUDAD, PAIS, TIPO).
/* Tipo:
    paradisiaca
    negocios
    importanciaCultural([lugaresEmblematicos])
*/

ciudad(palawan, filipinias, paradisiaca).
ciudad(chicago, estadosUnidos, negocios).
ciudad(paris, francia, importanciaCultural([torreEifel, arcoDelTriunfo, museoLouvre, catedralDeNotreDame])).
ciudad(buenosAires, argentina, importanciaCultural([obelisco, congreso, cabildo])).

% ruta(Aerolinea, Codigo de Salida, Codigo de llegada, Costo).
ruta(aerolineasProlog, aep, gru, 75000).
ruta(aerolineasProlog, gru, scl, 65000).
ruta(jetsmart, aep, brc, 70000).
ruta(jetsmart, brc, aep, 72000).
ruta(jetsmart, igr, brc, 50000).
ruta(jetsmart, aep, igr, 54000).
ruta(jetsmart, igr, mdq, 80000).

% persona(NOMBRE, DINERO, MILLAS, CIUDAD ACTUAL).
persona(eduardo,50000,750,buenosAires).

/* Punto 2 */

esDeCabotaje(Aerolinea):-
    ruta(Aerolinea,Codigo,_,_),
    aeropuerto(Codigo,_,Pais),
    forall(ruta(Aerolinea, CodigoSalida,CodigoLlegada,_), (aeropuerto(CodigoLlegada,_, Pais), aeropuerto(CodigoSalida,_, Pais))).

soloTieneViajeDeIda(Partida, Destino):-
    aeropuerto(CodigoDestino, Destino,_),
    aeropuerto(CodigoSalida, Partida,_),
    ruta(_,CodigoSalida,CodigoDestino,_),
    not(ruta(_,CodigoDestino,CodigoSalida,_)).

rutaRelativamenteDirecta(CodigoSalida,CodigoLlegada):-
    ruta(_,CodigoSalida,CodigoLlegada,_).

rutaRelativamenteDirecta(CodigoSalida,CodigoLlegada):-
    ruta(Aerolinea,CodigoSalida,CodigoEscala,_),
    ruta(Aerolinea,CodigoEscala,CodigoLlegada,_),
    CodigoSalida \= CodigoLlegada.

costoViaje(Origen, Destino, Costo):-
    aeropuerto(CodigoSalida,Origen,_),
    aeropuerto(CodigoLlegada,Destino,_),
    ruta(_,CodigoSalida,CodigoLlegada,Costo).

costoViaje(Origen, Destino,Costo):-
    aeropuerto(CodigoSalida,Origen,_),
    aeropuerto(CodigoLlegada,Destino,_),
    ruta(Aerolinea,CodigoSalida,CodigoEscala,C1),
    ruta(Aerolinea,CodigoEscala,CodigoLlegada,C2),
    Costo is C1 + C2.


puedeViajar(Persona, Destino):-
    persona(Persona,Dinero,_,CiudadSalida),
    costoViaje(CiudadSalida,Destino,Costo),
    Dinero >= Costo.

puedeViajar(Persona, Destino):-
    persona(Persona,_,Millas,CiudadSalida),
    ciudad(CiudadSalida,Pais,_),
    ciudad(Destino,Pais,_),
    Millas >= 500.

puedeViajar(Persona, Destino):-
    persona(Persona,_,Millas,CiudadSalida),    
    ciudad(CiudadSalida,Pais,_),
    ciudad(Destino,Pais2,_),
    Pais \= Pais2,
    costoViaje(CiudadSalida,Destino,Costo),
    Millas >= Costo * 20 // 100.

personaApta(Persona):-
    persona(Persona, Dinero, Millas, _),
    Dinero > 5000,
    Millas > 100.

destinoApto(Destino):-
    ciudad(Destino,_,paradisiaca).

destinoApto(Destino):-
    ciudad(Destino,_,importanciaCultural(LugaresEmblematicos)),
    length(LugaresEmblematicos, Cantidad),
    Cantidad >= 4.

destinoApto(Destino):-
    ciudad(Destino,qatar,negocios).

quiereViajar(Persona, Destino):-
    destinoApto(Destino),
    personaApta(Persona).

debeAhorrarUnPocoMas(Persona,Destino):-
    persona(Persona, Dinero,_,CiudadSalida),
    quiereViajar(Persona,Destino),
    costoViaje(CiudadSalida, Destino, Costo),
    Dinero < Costo,
    not((quiereViajar(Persona,OtroDestino), costoViaje(CiudadSalida,OtroDestino, Costo2), Costo2 < Costo)).
    

    