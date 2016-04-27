-module(pe_server).
%%-export([start/0, stop/0]).
-compile(export_all).

print_datetime() ->
	{{Year,Month,Day},{Hour,Min,Sec}} = calendar:local_time(),
	lists:concat([Hour, ":", Min, ":", Sec," " ,Day,".",Month,".",Year]).


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
			io:fwrite(LogDevice, "[~s] Connected process ~w~n",[print_datetime(),ClientPid]),
			server_loop1([ClientPid | Clients],LogDevice);
		{cmd,{break,empty,empty}} ->
			io:fwrite(LogDevice, "[~s] Server stopped ~n",[print_datetime()]),
			file:close(LogDevice);
		{cmd,{msg, ClientPid, Msg}} ->
			io:fwrite(LogDevice, "[~s] Message received [~s] ~n",[print_datetime(), Msg]),
			case lists:member(ClientPid,Clients) of
				true -> notify(ClientPid, Clients, Msg);
				false -> io:fwrite(LogDevice, "[~s] Undefined process ~w~n",[print_datetime(),ClientPid])
			end,
			server_loop1(Clients, LogDevice);
		Uncaught ->
			io:fwrite(LogDevice, "[~s] Uncaught message ~w~n",[print_datetime(), Uncaught]),
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
		_Uncaught ->
			server_loop2(Clients)
	end.

start()->
	{A,R} = server_log(),
	if 
		A == ok ->
			io:fwrite(R, "[~s] Server started ~n",[print_datetime()]),
			global:register_name(srv,spawn(?MODULE, server_loop1,[[], R]));
		true -> 
			global:register_name(srv,spawn(?MODULE, server_loop2,[[]]))
	end.

stop()->
	global:send(srv, {cmd,{break,empty,empty}}).