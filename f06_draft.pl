/*FACTS*/


/*RULES*/

/*Menambahkan tentara sebanyak NumSoldiers di Area milik pemain*/

/*Mengecek tentara tambahan yang dimasukkan valid atau tidak*/
isDraftSoldierValid(NumSoldiers):-
    currentPlayer(Player), playerID(Player, ID),
    (
        (ID =:= 1, numOfFreeSoldiersP1(FreeSoldiers));
        (ID =:= 2, numOfFreeSoldiersP2(FreeSoldiers));
        (ID =:= 3, numOfFreeSoldiersP3(FreeSoldiers));
        (ID =:= 4, numOfFreeSoldiersP4(FreeSoldiers))
    ),
    NumSoldiers>=FreeSoldiers.

/*Tentara tambahan tidak mencukupi*/
draft(Area, NumSoldiers) :-
    currentPlayer(Player),
    \+isDraftSoldierValid(NumSoldiers), !,
    format("~w meletakkan ~w tentara tambahan di ~w.~n", [Player, NumSoldiers, Area]),
    write("Tentara tidak mencukupi. Draft dibatalkan"), nl.

/*Area tidak dimiliki pemain*/
draft(Area, NumSoldiers) :-
    currentPlayer(Player),
    \+isAreaValid(Area, Player), !,
    format("~w tidak memiliki wilayah ~w. Pemindahan dibatalkan.~n", [Player, Area]).

/*Draft bisa dilakukan*/
draft(Area, NumSoldiers) :-
    currentPlayer(Player), playerID(Player, ID),
    isDraftSoldierValid(NumSoldiers), isAreaValid(Area, Player), !,
    format("~w meletakkan ~w tentara tambahan di ~w.~n", [Player, NumSoldiers, Area]),
    areaCodename(_Code, Area, Index), soldiersInArea(Area, SoldiersInArea),
    (
        (ID =:= 1, numOfFreeSoldiersP1(FreeSoldiers), NewFreeSoldiers is FreeSoldiers-NumSoldiers, NewSoldiersInArea is SoldiersInArea+NumSoldiers, setEl(ownershipP1, Index, NewSoldiersInArea, NewOwnershipP1), retract(ownershipP1(_)), assert(ownershipP1(NewOwnershipP1)));
        (ID =:= 2, numOfFreeSoldiersP2(FreeSoldiers), NewFreeSoldiers is FreeSoldiers-NumSoldiers, NewSoldiersInArea is SoldiersInArea+NumSoldiers, setEl(ownershipP2, Index, NewSoldiersInArea, NewOwnershipP2), retract(ownershipP2(_)), assert(ownershipP2(NewOwnershipP2)));
        (ID =:= 3, numOfFreeSoldiersP3(FreeSoldiers), NewFreeSoldiers is FreeSoldiers-NumSoldiers, NewSoldiersInArea is SoldiersInArea+NumSoldiers, setEl(ownershipP3, Index, NewSoldiersInArea, NewOwnershipP3), retract(ownershipP3(_)), assert(ownershipP3(NewOwnershipP3)));
        (ID =:= 4, numOfFreeSoldiersP4(FreeSoldiers), NewFreeSoldiers is FreeSoldiers-NumSoldiers, NewSoldiersInArea is SoldiersInArea+NumSoldiers, setEl(ownershipP4, Index, NewSoldiersInArea, NewOwnershipP4), retract(ownershipP4(_)), assert(ownershipP4(NewOwnershipP4)))
    ),
    format("Tentara total di ~w: ~w~n", [Area, NewSoldiersInArea]),
    format("Jumlah Pasukan Tambahan Player ~w: ~w~n", [Player, NewFreeSoldiers]).



