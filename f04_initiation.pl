
/*FACTS*/
:- dynamic(endOfPhase1/1).
:- dynamic(ammPlayer/1).
/*

:- dynamic(nameOfPlayers/1).  ini dari players

insertLast(X, [], [X]). 
insertLast(X, [H|T], [H|Z]) :- insertLast(X, T, Z).
shakeOneDice(RandomNumber) :-
    random(1, 7, RandomNumber).

deleteFirst([H|T],H,T).
nextPlayer(OldList,NewList):- deleteFirst(OldList,H,T), insertLast(H,T,NewList). 


assertownershipP1([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]).
assertownershipP2([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]).
assertownershipP3([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]).
assertownershipP4([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]).
assertnameOfPlayers(['Name1', 'Name2', 'Name3', 'Name4']).
*/
/*RULES*/
insertNumOfPlayers :- write('Masukkan jumlah user: '),
                      retractall(ammPlayer(_)),
                      read(X), 
                      asserta(ammPlayer(X)).

insert_user_input(X, List) :- insert_user_input(X, List, X).

insert_user_input(0, List, List).
insert_user_input(N, List, Result) :- 
    N > 0, 
    N1 is N - 1, 
    write('Masukkan nama user: '),
    read(X), 
    insertLast(X, List, NewList), 
    insert_user_input(N1, NewList, Result).

insertPlayerNames :- 
    ammPlayer(X),
    X>1,
    X<5,
    retractall(nameOfPlayers(_)),
    insert_user_input(X, [], Result),
    asserta(nameOfPlayers(Result)).

insertPlayerNames :- 
    ammPlayer(X),
    X<2,
    X>4,
    write('Pemain minimal 2 dan maksimal 4 !!!'),
    nl,
    insertPlayerNames.


shakeDice(0, 0).
shakeDice(AmmDice,Sum) :-
    AmmDice > 0,
    AD1 is AmmDice - 1,
    shakeOneDice(D),
    write('individual dice: '),
    write(D),
    nl,
    shakeDice(AD1,Sum1),
    Sum is D + Sum1.


getListOfDiceSum(0, []).
getListOfDiceSum(N, [Sum | RestResult]) :-
    N > 0,
    N1 is N - 1,
    shakeDice(2, Sum),
    write('Total: '), write(Sum), nl,
    getListOfDiceSum(N1, RestResult).

/* Basis */
max([Head|Tail], Head) :-
    Tail = [], !.

/* Rekurens */
max([Head|Tail], Max) :-
    max(Tail, CurrMax),
    Head > CurrMax, !,
    Max is Head.

max([Head|Tail], Max) :-
    max(Tail, CurrMax),
    Head =< CurrMax, !,
    Max is CurrMax.
                    
decidePlayerOrders:- 
    ammPlayer(X),
    nameOfPlayers(Names),
    getListOfDiceSum(X,DiceSum),
    write(DiceSum),
    max(DiceSum,Max),
    getIdx(DiceSum,Max,IDX),
    getElmt(Names,IDX,FP),
    retractall(currentPlayer(_)),
    asserta(currentPlayer(FP)).

distributeSoldiersToPlayers :- ammPlayer(X),
                               X =:=2,
                               RS is 48//X,
                               format('~nSetiap pemain mendapatkan ~d tentara.', [RS]),
                               retractall(numOfFreeSoldiersP1(_)),
                               retractall(numOfFreeSoldiersP2(_)),
                               asserta(numOfFreeSoldiersP1(RS)),
                               asserta(numOfFreeSoldiersP2(RS)),
                               !.

distributeSoldiersToPlayers :- ammPlayer(X),
                               X =:=3,
                               RS is 48//X,
                               format('~nSetiap pemain mendapatkan ~d tentara.', [RS]),
                               retractall(numOfFreeSoldiersP1(_)),
                               retractall(numOfFreeSoldiersP2(_)),
                               retractall(numOfFreeSoldiersP3(_)),
                               asserta(numOfFreeSoldiersP1(RS)),
                               asserta(numOfFreeSoldiersP2(RS)),
                               asserta(numOfFreeSoldiersP3(RS)),
                               !.

distributeSoldiersToPlayers :- ammPlayer(X),
                               X =:=4,
                               RS is 48//X,
                               format('~nSetiap pemain mendapatkan ~d tentara.', [RS]),
                               retractall(numOfFreeSoldiersP1(_)),
                               retractall(numOfFreeSoldiersP2(_)),
                               retractall(numOfFreeSoldiersP3(_)),
                               retractall(numOfFreeSoldiersP4(_)),
                               asserta(numOfFreeSoldiersP1(RS)),
                               asserta(numOfFreeSoldiersP2(RS)),
                               asserta(numOfFreeSoldiersP3(RS)),
                               asserta(numOfFreeSoldiersP4(RS)),
                               !.



/*initChooseArea*/

setOwnerShipList :- 
                    retractall(ownershipP1(_)),
                    retractall(ownershipP2(_)),
                    retractall(ownershipP3(_)),
                    retractall(ownershipP4(_)),
                    asserta(ownershipP1([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])), 
                    asserta(ownershipP2([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])),
                    asserta(ownershipP3([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])),
                    asserta(ownershipP3([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])).


/* fact for choose player */
:- dynamic(kodeArea/1).

/*helper rules for choose area*/
getHowManySoldierP1inArea(KODEAREA,Result) :- areaCodename(KODEAREA,_,IDXAREA),
                                              ownershipP1(OS1),
                                              getElmt(OS1,IDXAREA,Result).

getHowManySoldierP2inArea(KODEAREA,Result) :- areaCodename(KODEAREA,_,IDXAREA),
                                              ownershipP2(OS2),
                                              getElmt(OS2,IDXAREA,Result).
                                            
getHowManySoldierP3inArea(KODEAREA,Result) :- areaCodename(KODEAREA,_,IDXAREA),
                                              ownershipP3(OS3),
                                              getElmt(OS3,IDXAREA,Result).

getHowManySoldierP4inArea(KODEAREA,Result) :- areaCodename(KODEAREA,_,IDXAREA),
                                              ownershipP4(OS4),
                                              getElmt(OS4,IDXAREA,Result).
                                              

/*for two players*/                            
chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 2,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 1,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP2inArea(KODEAREA,Result),
                      areaCodename(KODEAREA,_,IDXAREA),                     
                      Result <1,
                      ownershipP1(OS1),ownershipP2(OS2),
                      setEl(OS1,IDXAREA,1,NewLis),
                      retractall(ownershipP1(_)),
                      asserta(ownershipP1(NewLis)),
                      numOfFreeSoldiersP1(FREE1),
                      NewFree is FREE1 - 1,
                      retractall(numOfFreeSoldiersP1(_)),
                      asserta(numOfFreeSoldiersP1(NewFree)).

chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 2,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 2,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP1inArea(KODEAREA,Result),
                      areaCodename(KODEAREA,_,IDXAREA),
                      Result <1,
                      ownershipP1(OS1),ownershipP2(OS2),
                      setEl(OS2,IDXAREA,1,NewLis),
                      retractall(ownershipP2(_)),
                      asserta(ownershipP2(NewLis)),
                      numOfFreeSoldiersP2(FREE2),
                      NewFree is FREE2 - 1,
                      retractall(numOfFreeSoldiersP2(_)),
                      asserta(numOfFreeSoldiersP2(NewFree)).

/* for three players */
chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 3,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 1,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP2inArea(KODEAREA,Resultp2),
                      getHowManySoldierP3inArea(KODEAREA,Resultp3),
                      areaCodename(KODEAREA,_,IDXAREA),
                      Resultp2 <1,
                      Resultp3 <1,
                      ownershipP1(OS1),ownershipP2(OS2),ownershipP3(OS3),
                      setEl(OS1,KODEAREA,1,NewLis),
                      retractall(ownershipP1(_)),
                      asserta(ownershipP1(NewLis)),
                      numOfFreeSoldiersP1(FREE1),
                      NewFree is FREE1 - 1,
                      retractall(numOfFreeSoldiersP1(_)),
                      asserta(numOfFreeSoldiersP1(NewFree)).

chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 3,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 2,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP1inArea(KODEAREA,Resultp1),
                      getHowManySoldierP3inArea(KODEAREA,Resultp3),
                      areaCodename(KODEAREA,_,IDXAREA),
                      Resultp1 <1,
                      Resultp3 <1,
                      ownershipP1(OS1),ownershipP2(OS2),ownershipP3(OS3),
                      setEl(OS2,KODEAREA,1,NewLis),
                      retractall(ownershipP2(_)),
                      asserta(ownershipP2(NewLis)),
                      numOfFreeSoldiersP2(FREE2),
                      NewFree is FREE2 - 1,
                      retractall(numOfFreeSoldiersP2(_)),
                      asserta(numOfFreeSoldiersP2(NewFree)).

chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 3,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 3,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP1inArea(KODEAREA,Resultp1),
                      getHowManySoldierP2inArea(KODEAREA,Resultp2),
                      areaCodename(KODEAREA,_,IDXAREA),
                      Resultp1 <1,
                      Resultp2 <1,
                      ownershipP1(OS1),ownershipP2(OS2),ownershipP3(OS3),
                      setEl(OS3,KODEAREA,1,NewLis),
                      retractall(ownershipP3(_)),
                      asserta(ownershipP3(NewLis)),
                      numOfFreeSoldiersP3(FREE3),
                      NewFree is FREE3 - 1,
                      retractall(numOfFreeSoldiersP3(_)),
                      asserta(numOfFreeSoldiersP3(NewFree)).

/* for four players */
chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 4,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 1,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP2inArea(KODEAREA,Resultp2),
                      getHowManySoldierP3inArea(KODEAREA,Resultp3),
                      getHowManySoldierP4inArea(KODEAREA,Resultp4),
                      /*areaCodename(KODEAREA,_,IDXAREA),*/
                      Resultp2 <1,
                      Resultp3 <1,
                      Resultp4 <1,
                      ownershipP1(OS1),ownershipP2(OS2),ownershipP3(OS3),ownershipP4(OS4),
                      setEl(OS1,KODEAREA,1,NewLis),
                      retractall(ownershipP1(_)),
                      asserta(ownershipP1(NewLis)),
                      numOfFreeSoldiersP1(FREE1),
                      NewFree is FREE1 - 1,
                      retractall(numOfFreeSoldiersP1(_)),
                      asserta(numOfFreeSoldiersP1(NewFree)).

chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 4,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 2,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP1inArea(KODEAREA,Resultp1),
                      getHowManySoldierP3inArea(KODEAREA,Resultp3),
                      getHowManySoldierP4inArea(KODEAREA,Resultp4),
                      /*areaCodename(KODEAREA,_,IDXAREA),*/
                      Resultp1 <1,
                      Resultp3 <1,
                      Resultp4 <1,
                      ownershipP1(OS1),ownershipP2(OS2),ownershipP3(OS3),ownershipP4(OS4),
                      setEl(OS2,KODEAREA,1,NewLis),
                      retractall(ownershipP2(_)),
                      asserta(ownershipP2(NewLis)),
                      numOfFreeSoldiersP2(FREE2),
                      NewFree is FREE2 - 1,
                      retractall(numOfFreeSoldiersP2(_)),
                      asserta(numOfFreeSoldiersP2(NewFree)).

chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 4,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 3,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP2inArea(KODEAREA,Resultp2),
                      getHowManySoldierP1inArea(KODEAREA,Resultp1),
                      getHowManySoldierP4inArea(KODEAREA,Resultp4),
                      /*areaCodename(KODEAREA,_,IDXAREA),*/
                      Resultp2 <1,
                      Resultp1 <1,
                      Resultp4 <1,
                      ownershipP1(OS1),ownershipP2(OS2),ownershipP3(OS3),ownershipP4(OS4),
                      setEl(OS3,KODEAREA,1,NewLis),
                      retractall(ownershipP3(_)),
                      asserta(ownershipP3(NewLis)),
                      numOfFreeSoldiersP3(FREE3),
                      NewFree is FREE3 - 1,
                      retractall(numOfFreeSoldiersP3(_)),
                      asserta(numOfFreeSoldiersP3(NewFree)).

chooseArea(Player) :- ammPlayer(AP),
                      AP =:= 4,
                      nameOfPlayers(NOP),
                      getIdx(NOP,Player,IDXPLAYER),
                      IDXPLAYER == 4,
                      retractall(kodeArea(_)),
                      write('Giliran '),
                      write(Player),
                      nl,
                      write('Masukkan kode area yang valid : '),
                      read(X),
                      asserta(kodeArea(X)),
                      kodeArea(KODEAREA),
                      getHowManySoldierP2inArea(KODEAREA,Resultp2),
                      getHowManySoldierP3inArea(KODEAREA,Resultp3),
                      getHowManySoldierP1inArea(KODEAREA,Resultp1),
                      /*areaCodename(KODEAREA,_,IDXAREA),*/
                      Resultp2 <1,
                      Resultp3 <1,
                      Resultp1 <1,
                      ownershipP1(OS1),ownershipP2(OS2),ownershipP3(OS3),ownershipP4(OS4),
                      setEl(OS4,KODEAREA,1,NewLis),
                      retractall(ownershipP4(_)),
                      asserta(ownershipP4(NewLis)),
                      numOfFreeSoldiersP4(FREE4),
                      NewFree is FREE4 - 1,
                      retractall(numOfFreeSoldiersP4(_)),
                      asserta(numOfFreeSoldiersP4(NewFree)).

/*Helper rules for bagi wilayah*/
all_ones_except_last(List) :- all_ones_except_last_helper(List).

all_ones_except_last_helper([]).
all_ones_except_last_helper([1|Rest]) :- all_ones_except_last_helper(Rest).
all_ones_except_last_helper([_LastElement|[]]).

:- dynamic(ammWilayahP1/1).
:- dynamic(ammWilayahP2/1).
:- dynamic(ammWilayahP3/1).
:- dynamic(ammWilayahP4/1).

addAreaLis(Result) :- ammPlayer(A),
                      A =:=2, 
                      ownershipP1(X),ownershipP2(Y),
                      add_lists(X,Y,Result).

addAreaLis(Result) :- ammPlayer(A),
                      A =:=3, 
                      ownershipP1(X),ownershipP2(Y),ownershipP3(Z),
                      add_lists(X,Y,SUMP1P2),
                      add_lists(SUMP1P2,Z,Result).

addAreaLis(Result) :- ammPlayer(A),
                      A =:=4, 
                      ownershipP1(X),ownershipP2(Y),ownershipP3(Z),ownershipP4(A),
                      add_lists(X,Y,SUMP1P2),
                      add_lists(SUMP1P2,Z,SUMP3),
                      add_lists(SUMP3,A,Result).

/*Bagi Wilayah*/
bagiWilayah :- addAreaLis(X),
               \+ all_ones_except_last(X),
                write('masuk kasus 1'),
               nl,
               currentPlayer(H),
               ownershipP1(O1),
               ownershipP2(O2),
               displayMap,
               chooseArea(H),
               nextPlayer,
               write('nextplayer done'),
               bagiWilayah.

bagiWilayah :- addAreaLis(X),
               all_ones_except_last(X).

/*Fase 2*/
:-dynamic(newAmm/1).
:-dynamic(soldiersLeft/1).

placeTroops(KodeArea,BanyakTroop) :- currentPlayer(X),
                                     nameOfPlayers(NOP),
                                     format('~w meletakkan ~w tentara tambahan di ~w.~n', [X, BanyakTroop, KodeArea]),
                                     getIdx(NOP,X,IDX),
                                     IDX == 1,
                                     numOfFreeSoldiersP1(FS1),
                                     Comparator is FS1 - BanyakTroop,
                                     Comparator >= 0,
                                     ownershipP1(OP1),
                                     areaCodename(KodeArea,_,AreaIDX),
                                     getElmt(OP1,AreaIDX,AmmOfPpl),
                                     AmmOfPpl > 0, % if not milik orang lain
                                     retractall(newAmm(_)),
                                     S1 is BanyakTroop + AmmOfPpl,
                                     asserta(newAmm(S1)),
                                     newAmm(NA),
                                     setEl(OP1,AreaIDX,NA,NewLis),
                                     retractall(ownershipP1(_)),
                                     asserta(ownershipP1(NewLis)),
                                     retractall(soldiersLeft(_)),
                                     Subtraction is FS1 - BanyakTroop,
                                     asserta(soldiersLeft(Subtraction)),
                                     soldiersLeft(SL),
                                     retractall(numOfFreeSoldiersP1(_)),
                                     asserta(numOfFreeSoldiersP1(SL)),
                                     write('terdapat '),
                                     write(SL),
                                     write(' yang tersisa. '),
                                     nextPlayer.

placeTroops(KodeArea,BanyakTroop) :- currentPlayer(X),
                                     nameOfPlayers(NOP),
                                     format('~w meletakkan ~w tentara tambahan di ~w.~n', [X, BanyakTroop, KodeArea]),
                                     getIdx(NOP,X,IDX),
                                     IDX == 2,
                                     numOfFreeSoldiersP2(FS2),
                                     Comparator is FS2 - BanyakTroop,
                                     Comparator >= 0,
                                     ownershipP2(OP2),
                                     areaCodename(KodeArea,_,AreaIDX),
                                     getElmt(OP2,AreaIDX,AmmOfPpl),
                                     AmmOfPpl > 0,
                                     retractall(newAmm(_)),
                                     Hasil is BanyakTroop + AmmOfPpl,
                                     asserta(newAmm(Hasil)),
                                     newAmm(NA),
                                     setEl(OP2,AreaIDX,NA,NewLis),
                                     retractall(ownershipP2(_)),
                                     asserta(ownershipP2(NewLis)),
                                     retractall(soldiersLeft(_)),
                                     Subtraction is FS2 - BanyakTroop,
                                     asserta(soldiersLeft(Subtraction)),
                                     soldiersLeft(SL),
                                     retractall(numOfFreeSoldiersP2(_)),
                                     asserta(numOfFreeSoldiersP2(SL)),
                                     write('terdapat '),
                                     write(SL),
                                     write(' yang tersisa. '),
                                     nextPlayer.

/*Helper otomatic*/
non_zero_indices(List, Indices) :-
    non_zero_indices_helper(List, 1, Indices).

non_zero_indices_helper([], _, []).
non_zero_indices_helper([0|Rest], Index, Indices) :-
    NewIndex is Index + 1,
    non_zero_indices_helper(Rest, NewIndex, Indices).
non_zero_indices_helper([NonZero|Rest], Index, [Index|Indices]) :-
    NonZero \= 0,
    NewIndex is Index + 1,
    non_zero_indices_helper(Rest, NewIndex, Indices).

replace_ones([],_, []).

replace_ones([1 | Tail], NewNumber, [NewNumber | NewTail]) :-
    replace_ones(Tail, NewNumber, NewTail).

replace_ones([X | Tail], NewNumber, [X | NewTail]) :-
    X \= 1,
    replace_ones(Tail, NewNumber, NewTail).


/*Testing Purpose*/
print_list([]).
print_list([Head | Tail]) :-
    write(Head), nl,
    print_list(Tail).

printPlayerNames :- 
    nameOfPlayers(PlayersList),
    print_list(PlayersList).

displayList([]).
displayList([H]) :-
    write(H), !.
displayList([H|T]) :-
    write(H),
    write(', '),
    displayList(T).

%bagi secara otomatis
otomatis(X) :-
    X =:= 1, !,
    ownershipP1(OP1),
    ownershipP2(OP2),
    replace_ones(OP1,2,NL1),
    replace_ones(OP2,2,NL2),
    retractall(ownershipP1(_)),
    retractall(ownershipP2(_)),
    asserta(ownershipP1(NL1)),
    asserta(ownershipP2(NL2)),
    numOfFreeSoldiersP1(Free1),
    numOfFreeSoldiersP2(Free2),
    NewFree is 0,
    retractall(numOfFreeSoldiersP1(_)),
    retractall(numOfFreeSoldiersP2(_)),
    asserta(numOfFreeSoldiersP1(NewFree)),
    asserta(numOfFreeSoldiersP2(NewFree)),
    write('Troop di assign secara otomatis'),
    nl,
    !
    ;
    fail.




init:- 
    insertNumOfPlayers,
    ammPlayer(A),
    insertPlayerNames, 
    printPlayerNames,
    decidePlayerOrders,
    distributeSoldiersToPlayers,
    nl,
    setOwnerShipList,
    bagiWilayah,
    nl,!,
    nl,
    write('Apakah Anda ingin membagi troop secara otomatis ? (1/0) '),
    read(CD),
    otomatis(CD).


