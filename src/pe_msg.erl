-module(pe_msg).
-export([connect/0]).

connect()->
	global:send(srv, {cmd,{connect,self(),empty}}).