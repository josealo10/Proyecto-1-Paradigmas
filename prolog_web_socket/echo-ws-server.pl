:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/websocket)).

% necesario
:- use_module(library(http/http_client)).

% Direccion donde corre el server node
node_endpoint('http://localhost:6000').

:- initialization(start_server)
.
%%%%%%%%%%%%%%%%%%%%% Configure handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% static files handler
:- http_handler(root(.),
                http_reply_from_files('.', []),
                [prefix])
.
% websocket echo handler
:- http_handler(root(echo), 
                http_upgrade_to_websocket(echo, []),
                [spawn([])])
.
echo(WebSocket) :-
    ws_receive(WebSocket, Message),
	writeln('Send Message ' + Message.data),
	 (   Message.opcode == close
    ->  true
    ;   
        post_msg(Message.data, Reply),
        writeln(Reply),
        ws_send(WebSocket, text(Reply)),
        echo(WebSocket)          
    )
.

post_msg(Msg, Reply) :-
  node_endpoint(NodeEndPoint),
  format(atom(AtomMsg), '{"msg":"~s"}', [Msg]), 
  http_post(NodeEndPoint, atom(AtomMsg), Reply, []).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Server Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_server :-
    default_port(Port),
    start_server(Port).
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

stop_server() :-
    default_port(Port),
    stop_server(Port).
stop_server(Port) :-
    http_stop_server(Port, []).

default_port(3000).




