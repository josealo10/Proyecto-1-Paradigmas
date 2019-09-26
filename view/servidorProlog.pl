:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_path)).

% levanta el index.html que esta en la carpeta
:- http_handler(root(.), http_reply_from_files('.', []), [prefix]).

% referencia a las carpetas css, js e images
http:location(css, images, []).
http:location(js,images, []).


% monta el index.html en el puerto 9001
:- initialization
      http_server(http_dispatch, [port(9001)]). 