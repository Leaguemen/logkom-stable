/* TESTING TESTING TESTING TESTING TESTING

:- dynamic(ownershipP1/1).
:- dynamic(ownershipP2/1).

nameOfPlayers([ayam,goreng]).
currentPlayer(ayam).

init :-
    asserta(ownershipP1([5,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])),
    asserta(ownershipP2([0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])),
    asserta(haveAttacked(0)),
    asserta(numberOfMovesExecuted(0)),
    ['utilities.pl'],
    ['f02_areas.pl'],
    ['f01_map.pl'],
    ownershipP1(List),
    write(List).

playerID(Player, ID) :- nameOfPlayers(List), getIdx(List, Player, ID).

*/

/*FACTS*/
:- dynamic(numberOfMovesExecuted/1).

/*RULES*/
/*Memvalidasi jumlah tentara yang ingin dipindahkan*/
isMoveValid(InitialArea, NumSoldiers):-
    areaCodename(InitialArea,AreaName,_), soldiersInArea(AreaName, X),
    X1 is X-NumSoldiers, X1 >= 1, NumSoldiers \== 0.

/*Memvalidasi apakah area milik player*/
isAreaValid(Area, Player):-
    areaCodename(Area,AreaName,_), getAreaOccupier(AreaName, Occupier), Player==Occupier.


/*Memindahkan Tentara ke Area Lain*/

/*Tentara tidak mencukupi*/
move(InitialArea, DestinationArea, NumSoldiers):-
    \+ areaCodename(InitialArea,_,_), write('Masukkan kode area yang valid!'), nl, !
    ;
    \+ areaCodename(DestinationArea,_,_), write('Masukkan kode area yang valid!'), nl, !.

move(InitialArea, DestinationArea, NumSoldiers):-
    currentPlayer(Player),
    \+isMoveValid(InitialArea, NumSoldiers), !,
    format('~w memindahkan ~w tentara dari ~w ke ~w.~n', [Player, NumSoldiers, InitialArea, DestinationArea]),
    write('Tentara tidak mencukupi.'), nl,
    write('Pemindahan dibatalkan.').

/*Area tidak dimiliki player*/
move(InitialArea, _DestinationArea, NumSoldiers):-
    currentPlayer(Player),
    isMoveValid(InitialArea, NumSoldiers),
    \+isAreaValid(InitialArea, Player), !,
    format('~w tidak memiliki wilayah ~w.~n', [Player, InitialArea]),
    write('Pemindahan dibatalkan.'), nl.

/*Area tidak dimiliki player*/
move(InitialArea, DestinationArea, NumSoldiers):-
    currentPlayer(Player),
    isMoveValid(InitialArea, NumSoldiers),
    isAreaValid(InitialArea, Player), \+isAreaValid(DestinationArea, Player), !,
    format('~w tidak memiliki wilayah ~w.~n', [Player, DestinationArea]),
    write('Pemindahan dibatalkan.'), nl.

move(InitialArea, DestinationArea, NumSoldiers):-
    numberOfMovesExecuted(NumOfMoves),
    (
        NumOfMoves < 3,
        currentPlayer(Player), playerID(Player, ID),
        isMoveValid(InitialArea, NumSoldiers),
        isAreaValid(InitialArea, Player), isAreaValid(DestinationArea, Player),
        areaCodename(InitialArea, _, InitialIndex), areaCodename(DestinationArea, _, DestinationIndex),
        (
            (ID =:= 1, ownershipP1(List), getElmt(List, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers,
            setEl(List, InitialIndex, X, NewOwnershipP1),
            getElmt(NewOwnershipP1, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
            setEl(NewOwnershipP1, DestinationIndex, Y, NewNewOwnershipP1), retract(ownershipP1(_)), asserta(ownershipP1(NewNewOwnershipP1))
            );
            (ID =:= 2, ownershipP2(List), getElmt(List, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers, 
            setEl(List, InitialIndex, X, NewOwnershipP2),
            getElmt(NewOwnershipP2, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
            setEl(ownershipP2, DestinationIndex, Y, NewNewOwnershipP2), retract(ownershipP2(_)), asserta(ownershipP2(NewNewOwnershipP2))
            );
            (ID =:= 3, ownershipP3(List), getElmt(List, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers, 
            setEl(List, InitialIndex, X, NewOwnershipP3),
            getElmt(NewOwnershipP3, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
            setEl(NewOwnershipP3, DestinationIndex, Y, NewNewOwnershipP3), retract(ownershipP3(_)), asserta(ownershipP3(NewNewOwnershipP3))
            );
            (ID =:= 4, ownershipP4(List), getElmt(List, InitialIndex, InitAreaSoldiers), X is InitAreaSoldiers-NumSoldiers, 
            setEl(List, InitialIndex, X, NewOwnershipP4),
            getElmt(NewOwnershipP4, DestinationIndex, DestAreaSoldiers), Y is DestAreaSoldiers+NumSoldiers,
            setEl(NewOwnershipP4, DestinationIndex, Y, NewNewOwnershipP4), retract(ownershipP4(_)), asserta(ownershipP4(NewNewOwnershipP4))
            )
        ),
        displayMoveSuccessMessage(InitialArea, DestinationArea, NumSoldiers, X, Y), 
        numberOfMovesExecuted(N), N1 is N + 1, retractall(numberOfMovesExecuted(_)), asserta(numberOfMovesExecuted(N1)),!
    ;
        write('Pemindahan tentara dapat dilakukan maksimum 3 kali per turn.'), nl
    ).
    
displayMoveSuccessMessage(InitialArea, DestinationArea, NumSoldiers, X, Y):-
    currentPlayer(Player),
    format('~w memindahkan ~w tentara dari ~w ke ~w.~n', [Player, NumSoldiers, InitialArea, DestinationArea]),
    format('Jumlah tentara di ~w: ~w~n', [InitialArea, X]),
    format('Jumlah tentara di ~w: ~w~n', [DestinationArea, Y]), !.



