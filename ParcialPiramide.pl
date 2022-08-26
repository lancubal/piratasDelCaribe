
/* Punto 1 */
necesidad(respiracion, fisiologico).
necesidad(alimentacion, fisiologico).
necesidad(descanso, fisiologico).
necesidad(reproduccion, fisiologico).

necesidad(integridadFisica,seguridad).
necesidad(empleo,seguridad).
necesidad(salud,seguridad).
necesidad(emparchar,seguridad).
necesidad(limpiar,seguridad).

necesidad(afecto,social).
necesidad(intimidad,social).
necesidad(amistad,social).
necesidad(libertad,social).

necesidad(confianza, reconocimiento).
necesidad(respeto, reconocimiento).
necesidad(exito, reconocimiento).
necesidad(tenerUnLambo,autorrealizacion).

nivelSuperior(dios, autorrealizacion).
nivelSuperior(autorrealizacion, reconocimiento).
nivelSuperior(reconocimiento, social).
nivelSuperior(social,seguridad).
nivelSuperior(seguridad,fisiologico).

/* Punto 2 */
superior(Sup,Inf):-
    nivelSuperior(Sup,Inf).
superior(Sup,Inf):-
    nivelSuperior(Sup,Otro),
    superior(Otro,Inf).

listaDeNivelesOrd(ListaNivelesOrd):-
    nivelSuperior(NivelSup,_),
    not(nivelSuperior(_,NivelSup)),
    findall(Nivel, superior(NivelSup,Nivel), ListaNivelesOrdA),
    append([NivelSup],ListaNivelesOrdA,ListaNivelesOrd).

separacionDeNecesidades(Necesidad1,Necesidad2,Diferencia):-
    necesidad(Necesidad1,Nivel1),
    necesidad(Necesidad2,Nivel2),
    listaDeNivelesOrd(ListaNivelesOrd),
    nth1(Pos1,ListaNivelesOrd,Nivel1),
    nth1(Pos2,ListaNivelesOrd,Nivel2),
    Diferencia is abs(Pos1-Pos2).

/* Punto 3 */
necesita(carla,alimentarse).
necesita(carla,descanso).
necesita(carla,empleo).
necesita(juan,afecto).
necesita(juan, exito).
necesita(roberto, amistad).
necesita(manuel, libertad).
necesita(charly, emparchar).
necesita(charly, limpiar).

/* Punto 4 */
necesidadDeMayorJerarquia(Persona,Necesidad):-
    necesita(Persona, Necesidad),
    necesidad(Necesidad,Nivel),
    not((necesita(Persona, OtraNecesidad),necesidad(OtraNecesidad,OtroNivel), superior(OtroNivel,Nivel))).

/* Punto 5 */
nivelSatisfecho(Persona,Nivel):-
    necesita(Persona,_),
    necesidad(_,Nivel),
    not((necesita(Persona,Necesidad), necesidad(Necesidad,Nivel))).

/* Punto 6 */
% a
teoriaMaslow(Persona):-
    necesita(Persona,Algo),
    necesidad(Algo, Nivel),
    not((necesita(Persona,OtraCosa),necesidad(OtraCosa, OtroNivel), OtroNivel \= Nivel)).

%b 
seCumpleLaTeoriaParaTodos :- forall(necesita(Persona,_),teoriaMaslow(Persona)).

%c
seCumpleLaTeoriaParaLaMayoria :- 
    findall(Persona, distinct(Persona, necesita(Persona,_)), Personas),
    findall(PersonaCumple, distinct(PersonaCumple, teoriaMaslow(PersonaCumple)), PersonasQueCumplen),
    length(Personas, CantidadPersonas),
    length(PersonasQueCumplen, CantidadQueCumplen),
    CantidadQueCumplen > CantidadPersonas // 2.