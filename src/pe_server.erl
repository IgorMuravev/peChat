-module(pe_server).
-export([start/0, stop/0]).

server_logfile() -> "srv.log".

server_log() -> file:open(server_logfile(), [append]).



server_loop1(Clients, LogDevice) ->
	receive
		{cmd,{connect,ClientPid,empty}} ->
			io:fwrite(LogDevice, "[~w] Connected process ~w~n",[calendar:local_time(),ClientPid]),
			server_loop1([ClientPid | Clients],LogDevice);
		{cmd,{break,empty}} ->
			io:fwrite(LogDevice, "[~w] Server stopped ~n",[calendar:local_time()]);
		Uncaught ->
			io:fwrite(LogDevice, "[~w] Uncaught message ~w~n",[calendar:local_time(), Uncaught]),
			server_loop1(Clients,LogDevice)
	end.
server_loop2(Clients) ->
	receive
		{cmd,{connect,ClientPid,empty}} ->
			server_loop2([ClientPid | Clients]);
		{cmd,{break,empty}} ->
			ok;
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
	global:send(srv, {cmd,{break, empty}}).


