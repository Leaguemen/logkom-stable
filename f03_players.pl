/*FACTS*/
:-dynamic(ownershipP1/1).
:-dynamic(ownershipP2/1).
:-dynamic(ownershipP3/1).
:-dynamic(ownershipP4/1).
:-dynamic(numOfPlayers/1).
:-dynamic(nameOfPlayers/1).
:-dynamic(numOfFreeSoldiersP1/1).
:-dynamic(numOfFreeSoldiersP2/1).
:-dynamic(numOfFreeSoldiersP3/1).
:-dynamic(numOfFreeSoldiersP4/1).
:-dynamic(currentPlayer/1).

bonusSoldiers(northamerica, 3).
bonusSoldiers(europe, 3).
bonusSoldiers(asia, 5).
bonusSoldiers(southamerica, 2).
bonusSoldiers(africa, 2).
bonusSoldiers(australia, 1).

/*RULES*/ 
/*Menghitung jumlah tentara tambahan selanjutnya berdasarkan wilayah*/
numOfAddedSoldiers(Player, X) :-
    numOfOccupiedAreas(Player, X1), X is X1 div 2.

/*Menghitung jumlah bonus tentara jika punya benua*/
numOfBonusSoldiers(Player, X) :-
    findall(Bonus, (bonusSoldiers(Continent, Bonus), isDominatingContinent(Player, Continent)), Bonuses),    
    sum_list(Bonuses, X).

/*Menghitung jumlah tentara tambahan selanjutnya */
numOfTotalAddedSoldiers(Player, X) :-
    numOfAddedSoldiers(Player, X1), numOfBonusSoldiers(Player, X2), X is X1+X2.

/*Get ID of Player*/
playerID(Player, ID) :- nameOfPlayers(List), getIdx(List, Player, ID).

/*Mengecek apakah pemain ID menguasai benua Continent*/
isDominatingContinent(Player, Continent) :-
    forall(isInContinent(Area, Continent), getAreaOccupier(Area, Player)).

/*Menghitung jumlah wilayah yang dikuasai player*/
countOccupiedAreas([],0).
countOccupiedAreas([H|T],X):-
    H =\= 0, countOccupiedAreas(T,X1), X is X1 + 1.
countOccupiedAreas([H|T],X):-
    H =:= 0, countOccupiedAreas(T,X1), X is X1.

numOfOccupiedAreas(Player, X) :-
    playerID(Player, ID),
    (
        (ID =:= 1, ownershipP1(L), countOccupiedAreas(L, X));
        (ID =:= 2, ownershipP2(L), countOccupiedAreas(L, X));
        (ID =:= 3, ownershipP3(L), countOccupiedAreas(L, X));
        (ID =:= 4, ownershipP4(L), countOccupiedAreas(L, X))
    ).

/*Menghitung jumlah tentara aktif yang dikuasai player*/
countActiveSoldiers([],0).
countActiveSoldiers([H|T],X):-
    countActiveSoldiers(T,X1),
    X is X1+H.

numOfActiveSoldiers(Player, X) :-
    playerID(Player, ID),
    (
        (ID =:= 1, ownershipP1(L), countActiveSoldiers(L, X));
        (ID =:= 2, ownershipP2(L), countActiveSoldiers(L, X));
        (ID =:= 3, ownershipP3(L), countActiveSoldiers(L, X));
        (ID =:= 4, ownershipP4(L), countActiveSoldiers(L, X))
    ).

/* Melihat jumlah wilayah yang dikuasai player di benua continent*/
numOfOccupiedAreasPerContinent(Player, Continent, X):-
    playerID(Player, ID),
    continentRange(Continent, Start, End),
    (
        (ID =:= 1, ownershipP1(List), slice(List, Start, End+1, SplitList));
        (ID =:= 2, ownershipP2(List), slice(List, Start, End+1, SplitList));
        (ID =:= 3, ownershipP3(List), slice(List, Start, End+1, SplitList));
        (ID =:= 4, ownershipP4(List), slice(List, Start, End+1, SplitList))
    ),
    countOccupiedAreas(SplitList, X).


/* Menampilkan detail player*/
checkPlayerDetail(Player) :-
    playerID(Player, ID),
    (
        (ID =:= 1, numOfFreeSoldiersP1(FreeSoldiers));
        (ID =:= 2, numOfFreeSoldiersP2(FreeSoldiers))
    ),
    format("PLAYER P~w~n", [ID]),
    format("Nama                  : ~w~n", [Player]),
    findall(Continent, (continent(Continent), isDominatingContinent(Player, Continent)), Continents),
    write('Benua                 : '), displayList(Continents), nl,
    numOfOccupiedAreas(Player, AreasOccupied),
    numOfActiveSoldiers(Player, ActiveSoldiers),
    format("Total Wilayah         : ~w~n", [AreasOccupied]),
    format("Total Tentara Aktif   : ~w~n", [ActiveSoldiers]),
    format("Total Tentara Tambahan: ~w~n", [FreeSoldiers]), !.

/*Menampikan detail wilayah kekuasaaan player*/

displayContinentTerritories(Player, Continent) :-
    format("Benua ~w (", [Continent]),
    numOfOccupiedAreasPerContinent(Player, Continent, OccupiedAreas), continentRange(Continent, X, Y), Z is Y-X+1,
    format("~w/~w)~n", [OccupiedAreas, Z]),
    findall(Area, (isInContinent(Area, Continent), getAreaOccupier(Area, Player)), Areas),
    displayAreaTerritories(Areas), !.
  
displayAreaTerritories([]):- !.
displayAreaTerritories([Area|Rest]):-
    areaCodename(Code, Area, _),
    format('~w~n', [Code]),
    format("Nama              : ~w~n", [Area]),
    soldiersInArea(Area, ActiveSoldiers),
    format("Jumlah tentara    : ~w~n~n", [ActiveSoldiers]),
    displayAreaTerritories(Rest).

checkPlayerTerritories(Player) :-
    playerID(Player, _ID),
    format("Nama              : ~w~n", [Player]), nl,
    displayContinentTerritories(Player, northamerica), nl,
    displayContinentTerritories(Player, europe), nl,
    displayContinentTerritories(Player, asia), nl,
    displayContinentTerritories(Player, southamerica), nl,
    displayContinentTerritories(Player, africa), nl,
    displayContinentTerritories(Player, australia), nl.

/*Menampikan detail tentara player yang akan datang*/
displayContinentBonuses([]).
displayContinentBonuses([Head|Rest]):-
    bonusSoldiers(Head, X),
    format("Bonus                                   : (~w - ~d)~n", [Head, X]),
    displayContinentBonuses(Rest).

checkIncomingTroops(Player):-
    playerID(Player, _ID),
    format("Nama                                    : ~w~n", [Player]),
    numOfOccupiedAreas(Player, TotalAreas),
    format("Total wilayah                           : ~w~n", [TotalAreas]),
    numOfAddedSoldiers(Player, AddedSoldiers),
    format("Jumlah tentara tambahan dari wilayah    : ~w~n", [AddedSoldiers]),
    findall(Continent, (continent(Continent), isDominatingContinent(Player, Continent)), OccupiedContinents),
    displayContinentBonuses(OccupiedContinents),
    numOfTotalAddedSoldiers(Player, TotalAddedSoldiers),
    format("Total tentara tambahan                  : ~w~n", [TotalAddedSoldiers]), !.

/*Pengecekan kondisi menang*/
isDominatingMaps(Player):- numOfOccupiedAreas(Player, 24).

/*Pengecekan kondisi player kalah*/
isDead(Player) :- numOfOccupiedAreas(Player, 0).