endTurn :-
    currentPlayer(Player),
    format('Player ~w mengakhiri giliran.~n~n', [Player]),
    nextPlayer,
    currentPlayer(Player1),
    format('Sekarang giliran Player ~w!', [Player1]),
    numOfTotalAddedSoldiers(Player1, Extra),
    playerID(Player1,ID1),
    ((ID1 =:= 1, numOfFreeSoldiersP1(X), NewX is X + Extra, nl,retract(numOfFreeSoldiersP1(_)), asserta(numOfFreeSoldiersP1(NewX)));
    ID1 =:= 2, numOfFreeSoldiersP2(X), NewX is X + Extra, nl,retract(numOfFreeSoldiersP2(_)), asserta(numOfFreeSoldiersP2(NewX));
    ID1 =:= 3, numOfFreeSoldiersP3(X), NewX is X + Extra, nl,retract(numOfFreeSoldiersP3(_)), asserta(numOfFreeSoldiersP3(NewX));
    ID1 =:= 4, numOfFreeSoldiersP4(X), NewX is X + Extra, nl, retract(numOfFreeSoldiersP4(_)), asserta(numOfFreeSoldiersP4(NewX))),
    format('Player ~w mendapatkan ~d tentara tambahan.~n', [Player1, Extra]), !.