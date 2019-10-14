/*
EIF400 loriacarlos@gmail.com
*/

:- module(rsCompiler, [compile/0, compile/1, compile/3]).

:- use_module(rsParser).
:- use_module(rsEmiter).

compile(InPath, OutPath, Filename) :-
   atom_concat(InPath, Filename, PathInFile),
   exists_file(PathInFile), !,
   format('*** Compiling :"~a" *** ~n', [PathInFile]),
   rsParser:parse(PathInFile, P),
   atom_concat(OutPath, Filename, PathOutFile),
   atom_concat(PathOutFile, '.out', RSOutFile),
   format('*** Writing   :"~a" *** ~n', [RSOutFile]),
   rsEmiter:genCodeToFile(RSOutFile, P)
.
compile(InPath, _, Filename) :-
   atom_concat(InPath, Filename, PathInFile),
   format('*** RSCompiler: File Not found :"~a" *** ~n', [PathInFile]),
   fail
.
compile(Filename) :- compile('./cases/', './output/', Filename)
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Default test case %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
compile :- 
    File = 'micro.rive',
    compile(File)
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Entry Point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
main :-
    writeln('*** Starting compilation ***'),
    current_prolog_flag(argv, AllArgs),
    [E|_] = AllArgs,
    compile(E),
   writeln('*** Sucessful compilation ***'), !
.
main :-
    writeln('*** Provide an existing test case file ***')
.