/*FACTS*/
/*---NORTH AMERICA---*/
adjacentArea(na1, na2).    
adjacentArea(na1, na3).
adjacentArea(na2, na1).
adjacentArea(na2, na4).
adjacentArea(na2, na5).
adjacentArea(na3, na1).
adjacentArea(na3, na4).
/*Intercontinent*/
adjacentArea(na3, sa1).
adjacentArea(na5, e1).
/*Intercontinent*/
adjacentArea(na4, na2).
adjacentArea(na4, na3).
adjacentArea(na4, na5).
adjacentArea(na5, na2).
adjacentArea(na5, na4).
/*---SOUTH AMERICA---*/
/*Intercontinent*/
adjacentArea(sa1, na3).
adjacentArea(sa2, af1).
adjacentArea(sa2, au2).
/*Intercontinent*/
adjacentArea(sa1, sa2).
adjacentArea(sa2, sa1).
/*---EUROPE---*/
adjacentArea(e1, e2).
adjacentArea(e1, e3).
adjacentArea(e2, e1).
adjacentArea(e2, e4).
adjacentArea(e3, e1).
adjacentArea(e3, e4).
adjacentArea(e4, e2).
adjacentArea(e4, e3).
adjacentArea(e4, e5).
adjacentArea(e5, e4).
/*Intercontinent*/
adjacentArea(e1, na5).
adjacentArea(e2, a1).
adjacentArea(e3, af1).
adjacentArea(e4, af2).
adjacentArea(e5, af2).
adjacentArea(e5, a4).
/*Intercontinent*/
/*---ASIA---*/
adjacentArea(a1, a4).
adjacentArea(a1, a4).
adjacentArea(a2, a4).
adjacentArea(a2, a5).
adjacentArea(a2, a6).
adjacentArea(a3, a5).
adjacentArea(a4, a1).
adjacentArea(a4, a2).
adjacentArea(a4, a5).
adjacentArea(a4, a6).
adjacentArea(a5, a2).
adjacentArea(a5, a3).
adjacentArea(a5, a4).
adjacentArea(a5, a6).
adjacentArea(a6, a2).
adjacentArea(a6, a4).
adjacentArea(a6, a5).
adjacentArea(a6, a7).
adjacentArea(a7, a6).
/*Intercontinent*/
adjacentArea(a1, e2).
adjacentArea(a3, na1).
adjacentArea(a3, na3).
adjacentArea(a4, e5).
adjacentArea(a6, au1).
/*Intercontinent*/
/*---AUSTRALIA---*/
adjacentArea(au1, au2).
adjacentArea(au2, au1).
/*Intercontinent*/
adjacentArea(au2, sa2).
/*Intercontinent*/
/*---AFRICA---*/
adjacentArea(af1, af2).
adjacentArea(af1, af3).
adjacentArea(af2, af1).
adjacentArea(af2, af3).
adjacentArea(af3, af1).
adjacentArea(af3, af2).
/*Intercontinent*/
adjacentArea(af1, e3).
adjacentArea(af1, sa2).
adjacentArea(af2, e5).
adjacentArea(af2, e4).
/*Intercontinent*/
inContinent(Area, Continent):-
areaCodename(_,Area,Index), continentRange(Continent,I1,I2), Index>=I1, I2=<Index.


/*RULES*/
isSameContinent(Area1, Area2):-
areaCodename(_, Area1, Index1), 
areaCodename(_, Area2, Index2), 
continentRange(Continent, I1, I2), 
Index1>=I1, Index1=<I2, 
Index2>=I1, Index2=<I2.

printSpace(X):- (X<10 -> write(' ');true).
printDash(X):- (X<10 -> write('-');true).
listSoldiersWholeMap(List):-
    ownershipP1(List1),
    ownershipP2(List2),
    add_lists(List1,List2,List).

soldiersInArea(Area, NumSoldiers):- areaCodename(_, Area, Index), listSoldiersWholeMap(List), getElmt(List, Index, NumSoldiers).
displayMap:-
    soldiersInArea(australia,AU1),
    soldiersInArea(newzealand,AU2),
    soldiersInArea(egypt,AF1),
    soldiersInArea(southafrica,AF2),
    soldiersInArea(niger,AF3),
    soldiersInArea(cuba,SA1),
    soldiersInArea(brazil,SA2),
    soldiersInArea(unitedstates,NA1),
    soldiersInArea(canada,NA2),
    soldiersInArea(greenland,NA3),
    soldiersInArea(mexico,NA4),
    soldiersInArea(carribean,NA5),
    soldiersInArea(france,E1),
    soldiersInArea(england,E2),
    soldiersInArea(germany,E3),
    soldiersInArea(italy,E4),
    soldiersInArea(belgium,E5),
    soldiersInArea(indonesia,A1),
    soldiersInArea(russia,A2),
    soldiersInArea(china,A3),
    soldiersInArea(india,A4),
    soldiersInArea(japan,A5),
    soldiersInArea(kazakhstan,A6),
    soldiersInArea(saudi,A7),
    write('################################################################################################'), nl,
    write('#         North America        #        Europe         #                 Asia                  #'), nl,
    write('#                              #                       #                                       #'), nl,
    format('#       [NA1(~w)]-[NA2(~w)]    ',[NA1, NA2]),printSpace(NA1),printSpace(NA2),write('#                       #                                       #'), nl, 
    format('-----------|       |----[NA5(~w)]',[NA5]),write('----'),format('[E1(~w)]-[E2(~w)]',[E1, E2]),format('---------[A1(~w)] [A2(~w)] [A3(~w)]', [A1, A2, A3]),printDash(NA5),printDash(E1),printDash(E2), printDash(A1),printDash(A2),printDash(A3),write('-------') ,nl,
    format('#       [NA3(~w)]-[NA4(~w)]',[NA3, NA4]),printSpace(NA3),printSpace(NA4),write('    #       |       |       #        |       |       |              #'), nl,
    format('#          |                   #    [E3(~w)]-[E4(~w)]',[E3,E4]),printSpace(E3),printSpace(E4),write('  ####     |       |       |              #'), nl,
    format('###########|#####################      |       |-[E5(~w)]-----[A4(~w)]----+----[A5(~w)]',[E5, A4, A5]),printSpace(E5),printSpace(A4),printSpace(A5),write('        #'), nl,
    write('#          |                   ########|#######|###########             |                      #'), nl,
    format('#       [SA1(~w)]',[SA1]),printSpace(SA1),write('              #       |       |          #             |                      #'), nl,
    format('#          |                   #       |    [AF2(~w)]',[AF2]),printSpace(AF2),format('     #          [A6(~w))]---[A7(~w)]',[A6,A7]),printSpace(A6),printSpace(A7),write('      #'), nl,
    format('#   |---[SA2(~w)]--------------------[AF1(~w)]---|',[SA2,AF1]),printSpace(SA2),printSpace(AF1),write('        #             |                      #'), nl,
    write('#   |                          #               |          ##############|#######################'), nl,
    format('#   |                          #            [AF3(~w)]',[AF3]),printSpace(AF3),write('     #             |                      #'), nl,
    format('----|                          #                          #          [AU1(~w)]---[AU2(~w)]',[AU1,AU2]),printDash(AU1),printDash(AU2),write('------'), nl,
    write('#                              #                          #                                    #'), nl,
    write('#       South America          #         Africa           #          Australia                 #'), nl,
    write('################################################################################################'), nl,!.