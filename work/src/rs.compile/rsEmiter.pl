/*
loriacarlos@gmail.com
EIF400 II-2019
*/

:- module(rsEmiter, [
                       genCodeToFile/2,
                       genCode/1,
                       genCode/2,
                       genCodeHash/2,
                       genCodeStar/2,
                       genCodeUnderscore/2
                    ]).


testEmiter :-
    testParser(P),
    genCode(P)
.

% Quita el warning "Clauses are not together in source-file"
:- discontiguous genCode/2. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
genCodeToFile(File, RS_Prog) :-
   writeln(RS_Prog  ),nl,
   open(File, write, Out),
   genCode(Out, RS_Prog),
   close(Out)
.
genCodeResponse(Out, trigger(WL)) :- !,
    format(Out, '- ', []),
    genCodeList(Out, WL),
    nl(Out)
.

genCode(P) :- genCode(user_output, P)
.
genCode(Out, rsProg(L)) :- !,
    get_time(TS), 
    format_time(atom(T), '*** Rive Program *** : Generated at: %d/%m/%y %H:%M:%S', TS),
    
    genCode(Out, comment(T)), 
    
    genCodeList(Out, L)
.

genCode(Out, trigger_block(T)) :- !,
    nl(Out),
    genCode(Out, comment('>>> Trigger Block')),
    genCode(Out, T)
. 

genCode(Out, trigger(WL)) :- !,
    format(Out, '+ ', []),
    genCodeList(Out, WL),
    nl(Out)
.  

% copia del trigger, para response
genCode(Out, response_block(T)) :- !,
    nl(Out),
    genCode(Out, comment('>>> Response Block')),
    genCode(Out, T)
. 

genCode(Out, response(WL)) :- !,
    format(Out, '- ', []),
    genCodeList(Out, WL),
    nl(Out)
. 

% copia del trigger, para conditional
genCode(Out, conditional_block(T)) :- !,
    nl(Out),
    genCode(Out, comment('>>> Conditional')),
    genCode(Out, T)
. 

genCode(Out, conditional(WL)) :- !,
    format(Out, '* ', []),
    genCodeList(Out, WL),
    nl(Out)
.  
% copia del trigger, para variables
genCode(Out, define_block(T)) :- !,
    nl(Out),
    genCode(Out, comment('>>> Variables Block')),
    genCode(Out, T)
. 

genCode(Out, define(WL)) :- !,
    format(Out, '! ', []),
    genCodeList(Out, WL),
    nl(Out)
. 

genCode(Out, word(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, id(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, num(N))  :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, set(I, E)) :-  !,
   genCode(Out, operation(oper('='), I, E))
   
.  
% agregamos los de star, hash y underscore
genCode(Out, star(_)) :- !, genCodeStar(Out, atom(_))
. 
genCode(Out, hash(_)) :- !, genCodeHash(Out, atom(_))
.  
genCode(Out, underscore(_)) :- !, genCodeUnderscore(Out, atom(_))
.   
%%genCode(Out, var(A,B,C)) :- !, genCodeVar(Out, atom(A),atom(B),atom(C))
%%. 


% Internal Representations
genCode(Out, operation(O, L, R)) :- !,
    genCodeList(Out, [L, O, R])
.
genCode(Out, atom(N)) :- !, format(Out, '~a ', [N])
.   
genCode(Out, comment(C)):-format(Out, '// ~a \n', [C])
.
% Para que escriba #,_ o * cuando son star(N), hash(N), underscore(_)... ect
genCodeHash(Out, atom(_)) :- !, format(Out, '~a ', ["#"])
.   
genCodeStar(Out, atom(_)) :- !, format(Out, '~a ', ["*"])
. 
genCodeUnderscore(Out, atom(_)) :- !, format(Out, '~a ', ["_"])
.   
%% genCodeVar(Out, atom(A),atom(B),atom(C)):-!,format(Out, '~a ', [B]).

%%%% Error case %%%%%%%%%%%%%%%%%%%%%%%%%%
genCode(Out, E ) :- close(Out),!,
                    throw(genCode('genCode unhandled Tree', E))
.

genCodeList(Out, L) :- genCodeList(Out, L, '')
.
genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :- genCode(Out, X), 
                                     format(Out, '~a', [Sep]),
                                     genCodeList(Out, [Y | L], Sep)
.
