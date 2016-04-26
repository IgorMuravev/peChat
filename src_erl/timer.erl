-module(timer).
-export([get_timer/0]).


get_timer() ->
    Port = open_port({spawn, "python -u timer.py"}, [{line, 40}]),
    fun() ->
        port_command(Port, "time\n"),
        receive
            {Port, {data, {eol, Time}}} ->
                {ok, Time}
        after
            1000 ->
                {error, timeout}
        end
    end.