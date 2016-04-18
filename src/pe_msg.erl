-module(pe_msg).
-export([connect/0, send_msg/1]).

connect()->
	global:send(srv, {cmd,{connect,self(),empty}}).

send_msg(Msg)->
	global:send(srv, {cmd,{msg, self(), Msg}}).