-module(pe_client).
-compile(export_all).

start()->
	sniffer_pid(),
	connect(),
	{ok, Python} = python:start(),
	python:call(Python, main, run_gui, [whereis(sniffer)]).

sniffer_pid() ->
	register(sniffer,spawn(?MODULE, receiver,[[]])).

connect()->
	global:send(srv, {cmd,{connect,whereis(sniffer),empty}}).

send(Pid,Msg) ->
	global:send(srv, {cmd,{msg,Pid,Msg}}).

send(Msg) ->
	global:send(srv, {cmd,{msg,whereis(sniffer),Msg}}).
	
default_listener(Msg)->
	io:format("~s~n",[Msg]).

recv() ->
	recv(fun default_listener/1).

recv(F) ->
	receive
		{cmd, {msg, _, Msg}} ->
			F(Msg),
			recv(F)
	end.

get_msg()->
	whereis(sniffer) ! {cmd, {msgs, self(), empty}},
	receive
		{cmd,{msgs,_,Msgs}} -> Msgs
	end.
	
receiver(Msgs)->
	receive
		{cmd, {msg, _, Msg}} ->
			receiver([Msg| Msgs]);
		{cmd, {msgs, Pid, empty}} ->
			Pid ! {cmd,{msgs,empty,Msgs}},
			receiver([])
	end.










