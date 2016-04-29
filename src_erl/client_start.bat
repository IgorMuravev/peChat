set "enodename=%COMPUTERNAME%%RANDOM%%RANDOM%"
set srvnode=net_adm:ping(server@Muravev).
erl -sname %enodename% -cookie 9716ae4038ee99eb3cb9cc3f37c1e322 -eval %srvnode% 