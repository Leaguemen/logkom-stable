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


bonusSoldiers(northAmerica, 3).
bonusSoldiers(europe, 3).
bonusSoldiers(asia, 5).
bonusSoldiers(southAmerica, 2).
bonusSoldiers(africa, 2).
bonusSoldiers(australia, 1).


/*RULES*/ 
/*semuanya masih coret coret dan belum bisa diintegrasi*/ 

/*Get ID of Player*/
playerID(Player, ID) :- getIdx(nameOfPlayers, Player, ID). 

/*Mengecek apakah pemain Player menguasai benua Continent*/
isDominatingContinent(Player, Continent):-
    forall(inContinent(Area, Continent), getAreaOccupier(Area, Player)).

/*Menghitung jumlah wilayah yang dikuasai player*/
countOccupiedAreas([],0).
countOccupiedAreas([H|T],X):-
    H =\= 0,
    countOccupiedAreas(T,X1),
    X is X1+1.
countOccupiedAreas([H|T],X):-
    H =:= 0,
    countOccupiedAreas(T,X).

numOfOccupiedAreas(Player, X) :-
    playerID(Player, ID),
    (
        (ID =:= 1, countOccupiedAreas(ownershipP1, X));
        (ID =:= 2, countOccupiedAreas(ownershipP2, X));
        (ID =:= 3, countOccupiedAreas(ownershipP3, X));
        (ID =:= 4, countOccupiedAreas(ownershipP4, X))
    ).

/*Menghitung jumlah tentara aktif yang dikuasai player*/
countActiveSoldiers([],0).
countActiveSoldiers([H|T],X):-
    H =\= 0,
    countOccupiedAreas(T,X1),
    X is X1+H.
countActiveSoldiers([H|T],X):-
    H =:= 0,
    countOccupiedAreas(T,X).

numOfActiveSoldiers(Player, X) :-
    playerID(Player, ID),
    (
        (ID =:= 1, countActiveSoldiers(ownershipP1, X));
        (ID =:= 2, countActiveSoldiers(ownershipP2, X));
        (ID =:= 3, countActiveSoldiers(ownershipP3, X));
        (ID =:= 4, countActiveSoldiers(ownershipP4, X))
    ).

/Melihat jumlah wilayah yang dikuasai player di benua continent*/
numOfOccupiedAreasPerContinent(Player, Continent, X):-
    playerID(Player, ID),
    continentRange(Continent, Start, End),
    (
        (ID =:= 1, split(ownershipP1, Start, End, SplitList));
        (ID =:= 2, split(ownershipP2, Start, End, SplitList));
        (ID =:= 3, split(ownershipP3, Start, End, SplitList));
        (ID =:= 4, split(ownershipP4, Start, End, SplitList))
    ),
    countOccupiedAreas(SplitList, X).

/*Menghitung jumlah tentara tambahan selanjutnya berdasarkan wilayah*/
numOfAddedSoldiers(Player, X) :-
    numOfOccupiedAreas(Player, X1), X is X1/2.

/*Menghitung jumlah bonus tentara jika punya benua*/
numOfBonusSoldiers(Player, X) :-
    findall(Bonus, (isDominatingContinent(Player, Continent), bonusSoldiers(Continent, Bonus)), Bonuses),
    sum_list(Bonuses, X).

/*Menghitung jumlah tentara tambahan selanjutnya */
numOfTotalAddedSoldiers(Player, X) :-
    numOfAddedSoldiers(Player, X1), numOfBonusSoldiers(Player, X2), X is X1+X2.

/Menampilkan detail player*/
checkPlayerDetail(Player) :-
    playerID(Player, ID),
    (
        (ID =:= 1, numOfFreeSoldiersP1(FreeSoldiers));
        (ID =:= 2, numOfFreeSoldiersP2(FreeSoldiers));
        (ID =:= 3, numOfFreeSoldiersP3(FreeSoldiers));
        (ID =:= 4, numOfFreeSoldiersP4(FreeSoldiers))
    ),
    format("PLAYER P~w~n", [ID]),
    format("Nama                  : ~w~n", [Player]),
    findall(Continent, isDominatingContinent(Player, Continent), Continents),
    format("Benua                 : ~w~n", [Continents]),
    numOfOccupiedAreas(Player, areasOccupied),
    numOfActiveSoldiers(Player, activeSoldiers),
    format("Total Wilayah         : ~w~n", [areasOccupied]),
    format("Total Tentara Aktif   : ~w~n", [activeSoldiers]),
    format("Total Tentara Tambahan: ~w~n", [FreeSoldiers]).

/*Menampikan detail wilayah kekuasaaan player*/

displayContinentTerritories(Player, Continent) :-
    format("Benua ~w (", [Continent]),
    numOfOccupiedAreasPerContinent(Player, Continent, OccupiedAreas), continentRange(Continent, X, Y), Z is Y-X,
    format("~w/~w)~n", [OccupiedAreas, Z]),
    findall(Area, (inContinent(Area, Continent), getAreaOccupier(Area, Player)), Areas),
    displayAreaTerritories(Player, Areas).

displayAreaTerritories(_, []).
displayAreaTerritories(Player, [Area|Rest]):-
    areaCodename(Code, Name, Index),
    write('Code'), nl,
    format("Nama              : ~w~n", [Name]),
    soldiersInArea(Area, ActiveSoldiers),
    format("Jumlah tentara    : ~w~n", [ActiveSoldiers]),
    displayAreaTerritories(Player, Rest).

checkPlayerTerritories(Player) :-
    playerID(Player, ID),
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
    format("Bonus benua ~w                          : ~w~n", [Head, X]),
    displayContinentBonuses(Rest).

checkIncomingTroops(Player):-
    playerID(Player, ID),
    format("Nama                                    : ~w~n", [Player]),
    numOfOccupiedAreas(Player, TotalAreas),
    format("Total wilayah                           : ~w~n", [TotalAreas]),
    numOfAddedSoldiers(Player, AddedSoldiers),
    format("Jumlah tentara tambahan dari wilayah    : ~w~n", [AddedSoldiers]),
    findall(OccupiedContinent, (isDominatingContinent(Player, Continent)), OccupiedContinents),
    displayContinentBonuses(OccupiedContinents),
    numOfTotalAddedSoldiers(Player, TotalAddedSoldiers),
    format("Total tentara tambahan                  : ~w~n", [TotalAddedSoldiers]).

/*Pengecekan kondisi menang*/
isDominatingMaps(Player):- numOfOccupiedAreas(Player, 24).

/*Pengecekan kondisi player kalah*/
isDead(Player) :- numOfOccupiedAreas(Player, 0).
