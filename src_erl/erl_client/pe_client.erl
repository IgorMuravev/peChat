-module(pe_client).
-compile(export_all).

start()->
	connect(),
	send("Hello!"),
	{ok, Python} = python:start(),
	API = python:call(Python, main, get_api, []),
	python:call(Python, main, show_form,[API]),
	python:call(Python, main, send,[API,<<"CONNECTED">>]).


connect()->
	global:send(srv, {cmd,{connect,self(),empty}}).

send(Msg) ->
	global:send(srv, {cmd,{msg,self(),Msg}}).

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








