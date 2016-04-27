-module(pe_client).
-compile(export_all).

init(ServerNode)->
	net_adm:ping(ServerNode),
	spawn(pe_msg,recv,[]),
	pe_msg:connect(),
	pe_msg:send("Hello!").

