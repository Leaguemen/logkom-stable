/* TESTING TESTING TESTING TESTING TESTING

:- dynamic(ownershipP1/1).
:- dynamic(ownershipP2/1).

nameOfPlayers([ayam,goreng]).
currentPlayer(ayam).

init :-
    asserta(ownershipP1([5,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])),
    asserta(ownershipP2([0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])),
    asserta(haveAttacked(0)),
    ['utilities.pl'],
    ['f02_areas.pl'],
    ['f01_map.pl'],
    ['f07_move.pl'],
    ownershipP1(List),
    write(List).

playerID(Player, ID) :- nameOfPlayers(List), getIdx(List, Player, ID).

*/

:- dynamic(haveAttacked/1).

/*RULES*/

/*Memilih area untuk menyerang*/
isAttackValid(InitialArea, NumSoldiers):-
    soldiersInArea(InitialArea, X),
    X1 is X-NumSoldiers, write(X1),X1 >= 1, NumSoldiers \== 0.

chooseAreaAttacker(AreaAttacker) :-
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(AreaAttacker), nl, !.

isAreaValidToAttack(AreaCode,Player) :-
    getAreaName(AreaCode,AreaName), getAreaOccupier(AreaName, Player1), Player == Player1, !.

/*Menampilkan area yang mungkin diserang*/
getAttackableAreas(AreaAttackerCode, Player, AttackableAreasCode) :-
    findall(AdjacentAreaCode, ((adjacentArea(AreaAttackerCode, AdjacentAreaCode), getAreaName(AdjacentAreaCode,AdjacentArea), getAreaOccupier(AdjacentArea, Player1)), Player1 \== Player), AttackableAreasCode), write(AttackableAreasCode).

displayAttackableAreas([], _).
displayAttackableAreas([Area | Rest], Index) :-
    format('~w. ~w~n', [Index, Area]),
    NextIndex is Index + 1,
    displayAttackableAreas(Rest, NextIndex).

getAreaDefender(AttackableAreas, NumAttackableAreas, NumAreaDefender) :-
    write('Pilih area: '), read(NumAreaDefender),
    (
        (NumAreaDefender < 1 ; NumAreaDefender > NumAttackableAreas) ->
            write('Input tidak valid. Silahkan input kembali.'), nl,
            getAreaDefender(AttackableAreas, NumAttackableAreas, AreaDefender)
        ;
            true
    ).


/*Memilih area untuk diserang*/
chooseAreaDefender(AreaAttacker, AreaDefender) :- %aneh banget kmrn bisa njir
    write('Pilihlah daerah yang ingin Anda serang: '),
    getAreaName(AreaCode, AreaAttacker),
    currentPlayer(Player),
    getAttackableAreas(AreaCode, Player, AttackableAreasCode),%masi belum muncul attackablearea
    length(AttackableAreasCode, NumAttackableAreas),
    write(NumAttackableAreas),nl,
    displayAttackableAreas(AttackableAreasCode, 1), nl,
    repeat,
    write('Pilih area: '), read(NumAreaDefender),
    ((NumAreaDefender<1 ; NumAreaDefender>NumAttackableAreas) ->
        write('Input tidak valid. Silahkan input kembali.'), nl, 
        fail
        ;
        getElmt(AttackableAreasCode, NumAreaDefender, AreaDefenderCode),!
    ),
    getElmt(AttackableAreas, NumAreaDefender, AreaDefenderCode), getAreaName(AreaDefenderCode, AreaDefender).

/*Menampilkan pengocokan dadu sebanyak Num*/
displayRollingDices(0, _, Total, Total):-
    !, format("Total: ~w.~n", [Total]).

displayRollingDices(Num, Index, TempTotal, Total):-
    shakeOneDice(DiceResult),
    format("Dadu ~w: ~w.~n", [Index, DiceResult]),
    Index1 is Index+1, Num1 is Num-1,
    TempTotal1 is TempTotal+DiceResult,
    displayRollingDices(Num1, Index1, TempTotal1, Total).

/*Menjadikan area yang kalah diserang menjadi area milik penyerang*/
acquireArea(AreaAttacker, AreaDefender, NumSoldiersMove) :-
    getAreaOccupier(AreaDefender, DefenderPlayer), playerID(DefenderPlayer, DefenderID),
    /*tentara milik musuh hangus*/
    areaCodename(_, AreaDefender, IndexAreaDefender),
    (
        (DefenderID =:= 1, ownershipP1(List), setEl(List, IndexAreaDefender, 0, NewOwnershipP1), retract(ownershipP1(_)), asserta(ownershipP1(NewOwnershipP1)));
        (DefenderID =:= 2, ownershipP2(List), setEl(List, IndexAreaDefender, 0, NewOwnershipP2), retract(ownershipP2(_)), asserta(ownershipP2(NewOwnershipP2)));
        (DefenderID =:= 3, ownershipP3(List), setEl(List, IndexAreaDefender, 0, NewOwnershipP3), retract(ownershipP3(_)), asserta(ownershipP3(NewOwnershipP3)));
        (DefenderID =:= 4, ownershipP4(List), setEl(List, IndexAreaDefender, 0, NewOwnershipP4), retract(ownershipP4(_)), asserta(ownershipP4(NewOwnershipP4)))
    ), 
    currentPlayer(AttackerPlayer), playerID(AttackerPlayer, AttackerID),
    areaCodename(_, AreaAttacker, IndexAreaAttacker),
    (
        (AttackerID =:= 1, ownershipP1(List1), getElmt(List1,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List1, IndexAreaAttacker, N1, NewOwnership1),
        setEl(NewOwnership1, IndexAreaDefender, NumSoldiersMove, NewNewOwnership1), retract(ownershipP1(_)), asserta(ownershipP1(NewNewOwnership1)));
        (AttackerID =:= 2, ownershipP2(List1), getElmt(List1,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List1, IndexAreaAttacker, N1, NewOwnership2),
        setEl(NewOwnership2, IndexAreaDefender, NumSoldiersMove, NewNewOwnership2),retract(ownershipP2(_)), asserta(ownershipP2(NewNewOwnership2)));
        (AttackerID =:= 3, ownershipP3(List1), getElmt(List1,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List1, IndexAreaAttacker, N1, NewOwnership3),
        setEl(NewOwnership3, IndexAreaDefender, NumSoldiersMove, NewNewOwnership3),retract(ownershipP3(_)), asserta(ownershipP3(NewNewOwnership3)));
        (AttackerID =:= 4, ownershipP4(List1), getElmt(List1,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List1, IndexAreaAttacker, N1, NewOwnership4),
        setEl(NewOwnership4, IndexAreaDefender, NumSoldiersMove, NewNewOwnership4),retract(ownershipP4(_)), asserta(ownershipP4(NewNewOwnership4)))
    ).

/*Menghanguskan tentara yang dikirim*/
soldiersDied(AreaAttacker, NumSoldiersMove):-
    areaCodename(_, AreaAttacker, IndexAreaAttacker), currentPlayer(Player), playerID(Player, ID),
    (
        (ID =:= 1, ownershipP1(List), getElmt(List,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List, IndexAreaAttacker, N1, NewOwnershipP1), retract(ownershipP1(_)), asserta(ownershipP1(NewOwnershipP1)));
        (ID =:= 2, ownershipP2(List), getElmt(List,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List, IndexAreaAttacker, N1, NewOwnershipP2), retract(ownershipP2(_)), asserta(ownershipP2(NewOwnershipP2)));
        (ID =:= 3, ownershipP3(List), getElmt(List,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List, IndexAreaAttacker, N1, NewOwnershipP3), retract(ownershipP3(_)), asserta(ownershipP3(NewOwnershipP3)));
        (ID =:= 4, ownershipP3(List), getElmt(List,IndexAreaAttacker,N), N1 is N-NumSoldiersMove, setEl(List, IndexAreaAttacker, N1, NewOwnershipP4), retract(ownershipP4(_)), asserta(ownershipP4(NewOwnershipP4)))
    ).




/*Melakukan penyerangan*/


attack :-
    (
        currentPlayer(Player),
        (
            haveAttacked(Bool), Bool =:= 1, !, format('Player ~w sudah menyerang pada giliran ini.~n', [Player])
        ;
        
            format('Sekarang giliran Player ~w menyerang.~n', [Player]),
            displayMap,
            repeat,
            chooseAreaAttacker(AreaAttackerCode),
            (
                \+ isAreaValidToAttack(AreaAttackerCode, Player) ->
                write('Daerah tidak valid. Silahkan input kembali.'), nl,
                fail
                ;
                getAreaName(AreaAttackerCode, AreaAttacker),
                soldiersInArea(AreaAttacker, NumSoldiersInArea),
                format('~nDalam daerah ~w, Anda memiliki sebanyak ~w tentara.~n', [AreaAttacker, NumSoldiersInArea]),
                repeat,
                nl, write('Masukkan banyak tentara yang akan bertempur: '),
                read(SoldierstoAttack),
                (
                    \+isAttackValid(AreaAttacker, SoldierstoAttack) ->
                    write('Banyak tentara tidak valid. Silahkan input kembali.'),
                    fail
                    ;
                    /*if num soldiers move valid*/
                    retract(haveAttacked(_)),
                    asserta(haveAttacked(1)),
                    displayMap,
                    chooseAreaDefender(AreaAttacker, AreaDefender),
                    getAreaOccupier(AreaDefender, PlayerDefender),
                    /*Play Game*/
                    write('Perang telah dimulai.'), nl,
                    format('~w melempar dadu...', [Player]), nl,
                    displayRollingDices(SoldierstoAttack, 1, 0, TotalDiceAttacker),

                    nl,nl,format('~w diserang melempar dadu...', [PlayerDefender]), nl,
                    soldiersInArea(AreaDefender, SoldiersDefender),
                    displayRollingDices(SoldiersDefender, 1, 0, TotalDiceDefender),
                    (
                        TotalDiceDefender>TotalDiceAttacker ->
                        /*Mekanisme Kalah*/
                        write('Sayang sekali penyerangan Anda gagal :(.'), nl,
                        soldiersDied(AreaAttacker, SoldierstoAttack), !
                        ;   
                        /*Mekanisme Menang*/
                        write('Anda menang!'),nl,
                        format('Wilayah ~w sekarang dikuasai oleh Anda.~n', [AreaDefender]),
                        format('Silahkan tentukan banyaknya tentara yang menetap di wilayah ~w: ', [AreaDefender]),
                        read(NumSoldiersMove),
                        acquireArea(AreaAttacker, AreaDefender, NumSoldiersMove),
                        soldiersInArea(AreaAttacker, NewSoldiersInAreaAttacker),
                        format('Tentara di wilayah ~w: ~w~n', [AreaAttacker, NewSoldiersInAreaAttacker]),
                        soldiersInArea(AreaDefender, NewSoldiersInAreaDefender),
                        format('Tentara di wilayah ~w: ~w~n', [AreaDefender, NewSoldiersInAreaDefender]), !,
                        (
                            (
                                isWin(Player),
                                format('Selamat!~nPlayer ~w berhasil mendominasi dunia~n', [Player]),
                                write('Permainan Selesai!'), nl,
                                write('  ___ ___        .__.__    ________                 .__               __                '), nl,
                                write(' /   |   \\_____  |__|  |   \\______ \\   ____   _____ |__| ____ _____ _/  |_  ___________ '), nl,
                                write('/    ~    \\__  \\ |  |  |    |    |  \\ /  _ \\ /     \\|  |/    \\\\__  \\\\   __\\/  _ \\_  __ \\'), nl,
                                write('\\    Y    // __ \\|  |  |__  |    `   (  <_> )  Y Y  \\  |   |  \\/ __ \\|  | (  <_> )  | \\/'), nl,
                                write(' \\___|_  /(____  /__|____/ /_______  /\\____/|__|_|  /__|___|  (____  /__|  \\____/|__|   '), nl,
                                write('       \\/      \\/                  \\/             \\/        \\/     \\/                   '), nl,
                                halt
                                )
                            ;
                            true
                        )
                    )
                )
            )
        )
    ).

isPlayerWin([], Count) :- Count =:= 0.
isPlayerWin([H|L], Count) :- Count > 0,
    H \== 0, Count1 is Count - 1, isPlayerWin(L, Count1).

isWin(Player) :-
    playerID(Player,PLayerID),
    (
        (PLayerID =:= 1, ownershipP1(List));
        (PLayerID =:= 2, ownershipP2(List));
        (PLayerID =:= 3, ownershipP3(List));
        (PLayerID =:= 4, ownershipP4(List))
    ),
    isPlayerWin(List, 24).