/*getIdx*/
getIdx([Head|_], Element, Index) :- Head = Element, !, Index is 1.
getIdx([Head|Tail], Element, Index) :- Head \= Element, getIdx(Tail, Element, NewIndex), Index is NewIndex + 1.

/*getElmt*/
getElmt([Head|_], Index, El) :- Index = 1, !, El = Head.
getElmt([_Head|Tail], Index, El) :- Index>1, NewIdx is Index-1, getElmt(Tail, NewIdx, El).

/*setEl*/
setEl([_Head|Tail], 1, El, NewList) :- NewList = [El|Tail],!.
setEl([Head|Tail], Index, El, NewList) :- N is Index-1, setEl(Tail, N, El, Temp), NewList = [Head|Temp].


/*SWAP*/
swap(List, Index, Index, List) :- !.
swap(List, Index1, Index2, NewList) :- Index2<Index1, swap(List, Index2, Index1, NewList).
swap(List, Index1, Index2, NewList) :- getElmt(List, Index1, El1), getElmt(List, Index2, El2), setEl(List, Index1, El2, Tmp), setEl(Tmp, Index2, El1, NewList), !. 
% :- use_module(library(random)).

/*ADDLIST*/
add_lists([],[],[]).
add_lists([H1|T1], [H2|T2], [H3|T3]):-
    H3 is H1 + H2,
    add_lists(T1, T2, T3).

/*FACTS*/

/*RULES*/

/*| ?- insertLast(3,[1,2],X).
X = [1,2,3] ? */

insertLast(X, [], [X]). 
insertLast(X, [H|T], [H|Z]) :- insertLast(X, T, Z).

deleteFirst([H|T],H,T).

/* | ?- nextPlayer([1,2,3],N).
N = [2,3,1] ? */

nextPlayerLama(OldList,NewList):- deleteFirst(OldList,H,T), insertLast(H,T,NewList). 

:-dynamic(newIdx/1).

nextPlayer:- currentPlayer(X),
             nameOfPlayers(Y),
             ammPlayer(Z),
             getIdx(Y,X,Idx),
             write('kasus 2'),nl,
             retractall(newIdx(_)),
             asserta(newIdx(Idx + 1)),
             newIdx(NI),
             NI =< Z,
             getElmt(Y,NI,El),
             retractall(currentPlayer(_)),
             asserta(currentPlayer(El)).
            
nextPlayer:- currentPlayer(X),
             nameOfPlayers(Y),
             ammPlayer(Z),
             getIdx(Y,X,Idx),
             write('kasus 1'),nl,
             retractall(newIdx(_)),
             asserta(newIdx(Idx + 1)),
             newIdx(NI),
             NI > Z,
             retractall(newIdx(_)),
             asserta(newIdx(1)),
             getElmt(Y,1,El),
             retractall(currentPlayer(_)),
             asserta(currentPlayer(El)).

shakeOneDice(RandomNumber) :-
    random(1, 7, RandomNumber).

list_sum([], 0).

list_sum([Head | Tail], Sum) :-
    list_sum(Tail, TailSum),
    Sum is Head + TailSum.

sum_is_zero(List1, List2) :-
    list_sum(List1, Sum1),
    Sum1 =:= 0;
    list_sum(List2, Sum2),
    Sum2 =:= 0.
