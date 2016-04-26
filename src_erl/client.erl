-module(client).
-compile(export_all).

observer() ->
    Port = open_port({spawn, "python -u pe_port.py"}, [{line, 40}]),
    fun(Msg) ->
        port_command(Port, Msg)
    end.

 spawn_receiver_thread() ->
 	Fun = observer(),
 	spawn(pe_msg, recv, [Fun]).