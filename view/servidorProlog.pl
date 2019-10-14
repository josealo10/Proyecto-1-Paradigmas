:- use_module(['src/rs.compile/rsCompiler'])

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_path)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_parameters)).

% levanta el index.html que esta en la carpeta
:- http_handler(root(.), http_reply_from_files('.', []), [prefix]).
:- http_handler('/login', handle_request_login, []).
:- http_handler('/admin', handle_request_Admin, []).

% referencia a las carpetas css, js e images
http:location(css, images, []).
http:location(js,images, []).


% monta el index.html en el puerto 9001
:- initialization
      http_server(http_dispatch, [port(9001)]). 

res(ok).
	  
isUser(_{username:X, password:Y}, _{user:N}) :-
    %user(X,Y),
    N = X.
	
response(_{response:N}):-res(N).

% controla los request
handle_request_login(Request) :-
    http_read_json_dict(Request, Query),
    isUser(Query, Solution),
    reply_json_dict(Solution).

handle_request_Admin(Request) :-
	member(method(post), Request), !,
	%http_parameters(Request, [ fname(Name, [])  ]),
    http_read_data(Request, Data, [to(string)]),
	format('Content-type: text/plain~n~n'),
	response(Solution),
	reply_json_dict(Solution).


user(chat,111).
user(admin,222).