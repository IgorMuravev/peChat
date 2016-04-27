-module(pe_msg).
-export([connect/0 , send/1, recv/1, recv/0]).
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



