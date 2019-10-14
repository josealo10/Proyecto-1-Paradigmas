/*
EIF400 loriacarlos@gmail.com
II-2019
*/

:- module(rsIndexer, [
                       reset_all_indexes/0,
                       reset_some_indexes/1,
                       next_index/2
                       
                     ]).
:- dynamic index/2.
reset_all_indexes :-
    retractall(index(_ ,_))
.
reset_some_indexes(L) :-
    forall(member(I, L), reset_index(I))
.
reset_index(I) :- reset_index(I, 1)
.
reset_index(I, V):- retractall(index(I, _)), assert(index(I, V))
.

next_index(I, V0) :- retract(index(I, V0)), V is V0 + 1, assert(index(I, V))
.