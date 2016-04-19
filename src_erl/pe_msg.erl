-module(pe_msg).
-export([connect/0 , send/1]).
connect()->
	global:send(srv, {cmd,{connect,self(),empty}}).
send(Msg) ->
	global:send(srv, {cmd,{msg,self(),Msg}}).

recv(F) ->
	receive
		{cmd, {msg, _, Msg}} ->
			F(Msg),
			recv(F)
	end.



