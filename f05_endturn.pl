endTurn :-
    currentPlayer(Player),
    format('Player ~w mengakhiri giliran.~n~n', [Player]),
    nextPlayer,
    currentPlayer(Player1),
    format('Sekarang giliran Player ~w!', [Player1]), !,
    (
        supplyChainIssue(true),
        format('Player ~w terdampak SUPPLY CHAIN ISSUE!~n', [Player1]),
        format('Player ~w tidak mendapatkan tentara tambahan.', [Player1]),
        retractall(supplyChainIssue(_)), asserta(supplyChainIssue(false)), !
    ;
        numOfTotalAddedSoldiers(Player1, Extra),
        playerID(Player1,ID1),
        (
            auxiliaryTroops(true),
            format('~nPlayer ~w mendapatkan AUXILIARY TROOPS!~n', [Player1]),
            Extra1 is Extra * 2, retractall(auxiliaryTroops(_)), asserta(supplyChainIssue(false)), !
        ;
            Extra1 is Extra, !
        ),
        ((ID1 =:= 1, numOfFreeSoldiersP1(X), NewX is X + Extra1, nl,retract(numOfFreeSoldiersP1(_)), asserta(numOfFreeSoldiersP1(NewX)));
        ID1 =:= 2, numOfFreeSoldiersP2(X), NewX is X + Extra1, nl,retract(numOfFreeSoldiersP2(_)), asserta(numOfFreeSoldiersP2(NewX));
        ID1 =:= 3, numOfFreeSoldiersP3(X), NewX is X + Extra1, nl,retract(numOfFreeSoldiersP3(_)), asserta(numOfFreeSoldiersP3(NewX));
        ID1 =:= 4, numOfFreeSoldiersP4(X), NewX is X + Extra1, nl, retract(numOfFreeSoldiersP4(_)), asserta(numOfFreeSoldiersP4(NewX))),

        format('Player ~w mendapatkan ~d tentara tambahan.~n', [Player1, Extra1]),
        retractall(haveAttacked(_)), asserta(haveAttacked(0)),
        retractall(numberOfMovesExecuted(_)), asserta(numberOfMovesExecuted(0)), !
    ).