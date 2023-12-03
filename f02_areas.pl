/*FACTS*/
/* juga merupakan urutan di ownership list */
areaCodename(na1, unitedstates, 1).
areaCodename(na2, canada, 2).
areaCodename(na3, greenland, 3).
areaCodename(na4, mexico, 4).
areaCodename(na5, carribean, 5).
areaCodename(eu1, france, 6).
areaCodename(eu2, england, 7).
areaCodename(eu3, germany, 8).
areaCodename(eu4, italy, 9).
areaCodename(eu5, belgium, 10).
areaCodename(a1, indonesia, 11).
areaCodename(a2, russia, 12).
areaCodename(a3, china, 13).
areaCodename(a4, india, 14).
areaCodename(a5, japan, 15).
areaCodename(a6, kazakhstan, 16).
areaCodename(a7, saudi, 17).
areaCodename(sa1, cuba, 18).
areaCodename(sa2, brazil, 19).
areaCodename(af1, egypt, 20).
areaCodename(af2, southafrica, 21).
areaCodename(af3, niger, 22).
areaCodename(au1, australia, 23).
areaCodename(au2, newzealand, 24).

continentRange(northAmerica, 1, 5).
continentRange(europe, 6, 10).
continentRange(asia, 11, 17).
continentRange(southAmerica, 18, 19).
continentRange(africa, 20, 22).
continentRange(australia, 23, 24).

continent(northamerica).
continent(europe).
continent(asia).
continent(southamerica).
continent(africa).
continent(australia).

/*RULES*/

/*RULES*/
getAreaName(AreaCode, AreaName):-areaCodename(AreaCode,AreaName,_).
getAreaOccupier(Area, Player) :-
    areaCodename(_AreaCode, Area, Index),
    ((ownershipP1(List), getElmt(List, Index, NumSoldiers), NumSoldiers \== 0, !, nameOfPlayers(L), getElmt(L, 1, Player));
    (ownershipP2(List), getElmt(List, Index, NumSoldiers), NumSoldiers \== 0, !, nameOfPlayers(L), getElmt(L, 2, Player))).
   /* (ownershipP3(List), getElmt(List, Index, NumSoldiers), NumSoldiers \== 0, !, nameOfPlayers(L), getElmt(L, 3, Player));
    (ownershipP4(List), getElmt(List, Index, NumSoldiers), NumSoldiers \== 0, !, nameOfPlayers(L), getElmt(L, 4, Player))). */ 

printListAreaName([]).
printListAreaName([H]) :- getAreaName(H, AreaName), write(AreaName), nl.
printListAreaName([H|T]) :-
    getAreaName(H, AreaName),
    write(AreaName), write(', '),
    printListAreaName(T).

printAdjacent(Codename):-
    findall(Adjacent, adjacentArea(Codename, Adjacent), AdjacentList),
    printListAreaName(AdjacentList).

checkLocationDetail(Area):-
    areaCodename(Codename, Area, _),
    getAreaOccupier(Area, Player),
    soldiersInArea(Area, NumSoldiers),
    format('Kode                  : ~w', [Codename]), nl,
    format('Nama                  : ~w', [Area]), nl,
    format('Pemilik               : ~w', [Player]), nl,
    format('Total Tentara         : ~w', [NumSoldiers]), nl,
    write('Tetangga              : '), printAdjacent(Codename).