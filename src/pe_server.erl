-module(pe_server).
%%-export([start/0, stop/0]).
-compile(export_all).
server_logfile() -> "srv.log".

server_log() -> file:open(server_logfile(), [append]).

notify(_,[],_)->ok;
notify(ClientPid, [ClientPid|T] , Msg) ->
	notify(ClientPid, T, Msg);
notify(ClientPid, [H | T], Msg) ->
	H ! Msg,
	notify(ClientPid, T, Msg). 

server_loop1(Clients, LogDevice) ->
	receive
		{cmd,{connect,ClientPid,empty}} ->
			io:fwrite(LogDevice, "[~w] Connected process ~w~n",[calendar:local_time(),ClientPid]),
			server_loop1([ClientPid | Clients],LogDevice);
		{cmd,{break,empty,empty}} ->
			io:fwrite(LogDevice, "[~w] Server stopped ~n",[calendar:local_time()]),
			file:close(LogDevice);
		{cmd, {msg,ClientPid,Msg}} ->
			io:fwrite(LogDevice, "[~w] Received message ~n",[calendar:local_time()]),
			notify(ClientPid, Clients, Msg),
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
		{cmd, {msg,ClientPid,Msg}} ->
			notify(ClientPid, Clients,Msg),
			server_loop2(Clients);
		Uncaught ->
			server_loop2(Clients)
	end.

start()->
	{A,R} = server_log(),
	if 
		A == ok ->
			io:fwrite(R, "[~w] Server started ~n",[calendar:local_time()]),
			global:register_name(srv,spawn(?MODULE, server_loop1,[[], R]));
		true -> 
			global:register_name(srv,spawn(?MODULE, server_loop2,[[]]))
	end.

stop()->
	global:send(srv, {cmd,{break,empty,empty}}).