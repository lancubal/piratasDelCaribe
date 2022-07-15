puerto(Nombre,Pais).

puerto(puertoBahamas,bahamas).
puerto(puertoPanama,panama).
puerto(puertoIslasCayman,islasCayman).
puerto(puertoJamaica,jamaica).
puerto(cartagenaDeIndias,colombia).
puerto(puertoBelice,belice).
puerto(puertoSanVicente,sanVicente).
puerto(puertoSurinam,surinam).
puerto(puertoGranadinas,granadinas).

rutaMaritima(UnPuerto,OtroPuerto,Distancia).

rutaMaritima(puertoBahamas,puertoPanama,50).
rutaMaritima(puertoPanama,puertoJamaica,30).
rutaMaritima(puertoJamaica,puertoIslasCayman,45).
rutaMaritima(puertoBelice,cartagenaDeIndias,60).
rutaMaritima(puertoSanVicente,cartagenaDeIndias,55).
rutaMaritima(cartagenaDeIndias,puertoSurinam,25).
rutaMaritima(cartagenaDeIndias,puertoGranadinas,90).
rutaMaritima(puertoBelice,puertoGranadinas,10).

viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion):-
    rutaMaritima(PuertoOrigen,PuertoDestino,_).

viaje(puertoPanama,puertoJamaica,1000,galeon1).
viaje(puertoSanVicente,cartagenaDeIndias,200,galeon1).
viaje(cartagenaDeIndias,puertoSurinam,600,galeon2).
viaje(puertoSanVicente,cartagenaDeIndias,1300,galeon2).
viaje(puertoJamaica,puertoIslasCayman,700,galeon3).
viaje(cartagenaDeIndias,puertoGranadinas,200,galeon3).
viaje(puertoPanama,puertoJamaica,100,carabela1).
viaje(puertoBelice,puertoGranadinas,200,carabela1).
viaje(cartagenaDeIndias,puertoGranadinas,400,carabela2).
viaje(puertoSanVicente,cartagenaDeIndias,100,carabela2).
viaje(puertoPanama,puertoJamaica,1000,carabela3).
viaje(cartagenaDeIndias,puertoSurinam,400,carabela3).
viaje(puertoJamaica,puertoIslasCayman,600,galera1).
viaje(cartagenaDeIndias,puertoSurinam,900,galera1).
viaje(cartagenaDeIndias,puertoGranadinas,500,galera2).
viaje(puertoJamaica,puertoIslasCayman,900,galera2).
viaje(puertoBelice,puertoGranadinas,300,galera3).
viaje(puertoBelice,puertoGranadinas,1200,galera3).

galeon(Embarcacion,CantidadDeCaniones).

galeon(galeon1,10).
galeon(galeon2,60).
galeon(galeon3,30).

carabela(Embarcacion,CapacidadBodega,CantidadSoldados).

carabela(carabela1,20,45).
carabela(carabela2,60,15).
carabela(carabela3,10,25).

galera(Embarcacion,PaisDeBandera).

galera(galera1,espania).
galera(galera2,inglaterra).
galera(galera3,portugal).

capitan(Nombre,Barco,CantidadPiratas).

capitan(jackSparrow,perlaNegra,80).
capitan(davidJones,holandesErrante,200).
capitan(barbosa,cobra,50).
capitan(henryTurner,monarca,200).

barco(Nombre,ImpetuCombativo).

esEspaniol(Barco).

esEspaniol(galera1).

poderio(Capitan,Poderio):-
 capitan(Capitan,Barco,CantidadPiratas),
 barco(Barco,ImpetuCombativo),
 Poderio is (CantidadPiratas+2)*ImpetuCombativo.

resistencia(viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion),Resistencia):-
 galeon(Embarcacion,CantidadDeCaniones),
 rutaMaritima(PuertoOrigen,PuertoDestino,Distancia),
 Resistencia is (CantidadDeCaniones*100)/Distancia.

resistencia(viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion),Resistencia):-
 carabela(Embarcacion,_,CantidadSoldados),
 Resistencia is (ValorMercaderia/10)+CantidadSoldados. 

resistencia(viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion),Resistencia):-
 esEspaniol(Embarcacion),
 rutaMaritima(PuertoOrigen,PuertoDestino,Distancia),
 Resistencia is 100 / Distancia.

resistencia(viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion),Resistencia):-
 not(esEspaniol(Embarcacion)),
 Resistencia is ValorMercaderia*10.

puedeAbordar(Capitan,viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion)):-
 poderio(Capitan) > resistencia(viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion)).

llegaCon(Embarcacion,Puerto,ValorMercaderia):-
 viaje(_,Puerto,ValorMercaderia,Embarcacion).
parteCon(Embarcacion,Puerto,ValorMercaderia):-
 viaje(Puerto,_,ValorMercaderia,Embarcacion).

botin(Capitan,Puerto,Botin):-
 findall(ValorMercaderia,(llegaCon(Embarcacion,Puerto,ValorMercaderia),(puedeAbordar(Capitan,viaje(_,Puerto,ValorMercaderia,Embarcacion)))),BotinesEntrantes),
 findall(ValorMercaderia,(parteCon(Embarcacion,Puerto,ValorMercaderia),(puedeAbordar(Capitan,viaje(Puerto,_,ValorMercaderia,Embarcacion)))),BotinesSalientes),
 append(BotinesEntrantes,BotinesSalientes,Botines),
 sum_list(Botines,Botin).

decadente(Capitan):-
 capitan(Capitan,Barco,CantidadPiratas),
 CantidadPiratas<10,
 forall(viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion),not(puedeAbordar(Capitan,viaje(PuertoOrigen,PuertoDestino,ValorMercaderia,Embarcacion)))).

puedeAbordarATodos(Capitan,Puerto):-
 capitan(Capitan,Barco,CantidadDePiratas),
 forall(llegaCon(Embarcacion,Puerto,_),puedeAbordar(Capitan,viaje(_,Puerto,_,Embarcacion))),
 forall(parteCon(Embarcacion,Puerto,_),puedeAbordar(Capitan,viaje(Puerto,_,_,Embarcacion))).

terrorDelPuerto(Capitan):-
 puerto(Puerto,_),
 puedeAbordarATodos(Capitan,Puerto),
 forall(capitan(OtroCapitan,_,_),not(puedeAbordarATodos(OtroCapitan,Puerto))).

odd(X) :- 1 is mod(X, 2).

excentrico(Capitan):-
 capitan(Nombre,Barco,CantidadDePiratas),
 odd(CantidadDePiratas),
 barco(Barco,ImpetuCombativo),
 odd(ImpetuCombativo),
 findall(Viaje,puedeAbordar(Capitan,Viaje),ViajesAbordables),
 length(ViajesAbordables, CantidadDeViajesAbordables),
 odd(CantidadDeViajesAbordables).

existeRutaTransitable(Capitan,PuertoOrigen,PuertoDestino):-
    rutaMaritima(PuertoOrigen,PuertoDestino,Distancia),
    poderio(Capitan,Poderio),
    Poderio > Distancia.

existeRutaTransitable(Capitan,PuertoOrigen,PuertoDestino):-
    rutaMaritima(Intermedio,PuertoDestino,_),
    existeRutaTransitable(Capitan,PuertoOrigen,Intermedio).
