/*FACTS*/
% createList(List):-
%     List = ["ceasefireOrder", "superSoldierSerum", "auxiliaryTroops", "supplyChainIssue", "rebellion"].

% dynamic:- (onCeasefireP1/1).
% dynamic:- (onCeasefireP2/1).
% dynamic:- (onCeasefireP3/1).
% dynamic:- (onCeasefireP4/1).
% onCeasefireP1(X).
% onCeasefireP2(X).
% onCeasefireP3(X).
% onCeasefireP4(X).

:- dynamic(supplyChainIssue/1).
:- dynamic(auxiliaryTroops/1).

setCeasefire:-
    currentPlayer(Name),
    format("Player ~w mendapatkan risk card CEASEFIRE ORDER.~nHingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.~n", [Name]),
    playerID(Name, ID),
    (
        (ID =:= 1, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 2, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 3, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 4, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)))
    ).

setSuperSoldier:-
    currentPlayer(Name),
    format("Player ~w mendapatkan risk card SUPER SOLDIER SERUM.~nHingga giliran berikutnya, semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.~n", [Name]),
    playerID(Name, ID),
    (
        (ID =:= 1, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 2, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 3, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 4, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)))
    ).

setAuxiliary:-
    currentPlayer(Name),
    format("Player ~w mendapatkan risk card AUXILIARY TROOPS.~nPada giliran berikutnya, tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.~n", [Name]),
    retractall(auxiliaryTroops(_)), asserta(auxiliaryTroops(true)), !.

setRebellion:-
    currentPlayer(Name),
    format("Player ~w mendapatkan risk card REBELLION.~nSalah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan (acak).~n", [Name]),
    playerID(Name, ID),
    (
        (ID =:= 1, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 2, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 3, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 4, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)))
    ).


setDisease:-
    currentPlayer(Name),
    format("Player ~w mendapatkan risk card DISEASE OUTBREAK.~nSemua hasil lemparan dadu saat penyerangan dan pertahanan hingga giliran berikutnya akan bernilai 1.~n", [Name]),
    playerID(Name, ID),
    (
        (ID =:= 1, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 2, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 3, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)));
        (ID =:= 4, retract(onCeasefireP1(_)), assertz(onCeasefireP1(true)))
    ).

setSupply:-
    currentPlayer(Name),
    format("Player ~w mendapatkan risk card SUPPLY CHAIN ISSUE.~nPemain tidak mendapatkan tentara tambahan pada giliran berikutnya.~n", [Name]),
    retractall(supplyChainIssue(_)), asserta(supplyChainIssue(true)).

risk:-
    random(1,7,Idx),
    (
        (Idx =:= 1, setCeasefire);
        (Idx =:= 2, setSuperSoldier);
        (Idx =:= 3, setAuxiliary);
        (Idx =:= 4, setRebellion);
        (Idx =:= 5, setDisease);
        (Idx =:= 6, setSupply)
    ), !.