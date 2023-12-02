['utilities.pl']

/*FACTS*/
additionalSoldiersContinent(northamerica, 3).
additionalSoldiersContinent(europe, 3).
additionalSoldiersContinent(asia, 5).
additionalSoldiersContinent(southamerica, 2).
additionalSoldiersContinent(africa, 2).
additionalSoldiersContinent(australia, 1).

/*RULES*/
addSoldiersIfAreaOccupied(NumSoldiersArea, Bool) :-
    NumSoldiersArea > 0,
    Bool is 1, !.

addSoldiersIfAreaOccupied(NumSoldiersArea, Bool) :-
    Bool is 0.

addSoldiersArea(Player, Extra) :-
    Player == 1,
    OwnershipP1(L),
    dynamic(TotalArea/1),
    asserta(TotalArea(0)),
    dynamic(Index/1),
    asserta(Index(1)),
    repeat,
        Index(I),
        selector(NumSoldiers, L, I),
        addSoldiersIfAreaOccupied(NumSoldiers, Bool),
        TotalArea(X),
        NewTot is X + Bool,
        retract(TotalArea(X)),
        asserta(TotalArea(NewTot)),
        I1 is I + 1,
        retract(Index(I))
        asserta(Index(I1)),
    I == 24,
    Extra is TotalArea mod 2.

addSoldiersArea(Player, Extra) :-
    Player == 2,
    OwnershipP2(L),
    dynamic(TotalArea/1),
    asserta(TotalArea(0)),
    dynamic(Index/1),
    asserta(Index(1)),
    repeat,
        Index(I),
        selector(NumSoldiers, L, I),
        addSoldiersIfAreaOccupied(NumSoldiers, Bool),
        TotalArea(X),
        NewTot is X + Bool,
        retract(TotalArea(X)),
        asserta(TotalArea(NewTot)),
        I1 is I + 1,
        retract(Index(I))
        asserta(Index(I1)),
    I == 24,
    Extra is TotalArea mod 2.

addSoldiersArea(Player, Extra) :-
    Player == 3,
    OwnershipP3(L),
    dynamic(TotalArea/1),
    asserta(TotalArea(0)),
    dynamic(Index/1),
    asserta(Index(1)),
    repeat,
        Index(I),
        selector(NumSoldiers, L, I),
        addSoldiersIfAreaOccupied(NumSoldiers, Bool),
        TotalArea(X),
        NewTot is X + Bool,
        retract(TotalArea(X)),
        asserta(TotalArea(NewTot)),
        I1 is I + 1,
        retract(Index(I))
        asserta(Index(I1)),
    I == 24,
    Extra is TotalArea mod 2.

addSoldiersArea(Player, Extra) :-
    Player == 4,
    OwnershipP4(L),
    dynamic(TotalArea/1),
    asserta(TotalArea(0)),
    dynamic(Index/1),
    asserta(Index(1)),
    repeat,
        Index(I),
        selector(NumSoldiers, L, I),
        addSoldiersIfAreaOccupied(NumSoldiers, Bool),
        TotalArea(X),
        NewTot is X + Bool,
        retract(TotalArea(X)),
        asserta(TotalArea(NewTot)),
        I1 is I + 1,
        retract(Index(I))
        asserta(Index(I1)),
    I == 24,
    Extra is TotalArea mod 2.

addSoldiersIfContinentOccupied(Continent, Player, AdditionalSoldiers) :-
    isDominatingContinent(Player, Continent),
    additionalSoldiersContinent(Continent,NumSoldiers),
    AdditionalSoldiers is NumSoldiers, !.

addSoldiersIfContinentOccupied(Continent, Player, AdditionalSoldiers) :-
    AdditionalSoldiers is 0.

addSoldiersContinent(Player, Extra) :-
    addSoldiersIfContinentOccupied(Player, northamerica, Extra1),
    addSoldiersIfContinentOccupied(Player, europe, Extra2),
    addSoldiersIfContinentOccupied(Player, asia, Extra3),
    addSoldiersIfContinentOccupied(Player, southamerica, Extra4),
    addSoldiersIfContinentOccupied(Player, africa, Extra5),
    addSoldiersIfContinentOccupied(Player, ausralia, Extra6),
    Extra is Extra1 + Extra2 + Extra3 + Extra4 + Extra5 + Extra6.

endTurn() :-
    currentPlayer(Player),
    write('Player '), write(Player), write(' mengakhiri giliran.'), nl, nl,
    nextPlayer(),
    currentPlayer(Player1),
    write('Sekarang giliran Player '), write(Player1), write('.'), nl,
    addSoldiersArea(Player1, Extra1),
    addSoldiersContinent(Player1, Extra2),
    Extra is Extra1 + Extra2,
    write('Player '), write(Player1), write(' mendapatkan '), write(Extra), write(' tentara tambahan.'), nl.