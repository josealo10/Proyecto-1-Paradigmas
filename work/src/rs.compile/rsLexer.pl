/*
EIF400 loriacarlos@gmail.com
Simple recursive lexer
II-2019
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Line number %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- module(rsLexer, [tokenize/2, 
                    reset_line_number/0, 
                    inc_line_number/0,
                    line_number/1
                    ]).

:- dynamic line_number/1
.
reset_line_number :- retractall(line_number(_)), inc_line_number
.
inc_line_number   :- retract(line_number(N)), 
                     N1 is N + 1, 
                     assert(line_number(N1)), !
.
inc_line_number   :- assert(line_number(1))
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
codes_to_chars(Lcodes, Lchars):-
    atom_codes(Atom_from_codes, Lcodes), 
    atom_chars(Atom_from_codes, Lchars).
    
tokenize(File, Tokens) :- open(File, read, Stream),
                          read_stream_to_codes(Stream, Codes),
                          close(Stream),
                          codes_to_chars(Codes, Input),
                          reset_line_number,
                          getTokens(Input, Tokens)
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testLexer(L) :- 
    working_directory(D, D),
    %write(D),
    File = './cases/mini.rive',
    format('~n~n*** Lexing file: ~s ***~n~n', File),
    tokenize(File, L),
    line_number(LN),
    format('File ~s lexed: ~d lines processed~n~n', [File, LN])
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get Tokens %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getTokens(+Input, -Tokens)
% Input: list of codes
% Tokens: List of atoms

getTokens(Input, Tokens) :- extractTokens(Input, ExTokens),
                            delete(ExTokens, [], Tokens) % delete null ('') tokens
.
% extractTokens(+Input, -ExtractedTokens)
% Extacts one by one the tokens delimited by whitespaces
extractTokens([], []) :- !.
extractTokens(Input, [Token | Tokens]) :-  skipWhiteSpace(Input, InputNWS),
                                           startOneToken(InputNWS, Token, Rest),
                                           extractTokens(Rest, Tokens)
.
% Skip White Space(s)
skipWhiteSpace([C | Input], Output) :- isWhiteSpace(C), !, 
                                       skipWhiteSpace(Input, Output)
.
skipWhiteSpace(Input, Input)
.
% START LEXING TOKEN
startOneToken(Input, Token, Rest) :- startOneToken(Input, [], Token, Rest)
.
startOneToken([], P, P, [])
.
startOneToken([C | Input], _, '\n', Input)       :- isNewLine(C), inc_line_number, !
.
startOneToken([C | Input], Partial, Token, Rest) :- isDigit(C), !,
                                                    finishNumber(Input, [ C | Partial], Token, Rest)
.

startOneToken([C | Input], Partial, Token, Rest) :- isLetter(C), !,
                                                    finishId(Input, [ C | Partial], Token, Rest)
.

startOneToken([C | Input], Partial, Token, Rest) :- isOper(C), !,
                                                    finishOper(Input, [ C | Partial], Token, Rest)
.
startOneToken([C | Input], Partial, Token, Rest) :- isQuote(C), !,
                                                    finishQuote(Input, [ C | Partial], Token, Rest)
.
startOneToken([C | _] , _, _, _) :- report_invalid_symbol(C)
.

% Error Reporting
report_invalid_symbol(C) :-
    Msg='*** Lexer Error: Unexpected symbol "~s" found in input stream. Line Number ~d ***',
    line_number(LN),
    format(atom(A), Msg, [C, LN]),
    throw(lexerError(A, ''))
. 
report_invalid_string(Msg) :-
    Msg='*** Lexer Error: Unclosed string in input stream. Line Number ~d ***',
    line_number(LN),
    format(atom(A), Msg, [LN]),
    throw(lexerError(A, ''))
. 

% FINISH NUMBER
finishNumber(Input, Partial, Token, Rest) :- finishToken(Input, isDigit, Partial, Token, Rest)
.
finishId(Input, Partial, Token, Rest) :- finishToken(Input, isAlpha, Partial, Token, Rest)
.
% FINISH QUOTE
finishQuote([C | Input], Partial, Token, Input) :- isQuote(C), !,
                                                   convertToAtom([C | Partial], Token) 
.
finishQuote([C | Input], Partial, Token, Rest) :- finishQuote(Input, [C |Partial], Token, Rest)
.
finishQuote([] , _Partial, _Token, _Input) :- report_invalid_string('opened and not closed string') 
.
% EXTRACT OPER
finishOper([C | Input], [PC | Partial], Token, Input) :- doubleOper(PC, C), !, 
                                                         convertToAtom([C, PC | Partial], Token) 
.
finishOper(Input, Partial, Token, Input) :- convertToAtom(Partial, Token) 
.
% FINISH TOKEN
finishToken([C | Input], Continue, Partial, Token, Rest) :- call(Continue, C), !, 
                                                            finishToken(Input, Continue, [ C | Partial], Token, Rest)
.

finishToken(Input, _, Partial, Token, Input) :- convertToAtom(Partial, Token) 
.

% CONVERT into TOKEN
convertToAtom(Partial, Token) :- reverse(Partial, TokenCodes), 
                                 atom_codes(Token, TokenCodes)
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHARACTER CLASSES (ONLY ASCII)
isNewLine(C) :- member(C, ['\n', '\r']).

isWhiteSpace(C) :- member(C, ['\t', ' ']).

isDigit(D)   :- D @>= '0', D @=< '9'.

isLetter('_') :- !. 
isLetter('$') :- !. 
isLetter(D)  :- D @>='a', D @=< 'z', !.  % a .. z
isLetter(D)  :- D @>= 'A', D @=< 'Z'.    % A .. Z

isAlpha(D) :- isLetter(D);isDigit(D).

isQuote('"'). 

isBackSlash('\\')          % \
.
isOper(O)    :- member(O, ['=','<','>', '*', '-', '+', '/', '\\', '.', '(', ')','[',']','\'']), !.
isOper(O)    :- member(O, ['{', '}', '&', '|', '%', '!', ';', ',', '#','?']), !.
isOper(O)    :- member(O, ['@', ':']), !.

doubleOper('!', '='). % !=
doubleOper('=', '='). % ==
doubleOper('<', '='). % <=
doubleOper('>', '='). % >=
doubleOper('=', '>'). % =>








