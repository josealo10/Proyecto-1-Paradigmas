/*
EIF400 loriacarlos@gmail.com
Para correr puede usar el .bat test_project asi:

test_project nombre_caso_de_un_caso_de_prueba.rive
El caso de prueba debe estar en el directorio cases del proycto.
Sino se da un caso de prueba asume cases\micro.rive
Genera un eco del archivo (más comentarios) en output
*/

:- assert(file_search_path(rs_path, '../src/rs.compile/')).

:- use_module(rs_path(rsCompiler)).


default_file('micro.rive').

run_compiler :-
   %spy(compile/1),
   current_prolog_flag(argv, AllArgs),
   ([File|_] = AllArgs -> true; default_file(File)),
   (compile(File) -> true; writeln('*** Compilation failed!! ***')),
   !
.
handle_error(genCode(Msg, T)) :- !,
    format('\n*** Emit ERROR: ~s >>> ~w ***', [Msg, T])
.
handle_error(syntaxError(Msg, T)) :- !,
    format('\n*** Parsing ERROR: ~s >>> ~w ***', [Msg, T])
.
handle_error(Any) :- writeln(Any),
    format('\n*** Undetermined ERROR: >>> ~w ***', [Any])
.
  
run :- 
   writeln('*** Testing RS Compiler v 0.1 (DEMO) ***'),
   % Change WD up in dir
   working_directory(OldDir, '..'),
   working_directory(FullDir, FullDir),
   atom_concat('*** Test is Working in ', FullDir, MsgDir),writeln(MsgDir),
   %
   catch(run_compiler, 
         Err, 
         handle_error(Err)),
   %
   % Restore original WD
   working_directory(_, OldDir)
. 

 