-module(pe_server).
%%-export([start/0, stop/0]).
-compile(export_all).
server_logfile() -> "srv.log".
server_log() -> file:open(server_logfile(), [append]).

notify(_,[],_) ->ok;
notify(X,[X|T],Msg)-> notify(X,T,Msg);
notify(X,[H|T], Msg)->
	H ! {cmd, {msg, self(),Msg}},
	notify(X,T,Msg).

server_loop1(Clients, LogDevice) ->
	receive
		{cmd,{connect,ClientPid,empty}} ->
			io:fwrite(LogDevice, "[~w] Connected process ~w~n",[calendar:local_time(),ClientPid]),
			server_loop1([ClientPid | Clients],LogDevice);
		{cmd,{break,empty,empty}} ->
			io:fwrite(LogDevice, "[~w] Server stopped ~n",[calendar:local_time()]),
			file:close(LogDevice);
		{cmd,{msg, ClientPid, Msg}} ->
			io:fwrite(LogDevice, "[~w] Message received [~w] ~n",[calendar:local_time(), Msg]),
			case lists:member(ClientPid,Clients) of
				true -> notify(ClientPid, Clients, Msg);
				false -> io:fwrite(LogDevice, "[~w] Undefined process ~w~n",[calendar:local_time(),ClientPid])
			end,
			server_loop1(Clients, LogDevice);
		Uncaught ->
			io:fwrite(LogDevice, "[~w] Uncaught message ~w~n",[calendar:local_time(), Uncaught]),
			server_loop1(Clients,LogDevice)
	end.
server_loop2(Clients) ->
	receive
		{cmd,{connect,ClientPid,empty}} ->
			server_loop2([ClientPid | Clients]);
		{cmd,{break,empty,empty}} ->
			ok;
		{cmd,{msg, ClientPid, Msg}} ->
			case lists:member(ClientPid,Clients) of
				true -> notify(ClientPid, Clients, Msg);
				false -> ok
			end,
			server_loop2(Clients);
		Uncaught ->
			server_loop2(Clients)
	end.

start()->
	{A,R} = server_log(),
	if 
		A == ok ->
			io:fwrite(R, "[~w] Server started ~n",[calendar:local_time()]),
			Server = spawn(?MODULE, server_loop1,[[], R]),
			global:sync(),
			global:register_name(srv,Server);
		true -> 
			Server = spawn(?MODULE, server_loop2,[[]]),
			global:sync(),
			global:register_name(srv,Server)
	end.

stop()->
	global:send(srv, {cmd,{break,empty,empty}}).