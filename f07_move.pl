/*FACTS*/
:- dynamic(numberOfMovesExecuted/1).

/*RULES*/
/*Memvalidasi jumlah tentara yang ingin dipindahkan*/
isMoveValid(InitialArea, NumSoldiers):-
    soldiersInArea(InitialArea, X),
    X-NumSoldiers >= 1.

/*Memvalidasi apakah area milik player*/
isAreaValid(Area, Player):-
    getAreaOccupier(Area, Occupier), Player==Occupier.


/*Memindahkan Tentara ke Area Lain*/

/*Tentara tidak mencukupi*/
move(InitialArea, DestinationArea, NumSoldiers):-
    currentPlayer(Player),
    \+isMoveValid(InitialArea, NumSoldiers), !,
    format("~w memindahkan ~w tentara dari ~w ke ~w.~n", [Player, NumSoldiers, InitialArea, DestinationArea]),
    write("Tentara tidak mencukupi. Pemindahan dibatalkan"), nl.

/*Area tidak dimiliki player*/
move(InitialArea, DestinationArea, NumSoldiers):-
    currentPlayer(Player),
    isMoveValid(InitialArea, NumSoldiers),
    \+isAreaValid(InitialArea, Player), !,
    format("~w tidak memiliki wilayah ~w. Pemindahan dibatalkan.~n", [Player, InitialArea]).

/*Area tidak dimiliki player*/
move(InitialArea, DestinationArea, NumSoldiers):-
    currentPlayer(Player),
    isMoveValid(InitialArea, NumSoldiers),
    isAreaValid(InitialArea, Player), \+isAreaValid(DestinationArea, Player), !,
    format("~w tidak memiliki wilayah ~w. Pemindahan dibatalkan.~n", [Player, DestinationArea]).

move(InitialArea, DestinationArea, NumSoldiers):-
    currentPlayer(Player), playerID(Player, ID),
    isMoveValid(InitialArea, NumSoldiers),
    isAreaValid(InitialArea, Player), isAreaValid(DestinationArea, Player),
    areaCodename(_Code, InitialArea, InitialIndex), areaCodename(_Code2, DestinationArea, DestinationIndex), 
    (
        (ID =:= 1, getElmt(ownershipP1, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers, 
        setEl(ownershipP1, InitialIndex, X, NewOwnershipP1), retract(ownershipP1(_)), assert(ownershipP1(NewOwnershipP1)),
        getElmt(ownershipP1, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
        setEl(ownershipP1, DestinationIndex, Y, NewNewOwnershipP1), retract(ownershipP1(_)), assert(ownershipP1(NewNewOwnershipP1))
        );
        (ID =:= 2, getElmt(ownershipP2, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers, 
        setEl(ownershipP2, InitialIndex, X, NewOwnershipP2), retract(ownershipP2(_)), assert(ownershipP2(NewOwnershipP2)),
        getElmt(ownershipP2, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
        setEl(ownershipP2, DestinationIndex, Y, NewNewOwnershipP2), retract(ownershipP2(_)), assert(ownershipP2(NewNewOwnershipP1))
        );
        (ID =:= 3, getElmt(ownershipP3, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers, 
        setEl(ownershipP3, InitialIndex, X, NewOwnershipP3), retract(ownershipP3(_)), assert(ownershipP3(NewOwnershipP3)),
        getElmt(ownershipP3, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
        setEl(ownershipP3, DestinationIndex, Y, NewNewOwnershipP3), retract(ownershipP3(_)), assert(ownershipP3(NewNewOwnershipP3))
        );
        (ID =:= 4, getElmt(ownershipP4, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers, 
        setEl(ownershipP4, InitialIndex, X, NewOwnershipP4), retract(ownershipP4(_)), assert(ownershipP4(NewOwnershipP4)),
        getElmt(ownershipP4, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
        setEl(ownershipP4, DestinationIndex, Y, NewNewOwnershipP4), retract(ownershipP4(_)), assert(ownershipP4(NewNewOwnershipP4))
        )
    ),
    displayMoveSuccessMessage(InitialArea, DestinationArea, NumSoldiers, X, Y), !.

displayMoveSuccessMessage(InitialArea, DestinationArea, NumSoldiers, X, Y):-
    currentPlayer(Player),
    format("~w memindahkan ~w tentara dari ~w ke ~w.~n", [Player, NumSoldiers, InitialArea, DestinationArea]),
    format("Jumlah tentara di ~w: ~w~n", [InitialArea, X]),
    format("Jumlah tentara di ~w: ~w~n", [DestinationArea, Y]).



